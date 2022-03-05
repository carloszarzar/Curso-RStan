###### Curso RStan ######
# 6_Script: Mais um exmeplo modelos hierárquicos
# Autor: Carlos A. Zarzar
# Data: 21/12/2021
# e-mail: carloszarzar_@hotmail.com
# Objetivo: 
#   Exemplo modelo hierárquico stan
# Sites: https://mlisi.xyz/post/bayesian-multilevel-models-r-stan/
#-------------------#-------------------#-------------------#-------------------
rm(list = ls())
# pacotes
library(lme4)
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())
# Dados
str(sleepstudy)
  # informações dos dados
  # https://rdrr.io/cran/lme4/man/sleepstudy.html
# Data Stan
d_stan <- list(Subject = as.numeric(factor(sleepstudy$Subject, 
                                           labels = 1:length(unique(sleepstudy$Subject)))),
               Days = sleepstudy$Days,
               RT = sleepstudy$Reaction/1000,
               N = nrow(sleepstudy),
               J = length(unique(sleepstudy$Subject))
               )
d_stan

# Rodando Stan
sleep_model <- stan(file = "sleep_model.stan", data = d_stan, 
                    iter = 2000, chains = 4)
# Estimativa betas
print(sleep_model, pars = c("beta","sigma_u","sigma_e"), probs = c(0.025, 0.975), 
      digits = 3)

plot(sleep_model, plotfun = "hist", pars = c("beta", "sigma_u"))
# Matriz de correlação
print(sleep_model, pars = c("Omega"), digits = 3)

#----------------------------------------------------------------

library(brms)
fit1 <- brm(RT ~ 1 + Days + (1 + Days|Subject), data = d_stan)
print(fit1)
#----------------------------------------------------------------

C <- matrix(c(1,0.7,0.7,1),2,2) # Matriz de variância e covariância
L <- chol(C) # função para calcular o fator de Cholesky. (A função fornece a raiz quadrada triangular superior de C)
L
tau <- diag(c(1,2))
Lambda <- tau %*% t(L)
Z <- rbind(rnorm(5),rnorm(5))
X <- Lambda %*% Z
# correlation in the generated sample
cor(X[1,],X[2,])
