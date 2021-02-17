■ R 을 활용한 머신러닝 3장 - Knn 알고리즘 - 실습 1. 유방암 데이터

1) 1단계 : 데이터 수집 -->  데이터 출처, 데이터 설명
위스콘신 유방암 진단 데이터셋이며 이 데이터를 569개의 암 조직검사예시가 들어있으며, 각 예시는 32개의 특징을 갖는다. 그 특징은 디지털 이미지에 존재하는 세포의 특성을 나타낸다.

반지름 조밀성
질감 오목함
둘레 오목점
넓음 대칭성
매끄러움 프랙탈 차원

지도학습이므로 정답이 있는 라벨 컬럼이 있는데 이 라벨컬럼이 diagnosis 입니다.

라벨:  양성(B), 악성(M)

2) 2단계 : 데이터 탐색 (시각화) --> 결측치, 이상치, 정규분포(히스토그램)을 확인해서 머신러닝 모델이 학습하기 적합한 데이터인지를 확인

① 라벨 컬럼의 데이터 분포 확인
# 양성이 60% , 악성이 40% 정의 비율로 구성

② 이상치 확인
library(outliers)

grubbs.flag <- function(x) {
  outliers <- NULL
  test <- x
  grubbs.result <- grubbs.test(test)
  pv <- grubbs.result$p.value
  while(pv < 0.05) {
    outliers <- c(outliers,as.numeric(strsplit(grubbs.result$alternative," ")[[1]][3]))
    test <- x[!x %in% outliers]
    grubbs.result <- grubbs.test(test)
    pv <- grubbs.result$p.value
  }
  return(data.frame(X=x,Outlier=(x %in% outliers)))
}

wisc <- read.csv("wisc_bc_data.csv")

for (i in 3:length(colnames(wisc))){
  
  a = grubbs.flag(wisc[,colnames(wisc)[i]])
  b = a[a$Outlier==TRUE,"Outlier"]
  print ( paste( colnames(wisc)[i] , '--> ',  length(b) )  )
  
}

[1] "radius_mean -->  3"
[1] "texture_mean -->  1"
[1] "perimeter_mean -->  3"
[1] "area_mean -->  6"
[1] "smoothness_mean -->  1"
[1] "compactness_mean -->  2"
[1] "concavity_mean -->  4"
[1] "points_mean -->  1"
[1] "symmetry_mean -->  2"
[1] "dimension_mean -->  6"
[1] "radius_se -->  7"
[1] "texture_se -->  5"
[1] "perimeter_se -->  14"
[1] "area_se -->  14"
[1] "smoothness_se -->  7"
[1] "compactness_se -->  12"
[1] "concavity_se -->  10"
[1] "points_se -->  6"
[1] "symmetry_se -->  13"
[1] "dimension_se -->  17"
[1] "radius_worst -->  1"
[1] "texture_worst -->  1"
[1] "perimeter_worst -->  1"
[1] "area_worst -->  8"
[1] "smoothness_worst -->  2"
[1] "compactness_worst -->  6"
[1] "concavity_worst -->  3"
[1] "points_worst -->  0"
[1] "symmetry_worst -->  5"
[1] "dimension_worst -->  3"

지금은 이상치 값이 얼마나 있는지 정도 확인하고 나중에 모델의 정확도가 너무 안나오거나 하면 이상치 데이터를 삭제하고 학습시킬 것을 고려해야 합니다. 

③ 결측치 확인
colSums(is.na(wisc))

설명 : 유방암 데이터에는 결측치가 없습니다. 만약 결측치가 많은 데이터가 있다면 결측치를 다른 값으로 치환하거나 삭제를 고려해야합니다.

3) 3단계 : 데이터로 모델 훈련 -> knn 알고리즘 (유클리드 거리계산 공식)으로 모델 생성

① 데이터를 로드한다. 
wbcd <-  read.csv("wisc_bc_data.csv", header=T, stringsAsFactors=FALSE)

②  diagnosis (정답컬럼) 을 factor 로 변환한다. 
wbcd$diagnosis <- factor( wbcd$diagnosis,
                          levels= c("B","M"),
                          labels=c("Benign", "Maliganant") ) 
str(wbcd)


③ 데이터를 shuffle 시킵니다.
# 어떠한 자리에서든 동일하게 shuffle 되게 하려면 어떻게 해야하는가?
set.seed(1)
sample(10) # 1부터 10까지의 숫자를 랜덤으로 섞어서 출력하는 코드
wbcd_shuffle <- wbcd[ sample(569),    ] # 설명:  wbcd[  행,  열 ]
wbcd_shuffle

④ 데이터에서 환자번호 id 컬럼을 제외 시킨다. 
wbcd2 <-  wbcd_shuffle[ , -1 ] 
str(wbcd2) 

⑤ 데이터를 정규화 한다. 
정규화를 왜 해야하는가 ?  단위로 인해서 미치는 영향의 차이가 있지 않게 하기 위해서 모든 값을 0-1 로 변경합니다.

정규화 방법 2가지 :  1.  scale 함수 사용
2.  min/max 함수 사용 ( 머신러닝시에 학습 잘되는 함수)

normalize <-  function(x) {
  return  ( (x-min(x)) / ( max(x) - min(x) ) )
}

wbcd_n <- as.data.frame( lapply( wbcd2[ , 2:31], normalize)  )

설명:  shuffle 시킨 wbcd2 데이터의 2번 컬럼부터 31번째 컬럼까지의 데이터를 normalize 함수에 적용시켜서 데이터를 변환하고 그리고 데이터 프레임으로 구성하시오.

summary(wbcd_n)  # 전부 0~1사이의 데이터로 변환되었는지 확인합니다. 

⑥ 훈련 데이터와 테스트 데이터로 wbcd_n 데이터를 9 대 1 로 나눈다. 
nrow( wbcd_n ) # 569 
train_num <- round( 0.9 * nrow(wbcd_n), 0 )
train_num  # 512 

wbcd_train <- wbcd_n[ 1:train_num,  ]   
wbcd_test  <- wbcd_n[ (train_num+1) : nrow(wbcd_n),  ]  
nrow(wbcd_test)   # 57

설명: 훈련 데이터를 모델을 학습 시키기 위해서 필요한 데이터고 테스트 데이터는 학습된 모델이 잘 학습했는지 테스트하기 위해서 필요한 데이터 입니다. 

데이터 분할을 하는 이유는?
  모델이 주어진 데이터에 대해서만 높은 성능을 보이는 과대적합의 문제를 예방하여 2종 오류인 잘못된 귀무가설을 채택하는 오류를 방하는데 목적이 있습니다.

데이터 분할의 3가지?
1) 훈련용 데이터
2) 검증용 데이터 : 모형의 학습 과정에서 모형이 제대로 학습되었는지 중간에 검증을 실시하고, 과대적합과 과소적합의 발생여부를 확인하여 모형의 튜닝에도 사용한다.

3) 테스트용 데이터


⑦ 훈련데이터 라벨(정답) 을 생성하고  테스트데이터의 라벨(정답)을 생성합니다.
wbcd_train_label <-  wbcd2[ 1:train_num,  1 ] 
wbcd_test_label <- wbcd2[ (train_num+1) : nrow(wbcd_n), 1  ] 
wbcd_test_label



⑧ knn 모델로 훈련시켜서 모델을 만들고 바로 그 모델에 test 데이터를 넣어서 정확도를 확인한다.
install.packages("class")
library(class) 

result1 <- knn(train=wbcd_train, test=wbcd_test,   cl=wbcd_train_label, k=21)

설명:  train= 훈련 데이터, test= 테스트 데이터,  cl= 훈련데이터의 라벨 result1 에 테스트 데이터에 대해서 머신러닝 모델이 알아낸 정답이 들어갑니다.  k 를 21로 줘서 만들었는데 이 숫자의 제일 좋은 숫자는 우리가 알아내야 합니다. 

머신러닝 모델을 학습 시킬때 필요한 파라미터 2가지
1. 파라미터 : 모델 내부에서 확인이 가능한 변수로 데이터를 통해서 산출이 가능한 값. 학습이 되어지면 만들어지는 숫자값
예 : 인공신경망에서의 가중치, 서포트 벡터머신에서의 서포트 벡터, 선형회귀나 로지스틱 회귀분석에서의 결정계수

2. 하이퍼 파라미터 : 모델에서 외적인 요소로 데이터 분석을 통해서 얻어지는 값이 아니 사용자가 직접 설정해주는 값. 경험에 의해서 결정 가능한 값
예 : knn에서의 k 값, 신경망에서의 학습률, 의사결정트리에서의 깊이

knn의 k값을 우리가 직접 알아내야 합니다. 이 유방암 데이터를 잘 분류하는  즉, 이 데이터에 맞는 적절한 k값을 우리가 실험으로 알아내야 합니다.
이러한 k 값을 무엇이라고 하는가?
  "하이퍼 파라미터"

result1  

실제 정답은  wbcd_test_label  입니다.  아래의 코드로 2개를 서로 비교합니다. 

data.frame( result1, wbcd_test_label)
sum( result1 == wbcd_test_label )

문제184. 아래의 결과를 확인하세요.  
x <-  data.frame('실제'=wbcd_test_label, '예측'=result1)
table(x) 

> table(x) 
예측
실제            Benign  Maliganant
Benign           43          0
Maliganant      1         13


문제185. 다음은 분석 모형을 정의할 때 설정하는 것이다. 이를 설명한 것으로 가장 적절한 것은 무엇인가? 
  
*모델 내부에서 확인이 가능한 변수로 데이터를 통해서 산출이 가능한 값이다.
*예측을 수행할 때 모델에 의해 요구되는 값들이다.
*주로 예측자에 의해 수작업으로 측정되지 않는다.

1. 신경망 학습에서의 학습률
2. 파라미터
3. 신경망 학습의 배치사이즈
4. 정규화 파라미터


질문 : 왜 유방암 데이터로 분류하는 테스트에서 왜 knn 알고리즘을 사용?
답변 : 데이터를 확인해보니 라벨컬럼을 빼고는 모두 숫치형 데이터로 구성되어있어서 knn 알고리즘을 사용


※ 데이터를 잘 분할해주는 R 패키지 caret 소개
install.packages("caret")
library(caret)

wbcd <- read.csv("wisc_bc_data.csv")
nrow(wbcd) 
train_num <- createDataPartition( wbcd$diagnosis, p=0.9, list=F)

설명 : 훈련 데이터와 테스트 데이터를 p=0.9 로 했기 때문에 9대 1로 나누는데 wbcd$diagnosis 가 양성과 악성이 있으므로 훈련 데이터에 양성이 다 모여있거나 테스트 데이터에 악성이 다 모여있지 않고 골고루 분포될 수 있도록 나눠주는 것입니다.

훈련(90%) , 테스트(10%)
양성           양성
악성           악성

train_num
train_data <- wbcd[train_num,]
test_data <- wbcd[-train_num,]
nrow(train_data) # 513
nrow(test_data) # 56

table(train_data$diagnosis) #건수
B   M 
322 191 
prop.table(table(train_data$diagnosis)) #비율
B         M 
0.6276803 0.3723197 

table(test_data$diagnosis) #건수
B  M 
35 21 
prop.table(table(test_data$diagnosis)) #비율
B     M 
0.625 0.375 



문제186. seed 값을 설정한 상태에서 모든 자리에서 동일한 결과가 나오도록 유방암 판별 모델을 생성하시오!
# 1. 데이터를 로드합니다.
wbcd <-  read.csv("wisc_bc_data.csv", header=T,  stringsAsFactors=FALSE)

wbcd$diagnosis <- factor(wbcd$diagnosis,
                         levels =c("B","M"),
                         labels = c("Benign","Maliganant"))

# 2. 데이터를 shuffle
set.seed(1)
wbcd_shuffle <- wbcd[sample(nrow(wbcd)), ]

# 3. 환자번호 제외
wbcd2 <- wbcd_shuffle[-1]

# 4. 데이터를 min/max 정규화 (0-1사이의 숫자로 변환)
normalize <- function(x) {
  return ( (x-min(x)) / (max(x) - min(x))  )
}


wbcd_n  <- as.data.frame(lapply(wbcd2[2:31],normalize))

# 5. 훈련데이터와 테스트 데이터를 9대 1로 나눕니다.
train_num<-round(0.9*nrow(wbcd_n),0)
wbcd_train<-wbcd_n[1:train_num,]
wbcd_test<-wbcd_n[(train_num+1):nrow(wbcd_n),]

wbcd_train_label <- wbcd2[1:train_num,1]
wbcd_test_label <- wbcd2[(train_num+1):nrow(wbcd_n),1]

wbcd_test_label 

# 6. 모델을 훈련시켜 테스트 데이터의 라벨을 예측합니다.
library(class) 
set.seed(1)
result1 <- knn(train=wbcd_train, test=wbcd_test,   cl=wbcd_train_label, k=21)

# 7. 테스트 데이터에 대한 실제값과 예측값을 확인합니다.
x <-  data.frame('실제'=wbcd_test_label, '예측'=result1)
table(x) 

설명 : seed 값과 k값은 결국 하이퍼 파라미터 입니다.

4) 4단계:  모델 성능 평가  ---> 이원교차표를 통해서 모델의 정확도를 확인 

*이원교차표로 확인하는 방법
install.packages("gmodels")
library(gmodels)
g2 <- CrossTable(x=wbcd_test_label, y=result1)
print(g2$prop.tb[1] + g2$prop.tb[4]) # 정확도


5단계:  모델 성능 개선  --->  정확도가 제일 좋은 k 값을 알아내기


