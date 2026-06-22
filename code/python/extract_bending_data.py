# extract_bending_data.py
# Purpose: Extract strain measurements from bending04 filtered data
# Input: zijlwegbuiging04.xls (converted to xlsx)
# Output: Verified strain values at 5 load steps
# Author: Neguse Solomon Mekonnen - Dissertation 2025/2026

import openpyxl
import pandas as pd
import numpy as np

# Load the converted xlsx file
wb = openpyxl.load_workbook('zijlwegbuiging04.xlsx', read_only=True, data_only=True)
ws = wb['Filtered']

data = []
headers = None
for i, row in enumerate(ws.iter_rows(values_only=True)):
    if i == 0:
        headers = list(row)
    else:
        data.append(row)
wb.close()

df = pd.DataFrame(data, columns=headers)

# Total force = absolute sum of 4 jacks (forces stored as negative compression)
df['F_total'] = abs(df['F1_Filtered'] + df['F2_Filtered'] + 
                    df['F3_Filtered'] + df['F4_Filtered'])

# Zero reference: mean of readings at near-zero load
zero_ref = df[df['F_total'] < 10]
ref02 = zero_ref['LVDT02_Filtered'].mean()
ref03 = zero_ref['LVDT03_Filtered'].mean()

print(f"Zero references: LVDT02={ref02:.6f}, LVDT03={ref03:.6f}")
print()

# Five load steps from loading protocol
load_steps = [400, 845, 1090, 1200, 1340]

print(f"{'Step':>5} {'F(kN)':>10} {'LVDT02(mm)':>12} {'LVDT03(mm)':>12} "
      f"{'eps2(με)':>10} {'eps3(με)':>10} {'eps_max(με)':>12}")
print('-' * 80)

results = []
for target in load_steps:
    mask = (df['F_total'] >= target - 50) & (df['F_total'] <= target + 50)
    s = df[mask]
    if len(s) > 0:
        F = s['F_total'].mean()
        # Displacement in mm over 1m (1000mm) gauge length
        delta02 = s['LVDT02_Filtered'].mean() - ref02  # mm
        delta03 = s['LVDT03_Filtered'].mean() - ref03  # mm
        # Strain (microstrain) = displacement_mm / gauge_length_mm * 1e6
        # gauge length = 1000mm, so strain = delta_mm * 1000
        eps2 = delta02 * 1000  # microstrain
        eps3 = delta03 * 1000  # microstrain
        eps_max = max(eps2, eps3)
        print(f"{target:>5} {F:>10.1f} {delta02:>12.5f} {delta03:>12.5f} "
              f"{eps2:>10.3f} {eps3:>10.3f} {eps_max:>12.3f}")
        results.append((target, F, eps2, eps3, eps_max))

# Bending moment at critical section
# Critical position a = 3382mm from support 5, span L = 10320mm
L = 10.320  # m
a = 3.382   # m

print()
print("BENDING MOMENTS AT CRITICAL SECTION:")
for r in results:
    M = r[1] * a * (L - a) / L
    print(f"  F={r[1]:.1f}kN -> M={M:.1f}kNm, eps_max={r[4]:.3f}με")

print()
print("C++ INPUT VECTOR (m_Q_PL in kNm):")
M_vals = [r[1] * a * (L - a) / L for r in results]
print(f"std::vector<double> m_Q_PL = {{{', '.join([f'{m:.1f}' for m in M_vals])}}};")