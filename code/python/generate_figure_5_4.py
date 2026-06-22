# generate_figure_5_4.py
# Figure 5.4: Exponential resistance model - full range to X=1.0
# Author: Neguse Solomon Mekonnen

import numpy as np
import matplotlib.pyplot as plt
import matplotlib
matplotlib.rcParams['font.family'] = 'Times New Roman'

w_range = np.linspace(0, 1.0, 1000)
m_X = np.where(w_range < 0.85,
               1.5 * np.exp(-3.0 * w_range) + 0.88, 1.0)
s_X = np.where(w_range < 1.1,
               0.53 * np.exp(-2.1 * w_range) - 0.05, 1e-8)
s_X = np.maximum(s_X, 0)

upper = m_X + s_X
lower = np.maximum(m_X - s_X, 0)

w_steps = [0.005187, 0.010690, 0.016380, 0.019986, 0.022651]
m_X_pts = [2.355, 2.326, 2.294, 2.274, 2.255]
s_X_pts = [0.474, 0.468, 0.462, 0.458, 0.455]
colors_s = ['#1f77b4','#ff7f0e','#2ca02c','#d62728','#9467bd']

fig, ax = plt.subplots(figsize=(9, 5.5))
fig.patch.set_facecolor('white')

ax.fill_between(w_range, lower, upper, alpha=0.18, color='steelblue',
                label='Mean +/- 1 std (model uncertainty)')
ax.plot(w_range, m_X, 'b-', linewidth=2.2, label='Exponential model m_X(w)')

ax.axhline(y=1.0, color='red', linewidth=2.0, linestyle='--',
           label='X = 1.0 (capacity = proof load, failure threshold)')

for j, (w, mx, sx, col) in enumerate(zip(w_steps, m_X_pts, s_X_pts, colors_s)):
    ax.errorbar(w, mx, yerr=sx, fmt='o', color=col, markersize=9,
                capsize=6, linewidth=1.5,
                label=f'Step {j+1}: w={w:.4f} mm')

ax.annotate('Failure\nthreshold', xy=(0.85, 1.0),
            xytext=(0.65, 1.25), fontsize=9, fontname='Times New Roman',
            arrowprops=dict(arrowstyle='->', color='red'),
            color='red')

ax.annotate('Zijlweg\nmeasurements\n(all X > 2.25)', xy=(0.022, 2.26),
            xytext=(0.15, 2.0), fontsize=9, fontname='Times New Roman',
            arrowprops=dict(arrowstyle='->', color='navy'), color='navy')

ax.set_xlabel('Maximum weighted nominal crack width w_max,w (mm)',
              fontsize=12, fontname='Times New Roman')
ax.set_ylabel('Resistance ratio m_X',
              fontsize=12, fontname='Times New Roman')
ax.set_title('Exponential Resistance Model vs. Crack Width\nZijlweg Shear Analysis (X = 1.0 at failure threshold)',
             fontsize=12, fontname='Times New Roman', fontweight='bold')
ax.legend(loc='upper right', fontsize=8, framealpha=0.9)
ax.set_xlim([0, 1.0])
ax.set_ylim([0.5, 3.2])
ax.grid(True, alpha=0.25)
ax.tick_params(labelsize=10)
plt.tight_layout()
plt.savefig('Fig5.4_resistance_ratio_model.png', dpi=300, bbox_inches='tight')
plt.close()
print('Saved: Fig5.4_resistance_ratio_model.png')