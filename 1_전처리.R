library(dplyr)
#######?뿰?룄蹂? 肄붾뱶#######
### preprocessing
#?궗?뾽泥?_留ㅼ텧?븸, ?궗?뾽泥?_珥앹쥌?궗?옄, 湲곗뾽?궡 ?궗?뾽泥댁닔, 以묒냼湲곗뾽援щ텇肄붾뱶, 湲곗뾽洹쒕え, 湲곗뾽泥?_留ㅼ텧?븸, 湲곗뾽泥?_醫낆궗?옄, (湲곗뾽泥? 媛쒖닔 留뚮뱾湲?)
#怨좎쑀?뿴:  ?떆?룄肄붾뱶, ?떆援곌뎄肄붾뱶, ?뻾?젙援ъ뿭 遺꾨쪟肄붾뱶, ?떆?룄紐?, ?떆援곌뎄紐?,?쓭硫대룞 紐? 踰뺤젙?룞肄붾뱶

setwd("D:/RECEIVE_FILES/2022/03/05/SBCS_EXTFILE_2373_1_20220305")
annual19<-read.table("sbcsExtr_0000002373_1_20220305_00280_21.txt", header=T, sep='\t')
annual19.2 <- annual19[,c(19:24, 28, 29, 38, 39, 42,43,56)]
annual19.2$NS2 <- as.character(annual19.2$NS2)
firm <-annual19.2 %>% 
  filter(NS2 %in% c("S1","S2"))


##吏묎퀎(ex:?뻾?젙?룞蹂? BR?궗?뾽泥? 留ㅼ텧?븸 ?빀怨?)
##b: ?궗?뾽泥?, e: 湲곗뾽泥?
firm$BR_EMP_MF_T<- as.numeric(firm$BR_EMP_MF_T)
firm$BR_GI_EMP_MF_T<- as.numeric(firm$BR_GI_EMP_MF_T)
firm$BR_EMP_MF_T
df<-firm %>% 
  group_by(ZONE_CD) %>% 
  summarise(sum_b_sales = sum(BR_AMTC),
            sum_b_employee= sum(BR_EMP_MF_T),
            sum_b_number= sum(GI_CNT),
            sum_e_sales= sum(BR_GI_SUMAMT),
            sum_e_employee= sum(BR_GI_EMP_MF_T),
            sum_e_number= sum(BR_GI))
write.csv(df, "D:/TAKE_OUT_FILES/df.csv")
