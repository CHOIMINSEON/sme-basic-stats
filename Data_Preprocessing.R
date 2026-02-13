library(dplyr) 

setwd("D:/RECEIVE_FILES/2022/03/05/SBCS_EXTFILE_2373_1_20220305") 
annual19<-read.table("sbcsExtr_0000002373_1_20220305_00280_21.txt", header=T, sep='\t') 
#해당 열 결합 
annual19.2 <- annual19[,c(19:24, 28, 29, 38, 39, 42,43,56)] 
#문자형 변수로 변환 
annual19.2$NS2 <- as.character(annual19.2$NS2) 
firm <-annual19.2 %>%  
  filter(NS2 %in% c("S1","S2")) 

#숫자형 변수로 변환 
firm$BR_EMP_MF_T<- as.numeric(firm$BR_EMP_MF_T) 
firm$BR_GI_EMP_MF_T<- as.numeric(firm$BR_GI_EMP_MF_T) 
firm$BR_EMP_MF_T 

#그룹별로 요약하기  
df<-firm %>%  
  group_by(ZONE_CD) %>%  
  summarise(sum_b_sales = sum(BR_AMTC), 
            sum_b_employee= sum(BR_EMP_MF_T), 
            sum_b_number= sum(GI_CNT), 
            sum_e_sales= sum(BR_GI_SUMAMT), 
            sum_e_employee= sum(BR_GI_EMP_MF_T), 
            sum_e_number= sum(BR_GI)) 

#csv 파일 저장 
write.csv(df, "D:/TAKE_OUT_FILES/df.csv")