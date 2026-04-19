# DMA_Controller
Verilog Implementation of Direct Memory Access controller

# DMA Controller — RTL Design in Verilog

A Direct Memory Access (DMA) Controller implemented in Verilog HDL that performs
word-by-word 32-bit memory-to-memory transfers without CPU involvement after
configuration. The design is fully modular, split across five submodules — a
Moore FSM (one-hot encoded, 6 states), a memory-mapped register file, a 16-bit
down-counter, a dual-pointer address generator, and a pipeline datapath register
— all coordinated by a top-level wrapper with a shared address MUX.

## Architecture

| Module | Role |
|---|---|
| `DMA_registers` | CPU-facing register file — programs src/dst address, size, and start |
| `DMA_fsm` | One-hot Moore FSM — IDLE → REQ → READ → WRITE → UPDATE → DONE |
| `DMA_counter` | 16-bit down-counter tracking remaining word transfers |
| `DMA_address_gen` | Running src/dst pointers, increments by 4 bytes per transfer |
| `DMA_datapath` | Latches data on READ, drives it on WRITE (3-cycle per-word pipeline) |

## Transfer Flow

1. CPU writes `src_addr`, `dst_addr`, `size`, and `start` via the register interface
2. FSM requests bus (`DMA_req`), waits for arbiter grant (`DMA_ack`)
3. For each word: READ from source → latch → WRITE to destination → UPDATE pointers
4. On completion, `status_done` is set; CPU acknowledges with `done_ack`

## Key Design Decisions

- **One-hot FSM encoding** for fast, glitch-free output decode
- **Moore machine** so control signals (read_en, write_en) never glitch on input changes
- **`loaded` flag** in counter to prevent false zero-detect at reset
- **Single bus arbitration** for the full N-word burst — no per-word re-arbitration
- **Self-clearing `start`** register on completion to enforce single-shot operation

## Tools

Verilog HDL — synthesisable RTL, simulation-ready
