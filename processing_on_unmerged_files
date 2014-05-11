
library(stringi)
library(utils)
library("R.utils")

start <- as.Date('2012-10-01')
day <- as.Date('2014-05-01')
all_days <- seq(start, day, by = 'day')
year <- as.POSIXlt(all_days)$year + 1900
urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')



#First download:

#Podajemy katalog, do ktorego chcemy sciagac pliki
destdir <- "D:/BigData/"

n <- length(urls)
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

# Creating file list
filelist.gz <- list.files(destdir,pattern="\\d$",full.names=TRUE)
filelist.csv <- list.files(destdir,pattern="u$",full.names=TRUE)
filelist <- filelist.gz[-(1:length(filelist.csv))]

start<-Sys.time()
for(f in filelist){
  gunzip(f,stri_paste(f,'u'),remove=FALSE)
}
end<-Sys.time()
end-start# Dla 570 plikow trwalo to 8,7 min


#Making statistics:

# Data frame for statistics
# one row - one file
 summary <- data.frame("date"=0,"number_of_different_packages"=0,
                       "number_of_different_id"=0,"size"=0,"processing_time"=0,
                       "windows"=0,"linux"=0,"mac"=0)
 filelist.csv <- list.files(destdir,pattern="u$",full.names=TRUE)
 # Creating empty list for counting downloads of each package
 statistics<-list()

 numberofpackages<-0
 k <- 1
start<-Sys.time()
for(f in filelist.csv){
  
  starttime <- Sys.time() 
  
  t <- read.table(f,h=TRUE,sep=",") 
  systems <- c("m"=0,"l"=0,"d"=0)
  n <- nrow(t)
  number_of_different_packages <- 0
  number_of_different_id <- 0
  for(i in 1:n){
    pi <- as.character(t[i,7])
    if(!is.na(pi)){
      if(is.null(statistics[[pi]])){
        numberofpackages <- numberofpackages+1
        statistics[numberofpackages]<-1     
        names(statistics)[numberofpackages] <- pi

      } else {
          statistics[pi] <- statistics[[pi]]+1
      }  
    }
    if(!is.na(t[i,10])){
      if(t[i,10]>number_of_different_id){
        sys <- stri_sub(t[i,6],1,1)
        if(!is.na(sys)){
          systems[sys] <- systems[sys] + 1
          number_of_different_id <- t[i,10]
        }
      }
    }
  }
  endtime <- Sys.time()

  summary[k,1] <- stri_sub(basename(f),1,stri_length(basename(f))-1)
  summary[k,2] <- numberofpackages
  summary[k,3] <- number_of_different_id
  summary[k,4] <- floor(file.info(f)$size/1000)
  summary[k,5] <- endtime-starttime
  summary[k,6] <- systems[1]
  summary[k,7] <- systems[2]
  summary[k,8] <- systems[3] 
  cat(k," ",summary[k,5],"\n")
  k <- k+1
}
end<-Sys.time()
(czas448_576<-end-start)

# Total time of processing (sum of partial times)
alltime<-(czas1_200+czas201_250+czas251_300+czas301_350+czas351_450+czas448_576)/3600 
# 11,5 h 

czasy100_ <- summary[-(1:100),5]
czasy100_[czasy100_<6] <- czasy100_[czasy100_<6]*60

czasy <- c(summary[1:100,5],czasy100_)
sum(summary[1:100,5],czasy100_)/3600 
# 9,3 h  - Time of counting number of downloads packages  

# Residual time :  11,5 - 9,3 = 2,2 h

# Operating Systems percentage:
c(sum(summary[,6]),sum(summary[,7]),sum(summary[,8]))/sum(summary[,6:8])
pie(c(sum(summary[,6]),sum(summary[,7]),sum(summary[,8])),labels=names(summary)[6:8])
# windows: 68%, linux: 15%, mac os: 16%

#Saving to file:
con <- file("C:/Documents and Settings/n/Desktop/statistics.txt","w")
open(con)
nn<-length(statistics)
for(i in 1:nn){
  cat(names(statistics)[i],statistics[[i]],file=con)
  cat("\n",file=con)
}
close(con)

#Saving to file:
nnn<-nrow(summary)
con2 <- file("C:/Documents and Settings/n/Desktop/summary.txt","w")
open(con2)
cat(names(summary)[1],names(summary)[2],names(summary)[3],names(summary)[4],
    names(summary)[5],names(summary)[6],names(summary)[7],names(summary)[8],"\n",file=con2,sep=";")
for(i in 1:nnn){ 
  cat(summary[i,1],summary[i,2],summary[i,3],summary[i,4],summary[i,5],summary[i,6],summary[i,7],summary[i,8],file=con2,sep=";")
  cat("\n",file=con2)
}
close(con2)

# Pretty plots:
require(graphics)
ts.plot(summary[,1], ts(summary[,2]),
        gpars=list(xlab="days", ylab="number of packages"))
ts.plot(summary[,1], ts(summary[,3]),
        gpars=list(xlab="days", ylab="number of users"))
ts.plot(summary[,1], ts(summary[,4]),
        gpars=list(xlab="days", ylab="size of file"))

plot(summary[,4],czasy,xlab="siez [kB]",ylab="time [s]")
lm(czasy~summary[,4])$coef[2]
# 0.013
# It means speed = 130 kB/s

