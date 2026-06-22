// load_effect.hpp
//
// Minimal header for load-effect modelling.
// Compatible with rdv / De Vries reliability framework.
//
// Author: Neguse Solomon Mekonnen
// Date: 2026

#pragma once

#include <vector>
#include <cmath>

namespace rdv {

/**
 * @brief Abstract base class for a load effect model
 *
 * A LoadEffect maps basic variables (loads, resistances, uncertainties)
 * to a scalar effect (e.g. shear force, moment, stress).
 */
class LoadEffect {
public:
    virtual ~LoadEffect() = default;

    /**
     * @brief Evaluate the load effect
     *
     * @param params Vector of input parameters
     * @return Scalar load effect value
     */
    virtual double evaluate(const std::vector<double>& params) const = 0;
};

/**
 * @brief Simple linear combination load effect
 *
 * Example:
 *   E = theta * (G_DL + G_SDL) + theta_Q * Q
 */
class LinearLoadEffect : public LoadEffect {
public:
    LinearLoadEffect(double theta = 1.0,
                     double theta_Q = 1.0)
        : theta_(theta), theta_Q_(theta_Q) {}

    double evaluate(const std::vector<double>& p) const override {
        // p[0] = G_DL
        // p[1] = G_SDL
        // p[2] = Q
        return theta_ * (p[0] + p[1]) + theta_Q_ * p[2];
    }

private:
    double theta_;
    double theta_Q_;
};

} // namespace rdv
