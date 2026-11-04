# 8-bit PISO Shifter (Parallel-In, Serial-Out)

A small Verilog parallel-in, serial-out shift register with a start request, built as a control path (FSM) and a datapath. Give it a byte and a start pulse, and it sends the byte out on one wire, LSB first, one bit per clock cycle, then pulses `done`.

## Overview

- 8 bits, LSB first, one bit per clock cycle
- Control path (`piso_c`): 4-state FSM
- Datapath (`piso_d`): 8-bit shift register, 3-bit bit counter, serial output taken straight from a flop (`mem[0]`)
- Top level (`piso_top`): wiring, plus a two-flop synchronizer and rising-edge detector on the external `start` input
- Asynchronous active-high reset in the FSM and datapath

## Interface (`piso_top`)

| Port    | Dir    | Width | Description                                                        |
|---------|--------|-------|--------------------------------------------------------------------|
| `clk`   | input  | 1     | Clock                                                              |
| `rst`   | input  | 1     | Asynchronous reset, active high                                    |
| `start` | input  | 1     | Start request; may be asynchronous (it is synchronized internally) |
| `din`   | input  | 8     | Byte to send; must stay stable until the load (see limitations)    |
| `dout`  | output | 1     | Serial output, LSB first                                           |
| `done`  | output | 1     | One-cycle strobe right after the last bit has been sent            |

### Internal control signals

| Signal       | From -> To         | Meaning                                  |
|--------------|--------------------|------------------------------------------|
| `load_en`    | `piso_c -> piso_d` | Load `din` into the shift register       |
| `shift`      | `piso_c -> piso_d` | Shift the register right by one          |
| `inc_count`  | `piso_c -> piso_d` | Increment the bit counter                |
| `clr_count`  | `piso_c -> piso_d` | Clear the bit counter                    |
| `count_done` | `piso_d -> piso_c` | High on the 8th data bit (`count == 7`)  |

## How a Transfer Works

1. `start` goes through two flip-flops (synchronizer) and a third flip-flop (edge detect), giving `start_pulse`, a one-cycle pulse per rising edge of `start`.
2. In `IDLE`, `start_pulse` moves the FSM to `DATA_IN`.
3. In `DATA_IN`, `load_en` is high and `din` is copied into the shift register at the end of the cycle.
4. In `DATA_SHIFT`, the register shifts right every cycle, so `dout` presents bit 0, then bit 1, up to bit 7. The FSM leaves this state when `count_done` is high on the 8th bit.
5. In `FINAL_out`, `done` is high for one cycle, then the FSM returns to `IDLE`.

| Cycle           | State        | `dout`    | Notes                                  |
|-----------------|--------------|-----------|----------------------------------------|
| before          | `IDLE`       | 0         | counter held at 0                      |
| 1               | `DATA_IN`    | 0         | `din` loaded at the end of this cycle  |
| 2 to 9          | `DATA_SHIFT` | d0 to d7  | one bit per cycle, LSB first           |
| 10              | `FINAL_out`  | 0         | `done` = 1                             |
| after           | `IDLE`       | 0         | shift register has been zero-filled    |

The first data bit appears on `dout` three clock edges after the edge that first sees `start` high (two for the synchronizer and edge detect, one for the load).

## Repository Layout

```
.
├── README.md
├── rtl/
│   ├── piso_top.v
│   ├── piso_c.v
│   └── piso_d.v
└── tb/
    └── tb_piso.v
```

## Known Limitations

- **`din` is sampled late.** It is loaded in `DATA_IN`, a few cycles after `start` is first seen (because of the synchronizer), so it must stay stable until `done`. There is no `din` synchronizer, so `din` should not change near the load edge.
- **No `busy` output.** A `start` that arrives mid-transfer is ignored without any indication.
- **The synchronizer flops have no reset,** so `start_pulse` can be unknown for the first few cycles after power-up in simulation.
- **The synchronizer and edge detector live in the top level,** so `piso_top` is not pure wiring.
- **Width is fixed at 8 bits** (the 3-bit counter and `count == 7` are hard-coded).
- **`dout` idles low** (the register is zero-filled as it shifts), which is fine for SPI MOSI but not for a UART-style line that idles high.
- **`shift` and `inc_count` run every clock cycle,** so the output rate is fixed at one bit per clock.
- **Bit order is LSB first only.**

## Roadmap

**Done**
- [x] Control path and datapath split
- [x] `start` synchronizer and edge detector
- [x] Self-checking testbench

**Next**
- [ ] Add a `busy` output and document the start/`done` protocol
- [ ] Capture `din` when the request is accepted
- [ ] Move the synchronizer and edge detector into their own module, with reset
- [ ] Parameterize the width (`N`)
