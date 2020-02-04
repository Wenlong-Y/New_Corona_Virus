nCoronaVirus\_Report
================
WY
2/4/2020

## Daily Update on the new corona virus statistics

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
x <- get_nCov2019()
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

The last updated time (Beijing Time) is 

``` r
x$lastUpdateTime
```

    ## [1] "2020-02-05 03:29:40"

Now we present the total number of confirmed and suspected respectively.

``` r
dataDay %>% ggplot() + geom_point(aes(date,confirm,colour="Confirmed")) +geom_point(aes(date,suspect,color="Suspect")) +theme(legend.position="right")+ylab("Number of cases")+labs(colour="Type")+scale_color_manual(values=c("blue","red"))
```

![](Report_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

Now we want to put an upper limit on infected cases, so we add up the
confimred and suspected. Because a big portion of suspected cases become
confirmed cases. This give us the following chart:

``` r
dataDay %>% ggplot(aes(date,confirm+suspect))+geom_point()
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

## Cases by country

We just look at the total number of cases for countries:

``` r
library(grid)
library(gridExtra)
areatotal <- cbind(x$areaTree$name,x$areaTree$total)
names(areatotal)[1] <- "Country"
png(filename = "totalbycountry.png", width=360,height=560,bg = "white")
grid.table(areatotal)
dev.off()
```

    ## png 
    ##   2

![Cases by country](totalbycountry.png)

## Cases by provinces and cities

There are several provinces hit hard by the disease. We present the data
for the first few provinces on the list.

Hubei is where the disease started and majority of cases come from this
province. It is believed that one of the wet market is the origin of the
new corona virus.

``` r
grid.table(x[1])
```

![](Report_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

The second heavily infected province is Zhejiang. Here are the data for
the cities in Zhejiang province.

``` r
grid.table(x[2])
```

![](Report_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

The third one on the list is Guangdong province, where the SARS started
in 2003.

``` r
grid.table(x[3])
```

![](Report_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

The fourth is Henan, a province with a population of 94 million and is
to the north of Hubei.

``` r
grid.table(x[4])
```

![](Report_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

The fifth is Hunan, a province to the south of Hubei.

``` r
grid.table(x[5])
```

![](Report_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

The sixth is Anhui, a province to the east of Hubei.

``` r
grid.table(x[6])
```

![](Report_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

The rest of the provinces are listed below:

``` r
for(i in 7:34)
{
  grid.text(label = as.character(x[,1]$name[i]),x=0.1,y=0.5,rot=90, gp=gpar(cex=2))
  grid.table(x[i],vp=viewport(x=0.5,y=.5,width=1,height=1))
  grid.newpage()
}
```

![](Report_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-2.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-3.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-4.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-5.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-6.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-7.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-8.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-9.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-10.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-11.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-12.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-13.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-14.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-15.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-16.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-17.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-18.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-19.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-20.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-21.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-22.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-23.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-24.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-25.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-26.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-27.png)<!-- -->![](Report_files/figure-gfm/unnamed-chunk-18-28.png)<!-- -->
