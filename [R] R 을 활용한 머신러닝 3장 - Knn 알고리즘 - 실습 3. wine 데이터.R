■ R 을 활용한 머신러닝 3장 - Knn 알고리즘 - 실습 3. wine 데이터


문제190. wine 데이터를 R로 불러와서 전체 건수가 몇건인지 확인하시오!
setwd("c:\\data")
wine <- read.csv("wine.csv")
nrow(wine) # 178
summary(wine)

라벨(정답)이 되는 컬럼은 Type 이고 나머지는 다 숫자형 데이터 입니다

문제191. 와인 데이터 분류 모델을 생성해 봅니다.
# 1. wine 테이블 파악
wine <- read.csv("wine.csv")
head( wine )
nrow(wine) # 178
ncol(wine) # 14
unique(wine$Type)

# 2. 정규화
normalize <- function(x) {
  return ( (x-min(x)) / (max(x) - min(x))  )
}

wine2  <- as.data.frame(lapply(wine[2:14],normalize))
wine2

#3. 셔플
set.seed(62)
wine_shuffle <- wine[sample(nrow(wine2)),]
wine_shuffle


# 4. 테스트 와 트레인 셋 구분 caret 이용 (8대 2로 훈련과 테스트를 나눈다)
library(caret)
set.seed(62)
train_num <- createDataPartition( wine_shuffle$Type, p=0.8, list=F)
train_num
train_data <- wine2[train_num,]
test_data <- wine2[ -train_num,]

nrow(train_data) # 144
nrow(test_data)  # 34


# 5. 라벨 지정 ( 정규화 되기전의 것을 이용한다.)
wine_train_label <- wine[train_num, 1]
wine_train_label

wine_test_label <-  wine[-train_num, 1]
wine_test_label

length(wine_train_label)
length(wine_test_label)

table(wine_train_label)
table(wine_test_label)

# 6. class 를 이용한 knn
library(class)
result1 <- knn(train=train_data, test=test_data,   cl=wine_train_label, k=7)
result1

# 7. 결과 확인
x <-  data.frame('실제' = wine_test_label, '예측' = result1)
table(x)

# 8.이원분석표
library(gmodels)
g2 <-  CrossTable(x=wine_test_label, y=result1 )
g2$prop.tbl
print( g2$prop.tb[1] + g2$prop.tb[5] + g2$prop.tb[9] )  # 정확도

