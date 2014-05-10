
#First download:

start <- as.Date('2012-10-01')
today <- as.Date('2014-05-10')
all_days <- seq(start, today, by = 'day')
year <- as.POSIXlt(all_days)$year + 1900
urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')

destdir <- "D:/BigData/"
destdir <- "D:/bd1/AlmostBigData/cran-logs/"
n <- length(urls)
i=1
for(i in 1:n){
   destfile <- stri_paste(destdir,as.character(all_days[i]))
   download.file(urls[i],destfile)
}
###################################
###################################
###################################
###################################

lok <- "D:/bd1/AlmostBigData"
gzpath <- character(n)
i <-1
for (i in 1:n){
   gzpath[i] <- paste(lok, "/cran-logs", all_days[i], sep="")
}
install.packages("R.utils")
library(R.utils)
for (i in 1:n){
   gunzip(gzpath[i], destname=paste(gzpath[i],".csv"),remove=TRUE)
}
?gunzip


for (i in 1:n){
write.csv2(read.csv2(paste(gzpath[i],".csv"), sep=","), paste(gzpath[i],"_new.csv"))
}

### hoho ho ahtung !

#filenames <- paste0(lok,"/cran-logs", all_days, " _new.csv")
#filenames <- filenames[-587]
#dane <- do.call("rbind", lapply(filenames, read.csv2, header = TRUE))
#dane <- dane[,-1]
#rownames(dane) <- NULL 
#write.csv2(dane, file=paste(temp_dir, "\dane.csv", sep=""))

##

lok2 <- "D:/bd1/AlmostBigData"

filenames <- paste0(lok2,"/cran-logs", all_days, " _new.csv")
filenames <- filenames[-587]

nazw <- character(586)
for ( i in 1:586){
nazw[i] <- paste0("proc import datafile='", filenames[i], "'\n", 
      "out=CR.cran",i, " dbms=csv replace;
      delimiter = ';';
      getnames=yes; 
      run;\n")
}
cat(nazw)

write.table(nazw,"D:/bd1/AlmostBigData/SAS.txt", sep="\t", quote=FALSE,row.names = FALSE,
            col.names = FALSE )
?write.table

to <- character(586)
for (i in 1:586){
   to[i] <- paste0("CR.cran",i,",")
}
to
write.table(to,"D:/bd1/AlmostBigData/merge.txt", sep="\t", quote=FALSE,row.names = FALSE,
            col.names = FALSE  )
