#install.packages("R.utils")
require(R.utils)


#### downloading files ####

start <- as.Date('2012-10-01')
today <- as.Date('2012-12-31')

all_days <- seq(start, today, by = 'day')

year <- as.POSIXlt(all_days)$year + 1900
urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')

dir <- "D:\\Artur\\AlmostBigData"

for (i in seq_along(urls)) {
   gzpath <- paste(dir,"\\", all_days[i], ".csv.gz", sep="")
   csvpath <- paste(dir,"\\", all_days[i], ".csv", sep="")
   
   if (!file.exists(gzpath) & !file.exists(csvpath)) {
      download.file(urls[i], destfile=gzpath)
      gunzip(gzpath, remove=TRUE)
   } else {
     if (file.exists(gzpath) & !file.exists(csvpath)) {
           gunzip(gzpath, remove=TRUE)
     }
   }
   
   write.csv2(read.csv2(csvpath, sep=","), csvpath)
}


#### merging files ####
filenames <- paste0(dir,"\\", all_days, '.csv')
dane <- do.call("rbind", lapply(filenames, read.csv2, header = TRUE))
dane <- dane[,-1]
rownames(dane) <- NULL 
write.csv2(dane, file=paste(dir, "\\dane.csv", sep=""), row.names = FALSE)
write.csv2(dane, file=paste("D:\\Artur\\Dokumenty\\studia\\sem 10\\PRZ\\dane.csv", sep=""), row.names = FALSE)



#### updating files ####
# as.Date("2012-10-10")Sys.Date()-1
missing_days <- setdiff(paste0(as.character(seq(start, Sys.Date()-1, by = 'day')), ".csv"),
                        list.files(dir))
year <- as.POSIXlt(missing_days)$year + 1900
urls <- paste0("http://cran-logs.rstudio.com/", year, "/", missing_days, ".gz")

for(i in 1:length(missing_days)) {
   gzpath <- paste(dir,"\\",missing_days[i], ".gz", sep="")
   csvpath <- paste(dir,"\\", missing_days[i], sep="")
   
   download.file(urls[i], destfile=gzpath)
   gunzip(gzpath, remove=TRUE)
   write.csv2(read.csv2(csvpath, sep=","), csvpath)
}


filenames <- paste0(dir,"\\", missing_days)
dane_n <- do.call("rbind", lapply(filenames, read.csv2, header = TRUE))
dane_n <- dane_n[,-1]
rownames(dane_n) <- NULL 
write.csv2(dane_n, file=paste(dir, "\\dane_n.csv", sep=""), row.names = FALSE)
dane <- do.call("rbind", lapply(c(paste(dir, "\\dane.csv", sep=""),
                                  paste(dir, "\\dane_n.csv", sep="")), read.csv2, header = TRUE))
write.csv2(dane, file=paste(dir, "\\dane.csv", sep=""), row.names = FALSE)
write.csv2(dane, file=paste("D:\\Artur\\Dokumenty\\studia\\sem 10\\PRZ\\dane.csv", sep=""), row.names = FALSE)
file.remove(paste(dir, "\\dane_n.csv", sep=""))
