
## Look for required packages, install them if not already installed
list.of.packages <- c('streamR','ROAuth')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

## load the required packages
l <- lapply(list.of.packages, require, character.only=T,  quietly=TRUE)

## get parameters
args <- commandArgs(trailingOnly = TRUE)

#str(args)

## Create or load the OAUTH credential file
if(!file.exists('pdi_R_twitter_oauth.Rdata')) {
    requestURL <- "https://api.twitter.com/oauth/request_token"
    accessURL <- "https://api.twitter.com/oauth/access_token"
    authURL <- "https://api.twitter.com/oauth/authorize"
    consumerKey <- "xxxxxxxxxxxxxxxxxxxxxx"
    consumerSecret <- "xxxxxxxxxxxxxxxxxxxxxxxxx"
    my_oauth <- OAuthFactory$new(consumerKey = consumerKey, consumerSecret = consumerSecret, 
                                 requestURL = requestURL, accessURL = accessURL, authURL = authURL)
    my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
    save(my_oauth, file = "pdi_R_twitter_oauth.Rdata")
} else {
    load('pdi_R_twitter_oauth.Rdata')
}

## Get the stream
streamResult <- filterStream("", track = args[1], timeout = as.numeric(args[2]), oauth = my_oauth)

## Append all JSON tweet together, seperate by ,
tweet <- paste(streamResult, collapse='',sep=',')

## Create a JSON array
tweets <- paste('{"statuses":[',tweet,']}')

## output to stdout
cat(tweets)