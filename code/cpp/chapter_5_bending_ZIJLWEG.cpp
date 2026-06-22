// chapter_5_bending_ZIJLWEG.cpp
//
// Bayesian reliability updating for Zijlweg viaduct - BENDING failure mode
// Based on: chapter_5_case_study_2_reliability_updating.cpp by Rein de Vries
//
// CORRECTIONS applied:
// 1. rv_X uses direct constructor rv_normal(mean, std_dev) not rv_normal::mv
// 2. rv_Q_PL uses direct constructor to prevent CoV/std dev confusion
// 3. Adjusted proposal widths for MCMC to improve chain mixing
//
// Author (modifications): Neguse Solomon Mekonnen
// Supervisors: Dr. Eva Lantsoght, Dr. Rolando Chacon
// Date: May 20 2026

#include "rdv/msvcr.hpp"
#include "rdv/random_variable.hpp"
#include <vector>
#include <omp.h>
#include <iomanip>
#include <iostream>

int main(int argc, char* argv[]) {
    rdv::tic();
    std::cout.setf(std::ios::left);
    SetPriorityClass(GetCurrentProcess(), BELOW_NORMAL_PRIORITY_CLASS);

    // Random variables
    auto rv_theta_R    = rdv::rv_lognormal::mv(1.0, 0.15);
    auto rv_theta_E    = rdv::rv_lognormal::mv(1.0, 0.10);
    auto rv_theta_E_PL = rdv::rv_lognormal::mv(1.0, 0.10);
    auto rv_G_DL       = rdv::rv_normal::mv(183.8, 0.05);
    auto rv_G_SDL      = rdv::rv_normal::mv(33.0,  0.10);
    auto rv_C_0Q       = rdv::rv_lognormal::mv(1.1, 0.10);
    auto rv_Q          = rdv::rv_gumbel_max::mv(1301.0, 0.058);
    auto rv_U          = rdv::rv_normal(0.0, 1.0);

    double Q_k_LM1 = 2863.0;
    double Q_k_WIM = rv_Q.quantile(0.999);

    std::cout << "=== ZIJLWEG VIADUCT - BENDING RELIABILITY ANALYSIS ===\n";
    std::cout << "M_y_mean = 3248.87 kNm (corrected sectional analysis)\n";
    std::cout << "M_y_std  = 444.561 kNm\n";
    std::cout << "Q_k_LM1  = " << Q_k_LM1 << " kNm\n";
    std::cout << "Q_k_WIM  = " << Q_k_WIM << " kNm\n\n";

    double rho       = 0.7;
    double rho_compl = sqrt(1.0 - rho * rho);

    // Proof load steps and resistance ratios
    // m_Q_PL: proof load moments from bending04 MATLAB output (kNm)
    std::vector<double> m_Q_PL = { 898.0, 1921.3, 2480.4, 2738.1, 3029.4 };

    // m_X = M_y_mean / E_PL where E_PL = G_DL + G_SDL + Q_PL
    // M_y_mean = 3248.87 kNm from corrected sectional analysis
    std::vector<double> m_X = { 2.9143, 1.5195, 1.2045, 1.0995, 1.0008 };

    // V_X = CoV of M_y = constant = 0.1369
    // Used as std dev via direct constructor rv_normal(mean, std_dev)
    std::vector<double> V_X = { 0.3988, 0.2079, 0.1648, 0.1504, 0.1369 };

    std::cout << std::setw(10) << "Step"
              << std::setw(12) << "M_PL(kNm)"
              << std::setw(10) << "f_WIM"
              << std::setw(10) << "f_LM1"
              << std::setw(14) << "beta_during"
              << std::setw(14) << "beta_after"
              << std::setw(14) << "beta_lower"
              << std::setw(14) << "accept_rate" << "\n";
    std::cout << std::string(108, '-') << "\n";
    std::cout.precision(3);

    for (size_t i = 0; i < m_Q_PL.size(); i++) {
        // FIX: direct constructor specifies mean and std dev exactly
        auto rv_Q_PL = rdv::rv_normal(m_Q_PL[i], 0.02 * m_Q_PL[i]);
        auto rv_X    = rdv::rv_normal(m_X[i], V_X[i]);

        std::vector<uint32_t> seeds = rdv::generate_seeds(omp_get_max_threads());
        size_t total_samples = size_t(1e8);
        size_t burn_in       = 1000;
        double width_theta_R = 1.0 * (0.15 * rv_theta_R.mean());
        double width_X       = 1.0 * V_X[i];

        size_t accept_count = 0, post_samples = 0;
        size_t fail_during = 0, fail_after = 0, fail_lower = 0;

        #pragma omp parallel reduction(+:accept_count, post_samples, \
                fail_during, fail_after, fail_lower)
        {
            std::mt19937 gen(seeds[omp_get_thread_num()]);
            size_t thread_samples = total_samples / omp_get_num_threads();
            double theta_R_c = rv_theta_R.mean();
            double X_c       = rv_X.mean();
            double p_c = rv_theta_R.pdf(theta_R_c) * rv_X.pdf(X_c);

            for (size_t s = 0; s < thread_samples; s++) {
                double theta_R_p = theta_R_c + rv_U(gen) * width_theta_R;
                double X_p       = X_c       + rv_U(gen) * width_X;

                if (theta_R_p > 0.0 && X_p > 0.0 && theta_R_p * X_p > 1.0) {
                    double p_p   = rv_theta_R.pdf(theta_R_p) * rv_X.pdf(X_p);
                    double alpha = std::min(1.0, p_p / p_c);
                    if (std::generate_canonical<double, size_t(-1)>(gen) < alpha) {
                        theta_R_c = theta_R_p; X_c = X_p; p_c = p_p;
                        accept_count++;
                    }
                }

                if (s > burn_in) {
                    post_samples++;
                    double u1 = rv_U(gen);
                    double u2 = rho * u1 + rho_compl * rv_U(gen);
                    double theta_E    = rv_theta_E.from_std_norm(u1);
                    double theta_E_PL = rv_theta_E_PL.from_std_norm(u2);
                    double G_DL  = rv_G_DL(gen);
                    double G_SDL = rv_G_SDL(gen);
                    double C_0Q  = rv_C_0Q(gen);
                    double Q     = rv_Q(gen);
                    double Q_PL  = rv_Q_PL(gen);

                    double E_perm = theta_E * (G_DL + G_SDL);
                    double E_PL   = E_perm + theta_E_PL * Q_PL;
                    double E      = E_perm + theta_E * C_0Q * Q;

                    if (theta_R_c * X_c * E_PL - E < 0.0) fail_after++;

                    double theta_R_f = rv_theta_R(gen);
                    double X_f       = rv_X(gen);
                    if (theta_R_f * X_f * E_PL - E_PL < 0.0) fail_during++;

                    if (theta_E_PL * Q_PL - theta_E * C_0Q * Q < 0.0) fail_lower++;
                }
            }
        }

        double Pf_during = (double)fail_during / post_samples;
        double Pf_after  = (double)fail_after  / post_samples;
        double Pf_lower  = (double)fail_lower  / post_samples;
        double beta_during = (Pf_during > 0.0 ? -rdv::normal_quantile(Pf_during) : 6.0);
        double beta_after  = (Pf_after  > 0.0 ? -rdv::normal_quantile(Pf_after)  : 6.0);
        double beta_lower  = (Pf_lower  > 0.0 ? -rdv::normal_quantile(Pf_lower)  : 6.0);

        std::cout << std::setw(10) << (i+1)
                  << std::setw(12) << m_Q_PL[i]
                  << std::setw(10) << m_Q_PL[i] / Q_k_WIM
                  << std::setw(10) << m_Q_PL[i] / Q_k_LM1
                  << std::setw(14) << beta_during
                  << std::setw(14) << beta_after
                  << std::setw(14) << beta_lower
                  << std::setw(14) << (double)accept_count / total_samples << "\n";
    }
    rdv::toc();
    return 0;
}
