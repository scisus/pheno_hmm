# fit simple hmm model

library(rstan)

options(mc.cores = 4)
rstan_options(auto_write=TRUE)

simdat <- read.csv("simulated_data.csv")
alpha <- c(2,2,2) # param for dirichlet prior on transition
beta <- c(2,2,2) # param for dirichlet prior on emission
K <- 3

stan_dat <- list(y = as.integer(simdat$y), alpha = alpha, beta = beta, N = nrow(simdat), K=K)

hmm_fit <- stan("hmm.stan", data = stan_dat, iter=2000, warmup = 1000, chains = 4)
