install.packages("plyr")
install.packages("classInt")
install.packages("spdep")
options(scipen=1000)
#library(plyr)
#library(rgdal)
#library(classInt)
#library(RColorBrewer)
#library(spdep)

################ 지도 시각화 (Visualization) ################
##shp: firm_dong
##value: column name (분석할 컬럼)
firm.groups <- classIntervals(firm_dong$sum_b_sales, 5, style = "jenks")
firm.colors <- findColours(firm.groups, brewer.pal(5, "Reds"))
plot(firm_dong, col = firm.colors, border = NA)

legend.text <- vector()
for (i in 1:(length(firm.groups$brks)-1)) {
  legend.text[i] <-
    paste(as.integer(firm.groups$brks)[i:(i+1)], collapse = " - ")
}
legend("bottomright", fill = attr(firm.colors, "palette"),
       legend = legend.text, border = NA, bg = NA,
       box.col = "gray",cex=0.6)

#moran, hotspot
###shp: firm_dong
##shp: firm_dong
##df: firm, n: 공간가중치(neighbors), value: 분석변수(매출액 등)
################ Global Moran's I (전역적 모란지수) ################

firm_dong@data$area <- area(firm_dong)
firm_dong$value <- firm_dong$sum_b_number / firm_dong$area
nb.queen <- poly2nb(firm_dong, queen = T)
aa <- nb2listw(nb.queen, zero.policy = T)
moran.mc(firm_dong$value, aa, nsim = 99, zero.policy = T) ########error!
firm_dong$sum_b_employee[is.na(firm_dong$sum_b_employee)]<-0
firm_dong$sum_e_employee[is.na(firm_dong$sum_e_employee)]<-0

firm_dong@data[!complete.cases(firm_dong@data),]

################ Local Moran's I (국지적 모란지수) ################
nn <- list()
nn <- firm_dong$value
nn.mr <- localmoran(nn, nb2listw(nb.queen))
nn.groups <- classIntervals(nn.mr[,1], 5, style = "quantile")
nny.colors <- findColours(nn.groups, brewer.pal(5, "PRGn"))
plot(firm_dong, col = nn.colors, border = "gray20", main="Local Moran's I")

### legend
legend.nn_text <- vector()
for (i in 1:(length(nn.groups$brks)-1)) {
  legend.nn_text[i] <-
    paste(round(nn.groups$brks, 2)[i:(i+1)], collapse = " - ")
}
legend("bottomleft", fill = attr(nn.colors, "palette"),
       legend = legend.nn_text, border = NA, box.col = "gray",cex=0.9)

################ Local G (핫스팟 분석) ################
##shp: firm_dong
##df: firm, value: 분석변수
dong.nb <- poly2nb(firm_dong, queen = TRUE)
dong.nblist <- nb2listw(firm_dong@data$value, zero.policy = TRUE )
dong.localG <- localG(firm_dong$value, dong.nblist, zero.policy = TRUE)
hh <- which(dong.localG >= 1.96)
ll <- which(dong.localG <= - 1.96)

plot(dong_area, col = "Grey 90", border = "Grey 50", main="hotspot and cold spot")
plot(dong_area[hh,], col = "red", border = "Grey 50", add = TRUE)
plot(dong_area[ll,], col = "blue", border = "Grey 50", add = TRUE)
legend(2681000, 6501000, fill = c("red", "light gray","blue"), 
       legend = c("Clusters of high values","Clusters of low values"), border = NA, bg = "gray90",cex = 0.6)

# shape파일에 localg 결과 저장 및 내보내기
dong_area <- dong_area %>%
  mutate(dong.localG = dong.localG)

dong_area <- as(dong_area, Class= "Spatial")
writeOGR(dong_area, dsn = "path", layer = 'oalocalg',
         driver = 'ESRI Shapefile')
