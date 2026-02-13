library(dplyr)
#######연도별 데이터 로드 및 전처리#######
### preprocessing
# 설명: 사업체_매출액, 사업체_총종사자, 기업내 사업체수, 중소기업구분코드, 기업규모, 기업체_매출액, 기업체_종사자
# 고유열: 시도코드, 시군구코드, 행정구역 분류코드, 시도명, 시군구명, 읍면동명, 법정동코드

setwd("D:/RECEIVE_FILES/2022/03/05/SBCS_EXTFILE_2373_1_20220305")
annual19 <- read.table("sbcsExtr_0000002373_1_20220305_00280_21.txt", header=T, sep='\t')
annual19.2 <- annual19[,c(19:24, 28, 29, 38, 39, 42,43,56)]
annual19.2$NS2 <- as.character(annual19.2$NS2)
firm <- annual19.2 %>% 
  filter(NS2 %in% c("S1","S2"))


## 집계 (ex: 행정동별 BR사업체 매출액 합계)
## b: 사업체(Business), e: 기업체(Enterprise)
firm$BR_EMP_MF_T <- as.numeric(firm$BR_EMP_MF_T)
firm$BR_GI_EMP_MF_T <- as.numeric(firm$BR_GI_EMP_MF_T)
firm$BR_EMP_MF_T

df <- firm %>% 
  group_by(ZONE_CD) %>% 
  summarise(sum_b_sales = sum(BR_AMTC),
            sum_b_employee = sum(BR_EMP_MF_T),
            sum_b_number = sum(GI_CNT),
            sum_e_sales = sum(BR_GI_SUMAMT),
            sum_e_employee = sum(BR_GI_EMP_MF_T),
            sum_e_number = sum(BR_GI))

write.csv(df, "D:/TAKE_OUT_FILES/df.csv")
