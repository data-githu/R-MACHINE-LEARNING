■ R 을 활용한 머신러닝 11장 - 모델성능개선 5. random forest - 실습 2. iris 데이터
#0.필요한 패키지 다운로드
#install.packages('randomForest')
library(randomForest)

#0.shuffle 을 먼저 합니다. 
set.seed(123)
iris_shuffle <- sample(1:150, 150)
iris_shuffle
iris2 <- iris[iris_shuffle,]
iris2

# 1. 훈련 데이터와 테스트 데이터 분리 
set.seed(123)
in_train <- createDataPartition(iris2$Species, p = 0.75, list = FALSE)
iris_train <- iris2[in_train, ] # 훈련 데이터 구성
iris_test <- iris2[-in_train, ] # 테스트 데이터 구성
nrow(iris_train) # 114
nrow(iris_test)  # 36

prop.table(table(iris_train$Species))
prop.table(table(iris_test$Species))

#2. 모델 훈련
forest_m <- randomForest(Species ~ ., data=iris_train)
forest_m   

forest_m$predicted # 학습된 모델을 통한 train data 의 예측값 확인
length(forest_m$predicted)# 114

forest_m$importance        # 각 feature importance(각 불순도 기반 설명변수 중요도) 
forest_m$mtry      # 모델의 mtry 값 확인
forest_m$ntree     # 모델의 ntree 값 확인

# 3. 모델을 통한 예측 

iris_train[10,-5]
iris_train[10,]

new_data <- iris_train[10,-5] + 0.2
new_data

predict(forest_m, newdata = new_data, type = 'class')    # 500개 트리의 다중투표 결과 
iris_train[10,'Species']

# 4. 모델 평가 
# 4-1) test data에 대한 score 확인
prd_v <- predict(forest_m, newdata = iris_test, type = 'class')
sum(prd_v == iris_test$Species) / nrow(iris_test) * 100

# 4-2) train data에 대한 score 확인 
prd_v2 <- predict(forest_m, newdata = iris_train, type = 'class')
sum(prd_v2 == iris_train$Species) / nrow(iris_train) * 100

# 5. 모델 시각화
layout(matrix(c(1,2),nrow=1),width=c(4,1)) 
par(mar=c(5,4,4,0)) # 오른쪽 마진 제거 
plot(forest_m)
par(mar=c(5,0,4,2)) # 왼쪽 마진 제거 
plot(c(0,1),type="n", axes=F, xlab="", ylab="")
legend("top", colnames(forest_m$err.rate),col=1:4,cex=0.8,fill=1:4)


ntree <- c(600,700,800)
mtry <- c(2:4)

param <- data.frame(n=ntree, m=mtry)
param

for (i in param$n) {
  #cat('ntree=', i, '\n')
  for(j in param$m) {
    cat('\n') 
    cat('ntree=', i,'  ',' mtry=',j,'\n')
    model_iris <- randomForest(Species ~ ., data=iris_train, ntree=i, mtry=j,
                               na.action=na.omit)
    print(model_iris)
  }
}
