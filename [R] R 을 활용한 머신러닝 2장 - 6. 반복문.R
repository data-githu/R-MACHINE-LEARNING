■  R 을 활용한 머신러닝 2장 - 6. 반복문

1) R 에서의 if 문 사용법

문법:
if(조건식){
  조건식이 True일 때 실행되는 식
}
else if(조건식){
  조건식이 True일 때실행되는 식
}
else{
  위의 조건식들에 만족하지 않는 경우 실행되는 식
}

예제1:if문을 이용해서 피타고라스의 직각 삼각형 여부를 구현하시오!

triangle <- function(){
  low<-as.integer(readline(prompt='밑변의 길이:'))
  high<-as.integer(readline(prompt='높이의 길이:'))
  sli<-as.integer(readline(prompt='빗변의 길이:'))
  
  if(low^2 + high^2 == sli^2) {print('직각삼각형이 맞습니다.')}
  else {print('직각삼각형이 아닙니다')}
}

triangle()
  
  
2)  R에서의 loop 문 사용법
문법 : for (루프변수 in 반복할 리스트) {반복할 실행문}
예제1: for (i in 1:10) {print(i)}
예제2: 위의 for 문을 함수로 만들어서 실행하시오!
aaa <- function(x) { for (i in 1:x) 
{print(i)} 
}

aaa(10)

예제3. 별을 3개 출력하시오!
rep('★',3)

  

문제174. 아래와 같이 별이 출력되는 함수를 생성하시오!
> star(5)
[1] "★"
[1] "★" "★"
[1] "★" "★" "★"
[1] "★" "★" "★" "★"
[1] "★" "★" "★" "★" "★"


> star <- function(x) {for (i in 1:x) {print(rep('★',i))}}
> star(5)
  