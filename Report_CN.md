新冠状病毒报告
================
WY
2/4/2020

## 每日冠状病毒传染数据

数据来源是一个R数据包。. 可以用下面的命令安装该数据包

``` r
remotes::install_github("GuangchuangYu/nCov2019")
```

首先加载一些功能包和数据：

``` r
Sys.setlocale(category = "LC_ALL", locale = "chs")
```

    ## [1] "LC_COLLATE=Chinese (Simplified)_China.936;LC_CTYPE=Chinese (Simplified)_China.936;LC_MONETARY=Chinese (Simplified)_China.936;LC_NUMERIC=C;LC_TIME=Chinese (Simplified)_China.936"

``` r
library(nCov2019)
library(tidyverse)
library(lubridate)
x <- get_nCov2019()
```

下面的命令用来整理数据：

``` r
dataDay <- x$chinaDayList %>% mutate(confirm = as.numeric(confirm), suspect = as.numeric(suspect), dead = as.numeric(dead), heal = as.numeric(heal), deathoverconfirm = dead/confirm)
dataDay <- dataDay %>% extract(date,c("month","day"), regex = "^(\\d+)\\.(\\d+)$",remove = FALSE) 
dataDay <- dataDay %>% mutate(month = as.numeric(month), day = as.numeric(day))
dataDay <- dataDay %>% mutate(date = make_date(2020,month,day))

dataAdd <- x$chinaDayAddList %>% mutate(confirm = as.numeric(confirm), suspect = as.numeric(suspect), dead = as.numeric(dead), heal = as.numeric(heal), deathoverconfirm = dead/confirm)
dataAdd <- dataAdd %>% extract(date,c("month","day"), regex = "^(\\d+)\\.(\\d+)$",remove = FALSE) 
dataAdd <- dataAdd %>% mutate(month = as.numeric(month), day = as.numeric(day))
dataAdd <- dataAdd %>% mutate(date = make_date(2020,month,day))
```

该数据的更新时间是（北京时间）：

``` r
x$lastUpdateTime
```

    ## [1] "2020-02-14 11:15:06"

确诊和疑似病例的数据如下：

``` r
dataDay %>% ggplot() + geom_point(aes(date,confirm,colour="确诊")) +geom_point(aes(date,suspect,color="疑似")) +theme(legend.position="right")+ylab("病例数")+xlab("日期")+labs(colour="类别")+scale_color_manual(values=c("blue","red"))
```

![](Report_CN_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

确认病理+疑似病例的变化如下：

1月28日到2月9日之间，该数据成直线上涨趋势。

``` r
dataDay <- dataDay %>% mutate(confandsusp = confirm + suspect)
dataforfitting <- dataDay %>% filter(date > make_date(2020,1,27) & date < make_date(2020,2,9)) 
model <- lm(confandsusp ~ date, data=dataforfitting)
plot(dataDay$date, dataDay$confandsusp, xlab = "日期", ylab = "确诊+疑似总和" )
abline(model)
```

![](Report_CN_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
#mtext(paste("The number of cases (suspected + confirmed) increases", as.character(floor(model$coefficients[2])),"per day on average after Jan 28th.\n with R-squared value of ",round(summary(model)$r.squared, digits=5),"."))
```

死亡率：

``` r
dataDay %>% ggplot(aes(date,deathoverconfirm))+geom_point()+ylab("死亡人数/确诊人数")+xlab("日期")
```

![](Report_CN_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

死亡人数占死亡+康复人数之和：

``` r
dataDay %>% ggplot()+geom_point(aes(date,dead/(heal+dead)))+ylab("死亡/(死亡+康复)")+xlab("日期")
```

![](Report_CN_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

Here are the total dead and healed cases:

``` r
dataDay %>% ggplot() + geom_point(aes(date,dead,colour="Dead")) +geom_point(aes(date,heal,color="Healed")) +theme(legend.position="right")+ylab("Number of cases")+labs(colour="Type")+scale_color_manual(values=c("black","red"))
```

![](Report_CN_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

Now we present the new cases on each day:

``` r
dataAdd %>% ggplot() + geom_point(aes(date,confirm,colour="Confirmed")) +geom_point(aes(date,suspect,color="Suspect")) +theme(legend.position="right")+ylab("Number of cases")+labs(colour="Type")+scale_color_manual(values=c("blue","red"))
```

![](Report_CN_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

And the sum of newly confimred and suspected cases for each day:

``` r
dataAdd %>% ggplot(aes(date,confirm+suspect))+geom_point()
```

![](Report_CN_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

Here are daily numbers of death and recovery:

``` r
dataAdd %>% ggplot() + geom_point(aes(date,dead,colour="Dead")) +geom_point(aes(date,heal,color="Healed")) +theme(legend.position="right")+ylab("Number of cases")+labs(colour="Type")+scale_color_manual(values=c("black","red"))
```

![](Report_CN_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

## Cases by country

We just look at the total number of cases for countries:

``` r
library(grid)
library(gridExtra)
areatotal <- x$are$total %>% select(confirm, suspect, dead, heal,deadRate,healRate)
areatotal <- cbind(x$areaTree$name,areatotal)
names(areatotal)[1] <- "Country"
grid.table(areatotal)
```

![](Report_CN_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

## Cases by Chinese provinces

The death rate for Hubei province and non-Hubei province is provided.

``` r
deathrate<-x$dailyDeadRateHistory
deathrate <- deathrate %>% mutate(hubeiRate=as.numeric(hubeiRate), notHubeiRate=as.numeric(notHubeiRate), countryRate=as.numeric(countryRate))
deathrate <- deathrate %>% extract(date,c("month","day"), regex = "^(\\d+)\\.(\\d+)$",remove = FALSE) 
deathrate <- deathrate %>% mutate(month = as.numeric(month), day = as.numeric(day))
deathrate <- deathrate %>% mutate(date = make_date(2020,month,day))
deathrate %>% ggplot()+geom_point(aes(date,hubeiRate,color="Hubei Rate"))+geom_point(aes(date,notHubeiRate,color="non-Hubei Rate"))+geom_point(aes(date,countryRate,color="country Rate"))+ ylab("Percentage(%)")
```

![](Report_CN_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

``` r
mytheme <- gridExtra::ttheme_default(core = list(fg_params=list(cex = 1.0)),colhead = list(fg_params=list(cex = 1.0)),rowhead = list(fg_params=list(cex = 1.0)))
deathrate<-x$dailyDeadRateHistory
names(deathrate) <- c("Date","hubei\nDead","hubei\nConfirm","country\nDead","country\nConfirm","hubei\nRate","notHubei\nRate","country\nRate")
grid.table(deathrate,theme=mytheme)
```

![](Report_CN_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

Detailed information for each province:

``` r
y <- load_nCov2019()
```

``` r
for(i in 1:34)
{
  grid.text(label = as.character(x[,1]$name[i]),x=0.5,y=.9, gp=gpar(cex=2))
  if(dim(x[i])[1]<10){
  grid.table(x[i] %>% select(name,confirm,dead,heal,deadRate,healRate),vp=viewport(x=0.5,y=.5,width=1,height=1))
  grid.newpage()
  }
  if(dim(x[i])[1]>=10){
  grid.table(x[i] %>% head(10) %>% select(name,confirm,dead,heal,deadRate,healRate),vp=viewport(x=0.5,y=.5,width=1,height=1))
  grid.newpage()
  }
  provs <- as.character(x[,1]$name[i])
  
    if(y$data %>% filter(province==provs) %>% .$city %>% as.factor %>% levels %>% length != 1){
p <- y$data %>% filter(province==provs,city!=provs) %>% group_by(city) %>% ggplot(color=city) + geom_line(aes(time,cum_confirm,color=city))+geom_point(aes(time,cum_confirm,color=city))+ylab(paste(provs," confirmed"))
print(p)
grid.newpage()
    }
  
      if(y$data %>% filter(province==provs) %>% .$city %>% as.factor %>% levels %>% length == 1){
p <- y$data %>% filter(province==provs)%>% ggplot(color=city) + geom_line(aes(time,cum_confirm,color=city))+geom_point(aes(time,cum_confirm,color=city))+ylab(paste(provs," confirmed"))
print(p)
grid.newpage()
    }
  
}
```

![](Report_CN_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-2.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-3.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-4.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-5.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-6.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-7.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-8.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-9.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-10.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-11.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-12.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-13.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-14.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-15.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-16.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-17.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-18.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-19.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-20.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-21.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-22.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-23.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-24.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-25.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-26.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-27.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-28.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-29.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-30.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-31.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-32.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-33.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-34.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-35.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-36.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-37.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-38.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-39.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-40.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-41.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-42.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-43.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-44.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-45.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-46.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-47.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-48.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-49.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-50.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-51.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-52.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-53.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-54.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-55.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-56.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-57.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-58.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-59.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-60.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-61.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-62.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-63.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-64.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-65.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-66.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-67.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-15-68.png)<!-- -->
