■ R 을 활용한 머신러닝 11장 - 모델성능개선 5. random forest - 자동튜닝
library(caret)
library(C50)
library(irr)
data(iris)
head(iris)

#0.shuffle 을 먼저 합니다. 
set.seed(123)
iris_shuffle <- sample(1:150, 150)
iris_shuffle
iris2 <- iris[iris_shuffle,]
iris2

set.seed(123)
in_train <- createDataPartition(iris2$Species, p = 0.75, list = FALSE)
iris_train <- iris2[in_train, ] # 훈련 데이터 구성
iris_test <- iris2[-in_train, ] # 테스트 데이터 구성

m <- train( Species~ . , data=iris_train, method="rf" )

# 랜덤포레스트: 의사결정트리 + 앙상블 기법 
m # 튜닝한 결과를 확인할 수 있다.

p <- predict( m , iris_test )
table(p, iris_test$Species)


library(gmodels)
y <- CrossTable(iris_test$Species ,p)
sum(y$prop.tbl * diag(3))
