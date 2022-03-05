###### Curso RStan ######
# 5_Script: Exemplo - 5 Modelo de regressão logística 2
# Dados de resposta de troca de poço, dados dois preditores: o nível de arsênico da água na casa do residente e a distância da casa até o poço seguro mais próximo.
# Autor: Carlos A. Zarzar
# Data: 21/12/2021
# e-mail: carloszarzar_@hotmail.com
# Objetivo: 
#   Exemplo - 5 Segundo exemplo do modelo de regressão logístico
# Sites: https://cran.microsoft.com/snapshot/2016-11-22/web/packages/loo/vignettes/Example.html
#-------------------#-------------------#-------------------#-------------------
rm(list = ls())

# Prepare data 
url <- "http://stat.columbia.edu/~gelman/arm/examples/arsenic/wells.dat"
wells <- read.table(url)
wells$dist100 <- wells$dist / 100 # rescale 
y <- wells$switch # 1-Muda poço, 0-permanece com o poço
a <- qlogis(mean(y)) # i.e., a = logit(Pr(y = 1))
x <- scale(model.matrix(~ 0 + dist + arsenic, wells))
data <- list(N = nrow(x), P = ncol(x), a = a, x = x, y = y)

# Modelo Stan
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

mod <- "
data {
  int<lower=0> N; // number of data points
  int<lower=0> P; // number of predictors (including intercept)
  int<lower=0,upper=1> y[N]; // binary outcome
  matrix[N,P] x; // predictors (no including intercept)
  real a;
}
parameters {
  real beta0;
  vector[P] beta;
}
model {
  beta0 ~ student_t(7, a, 0.1);
  beta ~ student_t(7, 0, 1);
  y ~ bernoulli_logit(beta0 + x * beta);
}


"

# Fit model
fit1 <- stan(model_code = mod, data = data)
print(fit1,pars=c("beta0","beta[1]","beta[2]"))
