# generate_figure_5_1.py
# Figure 5.1: Moment-strain curves for 100 LHS samples
# Input: Moment-strain curves ZIJLWEG corrected.csv
# Author: Neguse Solomon Mekonnen

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib
matplotlib.rcParams['font.family'] = 'Times New Roman'
matplotlib.rcParams['font.size'] = 11

df = pd.read_csv('Moment-strain curves ZIJLWEG corrected.csv', header=0)
strain_vals  = df['M_y'].values.astype(float)
moment_curves = df.iloc[:, 1:].values.astype(float)
mean_curve   = np.mean(moment_curves, axis=1)

fig, ax = plt.subplots(figsize=(9, 5.5))
set(fig, 'Color', 'white') if False else ax.set_facecolor('white')
fig.patch.set_facecolor('white')

for i in range(moment_curves.shape[1]):
    ax.plot(strain_vals, moment_curves[:, i],
            color='#CCCCCC', linewidth=0.4, alpha=0.7)

ax.plot(strain_vals, mean_curve, 'k-', linewidth=2.2,
        label=f'Mean curve (M_y,mean = 3,249 kNm)')

ax.axhline(y=3248.87, color='black', linewidth=1.2,
           linestyle='--', label='Mean yield moment = 3,249 kNm')

eps_measured = [52.233, 111.748, 178.862, 206.615, 239.220]
colors_s = ['#1f77b4','#ff7f0e','#2ca02c','#d62728','#9467bd']
for j, (eps, col) in enumerate(zip(eps_measured, colors_s)):
    ax.axvline(x=eps, color=col, linewidth=1.3, linestyle=':',
               label=f'Step {j+1}: {eps:.0f} με')

ax.set_xlabel('Concrete strain at bottom fibre (με)',
              fontsize=12, fontname='Times New Roman')
ax.set_ylabel('Bending moment (kNm)',
              fontsize=12, fontname='Times New Roman')
ax.set_title('Moment-Strain Curves for 100 LHS Realisations\nZijlweg Viaduct - Corrected Sectional Analysis',
             fontsize=12, fontname='Times New Roman', fontweight='bold')
ax.legend(loc='upper left', fontsize=8, framealpha=0.9)
ax.set_xlim([0, 2500])
ax.set_ylim([0, 5500])
ax.grid(True, alpha=0.25)
ax.tick_params(labelsize=10)
plt.tight_layout()
plt.savefig('Fig5.1_moment_strain_curves.png', dpi=300, bbox_inches='tight')
plt.close()
print('Saved: Fig5.1_moment_strain_curves.png')