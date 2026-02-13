#라이브러리 설치 library(dplyr), 주로 filter, select, slice 등
library(dplyr)

#setwd() 새로운 경로 지정, getwd() 현재 작업 경로 확인, dir() 작업 경로내 파일명 확인
setwd("D:/RECEIVE_FILES/2022/03/05/SBCS_EXTFILE_2373_1_20220305")
#read.table 구분자로 되어있는 파일을 불러옴,sep = "칼럼구분자" 기본이 공백,:,;,등 , header = "T|F"
annual19<-read.table("sbcsExtr_0000002373_1_20220305_00280_21.txt", header=T, sep='\t')
#열의 각 항목을 c()로 해당 열을 결합
annual19.2 <- annual19[,c(19:24, 28, 29, 38, 39, 42,43,56)]
#문자형으로 속성 변환
annual19.2$NS2 <- as.character(annual19.2$NS2)
#annual19.2에서 열 NS2에서 "S1","S2"를 찾아서 firm에 저장
firm <-annual19.2 %>% 
  filter(NS2 %in% c("S1","S2"))


#as.numeric 숫자형 변수로 변환
firm$BR_EMP_MF_T<- as.numeric(firm$BR_EMP_MF_T)
firm$BR_GI_EMP_MF_T<- as.numeric(firm$BR_GI_EMP_MF_T)
firm$BR_EMP_MF_T
#그룹별로 요약하기 group_by()로 ZONE_CD의 그룹을 묶고 summarise()로 각 ZONE_CD별 해당값의 합 구함.
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
