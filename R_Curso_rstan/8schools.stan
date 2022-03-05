data {
  int<lower=0> J;
  real y[J];
  real<lower=0> sigma[J];
}

parameters {
  real mu;
  real<lower=0> tau;
  real theta[J];
}

model {
   // Distribuições a priori
  tau ~ cauchy(0,25);
  theta ~ normal(mu, tau);
   // Verossimilhança
  y ~ normal(theta, sigma);
}

