# 21-tap FIR Filter Design

## Table of Contents
- [Overview](#overview)
- [Implement Status](#implement-status)
- [File Description](#file-description)
- [Specification](#specification)
- [Method & Results](#method-&-results)
- [RTL Waveform](#rtl-waveform)

&nbsp;

## Overview

This project implements a 21-tap Finite Impulse Response (FIR) filter using Verilog HDL. The FIR filter is a fundamental digital signal processing component widely used in applications such as audio processing, communications, and image filtering.
A FIR filter is a type of digital filter characterized by its finite-duration impulse response. Unlike IIR filters, FIR filters use only current and past input samples to compute the output, making them inherently stable.
The "21-tap" designation indicates that the filter uses 21 coefficients (or taps) in its computation. This architecture consists of:

- **20 Delay Elements (D)**: Store the previous 20 input samples, creating a delay line
- **21 Multipliers (⊗)**: Multiply each input sample by its corresponding coefficient
- **21 Adders (⊕)**: Sum all weighted samples to produce the final output

<div align="center">
  <img src="media/image1.png" alt="21-tap FIR Filter Architecture" width="600"/>
  <p><i>Figure 1: 21-tap FIR Filter Block Diagram</i></p>
</div>
As shown in the architecture diagram, the input signal x flows through a series of delay elements (D blocks). At each tap point, the delayed signal is multiplied by its corresponding coefficient (b₀, b₁, ..., b₂₀), and all products are summed together through the adder chain to produce the output y.

The table below is the coefficient table of the FIR filter.
<div align="center">
  <p><i>Table 1: Coefficient Table</i></p>
  <img src="media/coeff_table.png" alt="coefficient table" width="500"/>
</div>

&nbsp;

### Operating Principle

The filter operates through the following mechanism:

1. **Sample Buffering**: At each clock cycle, a new input sample enters the delay line, and the oldest sample is discarded
2. **Weighted Multiplication**: Each of the 21 samples (current + 20 delayed) is multiplied by its corresponding coefficient b[k]
3. **Accumulation**: All 21 products are summed together to produce the current output sample

&nbsp;

### Mathematical Expression

The output y(n) is calculated as:

<div align="center">
  <img src="media/image2.png" alt="FIR Filter Equation" width="250"/>
</div>

The mathematical formula represents the convolution operation where:
- **y(n)**: Output signal at time n
- **x(n-k)**: Input signal delayed by k samples
- **bₖ**: Filter coefficient for the k-th tap
- **M-1 = 20**: The summation runs from k=0 to k=20, covering all 21 taps

&nbsp;

### Applications

21-tap FIR filters are commonly used in:
- **Audio Processing**: Equalization, noise reduction
- **Communications**: Channel equalization, pulse shaping
- **Biomedical**: ECG/EEG signal filtering
- **Image Processing**: Edge detection, smoothing
- **Instrumentation**: Anti-aliasing filters

&nbsp;

## Implement Status

RTL code completed.

&nbsp;

## File Description

| File Name | Description |
|-----------|-------------|
| `fir_filter.v` | Main RTL module implementing the 21-tap FIR filter architecture |
| `bits_calculate.m` | MATLAB script for coefficient bit-width calculation, SNR analysis, and fixed-point quantization |
| `coeff_conversion.m` | MATLAB script for converting floating-point filter coefficients to 9-bit binary representation |
| `coeff_9bit.txt` | Text file containing the 21 quantized filter coefficients in 9-bit binary format |
| `input_tm_data.txt` | Test vector file containing 40 input samples for verification testing |
| `testbench.v` | Verilog testbench for simulation and verification (if applicable) |

---

&nbsp;

## Specification

### Input Ports

| Port Name | Width | Description |
|-----------|-------|-------------|
| `clk` | 1-bit | System clock signal - synchronizes all operations in the filter |
| `rst` | 1-bit | Reset signal - initializes the filter state (active high/low) |
| `in` | 10-bit | Input data signal - signed 10-bit input samples (range: -512 to 511) |

### Output Ports

| Port Name | Width | Description |
|-----------|-------|-------------|
| `out` | 24-bit | Filtered output signal - signed 24-bit result of the convolution operation |

&nbsp;

## Method

The design methodology follows a four-step process to ensure optimal filter performance:

### ◆ Step 1: Coefficient Bit-Width Calculation

**Objective**: Determine the required bit width to achieve the target SNR specification through fixed-point quantization.

**Target Specification**: SNR ≥ 50dB

#### Process:
1. Generate random input signal with 50 samples
2. Define ideal FIR filter coefficients using MATLAB's `fir1` function
3. Perform convolution between input signal and filter coefficients
4. Calculate floating-point reference output

#### Bit-Width Analysis:
For different bit widths (L = 5 to 15):
- Quantize coefficients: `b_f = floor(b * 2^L) / 2^L`
- Calculate quantized output through convolution
- Compute SNR: `SNR(L) = 10 * log10(signal_power / noise_power)`

**Result**: 9-bit representation achieves SNR ≈ 56.83dB (>50dB requirement)
<div align="center">
  <img src="media/bits_cal.png" alt="FIR Filter Equation" width="550"/>
</div>

### ◆ Step 2: Coefficient Conversion to Binary

Convert the floating-point filter coefficients to 9-bit fixed-point binary representation.

**Original Coefficients**:
```
[-0.0156, 0.0182, 0.0417, 0.0260, -0.0208, -0.0677, -0.0625, 
 0.0182, 0.1536, 0.2813, 0.3333, 0.2813, 0.1536, 0.0182,
 -0.0625, -0.0677, -0.0208, 0.0260, 0.0417, 0.0182, -0.0156]
```

### ◆ Step 3: Verilog Implementation

Implement the FIR filter in Verilog HDL with the 9-bit quantized coefficients from Step 2.

### ◆ Step 4: Verification

Compare three computation methods to validate the Verilog implementation:

1. **MATLAB Direct Computation**: Floating-point calculation
2. **MATLAB Fixed-Point Computation**: Using quantized coefficients
3. **Verilog Simulation Result**: Hardware implementation output

#### Test Vector:
Input: 40 samples of TM (Test Mode) data
```
[160, 304, 417, 489, 511, 482, 405, 287, 139, -22, -181, -322, -430,
 -496, -512, -476, -392, -270, -120, 42, 200, 337, 441, 500, 509, 467,
 377, 250, 98, -64, -220, -354, -452, -505, -507, -458, -364, -233, -78, 84]
```

#### Verification Results

The verification compares three computation methods to validate the Verilog implementation:

##### 1. MATLAB Floating-Point Results

<div align="center">
  <img src="media/matlab_result.png" alt="MATLAB Floating-Point Results" width="800"/>
  <p><i>Figure: MATLAB floating-point computation output</i></p>
</div>

---

##### 2. MATLAB Fixed-Point Results

<div align="center">
  <img src="media/matlab_trun_result.png" alt="MATLAB Fixed-Point Results" width="800"/>
  <p><i>Figure: MATLAB fixed-point computation output (9-bit quantized coefficients)</i></p>
</div>

---

##### 3. Verilog Simulation Output

<div align="center">
  <img src="media/verilog_result.png" alt="Verilog Simulation Results" width="800"/>
  <p><i>Figure: Verilog hardware simulation output</i></p>
</div>

---

- **Conclusion**: In the MATLAB computation, the first output appears after 21 clock cycles, so the MATLAB results are compared starting from the 21st sample.
After truncation in MATLAB, the fixed-point computation results are consistent with the Verilog results!

&nbsp;

## RTL Waveform
<div align="center">
  <img src="media/waveform.png" alt="FIR Filter Equation" width="800"/>
</div>

&nbsp;
