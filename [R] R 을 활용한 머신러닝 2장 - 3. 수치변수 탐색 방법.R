■  R 을 활용한 머신러닝 2장 - 3. 수치변수 탐색 방법

1) summary 함수를 사용한다.
데이터의 각 변수(컬럼)에 대해서  최대, 최소, 평균, 중앙값을 요약해서 보여줍니다.
이 값들을 살펴보면 데이터의 중심이 어떻게 되는지 확인할 수 있습니다.

예:  중고차 가격의 평균값, 중앙값, 최대값, 최소값이 어떻게 되는지 확인

car <-  read.csv("usedcars.csv")
car
summary(car)

결과에 대한 설명 : 
중고차 가격 최소 -  3800 달러( 456만원), 평균 - 12962 달러(천 5백 5십 5만원), 최대 -  21992  달러 ( 2천 6백만원)

2) 이상치가 있는지 확인한다.
이상치를 확인해야하는 이유는 이상치가 있으면 머신러닝 학습시 학습이 잘 안됩니다.
이상치를 제거한 보편적이고 일반적인 데이터로 학습 시키는게 중요합니다. 

install.packages("outliers")
library(outliers)

outlier( car$price )

또 다른 방법

x2 <- boxplot(car$price)
x2$out

[1] 21992 20995  4899  3800

이상치를 포함시켜서 학습을 시켰는데 모델의 정확도가 높지 않다면 이상치를 제거하고 학습을 시켜서 모델의 정확도가 올라가는지 확인해야합니다.

3) 데이터의 편향여부를 확인합니다.
평균값과 중앙값을 비교해서 편향여부를 확인할 수 있습니다.

평균값 > 중앙값 -->  데이터가 오른쪽으로 편향이 됩니다. (이상치의 영향)

평균값 < 중앙값 --> 데이터가 왼쪽으로 편향이 됩니다.


예제:  중고차 가격 데이터의 편향 여부를 확인합니다.

summary(car$price)
Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
3800   10995   13592   12962   14904   21992 

평균값 : 12962    <   중앙값 : 13592 

예제:  중고차의 마일리지(주행거리)의 편향여부를 확인합니다.

summary(car$mileage)
Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
4867   27200   36385   44261   55125  151479 

평균값 :  44261    > 중앙값 : 36385  

설명: 평균값이 중앙값보다 크다면 데이터가 오른쪽으로 편향 되었으므로 이상치가 있는지 확인을 해봐야합니다.

outlier(car$mileage)  # 151479

4) 히스토그램, 산포도 그래프를 확인하여 데이터를 시각화해봅니다.

5) 왜도값과 첨도값을 확인합니다.
- 왜도 : 데이터의 좌우로 기울어짐 정도
왜도값 > 0  :  오른쪽으로 꼬리가 길다
왜도값 < 0 :   왼쪽으로 꼬리가 길다.

- 첨도 : 위아래 뾰족한 정도 
첨도값이 3에 가까울수록 정규분포에 해당하고 3보다 작은 경우는 완만한 곡선 3보다 크면 뾰족한 곡선

가급적 데이터가 정규분포형태를 보여야 학습이 잘 됩니다. 

예제:  중고차의 주행거리의 왜도값을 확인하기 

install.packages("fBasics")
library(fBasics)
skewness( car$mileage) #1.231805

설명 : 왜도값이 > 0 으로 오른쪽으로 꼬리가 긴 경우 입니다. 
평균값 > 중앙값 경우로 이상치가 평균값을 한쪽 방향으로 잡아끄는 경우 입니다. 

6) 산포도 그래프를 사용한다.
두 변수간의 관계를 파악할 때 사용하는 그래프 
특히 두변수간의 관계가 양의 관계인지 음의 관계인지를 파악할 때 유용합니다. 
두 데이터(변량)간의 상관관계 유무를 xy 평면상에 시각적으로 나타내는 그림입니다.

예제:  사원 테이블의 커미션과 월급과의 관계를 산포도 그래프로 그리시오 !
plot ( emp$comm,  emp$sal,  pch=21, col='red', bg='red') 

설명: 그래프를 보면 커미션을 받는 사원들의 월급이 대체적으로 작은 것을 확인할 수 있습니다. 이 사원들의 직업은 SALESMAN 이라서 커미션으로 수익을 올리기 때문이라고 볼 수 있습니다. 

문제166. 중고차의 주행거리가 높으면 중고차의 가격이 낮아지는지 산포도 그래프로 확인하시오 !
plot ( car$mileage,  car$price ,  pch=21, col='blue', bg='blue') 

설명: 주행거리가 높을수록 가격이 낮아지는 음의 상관관계를 보이고 있습니다.

cor( car$mileage,  car$price )  # -0.8061494

설명: 상관관계 그림들 가져다 둡니다.


문제167. 산포도 그래프를 자동화 스크립트에 추가하시오 !
sanpodo <- function() {
  
  fname <- file.choose()
  table <- read.csv(fname, header=T, stringsAsFactor=F )
  
  print(data.table(colnames(table)))
  
  xcol_num <- as.numeric(readline('x축 컬럼 번호: '))
  ycol_num <- as.numeric(readline('y축 컬럼 번호: '))      
  
  xcol <- colnames(table[xcol_num])
  ycol <- colnames(table[ycol_num])
  
  xcol2 <- table[,xcol]
  ycol2 <- table[,ycol]
  
  plot(xcol2,ycol2,
       main=paste(xcol,'과',ycol,'의 산포도 그래프'),,lwd=2,  xlab=xcol,ylab=ycol,col='blue',pch=21,bg='blue')
}
