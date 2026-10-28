# **Synchronous FIFO (16 × 8\)**

A single-clock, 16-deep, 8-bit-wide synchronous FIFO written in Verilog. The design is split into a control path and a datapath, tied together by a thin top-level wrapper.

## **Features**

* Single clock domain, asynchronous active-high reset  
* 16 entries × 8 bits (128 bits of storage)  
* `full` and `empty` status flags  
* Safe against overflow and underflow: pushes while full and pops while empty are ignored  
* Simultaneous push and pop supported in the same cycle  
* Combinational read: the oldest entry is always visible on `dout` (first-word-fall-through style)  
* 5-bit pointers (one extra MSB) for unambiguous full/empty detection

## **Interface (`fifo_top`)**

| Port | Dir | Width | Description |
| ----- | ----- | ----- | ----- |
| `clk` | input | 1 | Clock; all logic is rising-edge triggered |
| `rst` | input | 1 | Asynchronous reset, active high; clears pointers |
| `push` | input | 1 | Write request; accepted only when not full |
| `pop` | input | 1 | Read request; accepted only when not empty |
| `din` | input | 8 | Data to write |
| `dout` | output | 8 | Data at the head of the FIFO (oldest entry) |
| `full_flag` | output | 1 | High when all 16 entries are occupied |
| `empty_flag` | output | 1 | High when the FIFO holds no entries |

## **How It Works**

### **Pointers and flags**

The write pointer (`w_ptr`) and read pointer (`r_ptr`) are 5 bits wide. The lower 4 bits index the memory; the MSB tracks wrap-around.

* **Empty:** `w_ptr == r_ptr`  
* **Full:** lower 4 bits equal and MSBs differ (`w_ptr[3:0] == r_ptr[3:0] && w_ptr[4] != r_ptr[4]`)

### **Control path (`fifo_cp`)**

Purely combinational. It qualifies the user requests with the status flags:

ld\_en    \= push && \!full;   // write the memory  
inc\_wptr \= push && \!full;   // advance the write pointer  
inc\_rptr \= pop  && \!empty;  // advance the read pointer

### **Datapath (`fifo_dp`)**

* On a clock edge with `ld_en` high, `din` is written to `mem[w_ptr[3:0]]`.  
* On a clock edge with `inc_wptr` / `inc_rptr` high, the matching pointer increments.  
* `dout` is driven combinationally from `mem[r_ptr[3:0]]`.

## **Behavior Notes**

| Situation | Result |
| ----- | ----- |
| Push while full | Ignored; no data or pointer change |
| Pop while empty | Ignored; no pointer change |
| Push and pop, neither full nor empty | Both happen in the same cycle |
| Push and pop while full | Only the pop takes effect (push is blocked by `full`) |
| Push and pop while empty | Only the push takes effect (pop is blocked by `empty`) |
| Reset | Pointers cleared; memory contents are **not** cleared |

**Reading data:** `dout` always shows the oldest entry, so the consumer can sample `dout` and then assert `pop` to consume it. `dout` is only meaningful while `empty_flag` is low. Before the first write it may be `X` in simulation because the memory is not reset.

## **Simulation**

Example using [Icarus Verilog](https://steveicarus.github.io/iverilog/) (adjust file names to match your project):

iverilog \-g2005 \-o fifo\_sim fifo.v tb.v  
vvp fifo\_sim  
gtkwave dump.vcd   \# if the testbench dumps a VCD

A good testbench should cover:

1. Reset behavior (`empty_flag = 1`, `full_flag = 0`)  
2. Filling the FIFO with 16 pushes and confirming `full_flag`  
3. Extra pushes while full (data must not be corrupted)  
4. Draining all 16 entries in order and confirming `empty_flag`  
5. Extra pops while empty  
6. Simultaneous push and pop at various fill levels  
7. Pointer wrap-around across multiple fill/drain cycles

## **Known Limitations**

* **Asynchronous read:** `dout` is a combinational read of the memory array. This maps well to distributed (LUT) RAM, but will not infer Block RAM on most FPGAs. A registered read would be needed for BRAM inference, at the cost of one cycle of read latency.  
* **Fixed size:** the width (8) and depth (16) are hard-coded.  
* **Single clock domain:** not suitable for clock-domain crossing without redesign (e.g. Gray-coded pointers and synchronizers).  
* **No memory reset:** stored data persists across reset; only the pointers are cleared.

## **Possible Improvements**

* Parameterize data width and address width (`DW`, `AW`)  
* Add a registered-output option for BRAM mapping  
* Add almost-full / almost-empty flags and a data-count output  
* Add overflow / underflow error flags  
* Add an asynchronous (dual-clock) variant with Gray-code pointers