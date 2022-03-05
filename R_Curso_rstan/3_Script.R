###### Curso RStan ######
# 3_Script: Exemplo regressão linear simples com heterocedasticidade
# Autor: Carlos A. Zarzar
# Data: 21/12/2021
# e-mail: carloszarzar_@hotmail.com
# Objetivo: 
#   Exemplo modelo de regressão linear simples
#   com heterocedasticidade na lingugem Stan
# Sites: https://blog.curso-r.com/posts/2017-02-21-regressao-heterocedastica/
#-------------------#-------------------#-------------------#-------------------
rm(list = ls())
# pacotes
library(ggplot2)
# Tamanho da amostra
N <- 1000
# fixando uma semente (número pseudoaleatório)
set.seed(11071995)
X <- sample((N/100):(N*3), N)
Y <- rnorm(N,1*X,4*sqrt(X))

qplot(X,Y) + 
  theme_bw(15) + 
  geom_point(color = 'darkorange')

dataset <- data.frame(Y,X)

library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

scode <- "data {
  int<lower=0> N;
  vector[N] y;
  vector[N] x;
}
parameters {
  real beta;
  real<lower=0> alpha;
}
model {
  beta ~ normal(0,10);
  alpha ~ gamma(1,1);

  y ~ normal(beta * x, alpha * sqrt(x));
}"

dados <- list(N = nrow(dataset), y = dataset$Y, x = dataset$X)

fit_stan <- rstan::stan(model_code = scode, verbose = FALSE, data = dados,
                        control = list(adapt_delta = 0.99))







