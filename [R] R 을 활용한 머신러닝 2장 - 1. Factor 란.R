■ R 을 활용한 머신러닝 2장 - 1. Factor 란

*R 의 자료구조
1. vector : 같은 데이터 타입을 갖는 1차원 배열구조
2. matrix : 같은 데이터 타입을 갖는 2차원 배열구조
3. array : 같은 데이터 타입을 갖는 다차원 배열구조
4. data.frame : 행과 열로 이루어진 자료구조
5. list : 서로 다른 데이터 구조 (vector, data frame, matrix, array) 인 데이터 타입이 중첩된 구조


*factor란 ?
1) 범주(값의 목록) 를 갖는 vector
범주 변수나 순위 변수를 나타내기 위해 사용하는 특별한 종류의 벡터이다.
예제 : factor = 일반 vector + level

머신러닝 데이터 분석시 factor를 알아야하는 이유?
순위데이터를 모델링하는 머신러닝 알고리즘은 순서 팩터를 기대하기 때문에 팩터를 알아야 합니다.

2) factor() 함수를 통해서 생성

3) factor 는 nominal, ordinal 형식 2가지

4) nominal 은 level 순서의 값이 무의미하며 알파벳 순서로 정의됨 
예 : 
a <- c("middle", "low", "high") # 백터를 생성함 
a
str(a)
  
a2 <- factor(a))
a2
str(a2)

Factor w/ 3 levels "high","low","middle": 3 2 1

설명 : factor는 vector와 다르게 순서라는 개념이 들어가 있는데 위의 a2의 factor의 경우 순서가 알파벳 순서로 abcd 순서로 순서의 개념이 들어가 있습니다.

order(a2, decreasing=F)

a2[order(a2,decreasing =F)]
high low middle
Levels: high low middle

a[order(a,decreasing =F)]
[1] "high"   "low"    "middle"

5) ordinal 은 level 순서의 값을 직접 정의해서 원하는 순서를 정하는것임
우리가 생각하는 low, middle, high 순서로 순서를 부여해서 a3 factor를 구성합니다.

a3 <- factor(a, order=TRUE, level=c("low","middle","high"))
a3
str(a3)

Levels: low < middle < high 

설명 : 이렇게 순서를 부여할 수 있어서 머신러닝 모델 학습시킬때 어떤 것이 높고 낮은지 즉 어떤 것이 좋고 나쁜지 어떤 것이 악성이고 양성인지를 알려주면서 머신러닝 모델을 학습시켜야 학습이 됩니다.


예제:  유방암 데이터의 라벨은 factor 로 줘야합니다.

wisc <-  read.csv("wisc_bc_data.csv", header=T, stringsAsFactor=F )
str(wisc)

설명:  stringsAsFactor=F 는 wisc_bc_data.csv 의 데이터 중에 문자형 데이터를 Factor 로 변환하지 말고 문자형으로 쓰겠다. 그래서 아래와 같이 정답(label) 컬럼인 diagnosis 가  문자형(chr) 입니다.

$ diagnosis        : chr  "B" "B" "B" "B" …

그런데 위와 같이 정답은 factor 로 주지 않고 문자형으로 주면 B 와 M 중에서 뭐가 좋고 뭐가 나쁜지 알 수가 없으므로 아래와 같이 Factor 로 변환해서 머신러닝 모델에게 제공해 줘야 합니다.

wisc <-  read.csv("wisc_bc_data.csv", header=T, stringsAsFactor=T )
str(wisc)

$ diagnosis        : Factor w/ 2 levels "B","M":
  
문제165. 아래의 문자 3개를 factor 로 만드는데 순서를  SEVERE > MODERATE > MILD  이 순서가 되게 만드시오 !  factor 이름은 b 라고 하시오 !
  
  SEVERE      MILD     MODERATE    

a <- c("SEVERE", "MILD", "MODERATE ")
b <- factor(a, order=TRUE, level=c("MILD","MODERATE","SEVERE"))
b
str(b)
