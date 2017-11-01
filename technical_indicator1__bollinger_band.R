# Author: Jeffrey Jackovich
# Date: 10/30/2017

if (!require("TTR")) {
  install.packages("TTR")
  library(TTR)
}

if (!require("dplyr")) {
  install.packages("dplyr")
  library(dplyr)
}

if (!require("ggplot2")) {
  install.packages("ggplot2")
  library(ggplot2)
}

if (!require("tidyquant")) {
  install.packages("tidyquant")
  library(tidyquant)
}

###########################
# TWTR_df - Pre-Processing
###########################
# Twitter stock price df
head(TWTR_df)
# Correct Date column: convert from "character" to "date" Object
#   Reference Source - datetime: https://www.statmethods.net/input/dates.html
typeof(TWTR_df$Date)
TWTR_df$Date <- as.Date(TWTR_df$Date, format = "%d-%b-%y")
typeof(TWTR_df$Date)
head(TWTR_df)

# Sort price dates in ascending order
TWTR_df_aescDates <- TWTR_df[order(TWTR_df$Date),]
head(TWTR_df_aescDates)

##############################################################################
# Add Bollinger Band® (BB)
#   R code Source Reference: http://www.tradinggeeks.net/2014/07/technical-analysis-with-r/
##########################################################################
# 20-day Simple Moving Average
sma20 <- SMA(TWTR_df_aescDates[c('Close')],n=20)
head(sma20, n=50)

# Calculate BB
bb20 <- BBands(TWTR_df_aescDates[c('Close')], sd=2.0)
head(bb20, n=30)

# Create a df containg all input from the original, plus BB data
TWTR_df_bb <- data.frame(TWTR_df_aescDates, bb20)
# Verify both ends of the df
head(TWTR_df_bb, 6)
tail(TWTR_df_bb)

# Verify column types as double
# change "Open" column type from character to double
typeof(TWTR_df_bb$Open)
TWTR_df_bb$Open <- as.numeric(TWTR_df_bb$Open)
typeof(TWTR_df_bb$Open)
# change "High" column type from character to double
typeof(TWTR_df_bb$High)
TWTR_df_bb$High <- as.numeric(TWTR_df_bb$High)
typeof(TWTR_df_bb$High)

typeof(TWTR_df_bb$Low)
typeof(TWTR_df_bb$Close)
typeof(TWTR_df_bb$Volume)


# Plot BB
#    Source https://business-science.github.io/tidyquant/reference/geom_bbands.html
#    ggplot minor breaks: http://ggplot2.tidyverse.org/reference/scale_date.html
TWTR_df_bb %>%
  ggplot(aes(x = Date, y = Close)) +
  ggtitle("$TWTR Bollinger Bands (sma = 20)") +
  ylab("Close price (usd)") +
  geom_line(size=0.75) +
  geom_bbands(aes(high = High, low = Low, close = Close), ma_fun = SMA, n = 20, size = 0.75,
              color_ma = "royalblue4", color_bands = "red1") +
  coord_x_date(xlim = c("2016-11-02", "2017-10-30"), ylim = c(5,30)) +
  scale_x_date(date_labels = "%b %d %y", date_breaks = "2 month" )

#########################################################
# Use BB LowerBand as a CrossOver Buy Indicator   
########################################################

# BB interpretation:
# %B equals 1 when price is at the upper band
# %B equals 0 when price is at the lower band
# %B is above 1 when price is above the upper band
# %B is below 0 when price is below the lower band
# %B is above .50 when price is above the middle band (20-day SMA)
# %B is below .50 when price is below the middle band (20-day SMA)


TWTR_df_bb$sig <- NA
head(TWTR_df_bb)
# cross-over signal: https://stackoverflow.com/questions/30364782/creating-trading-signals-in-r
price.over.up <- Cl(TWTR_df_bb) > TWTR_df_bb$up
price.under.dn <- Cl(TWTR_df_bb) < TWTR_df_bb$dn
head(TWTR_df_bb)

TWTR_df_bb$sig <- rep(0,nrow(TWTR_df_bb))
head(TWTR_df_bb)

# Sell which price breaks top band
TWTR_df_bb$sig[which(diff(price.over.up)==1)] <- -1
head(TWTR_df_bb)

# Buy when price breaks bottom band
TWTR_df_bb$sig[which(diff(price.under.dn)==1)] <- 1
head(TWTR_df_bb)

#df_MMM_bb$sig <- Lag(df_MMM_bb$sig) ??removes the "sig" column???

###################
#  Buy sign dates
####################
which(TWTR_df_bb$sig == 1)  # 34  68  94 105 147 150 185
TWTR_df_bb[34,] #   2016-12-20
buy.date1 <- TWTR_df_bb[34,]$Date
buy.price1 <- TWTR_df_bb[34,]$Close
typeof(buy.date1)

TWTR_df_bb[68,] #   2017-02-09
buy.date2 <- TWTR_df_bb[68,]$Date
buy.price2 <- TWTR_df_bb[68,]$Close

TWTR_df_bb[94,] #   2017-03-20
buy.date3 <- TWTR_df_bb[94,]$Date
buy.price3 <- TWTR_df_bb[94,]$Close 

TWTR_df_bb[105,] #   2017-04-04
buy.date4 <- TWTR_df_bb[105,]$Date
buy.price4 <- TWTR_df_bb[105,]$Close 

TWTR_df_bb[147,] #  2017-06-05
buy.date5 <- TWTR_df_bb[147,]$Date
buy.price5 <- TWTR_df_bb[147,]$Close 

TWTR_df_bb[150,] #  2017-06-08
buy.date6 <- TWTR_df_bb[150,]$Date
buy.price6 <- TWTR_df_bb[150,]$Close 

TWTR_df_bb[185,] #  2017-07-28
buy.date7 <- TWTR_df_bb[185,]$Date
buy.price7 <- TWTR_df_bb[185,]$Close 

# resolve annotate issue: https://stackoverflow.com/questions/25179889/ggmap-error-in-annotate
# detach("package:ggplot2", unload=TRUE)
# detach("package:tidyverse", unload=TRUE)
# detach("package:tidyquant", unload=TRUE)
# library(ggplot2)
# library("TTR")

TWTR_df_bb %>%
  ggplot(aes(x = Date, y = Close)) +
  ggtitle("$TWTR Bollinger Bands (sma = 20)") +
  ylab("Close price (usd)") +
  geom_line(size=0.75) +
  geom_bbands(aes(high = High, low = Low, close = Close), ma_fun = SMA, n = 20, size = 0.75,
              color_ma = "royalblue4", color_bands = "red1") +
  coord_x_date(xlim = c("2016-11-02", "2017-10-30"), ylim = c(5,30)) +
  scale_x_date(date_labels = "%b %d %y", date_breaks = "2 month" ) +
  annotate("text", x = c(buy.date1, buy.date2, buy.date3, buy.date4,buy.date5, buy.date6, buy.date7), 
           y = c(buy.price1, buy.price2, buy.price3, buy.price4, buy.price5, buy.price6, buy.price7), 
           label = sprintf("Buy", buy.date1), size = 3, 
           vjust = 2, colour = "blue",fontface = "bold")
