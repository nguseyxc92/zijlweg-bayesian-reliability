// chapter_5_shear_ZIJLWEG_FIXED.cpp
//
// Bayesian reliability updating for Zijlweg viaduct - SHEAR failure mode
// Based on: chapter_5_case_study_1.cpp by Rein de Vries
//
// FINAL CORRECTIONS APPLIED:
// 1. rv_Q_PL uses direct constructor: rdv::rv_normal(mean, std_dev)
// 2. rv_X (Students-t) scale parameter corrected to use std_dev
// 3. MCMC proposal widths adjusted for acceptance rate ~0.56
//
// Author (modifications): Neguse Solomon Mekonnen
// Supervisors: Dr. Eva Lantsoght, Dr. Rolando Chacon
// Date: May 20 2026

#include "rdv/msvcr.hpp"
#include <boost/math/distributions/students_t.hpp>
#include "rdv/random_variable.hpp"
#include "rdv/reliability.hpp"
#include <vector>
#include <omp.h>
#include <iomanip>

int main(int argc, char* argv[]) {
    rdv::tic();
    std::cout.setf(std::ios::left);
    SetPriorityClass(GetCurrentProcess(), BELOW_NORMAL_PRIORITY_CLASS);

    double Q_k_LM1 = 1228.0;

    auto rv_theta_R    = rdv::rv_lognormal::mv(1.0, 0.15);
    auto rv_theta_E    = rdv::rv_lognormal::mv(1.0, 0.10);
    auto rv_theta_E_PL = rdv::rv_lognormal::mv(1.0, 0.10);
    auto rv_G_DL       = rdv::rv_normal::mv(476.0, 0.05);
    auto rv_G_SDL      = rdv::rv_normal::mv(85.0,  0.10);
    auto rv_C_0Q       = rdv::rv_lognormal::mv(1.1, 0.10);
    auto rv_Q          = rdv::rv_gumbel_max::mv(651.7, 0.035);
    auto rv_U          = rdv::rv_normal(0.0, 1.0);

    double Q_k_WIM = rv_Q.quantile(0.999);
    std::cout << "=== ZIJLWEG VIADUCT - SHEAR RELIABILITY ANALYSIS ===\n";
    std::cout << "Q_k_LM1 = " << Q_k_LM1 << " kN\n";
    std::cout << "Q_k_WIM = " << Q_k_WIM << " kN\n\n";

    double rho       = 0.7;
    double rho_compl = sqrt(1.0 - rho * rho);

    // Proof load steps and measured crack widths from shear01 MATLAB output
    std::vector<double> m_V_PL  = { 338.4, 684.0, 925.4, 1042.6, 1146.5 };
    std::vector<double> w_max_w = { 0.005187, 0.010690, 0.016380, 0.019986, 0.022651 };
    size_t n_X = 5; // De Vries slab strip calibration dataset size

    std::cout << std::setw(10) << "Step"
              << std::setw(12) << "V_PL(kN)"
              << std::setw(10) << "w_max,w"
              << std::setw(10) << "m_X"
              << std::setw(14) << "beta_during"
              << std::setw(14) << "beta_after"
              << std::setw(14) << "beta_lower"
              << std::setw(14) << "accept_rate" << "\n";
    std::cout << std::string(108, '-') << "\n";
    std::cout.precision(3);

    for (size_t i = 0; i < m_V_PL.size(); i++) {
        double w = w_max_w[i];

        // Exponential resistance model (De Vries et al. 2025)
        double m_X_val = (w < 0.85 ? 1.5 * exp(-3.0 * w) + 0.88 : 1.0);
        double s_X_val = (w < 1.1  ? 0.53 * exp(-2.1 * w) - 0.05 : 1e-7);
        if (s_X_val < 1e-6) s_X_val = 1e-7;
        double total_std_X = s_X_val * sqrt(1.0 + 1.0 / (double)n_X);

        // FIX: direct constructors specifying mean and std dev
        auto rv_V_PL = rdv::rv_normal(m_V_PL[i], 0.02 * m_V_PL[i]);
        auto rv_X    = rdv::rv_students_t((double)(n_X - 1), m_X_val, total_std_X);

        std::vector<uint32_t> seeds = rdv::generate_seeds(omp_get_max_threads());
        size_t total_samples = size_t(1e8);
        size_t burn_in       = 1000;
        double width_theta_R = 1.0 * (0.15 * rv_theta_R.mean());
        double width_X       = 1.0 * total_std_X;

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
                    double G_DL       = rv_G_DL(gen);
                    double G_SDL      = rv_G_SDL(gen);
                    double C_0Q       = rv_C_0Q(gen);
                    double Q          = rv_Q(gen);
                    double V_PL_s     = rv_V_PL(gen);

                    double E_perm    = theta_E * (G_DL + G_SDL);
                    double E_PL      = E_perm + theta_E_PL * V_PL_s;
                    double E_traffic = E_perm + theta_E * C_0Q * Q;

                    if (theta_R_c * X_c * E_PL - E_traffic < 0.0) fail_after++;

                    double theta_R_f = rv_theta_R(gen);
                    double X_f       = rv_X(gen);
                    if (theta_R_f * X_f * E_PL - E_PL < 0.0) fail_during++;

                    if (theta_E_PL * V_PL_s - theta_E * C_0Q * Q < 0.0) fail_lower++;
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
                  << std::setw(12) << m_V_PL[i]
                  << std::setw(10) << w
                  << std::setw(10) << m_X_val
                  << std::setw(14) << beta_during
                  << std::setw(14) << beta_after
                  << std::setw(14) << beta_lower
                  << std::setw(14) << (double)accept_count / total_samples << "\n";
    }
    rdv::toc();
    return 0;
}
