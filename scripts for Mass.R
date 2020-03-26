library(tidyverse)
library(textreadr)
library(lubridate)

covMas <- read.csv("covmas.csv")
sources <- read.csv("masSources.csv")
covMasDet <- read.csv("covmasdetail.csv")
covMasDay <- read.csv("covmasday.csv")
covMasAge <- read.csv("covmasAge.csv")

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
#covMasDet <- rbind(covMasDet %>% select(-X),data.frame(date=as.character(make_date(2020,3,25)),Barnstable=51, Berkshire=71, Bristol=67, DukesNantucket=3, Essex=177, Franklin=14, Hampden=45, Hampshire=11, Middlesex=446, Norfolk=222, Plymouth=101, Suffolk=342, Worcester=129, CntUnknown=159,Female=903, Male=933, sexUnknown=2, Biogen=99, Travel=92, LocalTransmission=146, UnkownReason=1501, hospitalized= 103, notHospitalized=350,Hosunknown=1385))
#covMasDay <- covMas %>% arrange(date) %>% mutate(newConfirm=c(0,diff(confirmed)),newPresum=c(0,diff(presumptive)),newTotal=c(0,diff(total)), newDeath=c(0,diff(death))) %>% select(date,newPresum,newConfirm,newTotal,newDeath)
#covMasAge <- rbind(covMasAge %>% select(-X), data.frame(date=as.character(make_date(2020,3,25)), below19=41, Age20s=326, Age30s=322, Age40s=313, Age50s=330, Age60s=249, above70=255, ageUnknown=2)  )

#write.csv(covMas,"covmas.csv")
#write.csv(sources,"masSources.csv")
#write.csv(covMasDet,"covmasdetail.csv")
#write.csv(covMasDay,"covmasday.csv")
#write.csv(covMasAge,"covmasAge.csv")