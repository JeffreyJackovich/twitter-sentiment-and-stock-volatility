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
                        removeWords, c("TWTR", "TWITTER", "twtr", "twitter", "stock", "market"))
  
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


################################################################
################################################################ 
# Sentiment Analysis - Diligence  
################################################################
################################################################

###########################################################################
# 1.) Find the most frequent terms
###########################################################################
findFreqTerms(tdm, lowfreq = 1500)


# Convert to matrix
tdm.matrix <- as.matrix(tdm)
# Calculate the word frequency
twtr.wf <- rowSums(tdm.matrix)
# Sort in decreasing order
twtr.wf.sorted <- sort(twtr.wf, decreasing = TRUE)
twtrNames <- names(twtr.wf.sorted)

twtr.df <- data.frame(word=twtrNames, freq=twtr.wf.sorted)

################
# $TWTR - wordcloud
################
if (!require("wordcloud")) {
  install.packages("wordcloud")
  library(wordcloud)
}

set.seed(137)
wordcloud(words = names(twtr.wf.sorted),
          freq = twtr.wf.sorted,
          min.freq = 100,
          random.order = F,
          colors =  brewer.pal(8, "Dark2"))

####################
# Most frequent words
# source: https://www.kaggle.com/gpreda/explore-king-james-bible-books
####################

ggplot(twtr.df[1:20,], aes(x=reorder(word, freq), y=freq)) +
  geom_bar(stat = "identity", fill="tomato") +
  coord_flip() +
  labs(title="$TWTR - Most Frequent Words", x="Word", y="Frequency")