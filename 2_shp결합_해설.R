#join with csv and shp
###load shp
###csv: firm
###dong code: ZONE_CD
install.packages("rgdal")
library(rgdal)
install.packages("raster")
library(raster)
setwd("D:/RECEIVE_FILES/2022/03/05/SBCS_EXTFILE_2373_1_20220305/bnd_dong_00_2021_2021")

#shp읽기
dong<-readOGR("bnd_dong_00_2021_2021_2Q.shp",encoding="UTF-8")
names(dong@data)[2]<-"ZONE_CD" ##dong code, ADM_DR_CD -> ZONE_CD

#merge()는 ZONE_CD기준으로 dong, df합침
firm_dong<- merge(dong, df, by = "ZONE_CD") 

#shp 내보내기
writeOGR(firm_dong, dsn = "D:/TAKE_OUT_FILES", layer = 'merge2', layer_options = "ENCODING=UTF-8",
         driver = 'ESRI Shapefile')
