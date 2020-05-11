library(tidyverse)
library(textreadr)
library(lubridate)
library(downloader)

covMas <- read.csv("covmas.csv")
sources <- read.csv("masSources.csv")
covMasDet <- read.csv("covmasdetail.csv")
covMasDay <- read.csv("covmasday.csv")
covMasAge <- read.csv("covmasAge.csv")

# setwd(paste(getwd(), "/New_Corona_Virus/", sep = ""))
data_dir = "./data"
dir.create(data_dir)
url_zip <- "https://www.mass.gov/doc/covid-19-raw-data-may-10-2020/download"
download(url_zip, dest="./data/dataset.zip", mode="wb") 

unzip ("./data/dataset.zip", exdir = "./data")

#cases
cases <- read.csv("./data/Cases.csv")
caseslong <- gather(cases %>% mutate(Date=as.Date(Date, "%m/%d/%Y")) %>% select(Date, Cases), key="key", value="value", -Date)
names(caseslong)[2] <- "Category"
caseslong %>% ggplot(aes(Date, value, color=Category, shape = Category)) + geom_line(size = .5) + geom_point(size = 1) + ylab("numbers of people") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))

#daily changes

caseslong <- gather(cases %>% mutate(Date=as.Date(Date, "%m/%d/%Y")) %>% select(Date, New), key="key", value="value", -Date)
names(caseslong)[2] <- "Category"
caseslong %>% ggplot(aes(Date, value, color=Category, shape = Category)) + geom_line(size = .5) + geom_point(size = 1) + ylab("numbers of people") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))

#death data
death <- read.csv("./data/DateofDeath.csv")
death <- death %>% mutate(Date=as.Date(Date.of.Death, "%m/%d/%Y"))
death %>% ggplot(aes(Date, Running.Total)) + geom_line(size = .5) + geom_point(size = 1) + ylab("Percentage of Death by Age") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))
death %>% ggplot(aes(Date, New.Deaths)) + geom_line(size = .5) + geom_point(size = 1) + ylab("Percentage of Death by Age") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))
# plotting data on gender
sex <- read.csv("./data/Sex.csv")
sexlong <- gather(sex %>% mutate(Date=as.Date(Date, "%m/%d/%Y")), key="key", value="value", -Date)
names(sexlong)[2] <- "Sex"
sexlong %>% ggplot(aes(Date, value, color=Sex, shape = Sex)) + geom_line(size = .5) + geom_point(size = 1) + ylab("numbers of people") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))

#plotting data on age
age <- read.csv("./data/Age.csv")
age <- age %>% mutate(Date=as.Date(Date, "%m/%d/%Y"))
age %>% ggplot(aes(Date, Cases, color=Age)) + geom_line(size = .5) + geom_point(size = 1) + ylab("numbers of people") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))
age <- age %>% mutate(rate_Hospitalization = Hospitalized/Cases * 100, rate_Death = Deaths/Cases * 100)
age %>% ggplot(aes(Date, rate_Hospitalization, color=Age)) + geom_line(size = .5) + geom_point(size = 1) + ylab("Percentage of Hospitalization by Age") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))
age %>% ggplot(aes(Date, rate_Death, color=Age)) + geom_line(size = .5) + geom_point(size = 1) + ylab("Percentage of Death by Age") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))

#plotting data by county
county <- read.csv("./data/County.csv")
county <- county %>% mutate(Date=as.Date(Date, "%m/%d/%Y"))
county %>% ggplot(aes(Date, Count, color=County)) + geom_line(size = .5) + geom_point(size = 1) + ylab("numbers of people") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))
county %>% filter( Date >as.Date("2020/04/01"))%>% ggplot(aes(Date, Deaths, color=County)) + geom_line(size = .5) + geom_point(size = 1) + ylab("numbers of people") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))
county <- county %>% mutate(death_rate = Deaths/Count * 100)
county %>% filter( Date >as.Date("2020/04/01"))%>% ggplot(aes(Date, death_rate, color=County)) + geom_line(size = .5) + geom_point(size = 1) + ylab("numbers of people") + xlab("") + theme(axis.text.x = element_text(angle = 60, hjust = 1))

