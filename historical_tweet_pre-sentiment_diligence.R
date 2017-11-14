# Author: Jeffrey Jackovich
# Date: 10/30/2017


# path to historical $TWTR data 
twtr.hist.path <- "<insert path> \\twtr_stock_10.29.2017_to_11.01.16.csv"
 
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
length(twtr.tweets.df$date_time)

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
if (!require("ggplot2")) {
  install.packages("ggplot2")
  library(ggplot2)
}
# plot tweet count by month
ggplot(data = twtr.tweets.df, aes(x = month(date_time, label = TRUE))) +
  geom_histogram(aes(fill = ..count..), stat = "count") +
  theme(legend.position = "none") +
  xlab("Month") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "midnightblue", high = "aquamarine4")+
  ggtitle("$TWTR - Tweet count by month")

# plot individual dates by day
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
length(twtr.tweets.df$charsintweet)
# Number of characters per tweet
ggplot(data = twtr.tweets.df, aes(x = charsintweet)) +
  geom_histogram(aes(fill = ..count..), binwidth = 4) +
  theme(legend.position = "none") +
  xlab("Characters per Tweet") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "midnightblue", high = "aquamarine4")+
  theme(plot.caption=element_text(hjust=0.01)) +
  labs(caption = "Figure 1: Examining the number of characters per tweet containing $TWTR posted between \nNovember 2016 to November 2017 for possible outliers.")

# ggtitle("$TWTR - Number of characters per Tweet") +

#check tweet indicies and dates with more than 400 characters
twtr.tweets.df[(twtr.tweets.df$charsintweet > 400),]

#
# Frequency Analysis:
# source: https://sites.google.com/site/miningtwitter/questions/frequencies

#######################################
# number of words per tweet 
#######################################
head(twtr.tweets.df)
twtr.tweets.df$words <- strsplit(twtr.tweets.df$text, " ")
head(twtr.tweets.df)
twtr.tweets.df$wordsintweet <- sapply(twtr.tweets.df$words, function(x) length(x))
head(twtr.tweets.df)
length(twtr.tweets.df$wordsintweet)

ggplot(data = twtr.tweets.df, aes(x = wordsintweet)) +
  geom_histogram(aes(fill = ..count..), binwidth = 4) +
  theme(legend.position = "none") +
  xlab("Word count per Tweet") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "midnightblue", high = "aquamarine4") +
  theme(plot.caption=element_text(hjust=0.01)) +
  labs(caption = "Figure 2: Examining the number of words per tweet containing $TWTR posted between \nNovember 2016 to November 2017 for possible outliers.")



# ggtitle("$TWTR - Distribution of words per Tweet")

#######################################
#  number of Unique words per tweet 
#######################################
twtr.tweets.df$uniqueWordsInTweet <- sapply(twtr.tweets.df$words, function(x) length(unique(x)))
head(twtr.tweets.df)

ggplot(data = twtr.tweets.df, aes(x = uniqueWordsInTweet)) +
  geom_histogram(aes(fill = ..count..), binwidth = 4) +
  theme(legend.position = "none") +
  xlab("Unique Word Count per Tweet") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "midnightblue", high = "aquamarine4") +
  theme(plot.caption=element_text(hjust=0.01)) +
  labs(caption = "Figure 3: Examining the number of Unique words per tweet containing $TWTR posted between \nNovember 2016 to November 2017 for possible outliers.")





#ggtitle("$TWTR - Distribution of Unique Words per Tweet")

#######################################
#  number of http links per tweet 
#######################################
twtr.tweets.df$httpPerTweet <- sapply(twtr.tweets.df$text, function(x) length(grep("http", x)))

head(twtr.tweets.df)
length(twtr.tweets.df$httpPerTweet)

ggplot(data = twtr.tweets.df, aes(x = httpPerTweet)) +
  geom_histogram(aes(fill = ..count..), binwidth = 4) +
  theme(legend.position = "none") +
  xlab("http link Count per Tweet") + ylab("Number of tweets") + 
  scale_fill_gradient(low = "midnightblue", high = "aquamarine4")+
  ggtitle("$TWTR - Distribution of http links per Tweet")


# possibly return and remove outlier to assess change to sentiment
