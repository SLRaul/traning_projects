rm(list = ls())

library(fpp2)
library(forecast)
library(ggplot2)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
############## Cap 2; gr�ficos de s�ries temporais ###########
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

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
# a linha horizontal indica a m�dia, esse tipo de gr�fico pode revelar  mudan�as sazonais

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
tute1_ts <- ts(tute1[,-1], start = 1981, frequency = 4) # transformando em st e removendo as datas
# c
autoplot(tute1_ts, facets = T) # stde cada vari�vel separadas
autoplot(tute1_ts, facets = F)
# poss�vel correla��o positiva entre  sales e AdBudget
# poss�vel correla��o negativa entre gdp e as demais
## 3
# a
retail <- readxl::read_excel("~/R_Diretorio/Forecast/retail.xlsx", skip = 1) 
# venda das de diversos tipos de loja e alguns estados
head(retail)
# b
retail__ts <- ts(retail[,'A3349398A'], start = c(1982,4), frequency = 12)
# c
autoplot(retail__ts)
# mostra tendencia e sazonalidade
ggseasonplot(retail__ts)
# mostra um aumento em dezembro e queda em fev
ggsubseriesplot(retail__ts)
gglagplot(window(retail__ts))
# em todos os lags existe uma correla��o linear forte
ggAcf(retail__ts, lag.max= 100)
# mostra que existe uma tend�ncia bem forte uma leve sazonalidade

## 4
?bicoal # produ��o anual de carv�o no eua 1920-1968
?chicken # pre�o da galinha em dollar 1924-1993
?dole # total mensal de seguro desemprego na austr�lia 01/1965-06/1992
?usdeaths # mortes mensais acidentais no EUA 1973-1978
?lynx # numeros anual de lynx capturadas 1821-1934
?goog # Pre�os das a��es do google 25/02/2013-13/02/2017
?writing # venda de papel na fran�a 01/1963-12/1972
?fancy # vendas mensais de souvenir no cais de um resorte em Queensland
?a10 # venda mensal de rem�dios para diabets na austr�lia 07/91-06/2008
?h02 # venda de corticoide mensal na austr�lia 07/1991-06/2008

autoplot(bicoal) + ylab("Quantidade produzida") + xlab("Anos") +
  ggtitle("Produ��o anual de carv�o no EUA 1920-1968")

autoplot(chicken) + ylab("Pre�o em dollar") + xlab("Anos") +
  ggtitle("S�rie hist�rica do pre�o da galinha em dollar 1924-1993")

autoplot(dole) + ylab("Quantidade de pedidos") + xlab("Anos") +
  ggtitle("Quantidade de pedidos desempregos durante 01/1965-06/1992 na Austr�lia")

autoplot(usdeaths) + ylab("Quantidade de mortes") + xlab("Anos") +
  ggtitle("Quantidade de mortes acidentais no EUA 1973-1978")

autoplot(lynx) + ylab("Quantidade capturadas") + xlab("Anos") +
  ggtitle("Quantidade delynnx capturadas durante 1821-1934")

autoplot(goog) + ylab("Pre�o em dollar") + xlab("Anos") +
  ggtitle("S�rie hist�rica do pre�o das a��es do Google em dollar durante 25/02/2013-13/02/2017")

autoplot(writing) + ylab("Quantidade em milhares") + xlab("anos") +
  ggtitle("Quantidade de papeis vendidos na Fran�a durante 01/1963-12/1972")

autoplot(fancy) + ylab("Quantidade vendida") + xlab("Anos") +
  ggtitle("Vendas de souvenir do Resort Queensland")

autoplot(a10) + ylab("Quantidade vendida") + xlab("Anos") +
  ggtitle("S�rie historica de vendas de rem�dios para diabetes na Austr�lia 07/91-06/2008")

autoplot(h02) + ylab("Quantidade vendida") + xlab("Anos") +
  ggtitle("S�rie historica de vendas de corticoides na Austr�lia 07/1991-06/2008")

## 5
gridExtra::grid.arrange(
  ggseasonplot(writing, year.labels = T),
  ggsubseriesplot(writing)
)
# Queda significativa em jul e ago, e uma recupera��o em set 
# a queda � exatamente no perio de f�rias
gridExtra::grid.arrange(
  ggseasonplot(fancy, year.labels = T),
  ggsubseriesplot(fancy)
)
# maior venda em dez, pode estar associado as f�rias de natal
gridExtra::grid.arrange(
  ggseasonplot(a10, year.labels = T),
  ggsubseriesplot(a10)
)
# leve aumente em jan e "estavel no resto do ano
gridExtra::grid.arrange(
  ggseasonplot(h02, year.labels = T),
  ggsubseriesplot(h02)
)
# queda acentuada em fev e vai recuperando ao longo do ano

## 6
autoplot(BJsales) # indica tend�ncia
autoplot(usdeaths) # indica sazonalidade
autoplot(bricksq) # indica sazonalidade e tend�ncia
autoplot(sunspotarea) # indica sazonalidade
autoplot(gasoline) # indica sazonalidade e tend�ncia

ggseasonplot(BJsales) # Data are not seasonal
ggseasonplot(usdeaths) # picos no m� de julho
ggseasonplot(bricksq) # indica um crescimento no Q3
ggseasonplot(sunspotarea) # Data are not seasonal
ggseasonplot(gasoline) # queda nas semanas4-7 e pico 33-37

ggsubseriesplot((BJsales))
ggsubseriesplot(usdeaths) # mais ind�cios de sazonalidade
ggsubseriesplot(bricksq) # ind�cios de tend�ncias
ggsubseriesplot(sunspotarea)
ggsubseriesplot(gasoline)

gglagplot(BJsales) # observa-se em todos os lags oa tempos iniciais e finais s�o correlacionados
gglagplot(usdeaths) # lags 6, 7, 8 correla��o negativa e lag 12 positiva
gglagplot(bricksq) # todos os lags 4-9 tem correla��o positiva
gglagplot(sunspotarea) # lags 4, 5 e 6 parecem indicar correl��o negativa
gglagplot(gasoline) # lags 1, 2 e 3 indicam correla��o positiva

ggAcf(BJsales, lag.max= 98) # ind�cio de tendencia
ggAcf(usdeaths, lag.max= 98) # ind�cio de sazonalidade
ggAcf(bricksq, lag.max= 98) # ind�cio de tend�ncia
ggAcf(sunspotarea, lag.max= 98) # # ind�cio de sazonalidade
ggAcf(gasoline, lag.max= 198) # ind�cio de tend�ncia

## 7
arrivals

autoplot(arrivals, facets = T)
autoplot(arrivals)

ggseasonplot(arrivals[,1]) + ggtitle("Japan arrivels")
ggseasonplot(arrivals[,2]) + ggtitle("NZ arrivels")
ggseasonplot(arrivals[,1]) + ggtitle("UK arrivels")
ggseasonplot(arrivals[,1]) + ggtitle("US arrivels")
# exeto a NZ todos os demais paises registam um queda no segundo semestre

ggsubseriesplot(arrivals[,1]) + ggtitle("Japan arrivels")
ggsubseriesplot(arrivals[,2]) + ggtitle("NZ arrivels")
ggsubseriesplot(arrivals[,1]) + ggtitle("UK arrivels")
ggsubseriesplot(arrivals[,1]) + ggtitle("US arrivels")
# existe indicativos de que existe sazonalidade, em que o segundo trimestre tem uma queda

## 8
# 2-d; 3-a; 1-b; 4-c

## 9
?pigs #Produ��o de porcos no UK
mypigs <- window(pigs, start=1990)
gridExtra::grid.arrange(
  autoplot(mypigs),
  ggAcf(mypigs)
)
# h� um forte ind�cio de que a produ��o de porcos nao seja autocorrelacionada
# assim se caracterisando como um ruido branco

## 10
?dj #Dow-Jones index on 251 trading days ending 26 Aug 1994.
ddj_ <- diff(dj)
gridExtra::grid.arrange(
  autoplot(dj),
  autoplot(ddj_)
)

gridExtra::grid.arrange(
  ggAcf(dj),
  ggAcf(ddj_)
)
# sim com "centraliza��o" a st virou um ruido branco

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
############ Cap 3 ferramentas de forecast ##############
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

## os m�todos mais simple e q s�o tomados como refer�ncia s�o

## m�dias m�veis
# meanf(time series, periododa ts)

## m�todo naive
# naive(time series, periododa ts)
# rwf(y, h) # Equivalent alternative

## m�todo naive sasonal
# snaive(time series, periododa ts)

# # m�todo drift
# rwf(time series, periododa ts, drift=T)

beer_exemple <- window(ausbeer, start =1994, end = c(2004, 6))

#contruindo o gr�fico
autoplot(beer_exemple) +
  autolayer(meanf(beer_exemple, h = 7), series = "M�dia", PI = F) +
  autolayer(naive(beer_exemple, h = 7), series = "Naive", PI = F) +
  autolayer(snaive(beer_exemple, h = 7), series = "Sasonal Naive", PI = F) +
  ggtitle("Produ��o quadrimestral de cerveja") +
  xlab('Tempo') + ylab("Produ��o em megalitros")

autoplot(goog200) +
  autolayer(meanf(goog200, h = 20), series = "M�dia", PI = F) +
  autolayer(naive(goog200, h = 20), series = "Naive", PI = F) +
  autolayer(snaive(goog200, h = 20), series = "Sasonal Naive", PI = F) +
  ggtitle("Google stock (at� 06/2013)") +
  xlab('Tempo') + ylab("Pre�o")

# # tranforma��es e ajuste para um ST
# mes para dia (dividindo a produ��o do mes pela quantidade  de dias)
# exemplo
exemplo <- cbind(mensal = milk, media_diaria = milk/monthdays(milk))

autoplot(exemplo, facets = T) +
  ggtitle("Prod leite por vaca") +
  xlab('m�s/ano') + ylab('prod')

# # ajuste de popula��p
# dividir pelo tamanho da pop 

# # Ajuste de infla��o
# fazer a corre��o da infla��o com dados de pre�o

# # transforma��es matematicas
# log, ..
# box cox
# a escolha do lamb pode ter como base o resultado da fun��o
BoxCox.lambda(elec)

autoplot(BoxCox(elec, BoxCox.lambda(elec)))

# fazendo o ajuste de viez com o boxcox
# com o inverso
autoplot(InvBoxCox(elec, BoxCox.lambda(elec), biasadj = T, fvar = c(-1,1)))
# com box cox (ts, metodo drift, labda do boxcox (tranforma��o), periodo estimado, nivel de conf )
fc <- rwf(eggs, drift=TRUE, lambda =0, h = 50, level =80)
fc2 <- rwf(eggs, drift=TRUE, lambda=0, h=50, level=80,
           biasadj=TRUE)
autoplot(eggs) +
  autolayer(fc, series="Simple back transformation") +
  autolayer(fc2, series="Bias adjusted", PI=FALSE) +
  guides(colour=guide_legend(title="Forecast"))

# # # fazendo o ajuste

autoplot(goog200)

residuo <- residuals(naive(goog200))
autoplot(residuo)

gghistogram(residuo)

ggAcf(residuo)

# checando os res�duos
checkresiduals(naive(goog200))

# # # https://otexts.com/fpp2/graphics-exercises.html
