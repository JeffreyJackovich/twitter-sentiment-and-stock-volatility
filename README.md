Sentiment Analysis of "$TWTR" and Technical Indicator Correlation
=================================================================

### Jeffrey Jackovich
### October, 2017

# Contents
  
    1. Introduction
      1.1 Sentiment Analysis
      1.2 Twitter
    2. Methodology
      2.1 Stock Price Dataset
      2.2 Technical Indicator
      2.3 Tweet Dataset sourcing options
      2.4 Tweet's Pre-Processing
      2.5 Twitter Sentiment Corpus
    3. Results
    4. Future Work
    5. Conclusion


## 1. Introduction:  

###  1.1  Sentiment Analysis

Sentiment Analysis refers to the use of text analysis and natural language
processing to identify and extract subjective information in textual contents.
There are two type of user-generated content available on the web - facts and
opinions. Facts are statements about topics and in the current scenario,
easily collectible from the Internet using search engines that index documents
based on topic keywords. Opinions are user specific statement exhibiting
positive or negative sentiments about a certain topic. Generally opinions are
hard to categorize using keywords. Various text analysis and machine learning
techniques are used to mine opinions from a document [1]

**Financial Markets**
     Public opinion regarding companies can be used to predict performance of their stocks in the financial markets. If people have a positive opinion about a product that a company A has launched, then the share prices of A are likely to go higher and vice versa. Public opinion can be used as an additional feature in existing models that try to predict market performances based on historical data. 
     
###  1.2  Twitter
Twitter is an online social networking and micro-blogging service that enables
users to create and read short messages, called "Tweets". It is a global forum
with the presence of eminent personalities from the field of entertainment,
industry and politics. From the perspective of Sentiment
Analysis, we discuss a few characteristics of Twitter:

 
## 2. Methodology: 
I used Twitter's "cashtag" symbol \$ and stock symbol ("TWTR") to obtain Twitter's stock sentiment, to determine if there was a correlation between sentiment and stock price.[2] [3] 
I also obtained Twitters stock price data to assess how accurate  Bollinger Bands® are as a technical indicator.


### 2.1 Stock Price Dataset
<ul><a href="https://github.com/JeffreyJackovich/twitter_sentiment_analysis_and_correlated_trading_indicators/blob/master/obtain_historical_stock_data.R">Obtain historical stock data</a> via Google Finance.</ul>


### 2.2 Technical Indicator
<ul><a href="https://github.com/JeffreyJackovich/twitter_sentiment_analysis_and_correlated_trading_indicators/blob/master/technical_indicator1__bollinger_band.R">Technical Indicator Analysis: Bollinger Bands ®</a></ul>


### 2.3 Tweet Dataset sourcing options
<ul>a.<a href="https://github.com/JeffreyJackovich/twitter_sentiment_analysis_and_correlated_trading_indicators/blob/master/obtain_tweets_via_twitterAPI.R">Twitter API</a></ul>

<ul>b.<a href="https://github.com/JeffreyJackovich/twitter_sentiment_analysis_and_correlated_trading_indicators/blob/master/obtain_tweets_via_GetOldTweets-python.py">GetOldTweets-python</a></ul>


### 2.4 Tweet's Pre-Processing 
<ul><a href="https://github.com/JeffreyJackovich/twitter_sentiment_analysis_and_correlated_trading_indicators/blob/master/historical_tweet_pre-sentiment_diligence.R">Tweets diligence</a></ul>


### 2.5 Twitter Sentiment Corpus
<ul><a href="https://github.com/JeffreyJackovich/twitter_sentiment_analysis_and_correlated_trading_indicators/blob/master/sentiment_pre-processing_and_analysis.R">Sentiment Analysis</a></ul>
<ul><ul>I used R's <a href="https://cran.r-project.org/web/packages/tm/vignettes/tm.pdf">tm package</a> (which provides text mining functions) and <a href="https://github.com/mjockers/syuzhet">syuzhet package</a> (which includes the <a href="http://saifmohammad.com/WebPages/NRC-Emotion-Lexicon.htm">NRC Word-Emotion Association Lexicon</a> algorithm) to analyze the tweets sentiment.</ul></ul>


## 3. Results: 
<p><img width="1000"  src="https://github.com/JeffreyJackovich/twitter_sentiment_analysis_and_correlated_trading_indicators/blob/master/plots/longitudinal_sentiment_with_caption.png"> </p>
 
<br>
<br>

<p><img width="1000"  src="https://github.com/JeffreyJackovich/twitter_sentiment_analysis_and_correlated_trading_indicators/blob/master/plots/total_sentiment_scores_with_caption.png"> </p>


## 4. Future Work:
Implement a Granger causality analysis and Self-Organizing Fuzzy Neural Network to investigate the hypothesis that public mood states are predictive of changes in stock closing values.


## 5. Conclusion:
A visual comparison of Sentiment over time vs BB buy indicator needs more indepth analysis to assess if and how predictive sentiment is on price.       

## References:

[1] Bo Pang and Lillian Lee. Opinion mining and sentiment analysis. _Foundations and trends in information retrieval_, 2(1-2):pages 1-135, 2008. 

[2] Empson, Rip. "Twitter Launches Clickable Stock Symbols, StockTwits' Howard Lindzon Says 'Hey, We Already Do That!'" TechCrunch, TechCrunch, 30 July 2012, techcrunch.com/2012/07/30/twitter-clickable-ticker-symbols/.

[3] Bollen, Johan, et al. "Twitter Mood Predicts the Stock Market." Twitter Mood Predicts the Stock Market., 14 Oct. 2010, pp. 1-8., arxiv.org/pdf/1010.3003.pdf.
