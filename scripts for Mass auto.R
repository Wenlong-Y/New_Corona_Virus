library(tidyverse)
library(textreadr)
library(lubridate)
library(downloader)

covMas <- read.csv("covmas.csv")
sources <- read.csv("masSources.csv")
covMasDet <- read.csv("covmasdetail.csv")
covMasDay <- read.csv("covmasday.csv")
covMasAge <- read.csv("covmasAge.csv")

setwd("C:/Users/XieGroup/Documents/r projects/projects/covid19/New_Corona_Virus/")

url_zip <- "https://www.mass.gov/doc/covid-19-raw-data-may-10-2020/download"
download(url_zip, dest=temp, mode="wb") 
dir.create("./temp")
unzip (temp, exdir = "./temp")

# plotting data on gender
sex <- read.csv("./temp/Sex.csv")
covMasDetSexlong <- gather(sex %>% mutate(Date=as.Date(Date, "%m/%d/%Y")), key="key", value="value", -Date)
names(covMasDetSexlong)[2] <- "Sex"
covMasDetSexlong %>% ggplot(aes(Date, value, color=Sex, shape = Sex)) + geom_line(size = .5) + geom_point(size = 1) + ylab("numbers of people") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))

#plotting data on age
age <- read.csv("./temp/Age.csv")
age <- age %>% mutate(Date=as.Date(Date, "%m/%d/%Y"))
age %>% ggplot(aes(Date, Cases, color=Age)) + geom_line(size = .5) + geom_point(size = 1) + ylab("numbers of people") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))
age <- age %>% mutate(rate_Hospitalization = Hospitalized/Cases * 100, rate_Death = Deaths/Cases * 100)
age %>% ggplot(aes(Date, rate_Hospitalization, color=Age)) + geom_line(size = .5) + geom_point(size = 1) + ylab("Percentage of Hospitalization by Age") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))
age %>% ggplot(aes(Date, rate_Death, color=Age)) + geom_line(size = .5) + geom_point(size = 1) + ylab("Percentage of Death by Age") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))





# setwd("./New_Corona_Virus/")
#Daily task
#covMas <- rbind(covMas %>% select(-X),data.frame(date=as.character(make_date(2020,5,5)),presumptive=NA, confirmed=NA, total=70271, death=4212, quarantined =32019, Quarfinished = 22148, quarantNow=9871))
#covMasDet <- rbind(covMasDet %>% select(-X),data.frame(date=as.character(make_date(2020,4,28)),Barnstable=820, Berkshire=430, Bristol=3270, Dukes=15, Essex=7972, Franklin=237, Hampden=3546, Hampshire=509, Middlesex=13417, Nantucket=11, Norfolk=5567, Plymouth=4744, Suffolk=12140, Worcester=4999, CntUnknown=625,Female=31258, Male=25593, sexUnknown=NA, Biogen=NA, Travel=NA, LocalTransmission=NA, UnkownReason=NA, hospitalized= 3875, notHospitalized=NA,Hosunknown=NA))
#covMasDay <- covMas %>% arrange(date) %>% mutate(newConfirm=c(0,diff(confirmed)),newPresum=c(0,diff(presumptive)),newTotal=c(0,diff(total)), newDeath=c(0,diff(death))) %>% select(date,newPresum,newConfirm,newTotal,newDeath)
#covMasAge <- rbind(covMasAge %>% select(-X), data.frame(date=as.character(make_date(2020,3,25)), below19=41, Age20s=326, Age30s=322, Age40s=313, Age50s=330, Age60s=249, Age70s=1020, above80=255, ageUnknown=2)  )

#write.csv(covMas,"covmas.csv")
#write.csv(sources,"masSources.csv")
#write.csv(covMasDet,"covmasdetail.csv")
#write.csv(covMasDay,"covmasday.csv")
#write.csv(covMasAge,"covmasAge.csv")