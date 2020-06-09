# Fit example hidden markov model

library(rstan)
options(mc.cores = 4)
rstan_options(auto_write=TRUE)

stan_data <- list(N = length(y),
                  K = 2,
                  y = y)
hmm_fit <- stan("hmm_ex.stan", data = stan_data, iter = 1e3, chains = 4)

print(hmm_fit, pars = "z_star", include = FALSE, probs = c(0.05,0.95))
