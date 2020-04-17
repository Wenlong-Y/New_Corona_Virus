nCoronaVirus\_Report
================
WY
2/4/2020

## Daily Update on the new corona virus statistics [(中文)](https://github.com/Wenlong-Y/New_Corona_Virus/blob/master/Report_CN.md)

The data was obtained from an R package. To insall that R package. Use
the following command:

``` r
remotes::install_github("GuangchuangYu/nCov2019")
```

Then, I loaded the libraries and data by:

``` r
library(nCov2019)
library(utf8)
library(tidyverse)
library(lubridate)
library(grid)
library(gridExtra)

x <- get_nCov2019(lang = "en")
```

We start from two data sets in the packages: total
confirmed/suspected/dead/recovered numbers of cases and the changes from
the previous day.

We tide up the data with commands below:

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

The last updated time (Beijing Time)is

``` r
x$lastUpdateTime
```

    ## [1] "2020-04-17 09:36:02"

Now we present the total number of confirmed and suspected respectively.

``` r
dataDay %>% ggplot() + geom_point(aes(date,confirm,colour="Confirmed")) +geom_point(aes(date,suspect,color="Suspect")) +theme(legend.position="right")+ylab("Number of cases")+labs(colour="Type")+scale_color_manual(values=c("blue","red"))
```

![](Report_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

Now we want to put an upper limit on infected cases, so we add up the
confimred and suspected. Because a big portion of suspected cases become
confirmed cases.

It is obvious that starting Jan. 28th, the increase of sum of confirmed
and suspected case is on a straight line until Feb. 9th. The line is
fitted with data during this period.

``` r
dataDay <- dataDay %>% mutate(confandsusp = confirm + suspect)
dataforfitting <- dataDay %>% filter(date > make_date(2020,1,27) & date < make_date(2020,2,9)) 
dataDay %>% mutate(confandsusp = nowConfirm + suspect) %>% ggplot(aes(date,confandsusp))+geom_point()
```

![](Report_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

Now, we want to calculate the rate of death. There are several ways to
do this, one way is to divide the dead by the confirmed cases.

``` r
dataDay %>% ggplot(aes(date,deathoverconfirm))+geom_point()
```

![](Report_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

Another way of calculation is to use dead and recovered as total number
of cases that we know the results. Then we could find the portion of
cases result in death.

``` r
dataDay %>% ggplot()+geom_point(aes(date,dead/(heal+dead)))
```

![](Report_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

Here are the total dead and healed cases:

``` r
dataDay %>% ggplot() + geom_point(aes(date,dead,colour="Dead")) +geom_point(aes(date,heal,color="Healed")) +theme(legend.position="right")+ylab("Number of cases")+labs(colour="Type")+scale_color_manual(values=c("black","red"))
```

![](Report_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

Now we present the new cases on each day:

``` r
dataAdd %>% ggplot() + geom_point(aes(date,confirm,colour="Confirmed")) +geom_point(aes(date,suspect,color="Suspect")) +theme(legend.position="right")+ylab("Number of cases")+labs(colour="Type")+scale_color_manual(values=c("blue","red"))
```

![](Report_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

And the sum of newly confimred and suspected cases for each day:

``` r
dataAdd %>% ggplot(aes(date,confirm+suspect))+geom_point()
```

![](Report_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

Here are daily numbers of death and recovery:

``` r
dataAdd %>% ggplot() + geom_point(aes(date,dead,colour="Dead")) +geom_point(aes(date,heal,color="Healed")) +theme(legend.position="right")+ylab("Number of cases")+labs(colour="Type")+scale_color_manual(values=c("black","red"))
```

![](Report_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

## Cases by Chinese provinces

The death rate for Hubei province and non-Hubei province is provided.

``` r
deathrate<-x$dailyHistory
deathrate <- deathrate %>% mutate(hubeiRate=as.numeric(hubei.deadRate), notHubeiRate=as.numeric(notHubei.deadRate), countryRate=as.numeric(country.deadRate))
deathrate <- deathrate %>% extract(date,c("month","day"), regex = "^(\\d+)\\.(\\d+)$",remove = FALSE) 
deathrate <- deathrate %>% mutate(month = as.numeric(month), day = as.numeric(day))
deathrate <- deathrate %>% mutate(date = make_date(2020,month,day))
deathrate %>% ggplot()+geom_point(aes(date,hubeiRate,color="Hubei Rate"))+geom_point(aes(date,notHubeiRate,color="non-Hubei Rate"))+geom_point(aes(date,countryRate,color="country Rate"))+ ylab("Percentage(%)")
```

![](Report_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

Detailed information for each province:

``` r
y <- load_nCov2019(lang = "en")
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

![](Report_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-2.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-3.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-4.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-5.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-6.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-7.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-8.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-9.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-10.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-11.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-12.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-13.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-14.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-15.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-16.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-17.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-18.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-19.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-20.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-21.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-22.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-23.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-24.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-25.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-26.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-27.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-28.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-29.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-30.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-31.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-32.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-33.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-34.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-35.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-36.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-37.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-38.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-39.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-40.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-41.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-42.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-43.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-44.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-45.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-46.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-47.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-48.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-49.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-50.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-51.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-52.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-53.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-54.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-55.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-56.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-57.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-58.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-59.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-60.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-61.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-62.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-63.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-64.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-65.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-66.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-67.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-13-68.png)<!-- -->
