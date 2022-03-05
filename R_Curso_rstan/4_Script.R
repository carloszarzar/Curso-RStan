###### Curso RStan ######
# 4_Script: Exemplo - 4 Modelo de regressão logística
# Autor: Carlos A. Zarzar
# Data: 21/12/2021
# e-mail: carloszarzar_@hotmail.com
# Objetivo: 
#   Exemplo de um Modelo de regressão logística em Stan
# Sites: https://www.allyourbayes.com/post/2020-02-14-bayesian-logistic-regression-with-stan/
#-------------------#-------------------#-------------------#-------------------
rm(list = ls())
# pacotes
library(purrr) # função rbernoulli
library(ggplot2)

# Dados simulados
## dados das inspeções para entender o estado das estruturas (ciência dos materiais)
set.seed(1008)
# Parâmetros para simulação
N <- 500
lower <- 0
upper <- 10
alpha_true <- -2.5
beta_true <- 1.3
# Profundidade da rachadura
depth <- runif(n = N, min = lower, max = upper)
# Modelo regressão losgítico
PoD_1D <- function(depth, alpha, beta){
  PoD <- exp(alpha + beta * depth) / (1 + exp(alpha + beta * depth))
  return (PoD)
}
# Data frame simulado
pod_df <- data.frame(depth = depth, det = double(length = N))
# Distribuição Bernoulli (Binomial)
## 1 = Detectado (há fissura);
## 0 = não detectado;
for(i in 1:N) {
  pod_df$det[i] = rbernoulli(n = 1, 
                             p = PoD_1D(depth = pod_df$depth[i], 
                                        alpha = alpha_true, 
                                        beta = beta_true))
}
# Gráfico plot
ggplot(pod_df, aes(x=depth,y=det))+
  geom_point()+
  geom_smooth(method = "glm", 
              method.args = list(family = "binomial"), 
              se = FALSE) 
# Maior valor de fissura não detectado  
max(pod_df$depth[which(pod_df$det==0)]) # não detectado
# Menor valor de fissura detectado
min(pod_df$depth[which(pod_df$det==1)]) # detectado
#---------------------------------------------------------------
outcomeModel <- glm(det ~ 1+depth, data = pod_df,
                    family = binomial(link = "logit"))
summary(outcomeModel)
#---------------------------------------------------------------
# Modelo Stan
library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

mod <- "
data {
  int <lower = 0> N; // Defining the number of defects in the test dataset
  int <lower = 0, upper = 1> det [N]; // A variable that describes whether each defect was detected [1]or not [0]
  vector <lower = 0> [N] depth; // A variable that describes the corresponding depth of each defect
  
  int <lower = 0> K; // Defining the number of probabilistic predictions required from the model
  vector <lower = 0> [K] depth_pred;
}
parameters {
  
  // The (unobserved) model parameters that we want to recover
  real alpha;
  real beta;
  
}
model {

  // A logistic regression model relating the defect depth to whether it will be detected
  det ~ bernoulli_logit(alpha + beta * depth);
  
  // Prior models for the unobserved parameters
  alpha ~ normal(-2.5, 0.5);
  beta ~ normal(1, 0.25);
}

generated quantities {
  
  // Using the fitted model for probabilistic prediction.
  // K posterior predictive distributions will be estimated for a corresponding crack depth
  vector [K] postpred_pr;
  
  for (k in 1:K) {
    
    postpred_pr[k] = inv_logit(alpha + beta * depth_pred[k]);
    
  }
  
}

"

# Bloco quantidade geradas:
K <- 50 # 50 valores gerados
depth_pred <- seq(from = lower, to = upper, length.out = K) # tamanho de fissura igualmente espaçados

# Dados lista para Stan
dataStan <- list(
  N = N,
  det = pod_df$det,
  depth = pod_df$depth,
  K = K,
  depth_pred = depth_pred
)
# Modelo Stan
fit_stan <- rstan::stan(model_code = mod, data = dataStan,
                        seed = 1008)

print(fit_stan, pars=c("alpha","beta","lp__"))

# Extraindo informações do objeto fitstan
library(ggmcmc)
amostras <- ggs(S = fit_stan)
head(x = amostras, n = 5)
# Subset dos parâmetros alpha e beta
dat <- amostras %>%
  filter(Parameter %in% c("alpha","beta")) 
dat$Parameter <- factor(dat$Parameter)
levels(dat$Parameter)
dat$Chain <- factor(dat$Chain)

# Gráficos das posteriores marginais alpha e beta
ggplot(data=dat, aes(x=value, fill=Chain)) +
  geom_density(adjust=1.5, alpha=.2)+
  facet_wrap(~Parameter)+
  geom_vline(data=filter(dat, Parameter=="alpha"),
             aes(xintercept=alpha_true),
             linetype="dashed", size=1.1)+
  geom_vline(data=filter(dat, Parameter=="beta"),
             aes(xintercept=beta_true),
             linetype="dashed", size=1.1)
# Printando um resumo das posteriores
print(fit_stan, pars = c("alpha","beta"))
summary(outcomeModel)





