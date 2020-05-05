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
library(grid)
library(gridExtra)
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

    ## [1] "2020-05-05 09:43:57"

确诊和疑似病例的数据如下：

``` r
dataDay %>% ggplot() + geom_point(aes(date,confirm,colour="确诊")) +geom_point(aes(date,suspect,color="疑似")) +theme(legend.position="right")+ylab("病例数")+labs(colour="类别")+scale_color_manual(values=c("blue","red"))+xlab("")
```

![](Report_CN_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

确认病理+疑似病例的变化如下：

1月28日到2月9日之间，该数据成直线上涨趋势。

``` r
dataDay <- dataDay %>% mutate(confandsusp = confirm + suspect)
dataforfitting <- dataDay %>% filter(date > make_date(2020,1,27) & date < make_date(2020,2,9)) 
dataDay %>% mutate(confandsusp = nowConfirm + suspect) %>% ggplot(aes(date,confandsusp))+geom_point()+ylab("现有确诊+疑似")
```

![](Report_CN_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

死亡率：

``` r
dataDay %>% ggplot(aes(date,deathoverconfirm))+geom_point()+ylab("死亡人数/确诊人数")+xlab("")
```

![](Report_CN_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

死亡人数占死亡+康复人数之和：

``` r
dataDay %>% ggplot()+geom_point(aes(date,dead/(heal+dead)))+ylab("死亡/(死亡+康复)")+xlab("")
```

![](Report_CN_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

死亡人数与康复人数：

``` r
dataDay %>% ggplot() + geom_point(aes(date,dead,colour="死亡")) +geom_point(aes(date,heal,color="康复")) +theme(legend.position="right")+ylab("人数")+labs(colour="类别")+scale_color_manual(values=c("black","red"))+xlab("")
```

![](Report_CN_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

下面是每天新增确诊和疑似病人数量:

``` r
dataAdd %>% ggplot() + geom_point(aes(date,confirm,colour="确诊")) +geom_point(aes(date,suspect,color="疑似")) +theme(legend.position="right")+ylab("人数")+labs(colour="类别")+scale_color_manual(values=c("blue","red"))+xlab("")
```

![](Report_CN_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

每天新增确诊与疑似病例之和：

``` r
dataAdd %>% ggplot(aes(date,confirm+suspect))+geom_point()+ylab("人数")+xlab("")
```

![](Report_CN_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

每天的死亡与康复人数：

``` r
dataAdd %>% ggplot() + geom_point(aes(date,dead,colour="死亡")) +geom_point(aes(date,heal,color="康复")) +theme(legend.position="right")+ylab("Number of cases")+labs(colour="Type")+scale_color_manual(values=c("black","red"))+xlab("")
```

![](Report_CN_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

## 中国各省的感染情况

湖北和非湖北省的死亡人数和死亡率等：

``` r
deathrate<-x$dailyHistory
deathrate <- deathrate %>% mutate(hubeiRate=as.numeric(hubei.deadRate), notHubeiRate=as.numeric(notHubei.deadRate), countryRate=as.numeric(country.deadRate))
deathrate <- deathrate %>% extract(date,c("month","day"), regex = "^(\\d+)\\.(\\d+)$",remove = FALSE) 
deathrate <- deathrate %>% mutate(month = as.numeric(month), day = as.numeric(day))
deathrate <- deathrate %>% mutate(date = make_date(2020,month,day))
deathrate %>% ggplot()+geom_point(aes(date,hubeiRate,color="湖北死亡率"))+geom_point(aes(date,notHubeiRate,color="非湖北死亡率"))+geom_point(aes(date,countryRate,color="中国总死亡率"))+ ylab("百分比(%)")+xlab("")
```

![](Report_CN_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

各省具体情况（其中表格的数据是最新数据，而历史数据，更新并不及时）：

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
p <- y$data %>% filter(province==provs,city!=provs) %>% group_by(city) %>% ggplot(color=city) + geom_line(aes(time,cum_confirm,color=city))+geom_point(aes(time,cum_confirm,color=city))+ylab(paste(provs," 确诊人数"))+xlab("")
print(p)
grid.newpage()
    }
  
      if(y$data %>% filter(province==provs) %>% .$city %>% as.factor %>% levels %>% length == 1){
p <- y$data %>% filter(province==provs)%>% ggplot(color=city) + geom_line(aes(time,cum_confirm,color=city))+geom_point(aes(time,cum_confirm,color=city))+ylab(paste(provs," 确诊人数"))+xlab("")
print(p)
grid.newpage()
    }
  
}
```

![](Report_CN_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-2.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-3.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-4.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-5.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-6.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-7.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-8.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-9.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-10.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-11.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-12.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-13.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-14.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-15.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-16.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-17.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-18.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-19.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-20.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-21.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-22.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-23.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-24.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-25.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-26.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-27.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-28.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-29.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-30.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-31.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-32.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-33.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-34.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-35.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-36.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-37.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-38.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-39.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-40.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-41.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-42.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-43.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-44.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-45.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-46.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-47.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-48.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-49.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-50.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-51.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-52.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-53.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-54.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-55.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-56.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-57.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-58.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-59.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-60.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-61.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-62.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-63.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-64.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-65.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-66.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-67.png)<!-- -->![](Report_CN_files/figure-gfm/unnamed-chunk-13-68.png)<!-- -->
