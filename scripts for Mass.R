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


covUS <-read.csv("https://covidtracking.com/api/us/daily.csv")
covUS <- covUS %>% mutate(date = as.Date(as.character(date),"%Y%m%d"), US_confirmed = positive) %>% select(date, US_confirmed)
covUSlong <- gather(covUS, key ="key", value="value", -date)
covMalong <- gather(covMas %>% mutate(MA_confirmed = total) %>% select(-X) %>% select(date,MA_confirmed), key="key", value="value", -date)
covMAvsUS <- rbind(covUSlong, covMalong)
#add sources

#sources <- rbind(sources %>% select(-X),data.frame(date=as.character(make_date(2020,3,14)),url="https://www.mass.gov/doc/covid-19-cases-in-massachusetts-as-of-march-14-2020-accessible/download"))

#add daily data
#covMas <- rbind(covMas,data.frame(date=make_date(2020,3,6),presumptive=7, confirmed=1, total=8, quarantined =, Quarfinished =, quarantNow= ))

#Daily task
#covMas <- rbind(covMas %>% select(-X),data.frame(date=as.character(make_date(2020,4,2)),presumptive=NA, confirmed=NA, total=8966, death=154, quarantined =8394, Quarfinished = 3218, quarantNow=5176))
#covMasDet <- rbind(covMasDet %>% select(-X),data.frame(date=as.character(make_date(2020,4,12)),Barnstable=501, Berkshire=350, Bristol=1327, Dukes=12, Essex=3170, Franklin=143, Hampden=1647, Hampshire=219, Middlesex=5660, Nantucket=9, Norfolk=2649, Plymouth=2024, Suffolk=5359, Worcester=2032, CntUnknown=373,Female=13315, Male=11390, sexUnknown=770, Biogen=NA, Travel=NA, LocalTransmission=NA, UnkownReason=NA, hospitalized= 2235, notHospitalized=6455,Hosunknown=16785))
#covMasDay <- covMas %>% arrange(date) %>% mutate(newConfirm=c(0,diff(confirmed)),newPresum=c(0,diff(presumptive)),newTotal=c(0,diff(total)), newDeath=c(0,diff(death))) %>% select(date,newPresum,newConfirm,newTotal,newDeath)
#covMasAge <- rbind(covMasAge %>% select(-X), data.frame(date=as.character(make_date(2020,3,25)), below19=41, Age20s=326, Age30s=322, Age40s=313, Age50s=330, Age60s=249, Age70s=1020, above80=255, ageUnknown=2)  )

#write.csv(covMas,"covmas.csv")
#write.csv(sources,"masSources.csv")
#write.csv(covMasDet,"covmasdetail.csv")
#write.csv(covMasDay,"covmasday.csv")
#write.csv(covMasAge,"covmasAge.csv")