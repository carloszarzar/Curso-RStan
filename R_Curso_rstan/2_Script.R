###### Curso RStan ######
# 2_Script: Exemplo regressão linear simples
# Autor: Carlos A. Zarzar
# Data: 21/12/2021
# e-mail: carloszarzar_@hotmail.com
# Objetivo: 
#   Exemplo modelo de regressão linear simples lingugem Stan
# Sites: https://personalpages.manchester.ac.uk/staff/david.selby/rthritis/2021-03-26-stan/Bayesian-modelling-with-Stan.html#1
#-------------------#-------------------#-------------------#-------------------
rm(list = ls())
library(ggplot2)
library(rstan)
rstan_options(auto_write = TRUE)
# options(mc.cores = parallel::detectCores())
# Dados
## http://www.lac.inpe.br/~rafael.santos/Docs/CAP394/WholeStory-Iris.html
data("iris")
head(iris)
# Separando dados da espécie versicolor
index <- which(iris$Species == 'versicolor')
# Relação comprimento da petala ~ sepala
x <- iris$Sepal.Length[index]
y <- iris$Petal.Length[index]


#------------------------------
# Dados
dat<-iris[iris$Species=="setosa",c("Petal.Length", "Sepal.Length")]
# Modelo regressão linear simples (frequentista)
mod <- lm(Petal.Length ~ Sepal.Length, data = dat)
# Predição
dat <- transform(dat, Fitted = fitted(mod))
# Gráfico do erro residual
ggplot(dat, aes(x=Sepal.Length, y=Petal.Length)) + 
  geom_point(color="red") + geom_smooth(se=FALSE, method = "lm") +
  geom_segment(aes(x = Sepal.Length, y = Petal.Length,
                   xend = Sepal.Length, yend = Fitted))
# Modelo stan (salva automaticamente arquivo .stan)
write("// Stan model for simple linear regression
data {
 int < lower = 1 > N; // Sample size
 vector[N] x; // Predictor
 vector[N] y; // Outcome
}
parameters {
 real alpha; // Intercept
 real beta; // Slope (regression coefficients)
 real < lower = 0 > sigma; // Error SD
}
model {
 y ~ normal(alpha + x * beta , sigma);
}
generated quantities {
} // The posterior predictive distribution",

"stan_model1.stan")
# Conferindo o modelo 
stanc("stan_model1.stan")$status# Check if we wrote a file 
# Dados importados para Stan
stan_data<-list(y=dat$Petal.Length, x=dat$Sepal.Length, N=nrow(dat))#prepare the data
# Compilando o modelo C++ e rodando
stan_model1 <- "stan_model1.stan" # save the file path 
fit <- stan(file = stan_model1, data = stan_data, warmup = 500, iter = 1000, chains = 4, cores = 2, thin = 1)#running the model
# Resultados
print(fit) #basic summary stat

library(shinystan)
launch_shinystan(fit)

# Explorando as posteriores
posterior <- rstan::extract(fit)
plot(stan_data$y~ stan_data$x, pch = 20,type="n")
for (i in 1:500) {
  abline(posterior$alpha[i], posterior$beta[i], col = "gray", lty = 1)
}
abline(mean(posterior$alpha), mean(posterior$beta), col = 6, lw = 2)
points(dat$Sepal.Length,dat$Petal.Length)

# Diagóstico do modelo
traceplot(fit)
stan_dens(fit)

# Posterior Predictive Checks
# Gerando modelo Stan com bloco generated quantities
write("// Stan model for simple linear regression
data {
 int < lower = 1 > N; // Sample size
 vector[N] x; // Predictor
 vector[N] y; // Outcome
}
parameters {
 real alpha; // Intercept
 real beta; // Slope (regression coefficients)
 real < lower = 0 > sigma; // Error SD
}
model {
 alpha ~ normal(10, 0.1);
 beta ~ normal(1, 0.1);
 y ~ normal(alpha + x * beta , sigma);
}
generated quantities {
 real y_rep[N];
 for (n in 1:N) {
 y_rep[n] = normal_rng(x[n] * beta + alpha, sigma);
 }
}","stan_model2_GQ.stan")
# normal_rng => deve ser utilizado apenas no bloco generated quantities
# rng - random number generator
stan_model2_GQ <- "stan_model2_GQ.stan"
# Rodar o modelo
fit3 <- stan(file = stan_model2_GQ, data = stan_data, warmup = 1000, iter = 2000, chains = 4, cores = 6, thin = 1)#running the model
print(fit3, pars=c("alpha","beta","sigma","lp__"))
# Gráfico
y_rep <- as.matrix(fit3, pars = "y_rep")
library(bayesplot)
ppc_dens_overlay(stan_data$y, y_rep[1:200, ])

library(shinystan)
launch_shinystan(fit3)






