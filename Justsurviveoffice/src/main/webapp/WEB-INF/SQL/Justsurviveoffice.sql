show user;

select *
from tab;

create table tbl_rdg7203(
username varchar2(30),
userseq number);

create table spring_test
(no         number
,name       varchar2(100)
,writeday   date default sysdate
);

commit;

select *
from spring_test;

insert into spring_test(no, name)
values(1, 'aaa');

--------
select *
from tbl_member;

INSERT INTO tbl_member(user_id, user_name, user_pwd, gender, reg_date) VALUES ('leess', '이순신', 'qwer1234$', 1, DEFAULT);

commit;

select *
from category;

select *
from question;

select *
from options;

/*
    설문 데이터 가져오기
    questionno    questioncontent    optionno    optiontext  fk_categoryno
*/

SELECT questionno, questioncontent, optionno, optiontext, fk_categoryno
FROM question Q JOIN options O
ON Q.questionno = O.fk_questionno
ORDER BY questionno, fk_categoryno;









