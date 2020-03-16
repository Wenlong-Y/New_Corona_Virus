CoronaVirus in MASSACHUSETTS
================
WY
3/12/2020

The data was obtained from online sources

Libraries needed:

``` r
library(tidyverse)
library(lubridate)
covMas <- read.csv("covmas.csv")
sources <- read.csv("masSources.csv")
covMasDet <- read.csv("covmasdetail.csv")
covMasDay <- read.csv("covmasday.csv")
```

Confirmed/suspected and the total of the two in Massachusetts:

``` r
covMaslong <- gather(covMas%>% select(-X), key="key", value="value", -date)
names(covMaslong)[2] <- "Class"
covMaslong %>% filter(Class %in% c("presumptive","confirmed","total"))%>% ggplot(aes(as.Date(date, "%Y-%m-%d"),value,color=Class,shape=Class))+geom_line(size=1)+geom_point(size=3)+ylab("numbers of people")+xlab("")+theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

    ## Warning: Removed 2 row(s) containing missing values (geom_path).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](Report_MA_files/figure-gfm/plotting-1.png)<!-- -->

The daily changes:

``` r
covMasDaylong <- gather(covMasDay%>% select(-X), key="key", value="value", -date)
names(covMasDaylong)[2] <- "Class"
covMasDaylong %>%  ggplot(aes(as.Date(date, "%Y-%m-%d"),value,color=Class,shape=Class))+geom_line(size=1)+geom_point(size=3)+ylab("numbers of people")+xlab("")+theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

    ## Warning: Removed 2 row(s) containing missing values (geom_path).

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](Report_MA_files/figure-gfm/plotting%20for%20daily%20changes-1.png)<!-- -->

Here’s some detailed information about the people who are diagnoised
positive. Here are the distribution by county:

``` r
covMasDetCntlong <- gather(covMasDet%>% select(-X) %>% select(date,Barnstable,Berkshire,Bristol,Essex,Hampden,Middlesex,Norfolk,Plymouth,Suffolk,Worcester,CntUnknown), key="key", value="value", -date)
names(covMasDetCntlong)[2] <- "County"
covMasDetCntlong %>% ggplot(aes(as.Date(date, "%Y-%m-%d"),value,color=County))+geom_line(size=1)+geom_point(size=3)+ylab("numbers of people")+xlab("")+theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

![](Report_MA_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

By gender:

``` r
covMasDetSexlong <- gather(covMasDet%>% select(-X) %>% select(date,Male,Female), key="key", value="value", -date)
names(covMasDetSexlong)[2] <- "Class"
covMasDetSexlong %>% ggplot(aes(as.Date(date, "%Y-%m-%d"),value,color=Class,shape=Class))+geom_line(size=1)+geom_point(size=3)+ylab("numbers of people")+xlab("")+theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

![](Report_MA_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

By reason of the disease (BerkMedCen means Berkshire Medical Center
related cases):

``` r
covMasDetWhylong <- gather(covMasDet%>% select(-X) %>% select(date,Biogen,Travel,LocalTransmission,UnkownReason), key="key", value="value", -date)
names(covMasDetWhylong)[2] <- "Class"
covMasDetWhylong %>% ggplot(aes(as.Date(date, "%Y-%m-%d"),value,color=Class,shape=Class))+geom_line(size=1)+geom_point(size=3)+ylab("numbers of people")+xlab("")+theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

![](Report_MA_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

Whether the patient is treated in hospital:

``` r
covMasDetHoslong <- gather(covMasDet%>% select(-X) %>% select(date,hospitalized,notHospitalized,Hosunknown), key="key", value="value", -date)
names(covMasDetHoslong)[2] <- "Class"
covMasDetHoslong %>% ggplot(aes(as.Date(date, "%Y-%m-%d"),value,color=Class,shape=Class))+geom_line(size=1)+geom_point(size=3)+ylab("numbers of people")+xlab("")+theme(axis.text.x = element_text(angle = 60, hjust = 1))
```

![](Report_MA_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->
