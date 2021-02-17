■ R 을 활용한 머신러닝 3장 - Knn 알고리즘 - 실습 2. iris 데이터

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
# 1. 데이터 확인
# head(iris)
# nrow(iris) 
# unique(iris$Species)


# 2. 정규화
normalize <- function(x) {
  return ( (x-min(x)) / (max(x) - min(x))  )
}

iris_n  <- as.data.frame(lapply(iris[2:5],normalize))
head(iris_n) # 정규화 확인


# 3. 테스트데이터 트레인 데이터 나누기
library(caret)
set.seed(1)
train_num <- createDataPartition(iris$Species, p=0.8, list=F)
train_num
test_num <- iris[-train_num,1]
test_num
nrow(train_num)   # 120



# 4. 테스트 데이터와 트레인 데이터 번호 shuffle
train_shuffle <- sample(train_num)
train_shuffle

test_shuffle <- sample(test_num)
test_shuffle


# 5. shuffle 된 번호대로 iris_n 에서 데이터 가져오기
train_data <- iris_n[train_shuffle,]
train_data
nrow(train_data)   # 120

test_data <- iris_n[test_shuffle,]
test_data
nrow(test_data)    # 30


# 6. 원본데이터에서 라벨 설정
iris_train_label <- iris[train_shuffle,6]
# iris
# iris_train_label
iris_test_label <- iris[test_shuffle,6]


# 7. class 를 이용한 knn
library(class)
result1 <- knn(train=train_data, test=test_data,cl=iris_train_label, k=7)
result1

# 8. 결과 확인
x <-  data.frame('실제'=iris_test_label, '예측'=result1)
table(x)


# 9. 이원분석표
library(gmodels)
g2 <-  CrossTable(x=iris_test_label, y=result1 )
sum(g2$prop.tbl*diag(3)) 
