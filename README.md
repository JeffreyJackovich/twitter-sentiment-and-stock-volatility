<h2><strong>Goals</strong></h2> 
<ul>Analyze Twitter tweets relating to the stock market, and correlate technical indicators to tweet sentiment.</ul>


<h2><strong>Why Twitter?</strong></h2> 
<ul>Twitter's REST API provides access to ~500 million daily tweets with numerous options via a 
<a href="https://dev.twitter.com/rest/public/search">Search API</a>.</ul>
 
<h2><strong>Project Outline:</strong></h2> 
<ul>1. Obtain historical stock data via <a href="https://github.com/JeffreyJackovich/twitter_sentiment_analysis_and_correlated_trading_indicators/blob/master/obtain_historical_stock_data.R">Google Finance</a>.</ul>
<ul>2. <a href="https://github.com/JeffreyJackovich/twitter_sentiment_analysis_and_correlated_trading_indicators/blob/master/technical_indicator1__bollinger_band.R">Technical Indicator 1 - Bollinger Band®(BB)</a></ul>


## To Do:
# 2a. Verify output with WSJ historical stock graphs : #http://quotes.wsj.com/TWTR/advanced-chart
# 3. Calculate longitudinal sentiment analysis

# Issues encountered:
# - Low daily individual stock tweet count. Ex: $MMM 
# Next Steps: 
# - Build scalable to locate date and symbols for all 500 S&P's