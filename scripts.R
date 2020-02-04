#in git bash terminal
#echo "# New_Corona_Virus" >> README.md
#git init
#git add README.md
#git commit -m "first commit"
#git remote add origin https://github.com/Wenlong-Y/New_Corona_Virus.git
#git push -u origin master

#remotes::install_github("GuangchuangYu/nCov2019")
library(nCov2019)
library(utf8)
x <- get_nCov2019()
library(tidyverse)
library(lubridate)
dataDay <- x$chinaDayList %>% mutate(confirm = as.numeric(confirm), suspect = as.numeric(suspect), dead = as.numeric(dead), heal = as.numeric(heal), deathoverconfirm = dead/confirm)
dataDay <- dataDay %>% extract(date,c("month","day"), regex = "^(\\d+)\\.(\\d+)$",remove = FALSE) 
dataDay <- dataDay %>% mutate(month = as.numeric(month), day = as.numeric(day))
dataDay <- dataDay %>% mutate(date = make_date(2020,month,day))

dataAdd <- x$chinaDayAddList %>% mutate(confirm = as.numeric(confirm), suspect = as.numeric(suspect), dead = as.numeric(dead), heal = as.numeric(heal), deathoverconfirm = dead/confirm)
dataAdd <- dataAdd %>% extract(date,c("month","day"), regex = "^(\\d+)\\.(\\d+)$",remove = FALSE) 
dataAdd <- dataAdd %>% mutate(month = as.numeric(month), day = as.numeric(day))
dataAdd <- dataAdd %>% mutate(date = make_date(2020,month,day))

dataDay %>% ggplot() + geom_point(aes(date,confirm),color=1) +geom_point(aes(date,suspect),color=2)
dataDay %>% ggplot(aes(date,deathoverconfirm))+geom_point()
dataDay %>% ggplot(aes(date,confirm+suspect))+geom_point()
dataDay %>% ggplot()+geom_point(aes(date,dead/(confirm+suspect)))

dataAdd %>% ggplot() + geom_point(aes(date,confirm),color=1) +geom_point(aes(date,suspect),color=2)
dataAdd %>% ggplot(aes(date,deathoverconfirm))+geom_point()
dataAdd %>% ggplot(aes(date,confirm+suspect))+geom_point()
dataAdd %>% ggplot()+geom_point(aes(date,dead/(confirm+suspect)))


