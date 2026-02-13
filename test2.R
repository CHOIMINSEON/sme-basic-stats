library(dplyr)

## 자료 불러오기 ####
a <- read.csv(file.choose())  ## 자료 불러오기
a

## S1, S2 찾아서 저장
a[, 80] <- as.character(a[, 80]) ## search 위해 해당 열 문자형벡터로 변환
SBIZ_GRP_CD_filter <-a %>% filter(SBIZ_GRP_CD %in% c("S1","S2"))

##집계(ex:행정동별 BR사업체 매출액 합계)
SBIZ_GRP_CD_filter %>% 
  group_by(ZONE_CD) %>% 
  summarise(sum_BR_AMTC = sum(BR_AMTC))

##행 개수, 열 개수 구하기
nrow(SBIZ_GRP_CD)#행
ncol(SBIZ_GRP_CD)#열

