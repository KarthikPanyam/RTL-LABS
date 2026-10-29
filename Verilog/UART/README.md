# Serial TX/RX Core (UART in progress)


A Verilog serial transmitter and receiver with start/stop framing, built as a control-path / datapath design. The goal is a standard **8N1 UART**.

> **Status: work in progress.** Right now every bit lasts exactly one clock cycle and both ends share the same clock, so this is a *clock-synchronous* framed serial link, not yet a real asynchronous UART. The baud generator, input synchronizer, and mid-bit sampling are still to come (see the [roadmap](#roadmap)). Expect rough edges and renamed signals while things change.

## Overview

- 8 data bits, LSB first, 1 start bit, 1 stop bit, no parity (8N1)
- Transmitter: 4-state FSM + shift register + bit counter
- Receiver: 3-state FSM + serial-in/parallel-out register + holding register
- Each side is split into a **control path** (`*_cp`, the FSM) and a **datapath** (`*_dp`, registers and counters), joined by a thin top level
- Asynchronous active-high reset throughout

## Frame Format

```
line:   idle | start |  d0  d1  d2  d3  d4  d5  d6  d7  | stop | idle
         1       0     LSB ........................ MSB     1      1
```

At the moment each box above is **one clock cycle**. Once the baud generator is in, each box will last `CLK_FREQ / BAUD` cycles.


```

| Module         | File            | Role                                                         |
|----------------|-----------------|--------------------------------------------------------------|
| `uart_tx_top`  | `uart_tx_top.v` | Wires the TX control path to its datapath                    |
| `uart_tx_cp`   | `uart_tx_cp.v`  | FSM: `IDLE → START → DATA → STOP`                            |
| `uart_tx_dp`   | `uart_tx_dp.v`  | 8-bit shift register, 3-bit bit counter, output mux          |
| `uart_rx_top`  | `uart_rx_top.v` | Wires the RX control path to its datapath                    |
| `uart_rx_cp`   | `uart_rx_cp.v`  | FSM: `IDLE → DATA → STOP`                                    |
| `uart_rx_dp`   | `uart_rx_dp.v`  | Bit counter, shift register (`sipo`), output holding register |

## Interfaces

### `uart_tx_top`

| Port          | Dir    | Width | Description                                              |
|---------------|--------|-------|----------------------------------------------------------|
| `clk`         | input  | 1     | Clock                                                    |
| `rst`         | input  | 1     | Asynchronous reset, active high                          |
| `din`         | input  | 8     | Byte to send; see [known limitations](#known-limitations) for when it is sampled |
| `start_tx`    | input  | 1     | Request to send; only acted on while idle                |
| `dout`        | output | 1     | Serial line (idles high)                                 |
| `tx_complete` | output | 1     | High while the stop bit is being sent                    |

### `uart_rx_top`

| Port          | Dir    | Width | Description                                                  |
|---------------|--------|-------|--------------------------------------------------------------|
| `clk`         | input  | 1     | Clock                                                        |
| `rst`         | input  | 1     | Asynchronous reset, active high                              |
| `RX_in`       | input  | 1     | Serial line in                                               |
| `rx_data`     | output | 8     | Last received byte (held until the next frame completes)     |
| `rx_complete` | output | 1     | One-cycle pulse; `rx_data` is valid when it is high          |



## Simulation

Using [Icarus Verilog](https://steveicarus.github.io/iverilog/) and GTKWave:

```bash
iverilog -g2005 -o sim rtl/*.v tb/uart_tb.v
vvp sim
gtkwave uart_tb.vcd
```

The current testbench only exercises the transmitter: it sends one byte and dumps a waveform. It does **not** check results yet, and the receiver is not instantiated in it.

## Known Limitations

This is early work, so there are several things to be aware of:

- **No baud generator.** One bit per clock cycle; this will not interoperate with a real UART yet.
- **RX is not safe against a real serial line.** It samples every clock edge, has no input synchronizer (metastability risk), and does no start-edge or mid-bit sampling.
- **RX does not check the stop bit**, so there is no framing-error flag. The `START` state is declared in the RX FSM but unused.
- **TX samples `din` one cycle after `start_tx` is seen** (while in the `START` state), so `din` must still be valid then.
- **No `busy` output.** A `start_tx` that arrives mid-frame is silently ignored.
- **TX `dout` is combinational** (decoded from state), so it can glitch on state changes.
- **`tx_complete` covers the whole stop-bit state**, not a one-cycle "done" pulse.
- **Testbench is minimal** (TX only, one byte, no self-checking).
- A TX-to-RX loopback on a shared clock is expected to work (traced by hand), but it is not yet covered by a test.

## Roadmap

**Done**
- [x] TX: FSM and shift-register datapath
- [x] RX: FSM, serial-in/parallel-out datapath, and output holding register
- [x] Basic TX testbench with VCD dump

**Next**
- [ ] Self-checking TX → RX loopback testbench (several bytes, back-to-back frames, reset mid-frame)
- [ ] `baud_gen` as a separate module with a clean `tick` / `enable` interface
- [ ] TX: advance state and shift/count only on the baud tick
- [ ] TX: capture `din` when the request is accepted; add a `busy` output
- [ ] TX: registered (glitch-free) serial output

**Later**
- [ ] RX: two-flop input synchronizer
- [ ] RX: start-edge detection and mid-bit sampling (e.g. 16x oversampling)
- [ ] RX: use the `START` state to validate the start bit
- [ ] RX: stop-bit check and framing-error flag
- [ ] Naming cleanup across TX and RX; `localparam` for state encodings
- [ ] Parameterize data width and baud rate
- [ ] Optional: parity, selectable stop bits, FPGA bring-up

## License

Not chosen yet.
