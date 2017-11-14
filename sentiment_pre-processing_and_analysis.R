# Author: Jeffrey Jackovich
# Date: 10/17/2017

###########################################################################
###########################################################################
# Sentiment Pre-Processing:
###########################################################################
###########################################################################

###########################################################################
#   1.) Create data corpora for the tweets.
###########################################################################
if (!require("tm")) {
  install.packages("tm")
  library(tm)
}
if (!require("SnowballC")) {
  install.packages("SnowballC")
  library(SnowballC)
}
 
# Verify twitter tweet df
head(twtr.tweets.df)
length(twtr.tweets.df$text)
 
# Convert raw tweets to a Corpus 
tweetsToCorpus <- function(x) {
  data.source <- VectorSource(x)
  data.corpus <- Corpus(data.source)
  return(data.corpus)
}

corpus <- tweetsToCorpus(twtr.tweets.df$text)

# Verify correct implementation
meta(corpus[[2]])
content(corpus[[6]])

###########################################################################
#   2.)	Pre-processing transformations: Corpus to a pre-processed corpus.
###########################################################################

corpusToPreProcessedCorpus <- function(x) {
  # Step 1.) remove emoji's
  convertCharacters <- function(c) {
    iconv(c, from = "UTF-8", to = "ASCII", sub = "")
  }
  data.corpus <- tm_map(x, content_transformer(convertCharacters))
  # Step 2.) lower 
  data.corpus <- tm_map(data.corpus, content_transformer(tolower))
  
  # Step 3.) remove url's
  removeURL <- function(w) {
    gsub("(http[^ ]*)", "", w)
  }
  data.corpus <- tm_map(data.corpus, content_transformer(removeURL))
  
  # Step 4.) remove english stopWords
  english.stopwords <- stopwords("en")
  data.corpus <- tm_map(data.corpus,content_transformer(removeWords),
                        english.stopwords)
  # Step 5.) remove punctuation
  data.corpus <- tm_map(data.corpus, content_transformer(removePunctuation))
  
  # Step 5.a) remove the stock abbreviation specific words  
  data.corpus <- tm_map(data.corpus,
                        removeWords, c("TWTR", "TWITTER", "twtr", "twitter", 
                                       "stock", "STOCK", "market"))
  
  # Step 6.) remove number words
  removeNumberWords <- function(n) {
    gsub("([[:digit:]]+)([[:alnum:]])*", "", n)
  }
  data.corpus <- tm_map(data.corpus,
                        content_transformer(removeNumberWords))
  
  # Step 7.) stem the words
  data.corpus <- tm_map(data.corpus,
                        content_transformer(stemDocument))
  
  # Step 8.) remove whiteSpaces
  data.corpus <- tm_map(data.corpus,
                        content_transformer(stripWhitespace))
  return(data.corpus)
}

corpus <- corpusToPreProcessedCorpus(corpus)

###########################################################################
# 3.) Create the term-document matrix   
###########################################################################
tdm <- TermDocumentMatrix(corpus)
inspect(tdm)

# sparse tdm: source: https://stats.stackexchange.com/questions/160539/is-this-interpretation-of-sparsity-accurate
tdms <- removeSparseTerms(tdm, .98)
inspect(tdms)

save(tdms, file = "TDMSparse_.98__twtr_tweets")

################################################################
################################################################ 
# Sentiment Analysis - Diligence  
################################################################
################################################################

###########################################################################
# 1.) Find the most frequent terms
###########################################################################
# findFreqTerms(tdm, lowfreq = 1500)
findFreqTerms(tdms, lowfreq = 1500)

# Convert to matrix
# tdm.matrix <- as.matrix(tdm) #error Output: "Error: cannot allocate vector of size 35.3 Gb"  
# Troubleshoot 
# head(twtr.tweets.df)
# length(twtr.tweets.df$text)
# class(twtr.tweets.df$text)
# sessionInfo()
# gc()

# convert to sparse tdm
tdm.matrix.sparse <- as.matrix(tdms)

# Calculate the word frequency
# twtr.wf <- rowSums(tdm.matrix)
twtr.wf.s <- rowSums(tdm.matrix.sparse)

# Sort in decreasing order
# twtr.wf.sorted <- sort(twtr.wf, decreasing = TRUE)
# twtrNames <- names(twtr.wf.sorted)
twtr.wf.sorted <- sort(twtr.wf.s, decreasing = TRUE)
twtrNames <- names(twtr.wf.sorted)

twtr.df <- data.frame(word=twtrNames, freq=twtr.wf.sorted)

####################
# $TWTR - wordcloud
####################
if (!require("wordcloud")) {
  install.packages("wordcloud")
  library(wordcloud)
}
set.seed(137)

wordcloud(words = names(twtr.wf.sorted),
          freq = twtr.wf.sorted,
          min.freq = 50,
          random.order = F,
          colors =  brewer.pal(8, "Dark2"))

######################################################################
# Most frequent words
#         Source: https://www.kaggle.com/gpreda/explore-king-james-bible-books
#######################################################################

ggplot(twtr.df[1:20,], aes(x=reorder(word, freq), y=freq)) +
  geom_bar(stat = "identity", fill="tomato") +
  coord_flip() +
  labs(title="Most Frequent Words in $TWTR Tweets \ntweet created dates: 11/2016 to 11/2017", x="Word", y="Frequency") +
  theme(plot.caption=element_text(hjust=0.01)) +
  labs(caption = "Figure 3: Top 20 most frequent words.")

head(twtr.df)
length(twtr.df)
############################
############################
# Sentiment Analysis Methods
############################
############################


###########################################################################
# *****TO NOTE: I DID NOT use this method for my results****** 
#   ******I included this as reference to understand the underlying mechanics of sentiment analysis*****
# Method 1 - Basic: 
#       - Using the positive and negative word lists, compute the sentiment score 
#       for all the tweets.
###########################################################################
path_to_sentiment_positive_file = "C:\\positive-words.txt"
pos.words = scan(path_to_sentiment_positive_file,
                 what = 'character')

path_to_sentiment_negative_file = "C:\\negative-words.txt"
neg.words = scan(path_to_sentiment_negative_file,
                 what = 'character')

sentiment <- function(text, pos.words, neg.words) {
  text <- gsub('[[:punct:]]', '', text)
  text <- gsub('[[:cntrl:]]', '', text)
  text <- gsub('\\d+', '', text)
  text <- tolower(text)
  #split the text into a vector of words
  words <- strsplit(text, '\\s+')
  words <- unlist(words)
  #find which words are positive
  pos.matches <- match(words, pos.words)
  pos.matches <- !is.na(pos.matches)
  #find which words are negative
  neg.matches <- match(words, neg.words)
  neg.matches <- !is.na(neg.matches)
  #output tweet text
  cat(" Positive: ", words[pos.matches], "\n")
  cat(" Negative: ", words[neg.matches], "\n")
  #calc the sentiment score
  #removes count with equal number of positive and negative
  p <- sum(pos.matches)
  n <- sum(neg.matches)
  if (p == 0 & n == 0)
    return (NA)
  else
    return(p-n)  
}

# Verify possible error causing emojis and formats
twtr.tweets.df$text[[3]]
# remove emojis
twtr.tweets.1 <- iconv(twtr.tweets.df$text, "latin1", "ASCII", sub="")
#verify correct implementation
twtr.tweets.1[[3]]

##################################
# BASIC SENTIMENT -  score calculation
##################################
twtr.scores.basic <- sapply(twtr.tweets.1, sentiment, pos.words, neg.words)

twtr.score.basic.table <- table(twtr.scores.basic)

# plot basic method - sentiment scores
barplot(table(twtr.scores.basic),
        xlab = "Score", ylab = "Count", col = "cyan")


###########################################################################
# Method 2 - Advanced: 
#       - Using , compute the sentiment score 
#       for all the tweets.
#  Sources:
#     NRC Word-Emotion Association Lexicon: http://saifmohammad.com/WebPages/NRC-Emotion-Lexicon.htm
#     Project: https://juliasilge.com/blog/joy-to-the-world/
###########################################################################
if (!require("syuzhet")) {
  install.packages("syuzhet")
  library(syuzhet)
}
if (!require("reshape2")) {
  install.packages("reshape2")
  library(reshape2)
}
if (!require("ggplot2")) {
  install.packages("ggplot2")
  library(ggplot2)
}
if (!require("dplyr")) {
  install.packages("dplyr")
  library(dplyr)
}
if (!require("gridExtra")) {
  install.packages("gridExtra")
  library(gridExtra)
}

# convert "text" column to class "character"
twtr.tweets.df$text <- as.character(twtr.tweets.df$text)
twtrSentiment <- get_nrc_sentiment(twtr.tweets.df$text)

twtr.tweets.df <- cbind(twtr.tweets.df, twtrSentiment)

head(twtr.tweets.df)

# Verify Sentiment column indicies
head(twtr.tweets.df[,c(13:20)])

sentimentTotals <- data.frame(colSums(twtr.tweets.df[,c(13:20)]))
names(sentimentTotals) <- "count"
sentimentTotals <- cbind("sentiment" = rownames(sentimentTotals), sentimentTotals)
rownames(sentimentTotals) <- NULL

# Total sentiment Plot
ggplot(data = sentimentTotals, aes(x = sentiment, y = count)) +
  geom_bar(aes(fill = sentiment), stat = "identity") +
  theme(legend.position = "none",
        plot.caption=element_text(hjust=0.01)) +
  xlab("Sentiment") + ylab("Total Count") + 
  ggtitle("Total Sentiment Score for All $TWTR Tweets \n(November 2016 to November 2017)") +
  labs(caption = "Fig. 2. Categorizing all 169,974 tweets.")
   

head(twtr.tweets.df$date_time)
tail(twtr.tweets.df$date_time)
length(twtr.tweets.df$date_time)
######################
# sentiment over time
#####################
posnegtime <- twtr.tweets.df %>% 
  group_by(date_time = cut(date_time, breaks="1 day")) %>%
  summarise(negative = mean(negative),
            positive = mean(positive)) %>% melt
names(posnegtime) <- c("date_time", "sentiment", "meanvalue")
posnegtime$sentiment = factor(posnegtime$sentiment,levels(posnegtime$sentiment)[c(2,1)])


# Sentiment longitudional plot
# legend modifications source: http://www.cookbook-r.com/Graphs/Legends_(ggplot2)/
sentLongPlot <- ggplot(data = posnegtime, aes(x = as.Date(date_time), y = meanvalue, group = sentiment)) +
  geom_line(size = 0.75, alpha = 0.7, aes(color = sentiment)) +
  geom_point(size = 0.5) +
  ylim(0, NA) + 
  scale_colour_manual(values = c("springgreen4", "firebrick3")) +
  theme(legend.title=element_blank(), axis.title.x = element_blank()) +
  scale_x_date(breaks = date_breaks("1 month"), 
               labels = date_format("%b-%Y")) +
  ylab("Average sentiment score") + 
  ggtitle("$TWTR - Sentiment Over Time")


# Sentiment longitudional plot - Corrected legend
# sentPlot <- 

sentPlot <- 
  
ggplot(data = posnegtime, aes(x = as.Date(date_time), y = meanvalue, group = sentiment)) +
  geom_line(size = 0.75, alpha = 1, aes(color = sentiment)) +
  geom_point(size = 0.5) +
  ylim(0, NA) + 
  scale_colour_manual(values = c("springgreen4", "firebrick3")) +
  scale_x_date(breaks = date_breaks("1 month"), 
               labels = date_format("%b-%Y")) +
  ylab("Average sentiment score") + 
  ggtitle("$TWTR - Sentiment Over Time") +
  theme(legend.position = c(0.95,0.95), 
        legend.text = element_text(size = 8),
        legend.background = element_rect(color = "black")) +
  xlab("Date")

# BollingerBands plot- VERSION 2 *to combine
bb_plot_v2 <- ggplot(data= TWTR_df_bb, aes(x = Date, y = Close)) +
  ggtitle("$TWTR Bollinger Bands (sma = 20)") +
  ylab("Close price (usd)") +
  geom_line(size=0.75) +
  geom_bbands(aes(high = High, low = Low, close = Close), ma_fun = SMA, n = 20, size = 0.75,
              color_ma = "royalblue4", color_bands = "red1" ) +
  coord_x_date(xlim = c("2016-11-01", "2017-10-30"), ylim = c(5,30)) +
  scale_x_date(date_labels = "%b-%Y", date_breaks = "1 month" ) + 
  annotate("text", x = c(buy.date1, buy.date2, buy.date3, buy.date4,buy.date5, buy.date6, buy.date7), 
           y = c(buy.price1, buy.price2, buy.price3, buy.price4, buy.price5, buy.price6, buy.price7), 
           label = sprintf("Buy", buy.date1), size = 3, 
           vjust = 2, colour = "blue",fontface = "bold") +
  theme(plot.caption=element_text(hjust=0.01)) +
  labs(caption = "Fig. 1. Longitudinal sentiment compared to Bollinger Bands (BB) buy indicators.")



# combine BBplot and Sentiment
grid.arrange(sentPlot, bb_plot_v2)   



# BollingerBands plot -  VERSION 1
TWTR_df_bb %>%
  ggplot(aes(x = Date, y = Close)) +
  ggtitle("$TWTR Bollinger Bands (sma = 20)") +
  ylab("Close price (usd)") +
  geom_line(size=0.75) +
  geom_bbands(aes(high = High, low = Low, close = Close), ma_fun = SMA, n = 20, size = 0.75,
              color_ma = "royalblue4", color_bands = "red1") +
  coord_x_date(xlim = c("2017-04-01", "2017-10-30"), ylim = c(5,30)) +
  scale_x_date(date_labels = "%b %d %y", date_breaks = "1 month" ) +
  annotate("text", x = c(buy.date1, buy.date2, buy.date3, buy.date4,buy.date5, buy.date6, buy.date7), 
           y = c(buy.price1, buy.price2, buy.price3, buy.price4, buy.price5, buy.price6, buy.price7), 
           label = sprintf("Buy", buy.date1), size = 3, 
           vjust = 2, colour = "blue",fontface = "bold")




# BollingerBands plot
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




