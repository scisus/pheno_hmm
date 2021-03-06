// simple hmm example (1 output; 3 states)
data {
    int<lower=0> N; // # of obs
    int<lower=0> K; // # of true states (same as number of observed states)

    int<lower=1, upper=K> y[N]; // observations

    vector<lower=0>[K] beta; //emission prior param
}

parameters {
    //vector<lower=0>[K] alpha; //transition prior
    real<lower=0, upper=1> a; //transition prior
    real<lower=0, upper=1> b; //transition prior 2

    //simplex[K] theta[K]; //transition probs
    simplex[K] phi[K]; // emission probs
}

transformed parameters {
     simplex[K] theta[K]
     = { [a, 1-a, 0]',
         [0, b, 1-b]',
         [0, 0, 1]' };
}

model {
    // priors
    // for (k in 1:K) {
    //     theta[k] ~ dirichlet(alpha);
    // }

    a ~ beta(2,2);
    b ~ beta(2,2);

    for (k in 1:K) {
        phi[k] ~ dirichlet(beta);
    }

    // forward algorithm
    {
        real acc[K];
        real gamma[N, K];
        for (k in 1:K)
            gamma[1, k] = log(phi[k, y[1]]);
        for (n in 2:N) {
            for (k in 1:K) {
                for (j in 1:K)
                    acc[j] = gamma[n-1, j] + log(theta[j, k]) + log(phi[k, y[n]]);
                gamma[n, k] = log_sum_exp(acc);
            }
        }
        target += log_sum_exp(gamma[N]);
    }
}

// generated quantities {
//     int<lower=1,upper=K> z_star[N];
//     real log_p_z_star;
//     {
//         int back_ptr[N, K];
//         real best_logp[N, K];
//         for (k in 1:K)
//             best_logp[1, k] = normal_lpdf(y[1] | mu[k], 1);
//         for (t in 2:N) {
//             for (k in 1:K) {
//                 best_logp[t, k] = negative_infinity();
//                 for (j in 1:K) {
//                     real logp;
//                     logp = best_logp[t-1, j] + log(theta[j, k]) + normal_lpdf(y[t] | mu[k], 1);
//                     if (logp > best_logp[t, k]) {
//                         back_ptr[t, k] = j;
//                         best_logp[t, k] = logp;
//                     }
//                 }
//             }
//         }
//         log_p_z_star = max(best_logp[N]);
//         for (k in 1:K)
//             if (best_logp[N, k] == log_p_z_star)
//                 z_star[N] = k;
//         for (t in 1:(N - 1))
//             z_star[N - t] = back_ptr[N - t + 1, z_star[N - t + 1]];
//     }
// }
//
//


