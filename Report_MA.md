CoronaVirus in MASSACHUSETTS
================
WY
3/12/2020

The data was obtained from online sources

Libraries needed:

``` r
library(tidyverse)
library(lubridate)
masCov <- read.csv("covmas.csv")
sources <- read.csv("masSources.csv")
covMasDet <- read.csv("covmasdetail.csv")
covMasDay <- read.csv("covmasday.csv")
```

Confirmed/suspected and the total of the two in Massachusetts:

``` r
masCov %>% ggplot()+geom_point(aes(date,presumptive,color="Presumptive"), shape=0,size=3)+geom_point(aes(date,confirmed,color="Confirmed"),shape=1,size=3)+geom_point(aes(date,total,color="Total"),shape=2,size=3)+ylab("numbers of people")+xlab("")+theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

![](Report_MA_files/figure-gfm/plotting-1.png)<!-- -->

The daily changes:

``` r
covMasDay %>% ggplot()+geom_point(aes(date,newPresum,color="New Presumptive"),shape=0,size=3)+geom_point(aes(date,newConfirm,color="New Confirmed"),shape=1,size=3)+geom_point(aes(date,newTotal,color="New Total"),shape=2,size=3)+ylab("numbers of people")+xlab("")+theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

![](Report_MA_files/figure-gfm/plotting%20for%20daily%20changes-1.png)<!-- -->

Here’s some detailed information about the people who are diagnoised
positive. Here are the distribution by county:

``` r
covMasDet %>% ggplot()+geom_point(aes(date,Berkshire,color="Berkshire"),shape=0,size=3)+geom_point(aes(date,Essex,color="Essex"),shape=1,size=3)+geom_point(aes(date,Middlesex,color="Middlesex"),shape=2,size=3)+geom_point(aes(date,Norfolk,color="Norfolk"),shape=3,size=3)+geom_point(aes(date,Suffolk,color="Suffolk"),shape=4,size=3)+geom_point(aes(date,Worcester,color="Worcester"),shape=5,size=3)+geom_point(aes(date,CntUnknown,color="County Unknown"),shape=6,size=3)+ylab("numbers of people")+xlab("")+theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

![](Report_MA_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

By gender:

``` r
covMasDet %>% ggplot()+geom_point(aes(date,Female,color="Female"),shape=0,size=3)+geom_point(aes(date,Male,color="Male"),shape=1,size=3)+ylab("numbers of people")+xlab("")+theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

![](Report_MA_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

By reason of the disease:

``` r
covMasDet %>% ggplot()+geom_point(aes(date,Biogen,color="Biogen"),shape=0,size=3)+geom_point(aes(date,Travel,color="Travel"),shape=1,size=3)+geom_point(aes(date,BerkMedCen,color="BerkMedCen"),shape=2,size=3)+geom_point(aes(date,UnkownReason,color="Unkown Reasons"),shape=3,size=3)+ylab("numbers of people")+xlab("")+theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

![](Report_MA_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

Whether the patient is treated in hospital:

``` r
covMasDet %>% ggplot()+geom_point(aes(date,hospitalized,color="Hospitalized"),shape=0,size=3)+geom_point(aes(date,notHospitalized,color="Not Hospitalized"),shape=1,size=3)+geom_point(aes(date,Hosunknown,color="Unknown"),shape=2,size=3)+ylab("numbers of people")+xlab("")+theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

![](Report_MA_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->
