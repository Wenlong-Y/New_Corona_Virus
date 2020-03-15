library(tidyverse)
library(textreadr)
library(lubridate)
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
#covMas <- rbind(covMas %>% select(-X),data.frame(date=as.character(make_date(2020,3,13)),presumptive=105, confirmed=18, total=123, quarantined =719, Quarfinished = 470, quarantNow=249))
#covMasDet <- rbind(covMasDet %>% select(-X),data.frame(date=as.character(make_date(2020,3,14)),Barnstable=1, Bristol=1, Essex=5,Berkshire=9, Middlesex=65, Norfolk=28, Suffolk=27, Worcester=2,CntUnknown=0,Female=64, Male=74, Biogen=104, Travel=5, BerkMedCen=8, UnkownReason=21, hospitalized= 11, notHospitalized=105,Hosunknown=22))
#covMasDay <- covMas %>% arrange(date) %>% mutate(newConfirm=c(0,diff(confirmed)),newPresum=c(0,diff(presumptive)),newTotal=c(0,diff(total))) %>% select(date,newPresum,newConfirm,newTotal)


#write.csv(covMas,"covmas.csv")
#write.csv(sources,"masSources.csv")
#write.csv(covMasDet,"covmasdetail.csv")
#write.csv(covMasDay,"covmasday.csv")