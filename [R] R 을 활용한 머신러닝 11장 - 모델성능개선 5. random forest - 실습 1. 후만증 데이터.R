■ R 을 활용한 머신러닝 11장 - 모델성능개선 5. random forest - 실습 1. 후만증 데이터

실습 : kyphosis(후만증)은 척추의 비정상적으로 과도한 볼록 곡률입니다. 

후만증 데이터 프레임에는 81 개의 행과 4 개의 열이 있습니다. 

척추 교정 수술을받은 어린이에 대한 데이터를 나타냅니다. 데이터 세트는 3 개의 입력과 1 개의 출력을 포함합니다.

데이터로서 독립변수가 나이(개월수)와 관련된 척추의 수 그리고 수술 된 첫 번째 (최상위) 척추의 수이다.

데이터가 81개 밖에 안되므로 데이터를 전부 의사 결정트리에 넣어서 예측과 실제 라벨을 비교해서 정확도를 봅니다.


# 0. 필요한 패키지를 다운로드 합니다. 
install.packages("rpart")
install.packages("rattle")
install.packages("randomForest")


# 1. 데이터를 로드한다.
kyphosis <- read.csv("kyphosis.csv", stringsAsFactors = TRUE)

# 2. rpart 를 이용해서 의사 결정트리 모델을 생성한다.
library(rpart)
fit <- rpart(kyphosis ~ age + number + start,method="class", data=kyphosis)

# 3. 모델을 시각화 한다.
library(rattle)
library(rpart.plot)

fancyRpartPlot(fit)

# 4. 정확도를 확인한다.
result <- predict(fit , newdata = kyphosis)
sum(kyphosis$kyphosis == ifelse(result[,1]>0.5 , "absent" , "present"))/NROW(kyphosis) # [1] 0.8395062


# 이 수치를 높이기 위해서  random forest 를 사용한다.

# 1. 랜덤 포레스트 모델을 만든다.
library(randomForest)
fit <- randomForest(kyphosis ~ age + number + start,   data=kyphosis)
res2 <- predict(fit , newdata = kyphosis)
sum(res2 == kyphosis$kyphosis)/NROW(kyphosis) # 0.8395062

# str(fit)

문제1. 척추 데이터의 랜덤포레스트 모델을 다시 생성해서 성능을 개선하시오.
# 1. 랜덤 포레스트 모델을 만든다.
library(randomForest)
fit <- randomForest(kyphosis ~ age + number + start,   data=kyphosis, mtry=5)
res2 <- predict(fit , newdata = kyphosis)
sum(res2 == kyphosis$kyphosis)/NROW(kyphosis) # [1] 1

# str(fit)
