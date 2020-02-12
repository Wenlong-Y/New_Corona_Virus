#in git bash terminal
#echo "# New_Corona_Virus" >> README.md
#git init
#git add README.md
#git commit -m "first commit"
#git remote add origin https://github.com/Wenlong-Y/New_Corona_Virus.git
#git push -u origin master

#git add -A && git commit -m "Your Message"


#remotes::install_github("GuangchuangYu/nCov2019")
library(nCov2019)
library(utf8)
library(tidyverse)
library(lubridate)
x <- get_nCov2019()

dataDay <- x$chinaDayList %>% mutate(confirm = as.numeric(confirm), suspect = as.numeric(suspect), dead = as.numeric(dead), heal = as.numeric(heal), deathoverconfirm = dead/confirm)
dataDay <- dataDay %>% extract(date,c("month","day"), regex = "^(\\d+)\\.(\\d+)$",remove = FALSE) 
dataDay <- dataDay %>% mutate(month = as.numeric(month), day = as.numeric(day))
dataDay <- dataDay %>% mutate(date = make_date(2020,month,day))

dataAdd <- x$chinaDayAddList %>% mutate(confirm = as.numeric(confirm), suspect = as.numeric(suspect), dead = as.numeric(dead), heal = as.numeric(heal), deathoverconfirm = dead/confirm)
dataAdd <- dataAdd %>% extract(date,c("month","day"), regex = "^(\\d+)\\.(\\d+)$",remove = FALSE) 
dataAdd <- dataAdd %>% mutate(month = as.numeric(month), day = as.numeric(day))
dataAdd <- dataAdd %>% mutate(date = make_date(2020,month,day))

dataDay %>% ggplot() + geom_point(aes(date,confirm,colour="Confirmed")) +geom_point(aes(date,suspect,color="Suspect")) +theme(legend.position="right")+ylab("Number of cases")+labs(colour="Type")+scale_color_manual(values=c("blue","red"))

dataDay %>% ggplot() + geom_point(aes(date,dead,colour="Dead")) +geom_point(aes(date,heal,color="Healed")) +theme(legend.position="right")+ylab("Number of cases")+labs(colour="Type")+scale_color_manual(values=c("black","red"))

dataDay %>% ggplot(aes(date,deathoverconfirm))+geom_point()
dataDay <- dataDay %>% mutate(confandsusp = confirm + suspect)
dataforfitting <- dataDay %>% filter(date > make_date(2020,1,27)) 
model <- lm(confandsusp ~ date, data=dataforfitting)
plot(dataDay$date, dataDay$confandsusp )
abline(model)

dataDay %>% ggplot(aes(date,confandsusp))+geom_point()

dataDay %>% ggplot()+geom_point(aes(date,dead/(confirm+suspect)))

dataAdd %>% ggplot() + geom_point(aes(date,confirm,colour="Confirmed")) +geom_point(aes(date,suspect,color="Suspect")) +theme(legend.position="right")+ylab("Number of cases")+labs(colour="Type")+scale_color_manual(values=c("blue","red"))


dataAdd %>% ggplot(aes(date,deathoverconfirm))+geom_point()
dataAdd %>% ggplot(aes(date,confirm+suspect))+geom_point()
dataAdd %>% ggplot()+geom_point(aes(date,dead/(confirm+suspect)))


