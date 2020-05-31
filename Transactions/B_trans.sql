use SMV_UNIVER
go
------#4 B
begin transaction 
	insert into FACULTY(FACULTY, FACULTY_NAME) values ('СНФ', 'Совершенно новый факультет') -- фантомная стркоа
	-------------t1---------------
	update SUBJECT set SUBJECT = 'БЫДЫ' where SUBJECT like 'БД' --неподтвержденное
	-------------t2---------------
rollback tran

------#5 B
set transaction isolation level READ COMMITTED 
begin transaction
--------------------t1----------------------
update SUBJECT set SUBJECT = 'БЫДЫ' where SUBJECT like 'БД' -- неподтвержденное чтение
--update SUBJECT set SUBJECT = 'БД' where SUBJECT like 'БЫДЫ'
--------------------t2--------------------
--выполнять вместе с коммитом
insert into FACULTY(FACULTY, FACULTY_NAME) values ('СНФ', 'Совершенно новый факультет') --фантомная строка будет
update SUBJECT set SUBJECT = 'ЭкТеор' where SUBJECT like 'ЭТ' -- неповторяющееся чтение
--delete FACULTY where FACULTY like 'СНФ'
--update SUBJECT set SUBJECT = 'ЭТ' where SUBJECT like 'ЭкТеор'
commit tran

-------------#6 B
set transaction isolation level READ COMMITTED 
begin transaction
update SUBJECT set SUBJECT = 'БЫДЫ' where SUBJECT like 'БД' -- неподтвержденное чтение - не будет
----------------
update STUDENT set NAME = 'Смелова В.В.' where NAME like 'Бакунович Алина Олеговна' -- неповторяющееся чтение - не будет
insert into FACULTY(FACULTY, FACULTY_NAME) values ('СНФ', 'Совершенно новый факультет') --фантомная строка будет
commit tran
--delete FACULTY where FACULTY like 'СНФ'
--update STUDENT set NAME = 'Бакунович Алина Олеговна' where NAME like 'Смелова В.В.'
--update SUBJECT set SUBJECT = 'БД' where SUBJECT like 'БЫДЫ'

--------------#7 B
set transaction isolation level READ COMMITTED 
begin transaction
update SUBJECT set SUBJECT = 'БЫДЫ' where SUBJECT like 'БД' -- до коммита - неподтвержденное чтение
---------------------
update STUDENT set NAME = 'Смелова В.В.' where NAME like 'Бакунович Алина Олеговна' -- неповторяющееся чтение - не даст выполнить
insert into FACULTY(FACULTY, FACULTY_NAME) values ('СНФ', 'Совершенно новый факультет') --фантомная строка не даст выполнить
commit tran