# Author: Jeffrey Jackovich
# Date: 10/30/2017

###########################################################################
# Obtain - "$TWTR" tweets via Twitter API: 
###########################################################################

if (!require("twitteR")) {
  install.packages("twitteR")
  library(twitteR)
}

if (!require("ROAuth")) {
  install.packages("ROAuth")
  library(ROAuth)
}

if (!require("RCurl")) {
  install.packages("RCurl")
  library(RCurl)
}

if (!require("bitops")) {
  install.packages("bitops")
  library(bitops)
}

if (!require("rjson")) {
  install.packages("rjson")
  library(rjson)
}
 
twitter.api.key <- "<insert api key>"
twitter.api.secret <- "<insert api secret>"

# save(twitter.api.key, file = "twitter.api.key")
# save(twitter.api.secret, file = "twitter.api.secret")

setup_twitter_oauth(twitter.api.key,
                    twitter.api.secret, access_token = NULL,
                    access_secret = NULL)

#test correctly implemented
start <- getUser("cnnbrk")
start$description

TWTR.tweets <- searchTwitter("$TWTR", n=100, lang="en", since = '2017-10-20', until = '2017-10-21')
TWTR.tweets[[3]]
