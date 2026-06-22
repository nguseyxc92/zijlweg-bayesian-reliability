# generate_figure_5_5.py
# Figure 5.5: Shear reliability vs proof load factor
# Author: Neguse Solomon Mekonnen

import numpy as np
import matplotlib.pyplot as plt
import matplotlib
matplotlib.rcParams['font.family'] = 'Times New Roman'

Q_k_LM1    = 1228.0
V_PL       = [338.4, 684.0, 925.4, 1042.6, 1146.5]
f_LM1      = [v / Q_k_LM1 for v in V_PL]
beta_during = [1.84, 1.83, 1.82, 1.82, 1.81]
beta_after  = [1.55, 2.64, 3.81, 4.41, 4.89]
beta_lower  = [None, -0.31, 1.96, 2.85, 3.54]

fig, ax = plt.subplots(figsize=(9, 5.5))
fig.patch.set_facecolor('white')

ax.plot(f_LM1, beta_during, 'b-o', linewidth=2.0, markersize=8,
        label='During proof load (beta_during)')
ax.plot(f_LM1, beta_after,  'g-s', linewidth=2.0, markersize=8,
        label='After successful test (beta_after)')

f_low_plot = [f_LM1[i] for i in range(1,5)]
b_low_plot = [beta_lower[i] for i in range(1,5)]
ax.plot(f_low_plot, b_low_plot, 'r-^', linewidth=2.0, markersize=8,
        label='Lower bound (beta_lower)')
ax.annotate('Step 1: N/A\n(proof load < traffic)', xy=(f_LM1[0], 1.55),
            xytext=(0.35, 0.2), fontsize=8, color='red',
            fontname='Times New Roman',
            arrowprops=dict(arrowstyle='->', color='red'))

ax.axhline(y=3.6, color='orange', linewidth=1.8, linestyle='--',
           label='RBK Reconstruction (beta = 3.6)')
ax.axhline(y=4.3, color='purple', linewidth=1.8, linestyle=':',
           label='RBK Design (beta = 4.3)')
ax.axhline(y=0,   color='black',  linewidth=0.8, linestyle='-', alpha=0.3)
ax.axvline(x=1.0, color='grey',   linewidth=1.0, linestyle='--', alpha=0.6,
           label='f_LM1 = 1.0 (LM1 target load)')

for i, (f, ba) in enumerate(zip(f_LM1, beta_after)):
    ax.annotate(f'Step {i+1}', xy=(f, ba), xytext=(f+0.01, ba+0.12),
                fontsize=8, color='darkgreen', fontname='Times New Roman')

ax.fill_between([0.70, f_LM1[-1]+0.05], [3.6, 3.6], [6.0, 6.0],
                alpha=0.08, color='green', label='Adequate zone (beta_after > 3.6)')

ax.set_xlabel('Proof load factor f_LM1 = V_PL / Q_k,LM1',
              fontsize=12, fontname='Times New Roman')
ax.set_ylabel('Reliability index beta',
              fontsize=12, fontname='Times New Roman')
ax.set_title('Shear Reliability Index vs. Proof Load Factor\nZijlweg Viaduct',
             fontsize=12, fontname='Times New Roman', fontweight='bold')
ax.legend(loc='upper left', fontsize=8.5, framealpha=0.9)
ax.set_xlim([0.20, 1.05])
ax.set_ylim([-1.5, 6.0])
ax.grid(True, alpha=0.25)
ax.tick_params(labelsize=10)
plt.tight_layout()
plt.savefig('Fig5.5_shear_reliability.png', dpi=300, bbox_inches='tight')
plt.close()
print('Saved: Fig5.5_shear_reliability.png')