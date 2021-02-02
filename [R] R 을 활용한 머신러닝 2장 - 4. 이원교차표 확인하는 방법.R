■  R 을 활용한 머신러닝 2장 - 4. 이원교차표 확인하는 방법

두 명목 변수간의 관계를 관찰 하기 위해 이원 교차표를 사용합니다.
교차표는 하나의 변수값이 다른 변수 값에 의해 어떻게 변하는지 관찰할 수 있다는 점에서 산포도와 비슷합니다.

예:  
install.packages("gmodels")
library(gmodels)

두 변수 간의 관계를 확인하는 기존 방법
attach(emp)
tapply( empno,  list(deptno, job) , length, default=0 )

이원 교차표로 확인하는 방법
library(gmodels)
CrossTable( x=emp$deptno, y=emp$job)

※ Crosstable 해석 ?
  
1. 행합계
2. 열합계
3. 표합계에 대한 해당 셀의 상대적 비율을 나타냄
4. 카이제곱 통계 
예: CrossTable( x=emp$deptno, y=emp$job, chisq=TRUE )

문제168.  관계를 관찰할 수 있는 또 다른 척도인 이원 교차표를 이용해서 직업과 월급과의 관계를 관찰하여 직업별로 월급의 차이가 존재하는지 확인하시오 !
  
월급을 2500 을 기준으로 직업별로 각각 월급이 2500 이상인 사원들과 월급이 2500 보다 작은 사원들의 분포를 확인합니다. 

library( data.table )
data.table( emp$sal, emp$sal >= 2500 ) 
emp$sal_tf <-  emp$sal >= 2500
emp 

설명:  emp 테이블에 sal_tf 라는 새로운 컬럼과 데이터를 만들었는데 바로 이 sal_tf 는 기존 데이터로 만든 새로운 파생변수 입니다. 

library(gmodels)
CrossTable( emp$job,  emp$sal_tf ) 

문제169. 중고차의 모델별로 색깔이 보수적인 색깔이 많은지 아닌지를 이원교차표로 확인하시오 !
  
  보수적인 색깔:  Black, Gray, Silver, White 

setwd("c:\\data")
cars <- read.csv("usedcars.csv")

cars$color_tf <-  cars$color %in% c('Black','Gray','Silver','White')
library(gmodels)
CrossTable(cars$model, cars$color_tf)

설명: 총 150대의 차들중에서 99대가 보수적인 색깔을 이루고 있습니다.
