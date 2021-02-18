function F = solowModel(k)
F = 0.4 * k^(0.3) - (0.05 + 0.03 + 0.02 + (0.02 * 0.03)) * k;