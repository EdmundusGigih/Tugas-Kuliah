install.packages("xml2")
library(xml2)
install.packages("rvest")
library(rvest)
alamatweb<-"https://www.imdb.com/search/title/?release_date=2012-01-01,2013-01-01&count=100"
lamanweb<-read_html(alamatweb)
lamanweb

runtime_data_laman <- html_nodes(lamanweb,'.runtime')
runtime_data_laman
runtime_data <- html_text(runtime_data_laman)
head(runtime_data)

runtime_data <- gsub(" min","",runtime_data)
runtime_data
runtime_data<-as.numeric(runtime_data)
runtime_data
length (runtime_data)


for (i in c(93)){
  a <- runtime_data [1:(i-1)]
  b <- runtime_data [i:length (runtime_data)]
  runtime_data <- append (a, list ("NA"))
  runtime_data <- append (runtime_data, b)
}
length (runtime_data)
runtime_data

write.csv(runtime_data,"./dummy.csv",row.names =FALSE)
#Genre
genre_data_laman<-html_nodes(lamanweb,'.genre')
genre_data_laman
genre_data<-html_text(genre_data_laman)
genre_data
genre_data<-gsub("\n","",genre_data)
genre_data<-gsub("","",genre_data)
genre_data<-gsub(",.*","",genre_data)
genre_data
genre_data<-as.factor(genre_data)
genre_data
head(genre_data)
length(genre_data)

#rating
rating_data_laman<-html_nodes(lamanweb,'.ratings-imdb-rating strong')
rating_data_laman
rating_data<-html_text(rating_data_laman)
rating_data
rating_data<-as.numeric(rating_data)
rating_data
length(rating_data)

#Gross
gross_data_laman<-html_nodes(lamanweb,'.ghost~.text-muted+span')
gross_data<-html_text(gross_data_laman)
gross_data
gross_data<-gsub("M","",gross_data)
gross_data<-substring(gross_data,2,6)
gross_data
length(gross_data)
gross_data <- append(gross_data, "NA", 0)


for (i in c(2,3,5,10,12,13,17,21,22,24,27,37,38,44,46,54,57,59,78,79,84,90,92,93,98,99)){
  
  a<-gross_data[1:(i-1)]
  
  b<-gross_data[i:length(gross_data)]
  
  gross_data<-append(a,list("NA"))
  
  gross_data<-append(gross_data,b)
  
}
length(gross_data)
gross_data <- as.numeric(unlist(gross_data))
length(gross_data)
gross_data
gross_data<-as.numeric(gross_data)
summary(gross_data)


#Kumpulan data film
kumpulan_data_film <-data.frame(Runtime = runtime_data,
                                Genre = genre_data, Rating = rating_data,
                                Gross_Pendapatan = gross_data)
gross_data <- as.numeric(unlist(gross_data))
runtime_data<-as.numeric(runtime_data)
str(kumpulan_data_film)


install.packages ('ggplot2')
library('ggplot2')
qplot(data = kumpulan_data_film,Runtime,fill = Genre,bins = 30)

ggplot(kumpulan_data_film,aes(x=Runtime,y=Gross_Pendapatan))+
  geom_point(aes(size=Rating,col=Genre))  
