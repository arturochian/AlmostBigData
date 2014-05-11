

t1<-Sys.time()


start <- as.Date('2012-10-01')
today <- as.Date('2014-05-09')

all_days <- seq(start, today, by = 'day')

temp_dir<-destdir <- "~//BigData"
urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')


max_id<-0


for (i in seq_along(urls)) {

   csvpath <- paste(temp_dir,"/", all_days[i], ".csv", sep="")
   csvpath2 <- paste(temp_dir,"/", all_days[i], "_newf.csv", sep="")
   
   r<-read.csv2(csvpath, sep=",")
  r[,10]<-r[,10]+max_id
  max_id<-max(r[10])
  
   write.csv2(r, csvpath2)
}

# merge
t1<-Sys.time()
filenames <- paste0(temp_dir,"/", all_days, '_newf.csv')
if(file.exists(paste(temp_dir, "/dane.csv", sep=""))) file.remove(paste(temp_dir, "/dane.csv", sep=""))
for (i in 1:length(filenames)) {
dane<-read.csv2(filenames[i])
dane<-dane[c(-1)]

write.table(dane,file=paste(temp_dir, "/dane.csv", sep=""),append=TRUE,dec=",",sep=';',qmethod='double',col.names=FALSE,row.names=FALSE)
}


t2<-Sys.time()
t2-t1
#Time difference of 26.58059 mins




#Statystyka

options(stringsAsFactors = FALSE)
temp_dir<-destdir <- "~//BigData"
fname<-paste(temp_dir, "/dane.csv", sep="")

nazwy<-vector("character")


t1<-Sys.time()

skipy<-0
nrowsy<-2000000
nazwy<-character(0)
arch<-character(0)
r_os<-character(0)
#nazwy

ileLinijek<-0

   while(class(
      try({d<-read.csv2(fname,skip=skipy,nrows=nrowsy)},silent=TRUE)
   )
   !="try-error"  )
   { 
       nazwy<-union(d[,7],nazwy)
         arch<-union(d[,5],arch)
         r_os<-union(d[,6],r_os)
      ileLinijek<-ileLinijek+length(d[,1])
      skipy<-skipy+nrowsy
   }
   

nazwy<-na.omit(nazwy)
arch<-na.omit(arch)
r_os<-na.omit(r_os)
n<-length(nazwy)
a<-length(arch)
r<-length(r_os)
a_r<-data.frame(matrix(0,nrow=a,ncol=r))
rownames(a_r)<-arch
names(a_r)<-r_os


pakiety<-data.frame(rep( 0 ,length.out=n),row.names=nazwy)
names(pakiety)<-"Krotnosci"


t2<-Sys.time()
cat("Nazwy zajely:")
t2-t1




t1<-Sys.time()
skipy<-0
nrowsy<-2000000
#krotnosci
while(class(
   try({d<-read.csv2(fname,skip=skipy,nrows=nrowsy)},silent=TRUE)
)
!="try-error"  )
{ 
         un<-unique(d[,10])
         un<-na.omit(un)
         for (i in 1:length(un))
         {
            s<-(d[d[,10]==un[i],][1,])
            aa<-s[1,6]
            rr<-s[1,5]
            if (!is.na(aa) & !is.na(rr))a_r[rr,aa]<-a_r[rr,aa]+1
         }
         
#          for (j in 1:length(d[,1]) )
#                {if (!is.na(d[j,7]))pakiety[(d[j,7]),]<-pakiety[(d[j,7]),]+1}
               
         
        skipy<-skipy+nrowsy
        cat(c("Zrobione:",skipy," linijek."))
      }
    
t2<-Sys.time()
t2-t1

pakiety['stringi',]

write.csv2(pakiety,paste(temp_dir, "/pakiety.csv", sep=""))
sort(pakiety[,1])
