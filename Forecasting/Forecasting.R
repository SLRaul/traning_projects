rm(list = ls())

library(fpp2)
library(forecast)
library(ggplot2)

# Cap 2; gr�ficos de s�ries temporais
# Exemplo dedados e a sua visualiza��o 
data("melsyd")
autoplot(melsyd[,"Economy.Class"]) + ggtitle("Classe econ�mica Sydney-Melborne") +
  xlab("Ano") + ylab("Quantidade (em milhares)") +theme_bw()

data(a10)
autoplot(a10) + ggtitle("Venda de drogas anti-diab�ticas") +
  ylab("$ em milh�es") + xlab("Ano") +theme_bw()

# Gr�ficos sazonais
# year.labels = T serve para os r�tulos ficarem dentro do gr�fico
ggseasonplot(a10, year.labels = T, year.labels.left = T)

# em gr�fico polar
ggseasonplot(a10, polar = T)

# gr�ficos de sub s�ries
ggsubseriesplot(a10) + ylab("em milhares") + xlab("Meses") +
  ggtitle("Gr�fico de subs�rie temporal das vendas de anti-diab�tico")
# a linha horizontal indica a m�dia, esse tipo de gr�fico pode revelar  udan�as sazonais

# gr�fico de dispers�o
data("elecdemand")
# o gr�fico de dispers�o � idela para everiguar rela��es
autoplot(elecdemand) # plota com todas as vari�veis
autoplot(elecdemand[,c("Demand", "Temperature")], facets=T) +# fazendo o gr�fico separado
  ylab("") + xlab('Ano de 2014')

# utilizando o pacote base
plot(elecdemand, ylab = "Demand WorkDay Temperature")
plot(elecdemand[,c("Demand", "Temperature")])

# fazendo o gr�fico de dispers�o
qplot(Temperature, Demand, data = as.data.frame(elecdemand))
# pode-se perceber que existe uma rela��o entre a demana e temperatura

data("visnights")
autoplot(visnights[,c(1:5)], facets = T)+ylab("Quantidade de visitantes noturnos em milhares")

# visualizando as correla��es de Pearson
GGally::ggpairs(as.data.frame(visnights[,c(1:5)]))

# gr�fico LAG
data("ausbeer")
# extraindo um subset e gerando o gr�fico de lag
gglagplot(window(ausbeer, start= 1992))
# no gr�fico pode-se observar correla��es positivas nos lags 4 e 8
# e correla��es negativas nos lags 2 e 6

# auto correla��o
ggAcf(beer) #gr�fico de auto correla��o #autocorrelation function
# auto correla��o  dos dados iniciados em 92
ggAcf(window(ausbeer, start=1992)) + ggtitle("Consumo de cerveja desde 1992") +
  ylab("Correla��o") 
# consumo de energia na Austr�lia
# apartir do anos 80
ggAcf(window(elec, start=1980), lag.max = 48)
autoplot(window(elec, start=1980))
# apartir de 1956
ggAcf(elec, lag.max = 48)
autoplot(elec)
# os g�ficos de autocorrela��o indicam tend�ncia e sazonalidade,
# visto que observa-se uma diminui��o da autocorrela��o e picos de auto correla��o 

# White noise - ruido branco
# Serie temporal que n�o mostra correla��o � chamada de WN
# um ruido branco � dado por x ~ N(0,1) independentes
# por conta disso o gr�fico de correla��es deve ser pr�ximo de zero
# que as correla��es esteja dentro do liminte de confian�a de 95%, dado por 2/sqrt(tamanho_ts)
# exemplo de WN
set.seed(2019)
gridExtra::grid.arrange(
  autoplot(ts(rnorm(50))) + ggtitle("Exememplo de WN em ST"),
  ggAcf(ts(rnorm(50))) + ggtitle("Exememplo de WN no gr�fico de autocoorela��o")
)
# no exe acima o limite � = 2/sqrt(50) = -ou+ 0.28

#exerc�cios
## 1
# a
help("gas") # Produ��o mensal de gas na autr�lia
help("woolyrnq") # Produ��o trimestral de de fios de l� na Austr�lia
help("gold") # pre�o di�rio do ouro em dollar de 1/1985 -3/89
# b
help("frequency")
# refere a frequencia anual dos dados
frequency(gas) # 12
frequency(woolyrnq) # 4
frequency(gold) # 1
# c
which.max(gold) # outlier da ST desejada
# 770

## 2
# a
tute1 <-  readr::read_csv("~/R_Diretorio/Forecast/tute1.csv")
head(tute1)
# sales = vendas trimestrais de uma empresa pequena de 1981-2005
# AdBudget = gasto com publicidade
# GPD = produto interno bruto 
# todos ajustados pela infla��o
# b
tute1 <- ts(tute1[,-1], start = 1981, frequency = 4) # transformando em st e removendo as datas
# c
autoplot(tute1, facets = T) # stde cada vari�vel separadas
autoplot(tute1, facets = F)
# poss�vel correla��o positiva entre  sales e AdBudget
# poss�vel correla��o negativa entre gdp e as demais
