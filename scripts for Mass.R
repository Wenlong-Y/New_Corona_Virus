library(tidyverse)
rary(textreadr)
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

#sources <- rbind(sources,data.frame(date=make_date(2020,3,8),url="https://www.wgbh.org/news/local-news/2020/03/08/there-are-now-28-presumed-cases-of-covid-19-in-massachusetts"))

#add daily data
#covMas <- rbind(covMas,data.frame(date=make_date(2020,3,6),presumptive=7, confirmed=1, total=8, quarantined =, Quarfinished =, quarantNow= ))

#add detail
#covMasDay <-rbind(covMasDay,data.frame(date=make_date(2020,3,3),newQuar=covMas$quarantined[2]-covMas$quarantined[1],newConfirm=covMas$confirmed[2]-covMas))
#covMasDet <- rbind(covMasDet,data.frame(date=make_date(2020,3,10),Berkshire=5, Middlesex=15, Norfolk=10, Suffolk=10, Worcester=1,Female=18, Male=23, Biogen=32, Travel=4, UnkownReason=5, hospitalized= 4, notHospitalized=37))
covMasDay <- covMas %>% arrange(date) %>% mutate(newConfirm=c(0,diff(confirmed)),newPresum=c(0,diff(presumptive)),newTotal=c(0,diff(total))) %>% select(date,newPresum,newConfirm,newTotal)

#write.csv(covMas,"covmas.csv")
#write.csv(sources,"masSources.csv")
#write.csv(covMasDet,"covmasdetail.csv")
#write.csv(covMasDay,"covmasday.csv")