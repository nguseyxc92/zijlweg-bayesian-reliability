# generate_figure_5_6.py
# Figure 5.6: Stop criteria indicators vs applied shear force
# Author: Neguse Solomon Mekonnen

import numpy as np
import matplotlib.pyplot as plt
import matplotlib
matplotlib.rcParams['font.family'] = 'Times New Roman'

V_PL   = [338.4,    684.0,    925.4,    1042.6,   1146.5]
I_CSDT = [-0.000471, 0.000138, 0.001738, 0.003057, 0.004199]
I_CSCT = [0.109,    0.215,    0.285,    0.320,    0.352]
w_vals = [0.005187, 0.010690, 0.016380, 0.019986, 0.022651]

I_CSDT_yellow = 0.050
I_CSDT_red    = 0.100
f_c = 24.5
I_CSCT_thresh = np.sqrt(f_c) / 3.0

fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(9, 8), sharex=True)
fig.patch.set_facecolor('white')

# CSDT plot
ax1.fill_between([0, 1300], [0, 0], [I_CSDT_yellow]*2,
                  alpha=0.12, color='green')
ax1.fill_between([0, 1300], [I_CSDT_yellow]*2, [I_CSDT_red]*2,
                  alpha=0.12, color='orange')
ax1.fill_between([0, 1300], [I_CSDT_red]*2, [0.15]*2,
                  alpha=0.12, color='red')
ax1.plot(V_PL, I_CSDT, 'b-o', linewidth=2.0, markersize=9,
         label='I_CSDT (measured)')
ax1.axhline(y=I_CSDT_yellow, color='orange', linewidth=1.8, linestyle='--',
            label=f'Yellow threshold = {I_CSDT_yellow}')
ax1.axhline(y=I_CSDT_red,    color='red',    linewidth=1.8, linestyle='--',
            label=f'Red threshold = {I_CSDT_red}')
ax1.axhline(y=0, color='black', linewidth=0.8, alpha=0.4)
for j, (v, ic) in enumerate(zip(V_PL, I_CSDT)):
    ax1.annotate(f'Step {j+1}', xy=(v, ic), xytext=(v+12, ic+0.003),
                 fontsize=8, fontname='Times New Roman')
ax1.text(950, 0.062, 'YELLOW ZONE', fontsize=9, color='darkorange',
         fontname='Times New Roman', fontweight='bold')
ax1.text(950, 0.015, 'GREEN ZONE - All steps here', fontsize=9,
         color='darkgreen', fontname='Times New Roman', fontweight='bold')
ax1.set_ylabel('I_CSDT indicator', fontsize=11, fontname='Times New Roman')
ax1.set_title('Stop Criteria Indicators vs. Applied Shear Force\nZijlweg Viaduct - Shear Test (All Steps in Green Zone)',
              fontsize=12, fontname='Times New Roman', fontweight='bold')
ax1.legend(loc='upper left', fontsize=8.5, framealpha=0.9)
ax1.set_ylim([-0.008, 0.12])
ax1.set_xlim([200, 1250])
ax1.grid(True, alpha=0.25)
ax1.tick_params(labelsize=10)

# CSCT plot
I_CSCT_yellow = I_CSCT_thresh * 0.50
I_CSCT_red    = I_CSCT_thresh * 0.80
ax2.fill_between([0, 1300], [0, 0], [I_CSCT_yellow]*2,
                  alpha=0.12, color='green')
ax2.fill_between([0, 1300], [I_CSCT_yellow]*2, [I_CSCT_red]*2,
                  alpha=0.12, color='orange')
ax2.plot(V_PL, I_CSCT, 'r-s', linewidth=2.0, markersize=9,
         label='I_CSCT (measured)')
ax2.axhline(y=I_CSCT_thresh, color='darkred', linewidth=2.2, linestyle='-',
            label=f'CSCT capacity threshold = {I_CSCT_thresh:.3f}')
ax2.axhline(y=I_CSCT_yellow, color='orange', linewidth=1.8, linestyle='--',
            label=f'Yellow = {I_CSCT_yellow:.3f}')
ax2.axhline(y=I_CSCT_red,    color='red',    linewidth=1.8, linestyle=':',
            label=f'Red = {I_CSCT_red:.3f}')
for j, (v, ic) in enumerate(zip(V_PL, I_CSCT)):
    ax2.annotate(f'Step {j+1}', xy=(v, ic), xytext=(v+12, ic+0.01),
                 fontsize=8, fontname='Times New Roman')
ax2.text(700, 0.06, 'GREEN ZONE - All steps far below threshold',
         fontsize=9, color='darkgreen', fontname='Times New Roman',
         fontweight='bold')
ax2.set_xlabel('Applied shear force V_PL (kN)',
               fontsize=12, fontname='Times New Roman')
ax2.set_ylabel('I_CSCT indicator', fontsize=11, fontname='Times New Roman')
ax2.legend(loc='upper left', fontsize=8.5, framealpha=0.9)
ax2.set_ylim([0, 2.2])
ax2.set_xlim([200, 1250])
ax2.grid(True, alpha=0.25)
ax2.tick_params(labelsize=10)

plt.tight_layout()
plt.savefig('Fig5.6_stop_criteria.png', dpi=300, bbox_inches='tight')
plt.close()
print('Saved: Fig5.6_stop_criteria.png')