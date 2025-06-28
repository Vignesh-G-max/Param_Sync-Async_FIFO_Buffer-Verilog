# FIFO Designs in Verilog

This repository contains the Verilog design and simulation of both **Asynchronous FIFO** and **Synchronous FIFO**.

The files are organized into two separate folders:

- `Asynchronous_FIFO`
- `Synchronous_FIFO`

Each folder includes:

- ✅ Design files  
- ✅ Testbench files  
- ✅ Waveform simulation results  
- ✅ Block diagrams of the FIFO architecture

All designs have been written and tested using **Xilinx Vivado**.

---

## 📂 Folder Details

### 🔄 Asynchronous FIFO

Implements a **First-In First-Out** buffer that allows data to be written and read using **different clock domains**. It includes proper synchronization mechanisms (such as Gray code pointer conversion) to ensure reliable operation across clock boundaries, preventing metastability and data corruption.

### 🔁 Synchronous FIFO

Implements a **FIFO queue** where both write and read operations share the **same clock**. It uses circular buffer logic with full and empty flag generation and is simpler than asynchronous FIFO due to no clock domain crossing.

---

## 🛠 Tools Used

- **Vivado** – For simulation, testing, and waveform analysis

---

## ✅ How to Simulate

1. Open **Vivado**
2. Create a new project and add the design + testbench files from the appropriate folder
3. Set the testbench file as the top module
4. Run **Behavioral Simulation**
5. View waveforms in Vivado or export `.vcd` for GTKWave

---

## 📧 Contact

Feel free to open an issue or reach out for suggestions, bugs, or feedback.

---
