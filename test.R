library(dplyr)

## 자료 불러오기 ####
aa <- read.csv(file.choose())  ## 자료 불러오기
aa

## 특정 값 찾아서 저장
dd <- aa
dd[, 7] <- as.character(dd[, 7]) ## search 위해 문자형벡터로 변환
ff<-dd %>% filter(서비스_업종_코드 %in% c("CS200003","CS200001"))

#bb <- dd[dd[, 7] == "CS200003", ]
#ee <- dd[dd[, 7] == "CS200001", ]
#cc<-bb+ee

##집계
ff %>% 
  group_by(상권_구분_코드) %>% 
  summarise(sum_당월_매출_금액 = sum(당월_매출_금액))

##파일 내보내기
write.csv(ff, file = "C:/Users/yewon/Desktop/aaaaaa/pcroom.csv")
