###### Curso RStan ######
# 1_Script: Exemplo 8 escolas
# Autor: Carlos A. Zarzar
# Data: 21/12/2021
# e-mail: carloszarzar_@hotmail.com
# Objetivo: 
#   Exemplo modelo hierárquico 8 escolas lingugem Stan
#-------------------#-------------------#-------------------#-------------------
rm(list = ls())

# Dados
schools <- list(J = 8, y = c(28,  8, -3,  7, -1,  1, 18, 12), 
                sigma = c(15, 10, 16, 11,  9, 11, 10, 18),
                esc = factor(LETTERS[1:8]))
# Gráfico dos dados
plot(schools$y, pch = 4, col = 1, lwd = 3, ylim = c(-20,50),
     ylab = 'training effect', xlab = 'school', main = 'Observed training effects')
arrows(1:8, schools$y-schools$sigma, 1:8, schools$y+schools$sigma,
       length=0.05, angle=90, code=3, col = 4, lwd = 2)
abline(h = 0, lty = 2)
# abline(h = mean(schools$y))
# Modelo não agrupado (No pooling modelo)
set.seed(123)
n_sim <- 1e4
theta <- matrix(numeric(n_sim * schools$J), ncol = schools$J)
for(j in 1:schools$J)
  theta[ ,j] <- rnorm(n_sim, schools$y[j], schools$sigma[j])

boxplot(theta, col = 'skyblue', ylim = c(-60, 80), main = 'No pooling model')
abline(h = 0, lty = 2)
points(schools$y, col = 'red', lwd=2, pch=4)

# Completamente agrupado (complete pooling)
pooled_variance <- 1 / sum(1 / schools$sigma^2) # precisão é a soma das precisões de amostragem
grand_mean <- pooled_variance * sum(schools$y / schools$sigma^2) # Média ponderada

theta <- matrix(rnorm(n_sim * schools$J, grand_mean, pooled_variance), 
                ncol = schools$J)

boxplot(theta, col = 'skyblue', ylim = c(-60, 80), main = 'Complete pooling')
abline(h = 0, lty = 2)
points(schools$y, col = 'red', lwd=2, pch=4)

# Modelo hierarquico
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
# Modelo em arquivo .stan
fit_1 <- stan('8schools.stan', data = schools, iter = 1e4, chains = 4)
#----------------------
# Modelo como character
mod <- "data {
  int<lower=1> J;
  real y[J];
  vector[J] sigma;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real mu;
  real<lower=0> tau;
  real theta[J];
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  y ~ normal(theta, sigma);
  theta ~ normal(mu,tau);
  tau ~ cauchy(0,25);
}


"
# Lendo e conferindo o modelo stan
model <- stan_model(model_name = "8School", model_code = mod)
# Amostras MCMC (HMC)
fit_2 <- sampling(model, data = schools,
                  control = list(adapt_delta = 0.95),
                  chains=4, thin=2, iter=1e4, warmup=5000)
#----------------------
fit_2 # lp_ => logaritmo da densidade a posteriori (comparação de modelos)
# Extraindo dados do modelo stan
sim4 <- extract(fit_2)
# Plotando alguns resultados
boxplot(sim4$theta, col = 'skyblue',
        main = 'Hierarchical model with Cauchy prior')
abline(h=0)

hist(sim4$tau, col = 'red', breaks = 30, probability = TRUE,
     main = 'Posterior with Cauchy(0,25)', xlab = expression(tau),
     ylim =c(0,.12), xlim = c(0,60))
# Plote as posteriores
plot(fit_2)
# Trace plot das cadeias MCMC
traceplot(fit_2, pars = c("mu", "tau"), inc_warmup = TRUE, nrow = 2)

library(shinystan)
launch_shinystan(fit_2)



