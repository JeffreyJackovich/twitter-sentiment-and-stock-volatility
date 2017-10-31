# Author: Jeffrey Jackovich
# Date: 10/30/2017

###########################################################################
# Obtain stock data via: Google Finance
#     Reference Source: https://chrisconlan.com/download-daily-data-every-sp-500-stock-r/
###########################################################################
# Verify data.table is installed
if(!'data.table' %in% installed.packages()[,1]) install.packages('data.table')

# Function to obtain google stock data
google <- function(sym, current = TRUE, sy = 2017, sm = 1, sd = 1, ey, em, ed)
{
  if(current){
    system_time <- as.character(Sys.time())
    ey <- as.numeric(substr(system_time, start = 1, stop = 4))
    em <- as.numeric(substr(system_time, start = 6, stop = 7))
    ed <- as.numeric(substr(system_time, start = 9, stop = 10))
  }
  
  require(data.table)
  google_out = tryCatch(
    suppressWarnings(
      fread(paste0("http://www.google.com/finance/historical",
                   "?q=", sym,
                   "&startdate=", paste(sm, sd, sy, sep = "+"),
                   "&enddate=", paste(em, ed, ey, sep = "+"),
                   "&output=csv"), sep = ",")),
    error = function(e) NULL
  )
  
  if(!is.null(google_out)){
    names(google_out)[1] = "Date"
  }
  return(google_out)
}

# Test it
google_data = google('GOOGL')
head(google_data)


#####################################################
# Choice 1: Obtain all 500 S&P-500 comany's stockdata
#####################################################

# Hold stock data and vector of invalid requests
STOCK_DATA <- list()
INVALID <- c()

# Load list of all S&P 500 symbols (Updated May 2017)
SYM <- as.character( read.csv('http://trading.chrisconlan.com/SPstocks_current.csv', 
                              stringsAsFactors = FALSE, header = FALSE)[,1] )

# Attempt to fetch each symbol
for(sym in SYM){
  google_out <- google(sym)
  
  if(!is.null(google_out)) {
    STOCK_DATA[[sym]] <- google_out
  } else {
    INVALID <- c(INVALID, sym)
  }
}

# Overwrite with only valid symbols
SYM <- names(STOCK_DATA)

# Remove iteration variables
rm(google_out, sym)

cat("Successfully download", length(STOCK_DATA), "symbols.")
cat(length(INVALID), "invalid symbols requested.\n", paste(INVALID, collapse = "\n\t"))
cat("We now have a list of data frames of each symbol.")
cat("e.g. access MMM price history with STOCK_DATA[['MMM']]")

############################################
# Choice 2: Obtain one company's stockdata
############################################
###################
# Obtain twitter stock data
###################

# Hold stock data in a list object
TWITTER_DATA <- list()

twitter_data_out <- google("TWTR")
TWITTER_DATA[["TWTR"]] <- twitter_data_out

# Veriy data  
head(TWITTER_DATA)

# Create df for easier manipulation
TWTR_df <- data.frame(TWITTER_DATA[["TWTR"]])
head(TWTR_df)