// chapter_5_case_study_2_sectional_analysis_ZIJLWEG.cpp
//
// CORRECTED VERSION for Zijlweg viaduct dissertation analysis.
// Original code by Rein de Vries (chapter_5_case_study_2_sectional_analysis.cpp)
// Modified by: Neguse Solomon Mekonnen
// Dissertation: Bayesian Updating of Bridge Structural Reliability
// Supervisors: Dr. Eva Lantsoght, Dr. Rolando Chacon
// Date: May 19 2026
//
// Changes from original De Vries code:
// 1. Width b = 6.60m (Lantsoght 2017 Figure 2b)
// 2. Height h = LN(0.594m, CoV=0.10) (confirmed from Figure 2a)
// 3. Concrete cover c = Gamma(0.040m, CoV=0.17)
// 4. ALL bottom reinforcement from Lantsoght 2017 Figure 3:
//    Bar No. 4/9/16: phi28@300, Bar No. 11: phi16@300,
//    Bar No. 14: phi19@150 (ADDED), Bar No. 20: phi16@200 (ADDED)
// 5. Steel: f_y ~ Lognormal(230MPa, CoV=0.05) for QR22/QR24 plain bars
//    NOTE: Changed from Students-t to Lognormal because with only 2 data
//    points the Students-t has df=1 (Cauchy) with undefined mean/variance
// 6. Concrete: f_c ~ Lognormal(36.41MPa, CoV=0.10) from core tests

#include "rdv/msvcr.hpp"
#include "rdv/interpolate.hpp"
#include <boost/math/distributions/students_t.hpp>
#include <boost/math/special_functions/gamma.hpp>
#include "rdv/random_variable.hpp"
#include "rdv/sampling.hpp"
#include "rdv/vector_ext.hpp"
#include <fstream>
#include <omp.h>

int main(int argc, char* argv[]) {

    rdv::tic();
    std::cout.setf(std::ios::left);
    SetPriorityClass(GetCurrentProcess(), BELOW_NORMAL_PRIORITY_CLASS);

    // =========================================================
    // GEOMETRY
    // =========================================================
    double b = 6.60;
    auto rv_h = rdv::rv_lognormal::mv(0.594, 0.10);
    auto rv_c = rdv::rv_gamma::mv(0.040, 0.17);

    // =========================================================
    // REINFORCEMENT - ALL BOTTOM BARS (Lantsoght 2017 Figure 3)
    // =========================================================
    double A_s_bot1 = M_PI * rdv::sq(0.028 / 2.0) * b / 0.300; // phi28@300 No.4,9,16
    double A_s_bot2 = M_PI * rdv::sq(0.016 / 2.0) * b / 0.300; // phi16@300 No.11
    double A_s_bot3 = M_PI * rdv::sq(0.019 / 2.0) * b / 0.150; // phi19@150 No.14 ADDED
    double A_s_bot4 = M_PI * rdv::sq(0.016 / 2.0) * b / 0.200; // phi16@200 No.20 ADDED
    double A_s_top = M_PI * rdv::sq(0.016 / 2.0) * b / 0.300; // phi16@300 top

    // =========================================================
    // STEEL PROPERTIES
    // Use Lognormal instead of Students-t because with only 2 data
    // points (220 and 240 MPa) the Students-t has df=1 (Cauchy
    // distribution) which has no finite mean or variance and produces
    // physically impossible yield strains in some LHS samples.
    // JCSS (2001) recommends CoV=0.05 for steel yield strength.
    // =========================================================
    double f_ym = 230.0e6;   // mean yield strength (average of QR22/QR24)
    double f_y_cov = 0.05;   // CoV from JCSS (2001) for reinforcement steel
    auto rv_f_y = rdv::rv_lognormal::mv(f_ym, f_y_cov);

    double E_sm = 205e9;
    auto rv_E_s = rdv::rv_lognormal::mv(E_sm, 0.02);

    double eps_ym = f_ym / E_sm;
    double eps_y_to_eps_y2 = 0.01 / eps_ym;
    double eps_y_to_eps_u = 0.20 / eps_ym;
    double f_y_to_f_u = 360.0e6 / f_ym;

    // =========================================================
    // CONCRETE PROPERTIES
    // =========================================================
    double f_c_mean = 36.41e6;
    double f_c_cov = 0.10;
    auto rv_ln_f_c = rdv::rv_lognormal::mv(f_c_mean, f_c_cov);

    // Non-linearity parameters (De Vries, calibrated on experiments)
    double c_1 = 0.75;
    auto rv_c_2 = rdv::rv_lognormal::mv(0.41, 0.1);
    double c_3 = 4.1;

    // =========================================================
    // OUTPUT
    // =========================================================
    std::cout << "=== ZIJLWEG VIADUCT - CORRECTED SECTIONAL ANALYSIS ===\n";
    std::cout << "b = " << b << " m\n";
    std::cout << "h mean = 0.594 m\n";
    std::cout << "A_s_bot1 phi28@300: " << A_s_bot1 * 1e6 << " mm2\n";
    std::cout << "A_s_bot2 phi16@300: " << A_s_bot2 * 1e6 << " mm2\n";
    std::cout << "A_s_bot3 phi19@150: " << A_s_bot3 * 1e6 << " mm2 (ADDED)\n";
    std::cout << "A_s_bot4 phi16@200: " << A_s_bot4 * 1e6 << " mm2 (ADDED)\n";
    std::cout << "Total bottom: "
        << (A_s_bot1 + A_s_bot2 + A_s_bot3 + A_s_bot4) * 1e6 << " mm2\n";
    std::cout << "f_ym = " << f_ym / 1e6 << " MPa, CoV = " << f_y_cov << "\n";
    std::cout << "f_c mean = " << f_c_mean / 1e6 << " MPa, CoV = " << f_c_cov << "\n\n";

    // =========================================================
    // LATIN HYPERCUBE SAMPLING
    // =========================================================
    std::cout << "Creating latin hypercube...\n";
    size_t n_samples = 100;
    std::vector<std::vector<double>> samples;
    rdv::latin_hyp_sampling(6, n_samples, samples);

    std::vector<double> M_ys(n_samples);
    size_t curve_points = 101;
    double curve_eps_0 = 0.0;
    double curve_deps = 25e-6;
    std::vector<std::vector<double>> curves;
    resize(curves, n_samples, curve_points);

    // =========================================================
    // LOOP OVER SAMPLES
    // =========================================================
    std::cout << "Calculating curves...\n";

    for (size_t i_sample = 0; i_sample < n_samples; i_sample++) {
        const std::vector<double>& sample = samples[i_sample];

        double h = rv_h.quantile(sample[0]);
        double c = rv_c.quantile(sample[1]);
        double f_y = rv_f_y.quantile(sample[2]);   // Lognormal, no extreme values
        double E_s = rv_E_s.quantile(sample[3]);
        double f_c = rv_ln_f_c.quantile(sample[4]);
        double c_2 = rv_c_2.quantile(sample[5]);

        double E_c = 21.5e9 * pow(f_c / 1e7, 1.0 / 3.0);

        // Effective depths - four bottom layers
        double d_bot1 = h - c - 0.028 / 2.0;
        double d_bot2 = h - c - 0.028 - 0.010 - 0.016 / 2.0;
        double d_bot3 = h - c - 0.028 - 0.010 - 0.016 - 0.010 - 0.019 / 2.0;
        double d_bot4 = h - c - 0.028 - 0.010 - 0.016 - 0.010
            - 0.019 - 0.010 - 0.016 / 2.0;
        double d_top = c + 0.016 / 2.0;

        // Concrete stress-strain (Thorenfeldt 1987)
        double n_th = 0.8 + f_c / 17.24e6;
        double eps_0 = f_c / E_c * n_th / (n_th - 1.0);
        auto sigma_c = [&](double eps_c) -> double {
            if (eps_c < 0.0) return 0.0;
            double k_th = (eps_c < eps_0 ? 1.0 : 0.67 + f_c / 62.07e6);
            return f_c * n_th * eps_c / eps_0 /
                (n_th - 1.0 + pow(eps_c / eps_0, n_th * k_th));
            };

        // Steel stress-strain curve
        double eps_y = f_y / E_s;
        double eps_y2 = eps_y_to_eps_y2 * eps_y;
        double eps_u = eps_y_to_eps_u * eps_y;
        double f_u = f_y_to_f_u * f_y;
        std::vector<double> steel_eps = { -1.0, 0.0, eps_y, eps_y2,
                                          eps_u, eps_u + 1e-6, 1.0 };
        std::vector<double> steel_sig = { -E_s,  0.0, f_y,  f_y,
                                          f_u,   0.0,       0.0 };

        // Cross-section integration
        auto integrate = [&](double eps_c_top, double x,
            double& H, double& M) {
                double kappa = eps_c_top / x;
                H = 0.0; M = 0.0;

                int N = 100;
                double dz = h / N;
                for (int i = 0; i < N; i++) {
                    double z = (i + 0.5) * dz;
                    double eps_c = eps_c_top - kappa * z;
                    double F_c = -sigma_c(eps_c) * dz * b;
                    H += F_c; M += F_c * z;
                }

                auto add_steel = [&](double d_s, double A_s) {
                    double z = d_s;
                    double eps_c = eps_c_top - kappa * z;
                    double eps_s = -eps_c;
                    double sig_s = rdv::interpolate(steel_eps, steel_sig, eps_s,
                        rdv::extrapolation::linear);
                    double F_s = sig_s * A_s;
                    double F_c = -sigma_c(eps_c) * A_s;
                    H += F_s; H -= F_c;
                    M += F_s * z; M -= F_c * z;
                    };

                add_steel(d_bot1, A_s_bot1);
                add_steel(d_bot2, A_s_bot2);
                add_steel(d_bot3, A_s_bot3);
                add_steel(d_bot4, A_s_bot4);
                add_steel(d_top, A_s_top);
            };

        // Sweep top strain and build moment-strain curve
        std::vector<double> epss, Ms;
        epss.reserve(141); Ms.reserve(141);
        epss.push_back(0.0); Ms.push_back(0.0);

        for (double eps_c_top = 0.000025;
            eps_c_top < 0.0035001;
            eps_c_top += 0.000025) {

            double lo = 0.0, hi = h;
            for (int i = 0; hi - lo > 1e-6 && i < 100; i++) {
                double x_mid = (lo + hi) / 2.0;
                double H, M; integrate(eps_c_top, x_mid, H, M);
                if (H > 0.0) lo = x_mid; else hi = x_mid;
            }
            double x = (lo + hi) / 2.0;

            double kappa = eps_c_top / x;
            double eps_s_b1 = -eps_c_top + kappa * d_bot1;
            double H, M; integrate(eps_c_top, x, H, M);

            double eps_y_curr = f_y / E_s;
            double eps_mod = eps_s_b1 *
                (c_1 + c_2 * pow(eps_s_b1 / eps_y_curr, c_3));
            epss.push_back(eps_mod);
            Ms.push_back(M);
        }

        // Find yield moment using interpolation with constant extrapolation
        // to handle edge cases where eps_y is outside curve range
        double eps_y_curr = f_y / E_s;
        M_ys[i_sample] = rdv::interpolate(epss, Ms,
            eps_y_curr,
            rdv::extrapolation::constant);

        // Output curves at fixed strain points
        for (size_t i_point = 0; i_point < curve_points; i_point++) {
            double curve_eps = curve_eps_0 + curve_deps * i_point;
            curves[i_sample][i_point] = rdv::interpolate(epss, Ms,
                curve_eps,
                rdv::extrapolation::constant);
        }
    }

    // =========================================================
    // PRINT YIELD MOMENT STATISTICS
    // =========================================================
    double M_y_mean_val = mean(M_ys);
    double M_y_std_val = stddev_s(M_ys);
    std::cout << "\n=== YIELD MOMENT RESULTS ===\n";
    std::cout << "M_y mean = " << M_y_mean_val / 1e3 << " kNm\n";
    std::cout << "M_y std  = " << M_y_std_val / 1e3 << " kNm\n";
    std::cout << "M_y CoV  = " << M_y_std_val / M_y_mean_val << "\n\n";

    // =========================================================
    // WRITE CSV
    // =========================================================
    std::string file_name = "Moment-strain curves ZIJLWEG corrected.csv";
    std::cout << "Writing to: " << file_name << "\n";

    std::ofstream output_csv(file_name);
    output_csv << "M_y";
    for (size_t i = 0; i < n_samples; i++)
        output_csv << "," << M_ys[i] / 1e3;
    output_csv << "\n";

    for (size_t i_point = 0; i_point < curve_points; i_point++) {
        double curve_eps = curve_eps_0 + curve_deps * i_point;
        output_csv << curve_eps * 1e6;
        for (size_t i = 0; i < n_samples; i++)
            output_csv << "," << curves[i][i_point] / 1e3;
        output_csv << "\n";
    }

    rdv::toc();
    return 0;
}