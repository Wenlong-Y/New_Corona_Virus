library(tidyverse)
library(textreadr)
library(lubridate)

covMas <- read.csv("covmas.csv")
sources <- read.csv("masSources.csv")
covMasDet <- read.csv("covmasdetail.csv")
covMasDay <- read.csv("covmasday.csv")
covMasAge <- read.csv("covmasAge.csv")

temp <- paste(tempfile(),".zip", sep = "")
url <- "https://www.mass.gov/doc/covid-19-raw-data-may-9-2020/download"
download.file(url,temp)
data <- read.table("Sales.zip", nrows=10, header=T, quote="\"", sep=",")

data <- read.table(unz(temp, "Sex.csv"), header=T, quote="\"", sep=",")

unlink(temp)



#sources <- rbind(sources %>% select(-X),data.frame(date=as.character(make_date(2020,3,14)),url="https://www.mass.gov/doc/covid-19-cases-in-massachusetts-as-of-march-14-2020-accessible/download"))

# setwd("./New_Corona_Virus/")
#Daily task
#covMas <- rbind(covMas %>% select(-X),data.frame(date=as.character(make_date(2020,4,29)),presumptive=NA, confirmed=NA, total=60265, death=3405, quarantined =27939, Quarfinished = 17659, quarantNow=10280))
#covMasDet <- rbind(covMasDet %>% select(-X),data.frame(date=as.character(make_date(2020,4,28)),Barnstable=820, Berkshire=430, Bristol=3270, Dukes=15, Essex=7972, Franklin=237, Hampden=3546, Hampshire=509, Middlesex=13417, Nantucket=11, Norfolk=5567, Plymouth=4744, Suffolk=12140, Worcester=4999, CntUnknown=625,Female=31258, Male=25593, sexUnknown=NA, Biogen=NA, Travel=NA, LocalTransmission=NA, UnkownReason=NA, hospitalized= 3875, notHospitalized=NA,Hosunknown=NA))
#covMasDay <- covMas %>% arrange(date) %>% mutate(newConfirm=c(0,diff(confirmed)),newPresum=c(0,diff(presumptive)),newTotal=c(0,diff(total)), newDeath=c(0,diff(death))) %>% select(date,newPresum,newConfirm,newTotal,newDeath)
#covMasAge <- rbind(covMasAge %>% select(-X), data.frame(date=as.character(make_date(2020,3,25)), below19=41, Age20s=326, Age30s=322, Age40s=313, Age50s=330, Age60s=249, Age70s=1020, above80=255, ageUnknown=2)  )

#write.csv(covMas,"covmas.csv")
#write.csv(sources,"masSources.csv")
#write.csv(covMasDet,"covmasdetail.csv")
#write.csv(covMasDay,"covmasday.csv")
#write.csv(covMasAge,"covmasAge.csv")