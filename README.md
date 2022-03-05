# Curso-RStan
Introdução a linguagem Stan (rstan), um software para inferência bayesiana.

Ementa do Curso

Título: Introdução a linguagem Stan (rstan), um software para inferência bayesiana.
Carga horária: 6h
Dias administrando: 3 dias (2 horas/dia)
Data: 08, 09 e 10 de março de 2022
Horários: 08:00 às 10:00
Professor: Carlos Antônio Zarzar
Professor da Universidade Federal do Oeste do Pará Campus de Monte Alegre do curso de Engenharia de Aquicultura
Se inscreva no canal Youtube: https://www.youtube.com/channel/UC0aJ_xgty6efYmCy-9PJUYA 
e-mail: carloszarzar_@hotmail.com
	carlos.zarzar@ufopa.edu.br

•	Ementa:
Apresentaremos a linguagem de programação Stan, um software específico para modelos bayesianos. Usaremos programa R como interface do Stan, através do pacote rstan para realizar alguns exemplos práticos. Visto que vamos fazer inferências de modelos Bayesianos, faremos uma introdução a teoria bayesiana, métodos computacionais de amostragem como Método de Monte Carlo (MC) e sua diferença quanto ao Método de Monte Carlo via Cadeia de Markov (MCMC), uma introdução aos algoritmos de amostragem da família MCMC (Metropolis-Hasting, Gibbs, Hamiltoniano Monte Carlo - HMC e o algoritmo NUTS derivado do HMC). Entender a estruturas de dados hierárquicos e modelos hierárquicos/multinível e por fim mostrar alguns métodos bayesianos de comparação, avaliação e seleção de modelos.

•	Objetivo:
Introduzir a linguagem de modelos bayesianos Stan para todos os interessados e mostrar o potencial em resolver problemas reais com essa ferramenta. 

•	Metodologia:
Aulas com carga horária de 2 horas de duração durante 3 dias na forma online em plataformas que possibilitem interação com os participantes. As práticas serão realizadas no programa livre software R, com a IDE do RStudio. Conteúdo apresentado através de slides, software interativos como Whiteboard Canvas e sites que ilustram as densidades de probabilidades, simula funcionamento dos algoritmos de amostragem, entre outros blogs e artigos científicos sobre o conteúdo.

•	Pré-requisito:
É solicitado que todos os participantes do curso já tenham instalado nos seus computadores o software R, a IDE RStudio se preferir, os pacotes: rstan, shinystan, lme4, ggplot2, bayesplot, purrr, ggmcmc, brms, loo. É interessante, porém não é obrigatório, os conhecimentos básicos sobre estatística, probabilidade e experimentação.
 
•	Conteúdo programado:
o	Primeiro dia: Introdução a programação Stan; Sintaxe da linguagem Stan, exemplos de modelos bayesiano com a linhagem Stan (rstan) e atividades práticas;
o	Segundo dia: apresentação da teoria por trás do software Stan. Introdução ao teorema de Bayes; Modelos hierárquicos (modelo multinível); Métodos computacionais de integração; diferença do Método de Monte Carlo (MC) e o Método de Monte Carlo via a Cadeia de Markov (MCMC); Algoritmo de amostragem Metropolis-Hastings, Gibbs, Hamiltoniano Monte Carlo e No-U-Turn Sampler (NUTS); 
o	Terceiro dia: métodos bayesianos de comparação entre modelos, avaliação (diagnósticos), seleção e predição dos modelos. Índices de seleção de modelo como validação cruzada (cross validation) com perspectiva Bayesiana, Leave One Out Cross Validation e sua aproximação utilizando amostragem por importância suavizada de Pareto (PSIS - Pareto smoothed importance sampling).

•	Bibliografia:

GELMAN, A. Prior distributions for variance parameters in hierarchical models (comment on article by browne and draper). Bayesian analysis, International Society for Bayesian Analysis, v. 1, n. 3, p. 515–534, 2006.

GELMAN, A. et al. Hierarchical models. Bayesian data analysis, Chapman and Hall/CRC New York, p. 120–160, 2003.

GELMAN, A. et al. Bayesian data analysis. [S.l.]: Chapman and Hall/CRC, 2013.

GELMAN, A.; HWANG, J.; VEHTARI, A. Understanding predictive information criteria for bayesian models. Statistics and computing, Springer, v. 24, n. 6, p. 997–1016, 2014.

GELMAN, A.; MENG, X.-L.; STERN, H. Posterior predictive assessment of model fitness via realized discrepancies. Statistica sinica, JSTOR, p. 733–760, 1996.

GEMAN, S.; GEMAN, D. Stochastic relaxation, gibbs distributions, and the bayesian restoration of images. IEEE Transactions on pattern analysis and machine intelligence, IEEE, n. 6, p. 721–741, 1984.

HASTINGS, W. K. Monte carlo sampling methods using markov chains and their applications. Oxford University Press, 1970.

METROPOLIS, N. et al. Equation of state calculations by fast computing machines. The journal of chemical physics, AIP, v. 21, n. 6, p. 1087–1092, 1953.

NEAL, R. M. et al. Mcmc using hamiltonian dynamics. Handbook of markov chain
monte carlo, v. 2, n. 11, p. 2, 2011.

PAULINO, C. D. M.; TURKMAN, M. A. A.; MURTEIRA, B. Estatística bayesiana. [S.l.: s.n.], 2003.

VEHTARI, A.; GELMAN, A.; GABRY, J. Practical bayesian model evaluation using
leave-one-out cross-validation and waic. Statistics and computing, Springer, v. 27,
n. 5, p. 1413–1432, 2017.

WATANABE, S.; OPPER, M. Asymptotic equivalence of bayes cross validation and
widely applicable information criterion in singular learning theory. Journal of machine
learning research, v. 11, n. 12, 2010.

•	Conteúdo complementar:

Instalação do R e RStudio:
https://www.youtube.com/watch?v=8_GrR3FLZJM 
Instalação de pacotes no R:
https://lhmet.github.io/adar-ebook/install-pck.html 
http://www.leg.ufpr.br/~paulojus/embrapa/Rembrapa/Rembrapase36.html 
Instalação e introdução ao RStan:
https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started 
https://www.youtube.com/watch?v=4t6niM6sksI 
Instalação do pacote loo:
https://mc-stan.org/loo/ 
