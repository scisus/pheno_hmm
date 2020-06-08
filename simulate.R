# Simulate 3 state data

# States
K = 3
# Transition probs - self. States are pretty sticky.
p11 <- 0.9
p22 <- 0.8
# Transition matrix
theta <- rbind(c(p11, 1-p11, 0), c(0, p22, 1-p22), c(0,0,1))

# emission vector (3 states). Observations are very likely to match the true state, but sometimes observers screw up. When observers screw up, they're more likely to choose an adjacent state.
psi <- rbind(c(0.99, 0.009, 0.001), c(0.005, 0.99 , 0.005), c(0.001, 0.009, 0.99))

# obs
N = 100

# hidden states
z <- 1
for (i in 2:N) {
    z[i] <- sample(1:K, 1, replace = TRUE, prob = theta[z[i-1],]) # theta[row,]
}

# observations
y <- c()
for (i in 1:N) {
    y[i] <- sample(1:K, 1, replace = TRUE, prob = psi[z[i],])
}

# visualization
par(mfrow=c(2,1))
plot(z, type="p",
     main = "Latent States",
     ylab = "State Value",
     xlab = "Time")
plot(y, type = "l",
     main = "Observed Output",
     ylab = "Observation Value",
     xlab = "Time")

write.csv(data.frame(y=y, z=z), "simulated_data.csv", row.names = FALSE)
