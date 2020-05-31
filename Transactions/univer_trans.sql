use SVV_MyBase;
go
----------------------------#1 неявная транзакция
set nocount on
	if  exists (select * from  SYS.OBJECTS        -- таблица X есть?
	            where OBJECT_ID= object_id(N'DBO.EMPLOYEES') )	            
	drop table EMPLOYEES; 

declare @c int, @flag char = 'c';
SET IMPLICIT_TRANSACTIONS ON
create table EMPLOYEES( id int primary key, name nvarchar(20));
insert into EMPLOYEES (id, name) values(1, 'Peter'), (2, 'Ann'), (3, 'Vasya');
set @c = (select count(*) from EMPLOYEES);
		print 'количество строк в таблице EMPLOYEES: ' + cast( @c as varchar(2));
if @flag = 'c'  commit;                   -- завершение транзакции: фиксация 
else   rollback;                                 -- завершение транзакции: откат  
SET IMPLICIT_TRANSACTIONS  OFF   -- выключ. режим неявной транзакции

if  exists (select * from  SYS.OBJECTS       -- таблица X есть?
	        where OBJECT_ID= object_id(N'DBO.EMPLOYEES') )
	print 'таблица EMPLOYEES есть';  
      else print 'таблицы EMPLOYEES нет'

--------------------------#2 атомарность явной транзакции
begin try
	begin transaction
		update КРЕДИТЫ set Сумма = 300000 where Название_кредита like 'Щедрый'
		insert into КРЕДИТЫ(Название_кредита, Ставка, Сумма) values('Коронавирусный', 9, 100000)
		insert into КРЕДИТЫ(Название_кредита, Ставка, Сумма) values('Модерн', 12, 100000)
	commit 
end try
begin catch
print 'Ошибочка вышла: ' + cast(error_number() as varchar(6)) + '--' + error_message()
if @@trancount > 0 rollback tran
end catch

------------------------------------#3 SAVE TRAN
use SMV_UNIVER
go
declare @point varchar(32)
begin try
	begin transaction
	insert into PULPIT(PULPIT, PULPIT_NAME, FACULTY) values ('ПИ','Программной инженерии','ИТ')
	set @point = 'p1'; save tran @point
	insert into PULPIT(PULPIT, PULPIT_NAME, FACULTY) values ('Какая-то кафедра','у вас странная','да')
	set @point = 'p2'; save tran @point
	delete PULPIT where PULPIT like 'ДЭиВИ'
	set @point = 'p3'; save tran @point
	commit
end try
begin catch
print 'Ошибочка вышла: ' + cast(error_number() as varchar(6)) + '--' + error_message()
print 'Контрольная точка: ' + @point
rollback tran @point
commit tran
end catch
--delete PULPIT where PULPIT like 'ПИ'


----------------------------#4 READ COMMITED VS READ UNCOMMITED
--A						--B в другом файле
set transaction isolation level READ UNCOMMITTED 
begin transaction 
-------------------t1--------------------
select * from FACULTY	--  фантомное чтение - новый факультет
---B меняет БД на БЫДЫ
select * from SUBJECT where SUBJECT.SUBJECT like '%Б%'
--  + неповторяющееся и неподтвержденное чтение - был БД, а станет БЫДЫ
------------------t2----------------------
select * from SUBJECT where SUBJECT.SUBJECT like '%Б%'
commit tran

----------------------------#5 READ COMMITED неповторяющееся и фантомное чтение без неподтвержденного
set transaction isolation level READ COMMITTED 
begin transaction 
select * from [SUBJECT]
------------------t1----------------------
select * from [SUBJECT] --неподтвержденного нет пока нет коммита
select * from FACULTY		-- нет СНФ
 ----------------t2-----------------------
  --- фантомное чтение
 select * from FACULTY		-- есть СНФ => видны фантомные строки
 select * from [SUBJECT] -- увидим БЫДЫ после коммита В и ЭкТеор как неповторяющееся чтение
 commit tran

 ---------------------------#6 REPEATABLE READ - только фантомное
 set transaction isolation level REPEATABLE READ
 begin transaction
 ----------------
 select * from STUDENT where IDSTUDENT like 1080 --не увидим меня
 select * from [SUBJECT] --неподтвержденного нет
 --------
 select * from STUDENT where IDSTUDENT like 1080 -- увидим меня???
 select * from FACULTY -- увидим фантомную строку 
 commit tran

 --------------#7 SERIALIZABLE
 set transaction isolation level SERIALIZABLE
 begin transaction
 --select * from STUDENT where IDSTUDENT like 1080
 select * from FACULTY
 ------
 select * from [SUBJECT] -- не даст посмотреть неподтвержденное изменение
 ------
 select * from STUDENT where IDSTUDENT like 1080 -- не даст посмотреть неповторяющееся
 select * from FACULTY -- не даст посмотреть фантомную строку
 commit tran

 ---------------#8 вложенные транзакции
 begin tran
 insert into FACULTY(FACULTY, FACULTY_NAME) values ('ФДП', 'Факультет для примера')
	 begin tran
		insert into PULPIT(PULPIT, PULPIT_NAME, FACULTY) values ('КДП','Кафедра для примера','ИТ')
	 commit		-- Только для вложенной транзакции
 select * from FACULTY
 select * from PULPIT
 if @@trancount > 0 rollback		--внешний: отменяет внутреннюю транзакцию и внешнюю
 select * from FACULTY
 select * from PULPIT
 --delete FACULTY where FACULTY like 'ФДП'
 --delete PULPIT where PULPIT like 'КДП'

 ----------------
 begin tran
 insert into FACULTY(FACULTY, FACULTY_NAME) values ('ФДП', 'Факультет для примера')
	begin tran
	update SUBJECT set SUBJECT = 'БЫДЫ' where SUBJECT like 'БД'
	rollback		-- внутренний отменяет вложенную и внешнюю

	select * from SUBJECT
	select * from FACULTY


--update SUBJECT set SUBJECT = 'БД' where SUBJECT like 'БЫДЫ'