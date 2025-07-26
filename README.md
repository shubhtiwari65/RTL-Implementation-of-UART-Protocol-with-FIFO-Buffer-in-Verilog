# RTL-Implementation-of-UART-Protocol-with-FIFO-Buffer-in-Verilog

This project implements a fully synthesizable UART (Universal Asynchronous Receiver Transmitter) protocol using **Verilog at the RTL level**, enhanced with a **FIFO buffer** for handling multiple bytes efficiently verified through simulation.. It includes a complete loopback testbench and waveform visualization using GTKWave.

---

## 📌 Features

- ✅ UART Transmitter & Receiver with FSM-based design
- ✅ Baud rate generator (parameterized up to 1 Mbps)
- ✅ FIFO buffer for RX path (8-bit, non-blocking)
- ✅ RTL-compliant and synthesizable Verilog modules
- ✅ Loopback testbench with waveform capture
- ✅ Easy to simulate using Icarus Verilog + GTKWave
- ✅ Modular and extensible structure
---

## 📁 Project Structure

```
RTL-Implementation-of-UART-Protocol-with-FIFO-Buffer-in-Verilog/
├── src/
│   ├── uart_tx.v          → UART Transmitter module
│   ├── uart_rx.v          → UART Receiver module with optional FIFO integration
│   ├── baud_gen.v         → Baud rate tick generator
│   ├── fifo.v             → FIFO buffer module 
│   └── uart_top.v         → Top-level module connecting TX, RX, and tick
├── tb/
│   └── uart_tb.v          → Testbench simulating UART loopback
├── sim/
│   └── uart.vcd           → Waveform output for GTKWave
├── waveform.png           → Screenshot of simulation waveform
└── README.md              → Project documentation 
```


---

## 🎯 Functional Overview

UART is a common serial communication protocol used in embedded systems. The implementation follows this frame format:


The receiver module uses a **finite state machine (FSM)** and **a shift register** to capture incoming bits. The captured byte is pushed into a FIFO-style register (within `uart_rx`) for temporary storage, enabling **non-blocking reception**.

---

## 🚀 How to Run Simulation

> **Required Tools:**
> - [Icarus Verilog](http://iverilog.icarus.com/)
> - [GTKWave](http://gtkwave.sourceforge.net/)




## 🛠️ Step 1: Compile & Simulate

To compile the UART design and testbench using `iverilog`, run the following commands:

```bash
 iverilog -o uart.vvp uart_tb.v uart_top.v uart_tx.v uart_rx.v baud_gen.v 
```

This will compile the Verilog source files and testbench, and generate the simulation output (`uart.vvp`). Running `vvp uart.vvp` will produce a waveform file `uart.vcd`.

---

## 🧠 Step 2: View Waveform

After simulation, a `uart.vcd` file will be available inside the `sim/` directory.

To view the waveform using GTKWave:

```bash
gtkwave sim/uart.vcd
```
### ⚙️ Parameter Table
| Parameter    | Default Value | Description                 |
| ------------ | ------------- | --------------------------- |
| `CLK_FREQ`   | 50000000      | System clock frequency (Hz) |
| `BAUD_RATE`  | 1000000       | UART baud rate (bps)        |
| `DATA_WIDTH` | 8             | UART word size (8-bit)      |

### 📜 Future Enhancements

-  **Add Parity Bit Support**: Integrate configurable even/odd parity for error checking in TX/RX paths.
-  **Framing Error Detection**: Implement stop bit validation to detect corrupted frames on the receiver side.
-  **Support for Multiple Baud Rates**: Add dynamic baud rate selection using control inputs or parameters.
-  **Integrate Full FIFO Buffering**: Use both TX and RX FIFOs for buffered data streams and flow control.
-  **AXI-Lite Interface Integration**: Wrap UART logic with an AXI-lite interface for SoC integration.


## 📊 Simulation Output

![UART waveform simulation](assets/waveform.png)





