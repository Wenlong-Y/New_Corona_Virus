library(tidyverse)
library(textreadr)
library(lubridate)

covMas <- read.csv("covmas.csv")
sources <- read.csv("masSources.csv")
covMasDet <- read.csv("covmasdetail.csv")
covMasDay <- read.csv("covmasday.csv")

temp_file <- tempfile()
url <- "https://www.mass.gov/doc/covid-19-cases-in-massachusetts-march-10-2020/download"
txt <- read_pdf(url)
covMas <- data.frame(date=make_date(2020,3,5),presumptive=2, confirmed=1)
covMas <- covMas %>% mutate(total = presumptive+confirmed)
covMas <- rbind(covMas,data.frame(date=make_date(2020,3,6),presumptive=7, confirmed=1,total=8))

library(rvest)
tab <- read_html(url) %>% html_nodes("table")
tab$text[3]
months <- month.name[1:12]
month <- str_split(tab$text[3],' ')[[1]][3]
month <- match(month,months)
day <- as.numeric(substr(str_split(tab$text[3],' ')[[1]][4],1,2))
year <- as.numeric(str_split(tab$text[3],' ')[[1]][5])
date <- make_date(year, month, day)

library(lubridate)

#add sources

#sources <- rbind(sources %>% select(-X),data.frame(date=as.character(make_date(2020,3,14)),url="https://www.mass.gov/doc/covid-19-cases-in-massachusetts-as-of-march-14-2020-accessible/download"))

#add daily data
#covMas <- rbind(covMas,data.frame(date=make_date(2020,3,6),presumptive=7, confirmed=1, total=8, quarantined =, Quarfinished =, quarantNow= ))

#Daily task
#covMas <- rbind(covMas %>% select(-X),data.frame(date=as.character(make_date(2020,3,22)),presumptive=NA, confirmed=NA, total=646, death=5, quarantined =2054, Quarfinished = 886, quarantNow=1168))
#covMasDet <- rbind(covMasDet %>% select(-X),data.frame(date=as.character(make_date(2020,3,23)),Barnstable=30, Berkshire=26, Bristol=25, DukesNantucket=1, Essex=73, Franklin=2, Hampden=15, Hampshire=6, Middlesex=232, Norfolk=82, Plymouth=32, Suffolk=154, Worcester=42,CntUnknown=57,Female=378, Male=399, Biogen=99, Travel=75, LocalTransmission=104, UnkownReason=499, hospitalized= 79, notHospitalized=286,Hosunknown=412))
#covMasDay <- covMas %>% arrange(date) %>% mutate(newConfirm=c(0,diff(confirmed)),newPresum=c(0,diff(presumptive)),newTotal=c(0,diff(total)), newDeath=c(0,diff(death))) %>% select(date,newPresum,newConfirm,newTotal,newDeath)


#write.csv(covMas,"covmas.csv")
#write.csv(sources,"masSources.csv")
#write.csv(covMasDet,"covmasdetail.csv")
#write.csv(covMasDay,"covmasday.csv")