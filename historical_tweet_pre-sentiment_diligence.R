# Author: Jeffrey Jackovich
# Date: 10/30/2017


# path to historical $TWTR data 
twtr.hist.path <- "<insert path> \\twtr_stock_10.29.2017_to_03.31.17.csv"

twtr.his.data <- read.csv(twtr.hist.path, header = TRUE)
head(twtr.his.data)

# convert to df
twtr.tweets.df <- data.frame(twtr.his.data)
head(twtr.tweets.df)

# check extra columns for data to possible eliminate
NonNAindex <- which(!is.na(twtr.tweets.df$X.2))
NonNAindex
min(NonNAindex)

# remove columns
twtr.tweets.df <- subset(twtr.tweets.df, select = -c(X, X.1, X.2))
head(twtr.tweets.df)

# convert "date" column to include seconds
twtr.tweets.df$date_time <- format(as.POSIXct(twtr.tweets.df$date, format="%m/%d/%Y %H:%M"), format="%m-%d-%Y %H:%M:%S") 
head(twtr.tweets.df)

# convert "date_time" column from character to class, POSIXct"
typeof(twtr.tweets.df$date_time)
twtr.tweets.df$date_time <- as.POSIXct(twtr.tweets.df$date_time, format="%m-%d-%Y %H:%M:%S")
typeof(twtr.tweets.df$date_time)
# verify correct conversion
class(twtr.tweets.df$date_time)
head(twtr.tweets.df$date_time)

########################################################################################
# Verify tweets per day count to assure enough for a sufficient daily sentiment analysis
#       plot source: http://blog.revolutionanalytics.com/2016/01/twitter-sentiment.html
#       source 1: https://juliasilge.com/blog/ten-thousand-tweets/
#       source 2:  https://juliasilge.com/blog/joy-to-the-world/
#######################################################################################

if (!require("lubridate")) {
  install.packages("lubridate")
  library(lubridate)
}
if (!require("scales")) {
  install.packages("scales")
  library(scales)
}

# plot tweet count by month
ggplot(data = twtr.tweets.df, aes(x = month(date_time, label = TRUE))) +
  geom_histogram(aes(fill = ..count..), stat = "count") +
  theme(legend.position = "none") +
  xlab("Month") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "midnightblue", high = "aquamarine4")+
  ggtitle("$TWTR - Tweet count by month")

# plot individual dates by year
ggplot(data = twtr.tweets.df, aes(x = yday(date_time))) +
  geom_histogram(aes(fill = ..count..), stat = "count") +
  theme(legend.position = "none") +
  xlab("Day") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "midnightblue", high = "aquamarine4") +
  ggtitle("$TWTR - Tweet count by day")

#######################################################################
# Verify number of characters per tweet - to verify no outliers, etc
#######################################################################
typeof(twtr.tweets.df$text)
class(twtr.tweets.df$text)
twtr.tweets.df$text <- as.character(twtr.tweets.df$text)
twtr.tweets.df$charsintweet <- sapply(twtr.tweets.df$text, function(x) nchar(x))

table(twtr.tweets.df$charsintweet)

ggplot(data = twtr.tweets.df, aes(x = charsintweet)) +
  geom_histogram(aes(fill = ..count..), binwidth = 4) +
  theme(legend.position = "none") +
  xlab("Characters per Tweet") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "midnightblue", high = "aquamarine4")+
  ggtitle("$TWTR - Number of characters per Tweet")

#check tweet indicies and dates with more than 400 characters
twtr.tweets.df[(twtr.tweets.df$charsintweet > 400),]

# possibly return and remove outlier to assess change to sentiment
