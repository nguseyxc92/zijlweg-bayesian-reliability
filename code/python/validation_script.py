# validation_script.py
#
# ZIJLWEG VIADUCT - RELIABILITY VALIDATION SCRIPT
# This script verifies the C++ MCMC results using a simplified Monte Carlo 
# Bayesian update for Bending and Shear.
#
# Author: Neguse Solomon Mekonnen
# Dissertation: Bayesian Updating of Bridge Structural Reliability
# Supervisors: Dr. Eva Lantsoght, Dr. Rolando Chacon
# Date: May 13 2026

import numpy as np
from scipy.stats import norm

def calculate_beta(Pf):
    """Convert failure probability to reliability index."""
    if Pf <= 0: return 8.0
    if Pf >= 1: return -8.0
    return -norm.ppf(Pf)

def run_validation(mode="bending"):
    print(f"\n--- VALIDATING {mode.upper()} FAILURE MODE ---")
    np.random.seed(42)
    n_sim = 10000000  # 10 million samples for validation
    
    # Correlation between model uncertainties (theta_E and theta_E_PL)
    rho = 0.7
    u1 = np.random.normal(0, 1, n_sim)
    u2 = rho * u1 + np.sqrt(1 - rho**2) * np.random.normal(0, 1, n_sim)
    
    # Model Uncertainties (Lognormal Mean 1.0, CoV 0.10)
    sig_ln = np.sqrt(np.log(1 + 0.10**2))
    mu_ln = np.log(1.0) - 0.5 * sig_ln**2
    theta_E = np.exp(mu_ln + sig_ln * u1)
    theta_E_PL = np.exp(mu_ln + sig_ln * u2)
    
    # Model Uncertainty for Resistance (Lognormal Mean 1.0, CoV 0.15)
    sig_ln_R = np.sqrt(np.log(1 + 0.15**2))
    mu_ln_R = np.log(1.0) - 0.5 * sig_ln_R**2
    theta_R = np.random.lognormal(mu_ln_R, sig_ln_R, n_sim)

    if mode == "bending":
        # Inputs from Table 4.7 & 4.9
        G_DL_m, G_SDL_m = 183.8, 33.0
        Q_m, Q_cov = 1301.0, 0.058
        C0Q = np.random.lognormal(np.log(1.1) - 0.5*np.log(1+0.1**2), 0.1, n_sim)
        
        # Load Steps (kNm)
        steps = [898.0, 1921.3, 2480.4, 2738.1, 3029.4]
        # Resistance ratio parameters from C++ (m_X, s_X)
        m_X_list = [2.9143, 1.5195, 1.2045, 1.0995, 1.0008]
        s_X_list = [0.3988, 0.2079, 0.1648, 0.1504, 0.1369]
        
    else: # shear
        G_DL_m, G_SDL_m = 476.0, 85.0
        Q_m, Q_cov = 651.7, 0.035
        C0Q = 1.1 # simplified for shear validation
        
        steps = [338.4, 684.0, 925.4, 1042.6, 1146.5]
        # m_X and s_X from Exponential Model
        m_X_list = [2.355, 2.326, 2.294, 2.274, 2.259]
        s_X_list = [0.474, 0.468, 0.462, 0.458, 0.455]

    # Future Traffic Demand (Annual)
    G_DL = np.random.normal(G_DL_m, 0.05 * G_DL_m, n_sim)
    G_SDL = np.random.normal(G_SDL_m, 0.10 * G_SDL_m, n_sim)
    Q_traffic = np.random.gumbel(Q_m - 0.5772 * (np.sqrt(6)*Q_m*Q_cov/np.pi), (np.sqrt(6)*Q_m*Q_cov/np.pi), n_sim)
    E_traffic = theta_E * (G_DL + G_SDL + C0Q * Q_traffic)

    print(f"{'Step':<6} | {'Load':<10} | {'Beta_After (Validation)':<15}")
    print("-" * 45)

    for i in range(len(steps)):
        # Generate Prior Resistance for this step
        X_prior = np.random.normal(m_X_list[i], s_X_list[i], n_sim)
        
        # Test Load Effect
        E_PL = theta_E * (G_DL + G_SDL) + theta_E_PL * steps[i]
        
        # Survival Conditioning (Bayesian Likelihood)
        # Resistance = theta_R * X * E_PL
        survival_mask = (theta_R * X_prior > 1.0)
        
        # Posterior Reliability
        n_survived = np.sum(survival_mask)
        if n_survived > 0:
            fails = np.sum((theta_R[survival_mask] * X_prior[survival_mask] * E_PL[survival_mask]) < E_traffic[survival_mask])
            Pf = fails / n_survived
            beta = calculate_beta(Pf)
            print(f"{i+1:<6} | {steps[i]:<10.1f} | {beta:<15.2f}")
        else:
            print(f"{i+1:<6} | {steps[i]:<10.1f} | ERROR: No survivors")

if __name__ == "__main__":
    run_validation("bending")
    run_validation("shear")