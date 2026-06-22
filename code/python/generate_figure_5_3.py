# generate_figure_5_3.py
# Figure 5.3: Bending reliability vs proof load factor
# Author: Neguse Solomon Mekonnen

import numpy as np
import matplotlib.pyplot as plt
import matplotlib
matplotlib.rcParams['font.family'] = 'Times New Roman'

f_LM1       = [0.314, 0.671, 0.866, 0.956, 1.059]
beta_during = [4.36,   1.88,  0.821, 0.384, -0.076]
beta_after  = [2.68,   3.37,  4.40,  4.83,   5.33]
beta_lower  = [-3.36,  2.12,  3.77,  4.37,   5.00]

fig, ax = plt.subplots(figsize=(9, 5.5))
fig.patch.set_facecolor('white')

ax.plot(f_LM1, beta_during, 'b-o', linewidth=2.0, markersize=8,
        label='During proof load (beta_during)')
ax.plot(f_LM1, beta_after,  'g-s', linewidth=2.0, markersize=8,
        label='After successful test (beta_after)')
ax.plot(f_LM1, beta_lower,  'r-^', linewidth=2.0, markersize=8,
        label='Lower bound (beta_lower)')

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

ax.fill_between([0.8, 1.059], [3.6, 3.6], [6.0, 6.0],
                alpha=0.08, color='green', label='Adequate zone (beta_after > 3.6)')

ax.set_xlabel('Proof load factor f_LM1 = M_PL / Q_k,LM1',
              fontsize=12, fontname='Times New Roman')
ax.set_ylabel('Reliability index beta',
              fontsize=12, fontname='Times New Roman')
ax.set_title('Bending Reliability Index vs. Proof Load Factor\nZijlweg Viaduct',
             fontsize=12, fontname='Times New Roman', fontweight='bold')
ax.legend(loc='upper left', fontsize=8.5, framealpha=0.9)
ax.set_xlim([0.25, 1.15])
ax.set_ylim([-4.5, 6.5])
ax.grid(True, alpha=0.25)
ax.tick_params(labelsize=10)
plt.tight_layout()
plt.savefig('Fig5.3_bending_reliability.png', dpi=300, bbox_inches='tight')
plt.close()
print('Saved: Fig5.3_bending_reliability.png')