#First download:

require("stringi")

start <- as.Date('2012-10-01')
today <- as.Date('2014-05-09')
all_days <- seq(start, today, by = 'day')
year <- as.POSIXlt(all_days)$year + 1900
urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')

destdir <- "~//BigData/"
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




#downloading files

start <- as.Date('2012-10-01')
today <- as.Date('2014-05-09')

all_days <- seq(start, today, by = 'day')

year <- as.POSIXlt(all_days)$year + 1900
urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')

temp_dir<-destdir <- "~//BigData"
require(R.utils)
for (i in seq_along(urls)) {
   gzpath <- paste(temp_dir, "/", all_days[i], ".csv.gz", sep="")
csvpath <- paste(temp_dir,"/", all_days[i], ".csv", sep="")
csvpath2 <- paste(temp_dir,"/", all_days[i], "_new.csv", sep="")

if (!file.exists(gzpath) & !file.exists(csvpath)) {
download.file(urls[i], destfile=gzpath)
gunzip(gzpath, remove=TRUE)
} else {
if (file.exists(gzpath) & !file.exists(csvpath)) {
gunzip(gzpath, remove=TRUE)
}
}

write.csv2(read.csv2(csvpath, sep=","), csvpath2)
}



#merging files

filenames <- paste0(temp_dir,"/", all_days, '_new.csv')
dane <- do.call("rbind", lapply(filenames, read.csv2, header = TRUE))
dane <- dane[,-1]
rownames(dane) <- NULL
write.csv2(dane, file=paste(temp_dir, "/dane.csv", sep=""))
read.csv2(file=paste(temp_dir, "/dane.csv", sep=""))[1,]
