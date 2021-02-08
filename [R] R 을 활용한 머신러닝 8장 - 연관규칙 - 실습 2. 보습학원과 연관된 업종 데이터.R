■ R 을 활용한 머신러닝 8장 - 연관규칙 - 실습 2. 보습학원과 연관된 업종

건물상가에 서로 연관이 있는 업종이 무엇인가 ?
건물에 병원이 있으면 약국이 있는가 ?  
  
보습학원이 있는 건물에는 어떤 업종의 매장이 연관되어 있는지 분석하는 실습 

1. 데이터를 로드합니다.
build <- read.csv("building.csv" , header = T)
View(build)

2. na 를 0 으로 변경합니다. 
build[is.na(build)] <- 0  
build

3. 필요한 변수만 선별합니다.
build <- build[-1]   # 건물번호를 제외시킵니다. 
build 

4. 연관규칙 패키지를 다운로드 받습니다. 
install.packages("arules")
library(arules) 

5. 연관규칙 모델을 생성합니다.
trans <- as.matrix(build , "Transaction") # 행렬로 변환합니다. 
View(trans)


#설명: 지지도 0.2 이상이고 신뢰도 0.6 이상인 규칙
rules1 <- apriori(trans , parameter = list(supp=0.2 , conf = 0.6 , target = "rules"))
rules1 


6. 연관규칙을 확인합니다. 
inspect(sort(rules1))

7. 시각화를 합니다. 
# 여러 규칙들 중에서 보습학원부분만 따로 검색 
rules2 <- subset(rules1 , subset = lhs %pin% '보습학원' & confidence > 0.7)

# 설명: subset 함수는 전체 규칙에서 일부 규칙만 검색하는 함수 입니다. 

inspect(sort(rules2)) 

# 여러 규칙들 중에서 편의점에 연관된 부분만 따로 검색
rules3 <- subset(rules1 , subset = rhs %pin% '편의점' & confidence > 0.7)
rules3
inspect(sort(rules3)) 

#visualization

b2 <- t(as.matrix(build)) %*% as.matrix(build)   # 희소행렬로 변경합니다. 

install.packages("sna")
install.packages("rgl")
library(sna)
library(rgl)

b2.w <- b2 - diag(diag(b2))  # 희소행렬의  대각선을 0으로 변경합니다.
rownames(b2.w) 
colnames(b2.w) 

gplot(b2.w , displaylabel=T , vertex.cex=sqrt(diag(b2)) , vertex.col = "green" , edge.col="blue" , boxed.labels=F , arrowhead.cex = .3 , label.pos = 3 , edge.lwd = b2.w*2) 
