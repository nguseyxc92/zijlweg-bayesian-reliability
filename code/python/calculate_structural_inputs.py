# calculate_structural_inputs.py
#
# Purpose: Calculate permanent load effects and proof load moments/shears
# for input to Bayesian reliability updating C++ code
# Used for: Chapter 4 Tables 4.7 and 4.8, Chapter 5 Tables 5.4 and 5.6
#
# Author: Neguse Solomon Mekonnen
# Dissertation: Bayesian Updating of Bridge Structural Reliability
# Supervisors: Dr. Eva Lantsoght, Dr. Rolando Chacon
# Date: May 10 2026

import numpy as np

print("=" * 60)
print("ZIJLWEG VIADUCT - STRUCTURAL INPUT CALCULATIONS")
print("=" * 60)

# =====================================================
# SPAN 4 GEOMETRY (from Lantsoght et al. 2017)
# =====================================================
L     = 10.320   # m  span length (support 4 to support 5)
b     = 6.60     # m  total slab width
h_avg = 0.700    # m  average slab thickness in span 4 (varies 550-850mm)

# Critical positions (face-to-face distance from support 5)
a_bending = 3.382   # m  critical bending position (from Lantsoght 2017)
a_shear   = 1.500   # m  load centroid for shear test (approximate)

# Effective depth at critical sections
d_bending = 0.594 - 0.040 - 0.028/2  # m  = 0.540m (confirmed from drawings)
d_shear   = 0.516                      # m  (at critical shear section)

print()
print("SPAN 4 GEOMETRY:")
print(f"  Span length L          = {L} m")
print(f"  Width b                = {b} m")
print(f"  Average height h_avg   = {h_avg*1000:.0f} mm")
print(f"  Critical bending pos a = {a_bending} m from support 5")
print(f"  Critical shear pos a   = {a_shear} m from support 5")
print(f"  Effective depth d_bend = {d_bending*1000:.1f} mm")
print(f"  Effective depth d_shear= {d_shear*1000:.0f} mm")

# =====================================================
# PERMANENT LOAD INTENSITIES
# =====================================================
gamma_c     = 25.0   # kN/m3  concrete density
t_asphalt   = 0.10   # m      asphalt thickness
gamma_asph  = 22.0   # kN/m3  asphalt density

g_DL  = gamma_c    * h_avg    * b   # kN/m self-weight
g_SDL = gamma_asph * t_asphalt * b  # kN/m asphalt superimposed DL
g_total = g_DL + g_SDL

print()
print("PERMANENT LOAD INTENSITIES:")
print(f"  Self-weight g_DL       = {g_DL:.1f} kN/m")
print(f"  Asphalt g_SDL          = {g_SDL:.1f} kN/m")
print(f"  Total permanent        = {g_total:.1f} kN/m")

# =====================================================
# PERMANENT LOAD EFFECTS AT BENDING CRITICAL SECTION
# =====================================================
# Simply supported beam assumption (conservative for span 4)
M_DL  = (g_DL  / 2) * a_bending * (L - a_bending)
M_SDL = (g_SDL / 2) * a_bending * (L - a_bending)
M_perm_total = M_DL + M_SDL

print()
print("BENDING CRITICAL SECTION (a = 3.382m from support 5):")
print(f"  M_DL  (dead load)      = {M_DL:.1f} kNm")
print(f"  M_SDL (superimposed)   = {M_SDL:.1f} kNm")
print(f"  M_total permanent      = {M_perm_total:.1f} kNm")
print()
print("  C++ input values:")
print(f"  auto rv_G_DL  = rdv::rv_normal::mv({M_DL:.1f}, 0.05);")
print(f"  auto rv_G_SDL = rdv::rv_normal::mv({M_SDL:.1f}, 0.10);")

# =====================================================
# PERMANENT LOAD EFFECTS AT SHEAR CRITICAL SECTION
# =====================================================
R5_perm  = g_total * L / 2
V_DL_sh  = (g_DL  * L / 2) - g_DL  * a_shear
V_SDL_sh = (g_SDL * L / 2) - g_SDL * a_shear

print()
print("SHEAR CRITICAL SECTION (a = 1.500m from support 5):")
print(f"  V_DL  (dead load)      = {V_DL_sh:.1f} kN")
print(f"  V_SDL (superimposed)   = {V_SDL_sh:.1f} kN")
print(f"  V_total permanent      = {V_DL_sh+V_SDL_sh:.1f} kN")
print()
print("  C++ input values:")
print(f"  auto rv_G_DL  = rdv::rv_normal::mv({V_DL_sh:.1f}, 0.05);")
print(f"  auto rv_G_SDL = rdv::rv_normal::mv({V_SDL_sh:.1f}, 0.10);")

# =====================================================
# PROOF LOAD EFFECTS - BENDING
# =====================================================
F_bend  = [394.9, 845.0, 1090.9, 1204.3, 1332.4]
M_PL = [F * a_bending * (L - a_bending) / L for F in F_bend]

print()
print("PROOF LOAD BENDING MOMENTS (kNm):")
print(f"  {'Step':>5} {'F_total(kN)':>12} {'M_PL(kNm)':>12}")
print("  " + "-"*32)
for i, (F, M) in enumerate(zip(F_bend, M_PL)):
    print(f"  {i+1:>5} {F:>12.1f} {M:>12.1f}")
print()
print("  C++ input vector:")
print(f"  std::vector<double> m_Q_PL = "
      f"{{{', '.join([f'{m:.1f}' for m in M_PL])}}};  // kNm")

# =====================================================
# PROOF LOAD EFFECTS - SHEAR
# =====================================================
F_shear = [395.97, 800.27, 1082.77, 1219.93, 1341.51]
V_PL = [F * (L - a_shear) / L for F in F_shear]

print()
print("PROOF LOAD SHEAR FORCES (kN):")
print(f"  {'Step':>5} {'F_total(kN)':>12} {'V_PL(kN)':>12}")
print("  " + "-"*32)
for i, (F, V) in enumerate(zip(F_shear, V_PL)):
    print(f"  {i+1:>5} {F:>12.1f} {V:>12.1f}")
print()
print("  C++ input vector:")
print(f"  std::vector<double> m_Q_PL = "
      f"{{{', '.join([f'{v:.1f}' for v in V_PL])}}};  // kN")

# =====================================================
# RESISTANCE RATIO STATISTICS - BENDING
# =====================================================
M_y_mean = 1825.8   # kNm from sectional analysis (b=6.6m)
M_y_cov  = 0.131

m_X_bend = [M_y_mean / M for M in M_PL]
V_X_bend = [M_y_cov] * 5

print()
print("BENDING RESISTANCE RATIOS:")
print(f"  M_y_mean = {M_y_mean:.1f} kNm, CoV = {M_y_cov}")
print(f"  {'Step':>5} {'M_PL(kNm)':>12} {'m_X':>10} {'V_X':>10}")
print("  " + "-"*40)
for i, (M, mx, vx) in enumerate(zip(M_PL, m_X_bend, V_X_bend)):
    print(f"  {i+1:>5} {M:>12.1f} {mx:>10.4f} {vx:>10.4f}")
print()
print("  C++ input vectors:")
print(f"  std::vector<double> m_X = "
      f"{{{', '.join([f'{mx:.4f}' for mx in m_X_bend])}}};")
print(f"  std::vector<double> V_X = "
      f"{{{', '.join([f'{vx:.4f}' for vx in V_X_bend])}}};")

# =====================================================
# RESISTANCE RATIO STATISTICS - SHEAR
# =====================================================
w_max_w = [0.005187, 0.010690, 0.016380, 0.019986, 0.022651]
m_X_sh = [1.5*np.exp(-3.0*w)+0.88 if w < 0.85 else 1.0 for w in w_max_w]
s_X_sh = [max(0.53*np.exp(-2.1*w)-0.05, 1e-8) for w in w_max_w]
V_X_sh = [s/m for s, m in zip(s_X_sh, m_X_sh)]

print()
print("SHEAR RESISTANCE RATIOS (from exponential model):")
print(f"  {'Step':>5} {'w_max,w(mm)':>12} {'m_X':>10} {'s_X':>10} {'V_X':>10}")
print("  " + "-"*50)
for i, (w, mx, sx, vx) in enumerate(zip(w_max_w, m_X_sh, s_X_sh, V_X_sh)):
    print(f"  {i+1:>5} {w:>12.6f} {mx:>10.4f} {sx:>10.4f} {vx:>10.4f}")

# =====================================================
# TRAFFIC LOAD SCALING
# =====================================================
print()
print("TRAFFIC LOAD PARAMETERS:")
print("  Bending: Q ~ Gumbel(mean=1570.5 kNm, CoV=0.058)")
print("  Shear:   Q ~ Gumbel(mean=651.7 kN,  CoV=0.035)")
print("  (Scaled from De Vries 2025 WIM calibration to Zijlweg geometry)")

print()
print("=" * 60)
print("ALL CALCULATIONS COMPLETE")
print("=" * 60)