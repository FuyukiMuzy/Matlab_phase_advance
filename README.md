# Phase Advance Controller Designer (MATLAB 2024b)

This project is an app developed using **MATLAB 2024b App Designer**.  
Its main purpose is to assist in the design of **phase advance (lead) controllers** for **Type 1 systems**, based on user-defined **velocity constant (Kv)** and **gain margin (MG)** specifications.

## 📌 Overview

The application calculates the compensator parameters using **frequency domain analysis** with Bode diagrams. It supports:

- First-order systems with integrator (Type 1 systems)
- Lead compensator synthesis
- User input of:
  - Open-loop transfer function
  - Desired **Kv** (steady-state velocity constant)
  - Desired **Gain Margin** (MG)

The algorithm automatically computes:
- Desired crossover frequency
- Required phase margin
- Phase lead angle
- Compensator zero and pole positions
- Final controller transfer function

## ⚙️ Features

- Interactive GUI built in **App Designer**
- Bode plot generation with annotations
- Step-by-step calculation and symbolic output
- Export of the designed transfer function
- English interface and comments

## 🧠 Theory

The controller is based on classical **Lead Compensator** design using Bode plot criteria:
\[
Gc(s) = K_c \cdot \frac{s + z}{s + p}
\]
Where:
- \( z = \) compensator zero
- \( p = \) compensator pole
- \( z < p \), ensuring phase lead

The app determines \( z \), \( p \), and \( K_c \) such that:
- The open-loop system meets the desired **Kv**
- The closed-loop system meets the desired **Gain Margin (MG)** and **Phase Margin (MF)**

## 🔧 Requirements

- MATLAB R2024b or later
- Control System Toolbox
- App Designer (included in MATLAB)
