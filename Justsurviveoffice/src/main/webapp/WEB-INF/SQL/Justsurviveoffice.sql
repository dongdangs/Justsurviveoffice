--------- **** spring 기초 **** --------

show user;
-- USER이(가) "FINAL_ORAUSER2"입니다.
select * from tab;

------------------------------------------------------
-- 1. Users (회원목록)
CREATE TABLE Users (

id VARCHAR2(50),
name VARCHAR2(30) NOT NULL,
password VARCHAR2(50) NOT NULL,
email VARCHAR2(50) NOT NULL,
mobile VARCHAR2(40) NOT NULL,
point NUMBER DEFAULT 0,
fk_categoryNo NUMBER, -- 추후에 추가되는 카테고리 number
registerday DATE DEFAULT SYSDATE,
passwordChanged DATE DEFAULT SYSDATE,
isDormant NUMBER(1) DEFAULT 0 NOT NULL,
isDeleted NUMBER(1) DEFAULT 0 NOT NULL,

constraint pk_Users 
           primary key (id),
constraint fk_User_Category foreign key (fk_categoryNo) 
           references Category(categoryNo) on delete CASCADE,
constraint ck_Users_isDormant 
           CHECK (isDormant in (1, 0)),
constraint ck_Users_isDeleted 
           CHECK (isDeleted in (1, 0))
);
select * from users;
select * from category;
select * from tab;
select * from login_history;
commit;

desc users;
// fk_category 없이 회원가입 시 실행.
insert into users(id, name, password, email, mobile)
       values('admin', '관리자', 'qwer1234$', 'shindonghee2@naver.com', '01064396718');
      
// 테스트를 한 후, 회원가입을 진행하였을 시, fk_category 세팅.
insert into users(id, name, password, email, mobile
                  ,fk_category)
       values(admin, '관리자', 'qwer1234$', 'shindonghee2@naver.com', '01064396718', '1');
                        

-- 2. LoginHistory (로그인 기록)
CREATE TABLE login_history (

loginHistoryNo NUMBER,
fk_id VARCHAR2(50) NOT NULL,
lastLogin DATE DEFAULT SYSDATE NOT NULL,
ip VARCHAR2(45) NOT NULL,

constraint pk_LoginHistory 
           primary key (loginHistoryNo),
constraint fk_LoginHistory_Id 
           foreign key (fk_id) references Users(id) on delete CASCADE
);

CREATE SEQUENCE login_history_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;


-- 3. Question (질문)

CREATE TABLE Question (

questionNo NUMBER NOT NULL,
questionContent VARCHAR2(255) NOT NULL,

constraint PK_Question primary key (questionNo)
);

CREATE SEQUENCE question_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;

-- 4. Options (답변)
CREATE TABLE Options (

optionNo NUMBER NOT NULL,
fk_questionNo NUMBER NOT NULL,
optionText VARCHAR2(200),
fk_categoryNo NUMBER,

constraint pk_Option 
           primary key (optionNo),
constraint fk_Option_Question
           foreign key (fk_questionNo) references Question(questionNo) on delete CASCADE,
constraint fk_Option_Category 
           foreign key (fk_categoryNo) references Category(categoryNo)
);

CREATE SEQUENCE options_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;


-- 5. Category (카테고리)

CREATE TABLE Category (

categoryNo NUMBER NOT NULL,
categoryName VARCHAR2(50) NOT NULL,
categoryDescribe VARCHAR2(200),
categoryImagePath VARCHAR2(255),

constraint pK_Category 
           primary key (categoryNo)
);
--insert into category values(category_seq.nextval, '리더형', '', '');
--delete from category where categoryNo = 1;

CREATE SEQUENCE category_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;
drop sequence category_seq;

--- 6. Tag (태그)
CREATE TABLE Tag (

tagNo NUMBER NOT NULL,
fk_categoryNo NUMBER NOT NULL,
tagName VARCHAR2(50),

constraint pk_Tag
           primary key (tagNo),
constraint fk_Tag_category 
           foreign key (fk_categoryNo) references Category(categoryNo) on delete CASCADE

);

CREATE SEQUENCE tag_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;

select * from users;

select * from login_history;

select * from users B LEFT JOIN login_history H
on B.id = H.fk_id
where B.id = 'chosw';

select * from users where id = 'chosw';


select * from board;






select *
from (
    select 
           row_number() over(
               order by nvl(C.COMMENTCOUNT,0) desc
           ) as RANK,
           B.BOARDNO, 
           B.BOARDNAME, 
           B.FK_CATEGORYNO, 
           nvl(C.COMMENTCOUNT, 0) as COMMENTCOUNT
    from BOARD B
         left join (
            select FK_BOARDNO, 
                   count(*) as COMMENTCOUNT
            from COMMENTS
            group by FK_BOARDNO
         ) C 
         on B.BOARDNO = C.FK_BOARDNO
    where B.CREATEDATBOARD >= ADD_MONTHS(SYSDATE, -1)
) 
where RANK <= 5;


select * from board;

desc board;



select boardno, fk_categoryno, case
    		   	when length(boardName) > 12
    		   		then substr(boardName, 1, 12)
    		   		else boardName
    		   	end as boardName, createdatboard, updatedatboard, readcount, fk_id, boardfilename,
boardfileoriginname, boarddeleted, case
    		   	when length(boardcontent) > 12
    		   		then substr(boardcontent, 1, 12)
    		   		else boardcontent
    		   	end as boardcontent
from board;


select * from comments;


select count(*)
from comments
group by fk_boardNo;


select * from board;

select * from category;


select COALESCE(c.categoryNo, 0) AS categoryNo, 
       COALESCE(c.categoryname, '미분류') AS categoryName, 
       count(*) as cnt,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users), 2) AS percentage
from users U LEFT JOIN category C
ON U.fk_categoryNo = C.categoryNo
group by categoryNo, categoryName;


