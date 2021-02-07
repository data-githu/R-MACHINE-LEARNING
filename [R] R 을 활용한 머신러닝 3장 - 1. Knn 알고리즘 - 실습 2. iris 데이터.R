■ R 을 활용한 머신러닝 3장 - 1. Knn 알고리즘 - 실습 2. iris 데이터

# 데이터 확인
head( iris )
nrow(iris)
unique(iris$Species)

문제187. 아이리스의 종, 아이리스 종별 건수를 출력하시오!
table(iris$Species)

setosa versicolor  virginica 
50         50         50 

문제188. createDataPartition 함수를 이용해서 아이리스 데이터를 훈련 데이터와 테스트 데이터로 나누시오! 훈련 80% 테스트 20%
iris <-  read.csv("iris(150).csv", header=T,  stringsAsFactors=FALSE)
library(caret)
train_num <- createDataPartition(iris$Species, p=0.8, list=F)
train_data <- iris[train_num,]
test_data <- iris[-train_num,] # train_num 에 있는 숫자 빼고 다른 숫자
nrow(train_data) # 120
nrow(test_data) # 30

table(iris$Species) # 각 50

table(train_data$Species) # 각 40
table(test_data$Species)  # 각 10

문제189. 위의 훈련데이터와 테스트데이터를 바로 오스트리아 빈대학교에서 만든 knn 함수에 입력하여 테스트 데이터의 라벨을 예측하고 이원교차표를 출력하시오!
# iris 테이블 파악
head( iris )
nrow(iris)
unique(iris$Species)

# 정규화
normalize <- function(x) {
  return ( (x-min(x)) / (max(x) - min(x)) )
}

iris2 <- as.data.frame(lapply(iris[1:4],normalize))
iris2


# 셔플
set.seed(62)
iris_shuffle <- iris[sample(nrow(iris2)),]
iris_shuffle

# 테스트 와 트레인 셋 구분 caret 이용
library(caret)
train_num <- createDataPartition( iris_shuffle$Species, p=0.8, list=F)
str(train_num)
train_data <- iris2[train_num,]
test_data <- iris2[ -train_num,]
nrow(train_data)
nrow(test_data)


table(train_data$Species)
table(test_data$Species)
train_data$Species

# 라벨 지정 ( 정규화 되기전의 것을 이용한다.)
iris_train_label <- iris[train_num,5]
iris_test_label <- iris[-train_num,5]
iris_test_label

# class 를 이용한 knn

library(class)
result1 <- knn(train=train_data, test=test_data, cl=iris_train_label, k=7)

# ※ 주의사항 : knn 함수 실행시 train = 훈련 데이터 프레임명, test = 테스트 데이터 프레임명을 기술할 때 그 데이터 프레임에 전부 숫자만 있어야 합니다.

# 결과 확인
x <- data.frame('실제'=iris_test_label, '예측'=result1)
table(x)


#이원분석표
library(gmodels)
g2 <- CrossTable(x=iris_test_label, y=result1 )
g2$prop.tbl
print( g2$prop.tb[1] + g2$prop.tb[5] + g2$prop.tb[9] ) # 정확도