library(stringi)

#First download:

start <- as.Date('2012-10-01')
today <- as.Date('2014-05-01')
all_days <- seq(start, today, by = 'day')
year <- as.POSIXlt(all_days)$year + 1900
urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')

destdir <- "D:/BigData/"
n <- length(urls)
i=1
for(i in 1:n){
   destfile <- stri_paste(destdir,as.character(all_days[i]))
   download.file(urls[i],destfile)
}

#Update:

missing_days <- setdiff(as.character(seq(start, Sys.Date(), by = 'day')),list.files(destdir))
n<-length(missing_days)
urls <- paste0('http://cran-logs.rstudio.com/', 2014, '/', missing_days, '.csv.gz')
for(i in 1:n){
   destfile <- stri_paste(destdir,as.character(missing_days[i]))
   download.file(urls[i],destfile)
}