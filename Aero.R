
pacman::p_load(data.table, flextable, officer,udunits2,units,ggplot2,openxlsx, cowplot,RColorBrewer,lubridate, viridis,tidyverse,leaflet,readxl, airportr, flightsbr, writexl, stats, rmdformats, xfun, stringr)


##Formato da data para download
dataf <- format(Sys.Date() -1,'%Y-%m-%d')
data_atual <- Sys.Date()
nomes_meses <- c("Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro")
mes <- paste0(format(data_atual, "%m"), " - ", nomes_meses[month(data_atual)])

##Link download CSV ANAC
URL <- paste0("http://sistemas.anac.gov.br/dadosabertos/Voos%20e%20opera%C3%A7%C3%B5es%20a%C3%A9reas/Registro%20de%20servi%C3%A7os%20a%C3%A9reos/2023/", mes, "/registros_", dataf, ".csv")
AERO <- fread(URL)

AERO <- fread(URL, encoding = "UTF-8")


download.file("http://www.partow.net/downloads/GlobalAirportDatabase.zip",destfile = "data.zip")
unzip("data.zip")
ICAO <- read.table("GlobalAirportDatabase.txt", sep = ":")
colnames(data) <- c("ICAOCode", "IATACode", "AirportName", "City/Town", "Country", "LatDeg", "LatdeMin", "LatSec", "LatDirec", "LongDeg", "LongdeMin", "LongdeSec", "LongDirec", "Altitude", "LatDec", "LongDec")

colnames(AERO)[22] ="V1"

AERO$Fim.OperaÃ.Ã.o

br <- ICAO 

br_aero <- AERO %>%
  filter(str_detect(tolower(`Arpt Destino`), tolower("Brasil"))) %>%
  filter(str_detect(tolower(`Natureza Operação`), tolower("internacional"))) 


br_aero_filtro <- br_aero %>%
  mutate(pais = str_extract(`Arpt Origem`, "\\w+$"))

data <- format(Sys.Date(),'%Y-%m-%d')

data_atual <- Sys.Date()
mes <- month(data_atual, label = TRUE, locale = "pt")
##selecionar países 
paises_n <- br_aero_filtro %>%
  count(pais, `Arpt Destino`)

paises_p <- br_aero_filtro %>%
  count(pais)

paisvoo <- "ESTADOS UNIDOS" ##Escrever nome país


cod_icao <- ICAO %>%
  select(V1, V5) 

voos <- br_aero %>%
  filter(str_detect(tolower(`Arpt Origem`), tolower(paisvoo)))

write.xlsx(paises_n, file = "voos Brasil - Aeroportos.xlsx")
write.xlsx(paises_p , file = "voos Brasil - Países.xlsx")