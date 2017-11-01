# Author: Jeffrey Jackovich
# Date: 10/30/2017

################################################################################
# Obtain historical tweets
#  Python Code Source: https://github.com/Jefferson-Henrique/GetOldTweets-python
################################################################################
 
# Step 1.) Create a python 2.x (*Python 3.5 did not work for me) virtual environment via an Anaconda command prompt.   
#   a. Navigate to your working directory.
#   b. Run the following to create a virtual environment:
#       - "conda create --name py27 python=2.7"
#   c. Activate the virtual environment:
#       - "activate py27"
#   d. Need a CONDA cheat sheet? 
#       - https://conda.io/docs/_downloads/conda-cheatsheet.pdf
#
#
#  **If needed: To Install Anaconda:
#     a. Download the Anaconda Python package for your platform.
#       - Visit the Anaconda homepage. ( https://www.anaconda.com/ ) 
#       - Click "Anaconda" from the menu and click "Download" to go to the download page.
#       - Choose the download suitable for your platform (Windows, OSX, or Linux):
#       - Choose Python 3.5
#       - Choose the Graphical Installer
#     b. Install Anaconda
#     c. Confirm Anaconda is intalled correctly by opening a command prompt and typing:
#       "conda -V" # output should be similar to: "conda 4.2.9"
#     d. Confirm Python is intalled correctly by opening a command prompt and typing:
#       "python -V" # output should be similar to: "Python 3.5.2 :: Anaconda 4.2.0 (x86_64)"
#     e. Having Anaconda issues on Windows?
#       - See this detaie step-by-step install guide: https://machinelearningmastery.com/setup-python-environment-machine-learning-deep-learning-anaconda/
#
#
########################################################
########################################################
# TO obain historial tweets
########################################################
########################################################
# 1. Download or Clone "Get Old Tweets Programatically"
#       - Source: https://github.com/Jefferson-Henrique/GetOldTweets-python
#
# 2. Install requirements: "pip install -r requirements.txt"

# 3. Verify desired tweets are available via the following (*or command line method):
tweetCriteria = got.manager.TweetCriteria().setQuerySearch('$TWTR').setSince("2016-05-01").setUntil("2017-09-30").setMaxTweets(1)
tweet = got.manager.TweetManager.getTweets(tweetCriteria)[0]

print(tweet.text)
