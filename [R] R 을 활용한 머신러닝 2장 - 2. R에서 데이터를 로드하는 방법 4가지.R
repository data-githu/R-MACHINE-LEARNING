■ R 을 활용한 머신러닝 2장 - 2. R에서 데이터를 로드하는 방법 4가지

1) csv 파일을 로드하는 방법
예제 : 
setwd("c:\\data")
emp <- read.csv("emp.csv", header=T, stringsAsFactor=T)

설명 : read.csv 함수는 utils 패키지에 내장되어 있는 함수입니다. stringAsFactor=T은 문자형을 Factor형으로 변환하는 옵션입니다.

2) xlsx 파일을 로드하는 방법
예제 :
install.packages("xlsx")
library(xlsx)
dept <- read.xlsx("dept.xls", 1 )
                              ↑ 
                          sheet 번호 

3) text 파일을 로드하는 방법
niv <- readLines("NIV.txt")
niv 

4) database와 R과 연동하는 방법
1. 먼저 오라클에 접속이 되는지 확인한다.

아래처럼 sys 유져로 접속하는 방법

C:\Users\stu>sqlplus "/as sysdba"
C:\Users\stu>sqlplus sys/oracle_4U as sysdba

아래처럼 scott 유져로 접속하는 방법 

C:\Users\stu>sqlplus scott/tiger

2. db 와 연동하기 위해서 필요한 패키지를 설치합니다.
install.packages("DBI")
install.packages("RJDBC")

library("DBI")
library("RJDBC")

driver <-  JDBC("oracle.jdbc.driver.OracleDriver", "ojdbc8.jar")

설명:   오라클과 R 을 연동하려면 ojdbc8.jar 파일이 있어야 합니다.  워킹 디렉토리에  ojdbc8.jar  를 가져다 둡니다. 

3. 도스창을 열고 리스너의 상태를 확인합니다.
C:\Users\stu>lsnrctl status

여기서 확인할 내용을 포트번호와 서비스 이름입니다. 

포트번호: 1522
서비스 이름:  xe

4. 도스창에서 위의 정보로 오라클에 접속이 되는지 확인합니다.

SCOTT  으로 접속하려면 

C:\Users\stu> sqlplus  scott/tiger@127.0.0.1:1522/xe

sys  로 접속하려면 

C:\Users\stu> sqlplus  sys/oracle@127.0.0.1:1522/xe  as  sysdba

5. 아래의 R 명령어로 오라클의 데이터를 쿼리 합니다.

-- scott 인 사람 
oracle_db <- dbConnect( driver, 'jdbc:oracle:thin:@//127.0.0.1:1522/xe', 'scott', 'tiger')

-- sys 인 사람 
oracle_db <- dbConnect( driver, 'jdbc:oracle:thin:@//127.0.0.1:1522/xe', 'sys as sysdba', 'oracle')

--  공통 
emp_query <- 'select * from emp'
emp_data <- dbGetQuery( oracle_db, emp_query)
emp_data


