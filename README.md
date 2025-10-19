# 21-tap FIR Filter Design

## Table of Contents
- [Overview](#overview)
- [Implement Status](#implement-status)
- [File Description](#file-description)
- [Specification](#specification)
- [Method](#method)
- [RTL Waveform](#rtl-waveform)

## Overview

This project implements a 21-tap Finite Impulse Response (FIR) filter using Verilog HDL. The FIR filter is a fundamental digital signal processing component widely used in applications such as audio processing, communications, and image filtering.
A Finite Impulse Response (FIR) filter is a type of digital filter characterized by its finite-duration impulse response. Unlike IIR (Infinite Impulse Response) filters, FIR filters use only current and past input samples to compute the output, making them inherently stable.
The "21-tap" designation indicates that the filter uses 21 coefficients (or taps) in its computation. This architecture consists of:

- **20 Delay Elements (D)**: Store the previous 20 input samples, creating a delay line
- **21 Multipliers (⊗)**: Multiply each input sample by its corresponding coefficient
- **21 Adders (⊕)**: Sum all weighted samples to produce the final output
```
Input x → [D] → [D] → ... → [D] → (20 delays total)
           ↓     ↓           ↓
          [×]   [×]   ...   [×]    (21 multipliers)
          b0    b1          b20
           ↓     ↓           ↓
          [+] → [+] → ... → [+] → Output y
```

### Operating Principle

The filter operates through the following mechanism:

1. **Sample Buffering**: At each clock cycle, a new input sample enters the delay line, and the oldest sample is discarded
2. **Weighted Multiplication**: Each of the 21 samples (current + 20 delayed) is multiplied by its corresponding coefficient b[k]
3. **Accumulation**: All 21 products are summed together to produce the current output sample

### Mathematical Expression

The output y(n) is calculated as:
```
y(n) = Σ(k=0 to 20) b_k × x(n-k)
     = b₀·x(n) + b₁·x(n-1) + b₂·x(n-2) + ... + b₂₀·x(n-20)
```

Where:
- `x(n)` is the current input sample
- `x(n-k)` is the input sample k time steps ago
- `y(n)` is the current output sample
- `b_k` are the filter coefficients (k = 0 to 20)

### Key Characteristics

#### 1. **Frequency Selectivity**
The filter coefficients determine the frequency response. By carefully designing these coefficients, the filter can:
- Pass certain frequencies (passband)
- Attenuate unwanted frequencies (stopband)
- Implement lowpass, highpass, bandpass, or bandstop responses

#### 2. **Linear Phase Response**
When coefficients are symmetric (b[k] = b[20-k]), the filter achieves linear phase, meaning:
- No phase distortion in the output signal
- All frequency components experience equal delay
- Critical for applications requiring waveform preservation

#### 3. **Group Delay**
The 21-tap filter introduces a group delay of:
```
Delay = (N-1)/2 = (21-1)/2 = 10 samples
```
This means the output is delayed by 10 sample periods relative to the input.

#### 4. **Computational Complexity**
Each output sample requires:
- **21 multiplications**: One for each tap
- **20 additions**: To sum all products
- **20 memory accesses**: To retrieve delayed samples

#### 5. **Stability**
FIR filters are always stable because they:
- Have no feedback paths
- Use only finite summation
- Cannot produce unbounded output for bounded input

### Trade-offs in Tap Count

**More taps (e.g., 21 vs. 11)**:
- ✅ Better frequency selectivity (sharper transition bands)
- ✅ Lower passband ripple
- ✅ Higher stopband attenuation
- ❌ Increased computational cost
- ❌ Higher latency (group delay)
- ❌ More hardware resources required

**Fewer taps**:
- ✅ Lower computational complexity
- ✅ Reduced latency
- ✅ Smaller hardware footprint
- ❌ Wider transition bands
- ❌ Poorer frequency selectivity

### Applications

21-tap FIR filters are commonly used in:
- **Audio Processing**: Equalization, noise reduction
- **Communications**: Channel equalization, pulse shaping
- **Biomedical**: ECG/EEG signal filtering
- **Image Processing**: Edge detection, smoothing
- **Instrumentation**: Anti-aliasing filters

## Implement Status

*To be updated*

## File Description

*To be updated*

## Specification

*To be updated*

## Method

The design methodology follows a four-step process to ensure optimal filter performance:

### Step 1: Coefficient Bit-Width Calculation

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

### Step 2: Coefficient Conversion to Binary

Convert the floating-point filter coefficients to 9-bit fixed-point binary representation:
```matlab
for i = 1:numel(b)
    binaryCoeff = dec2bin(floor(b(i) * 2^9), 9);
    fprintf('%s\n', binaryCoeff);
end
```

**Original Coefficients**:
```
[-0.0156, 0.0182, 0.0417, 0.0260, -0.0208, -0.0677, -0.0625, 
 0.0182, 0.1536, 0.2813, 0.3333, 0.2813, 0.1536, 0.0182,
 -0.0625, -0.0677, -0.0208, 0.0260, 0.0417, 0.0182, -0.0156]
```

### Step 3: Verilog Implementation

Implement the FIR filter in Verilog HDL with the 9-bit quantized coefficients from Step 2.

### Step 4: Verification

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

#### Verification Results:
- MATLAB floating-point and fixed-point results match (starting from index 21)
- Verilog simulation output matches MATLAB fixed-point computation
- **Conclusion**: Verilog implementation is functionally correct

**Note**: MATLAB's `conv` function outputs (N+M-1) samples, where the first sample includes only the first input. For a 21-tap filter, valid output starts from sample 21 onwards.

## RTL Waveform

*To be updated*

---

## License

*Add your license information here*

## Author

*Add your information here*
