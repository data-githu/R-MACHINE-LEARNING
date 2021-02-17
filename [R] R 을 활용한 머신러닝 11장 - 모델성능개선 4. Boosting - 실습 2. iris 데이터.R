■ R 을 활용한 머신러닝 11장 - 모델성능개선 4. Boosting - 실습 2. iris 데이터

문제1. iris 데이터로 실습해보세요.
#1. 데이터를 로드한다.
#iris <- read.csv("iris(150).csv", stringsAsFactor=TRUE)
data(iris)
str(iris) 

#2. 데이터에 각 컬럼들을 이해한다.
prop.table(table(iris$Species))

#3. 데이터가 명목형 데이터인지 확인해본다.
str(iris)

#4. 데이터를 shuffle 시킨다.
set.seed(31)
iris_shuffle <- iris[ sample( nrow(iris) ),  ]
iris_shuffle
nrow(iris_shuffle)

#5. 데이터를 8 대 2로 나눈다.
train_num <- round( 0.8 * nrow(iris_shuffle), 0) 
iris_train <- iris_shuffle[1:train_num ,  ]
iris_train
iris_test  <- iris_shuffle[(train_num+1) : nrow(iris_shuffle),  ]
iris_test
nrow(iris_train) # 120
nrow(iris_test) # 30

#6. 부스팅으로 성능 높이기 
#install.packages("adabag")
library(adabag)
set.seed(300) # 데이터를 복원추출하기 때문에 필요하다.

m_adaboost <- boosting( Species ~ . , data=iris_train )
p_adaboost <-  predict( m_adaboost,  iris_test )

head(p_adaboost$class)
p_adaboost$confusion
table( p_adaboost$class, iris_test$Species) 

#7. 정확도 확인
library(gmodels)
g <- CrossTable( iris_test$Species, p_adaboost$class )

x <- sum(g$prop.tbl *diag(3))   # 정확도 확인하는 코드
x # 0.9333

문제2. 위의 boosting 모델의 성능을 높이시오.
#1. 데이터를 로드한다.
#iris <- read.csv("iris(150).csv", stringsAsFactor=TRUE)
data(iris)
str(iris) 

#2. 데이터에 각 컬럼들을 이해한다.
prop.table(table(iris$Species))

#3. 데이터가 명목형 데이터인지 확인해본다.
str(iris)

#4. 데이터를 shuffle 시킨다.
set.seed(31)
iris_shuffle <- iris[ sample( nrow(iris) ),  ]
iris_shuffle
nrow(iris_shuffle)

#5. 데이터를 8 대 2로 나눈다.
train_num <- round( 0.8 * nrow(iris_shuffle), 0) 
iris_train <- iris_shuffle[1:train_num ,  ]
iris_train
iris_test  <- iris_shuffle[(train_num+1) : nrow(iris_shuffle),  ]
iris_test
nrow(iris_train) # 120
nrow(iris_test) # 30

#6. 부스팅으로 성능 높이기 
#install.packages("adabag")
library(adabag)
set.seed(300) # 데이터를 복원추출하기 때문에 필요하다.

m_adaboost <- boosting( Species ~ . , data=iris_train, boos=TRUE, mfinal=3)
p_adaboost <-  predict( m_adaboost,  iris_test )

head(p_adaboost$class)
p_adaboost$confusion
table( p_adaboost$class, iris_test$Species) 

#7. 정확도 확인
library(gmodels)
g <- CrossTable( iris_test$Species, p_adaboost$class )

x <- sum(g$prop.tbl *diag(3))   # 정확도 확인하는 코드
x


문제3. 위의 옵션인 boos=TRUE 와 mfinal=3 은 무엇인가요?
boos # 학습이 반복될 때 마다 가중치를 부여할지 말지를 결정하는 옵션
if TRUE (by default), a bootstrap sample of the training set is drawn using the weights for each observation on that iteration. If FALSE, every observation is used with its weights.

mfinal	# 학습 반복 횟수
an integer, the number of iterations for which boosting is run or the number of trees to use. Defaults to mfinal=100 iterations.
