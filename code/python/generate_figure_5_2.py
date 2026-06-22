# generate_figure_5_2.py
# Figure 5.2: Prior resistance and demand PDFs
# Author: Neguse Solomon Mekonnen

import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm
import matplotlib
matplotlib.rcParams = plt.rcParams

matplotlib.rcParams['font.family'] = 'Times New Roman'

M_y_mean = 3248.87
M_y_std  = 444.56
theta_R_cov = 0.15
sigma_R = np.sqrt((theta_R_cov * M_y_mean)**2 + M_y_std**2)

E_mean = 1647.9
sigma_E = np.sqrt((0.10 * E_mean)**2 + (1.1 * 75.5)**2)

x = np.linspace(0, 6000, 2000)
pdf_R = norm.pdf(x, M_y_mean, sigma_R)
pdf_E = norm.pdf(x, E_mean,   sigma_E)

fig, ax = plt.subplots(figsize=(9, 5))
fig.patch.set_facecolor('white')

ax.plot(x, pdf_R, 'b-', linewidth=2.2,
        label=f'Resistance R: mean={M_y_mean:.0f} kNm, std={sigma_R:.0f} kNm')
ax.plot(x, pdf_E, 'r-', linewidth=2.2,
        label=f'Annual traffic E: mean={E_mean:.0f} kNm, std={sigma_E:.0f} kNm')

x_overlap = np.linspace(max(0, E_mean - 4*sigma_E),
                         min(6000, M_y_mean + 3*sigma_R), 1000)
pdf_overlap = np.minimum(norm.pdf(x_overlap, M_y_mean, sigma_R),
                          norm.pdf(x_overlap, E_mean,   sigma_E))
ax.fill_between(x_overlap, pdf_overlap, alpha=0.35, color='purple',
                label='Overlap = P(failure)')

ax.axvline(x=3248.87, color='blue',  linewidth=1.0, linestyle='--', alpha=0.7)
ax.axvline(x=1647.9,  color='red',   linewidth=1.0, linestyle='--', alpha=0.7)
ax.annotate('Safety margin\nZ_mean = 1,601 kNm',
            xy=(2450, 0.00010), fontsize=9, ha='center',
            fontname='Times New Roman',
            arrowprops=dict(arrowstyle='->', color='black'),
            xytext=(2450, 0.00030))
ax.annotate('', xy=(1647.9, 0.00010), xytext=(3248.87, 0.00010),
            arrowprops=dict(arrowstyle='<->', color='black', lw=1.5))

ax.set_xlabel('Bending moment (kNm)', fontsize=12, fontname='Times New Roman')
ax.set_ylabel('Probability density', fontsize=12, fontname='Times New Roman')
ax.set_title('Prior Resistance and Demand Distributions\nZijlweg Viaduct - Bending Analysis',
             fontsize=12, fontname='Times New Roman', fontweight='bold')
ax.legend(loc='upper right', fontsize=9, framealpha=0.9)
ax.set_xlim([0, 6000])
ax.set_ylim(bottom=0)
ax.grid(True, alpha=0.25)
ax.tick_params(labelsize=10)
plt.tight_layout()
plt.savefig('Fig5.2_prior_distributions.png', dpi=300, bbox_inches='tight')
plt.close()
print('Saved: Fig5.2_prior_distributions.png')