use SMV_UNIVER;
-----№1
go
create view All_Teachers
as select TEACHER_NAME [Имя],
		  GENDER [Пол],
		  PULPIT [Кафедра]
from TEACHER
 go
select * from All_Teachers;
go
 alter view All_Teachers
 as select TEACHER_NAME [Имя],
		  GENDER [Пол],
		  PULPIT [Кафедра],
		  TEACHER [новый столбец]
from TEACHER

go
select * from All_Teachers;

go
drop view All_Teachers;

---№2
go
create view Pulpits_count
as select f.FACULTY [факультет],
		  count(*) [всего кафедр]
from FACULTY f inner join PULPIT p
 on f.FACULTY like p.FACULTY
 group by f.FACULTY
 go
 select * from Pulpits_count;
 go
 drop view Pulpits_count
 
 --№3
 go
 create view LC_auditoriums
 as select a.AUDITORIUM [аудитория],
		   a.AUDITORIUM_NAME [имя],
		   a.AUDITORIUM_TYPE [тип]
from AUDITORIUM a
where a.AUDITORIUM_TYPE like '%ЛК%'
go
select * from LC_auditoriums;
go
drop view LC_auditoriums;

---№4
go
alter view LC_auditoriums
as select  a.AUDITORIUM [аудитория],
		   a.AUDITORIUM_NAME [имя],
		   a.AUDITORIUM_TYPE [тип]
from AUDITORIUM a
where a.AUDITORIUM_TYPE like '%ЛК%' and a.AUDITORIUM_CAPACITY >= 60 with check option;
go
select * from LC_auditoriums;
go
drop view LC_auditoriums
go
alter table AUDITORIUM
add constraint df_capacity
default '000-0' for AUDITORIUM_NAME

go
insert LC_auditoriums values('222-2','222-2', 'ЛК')

--№5
go
create view Disciplines
as select top(50) s.SUBJECT, s.SUBJECT_NAME, s.PULPIT
from SUBJECT s
order by s.SUBJECT_NAME
go
select * from Disciplines
go
drop view Disciplines
--№6
go
alter view Pulpits_count with schemabinding
as select f.FACULTY [факультет],
		  count(*) [всего кафедр]
from dbo.FACULTY f inner join dbo.PULPIT p
 on f.FACULTY like p.FACULTY
 group by f.FACULTY

 go
 drop view Puipits_count

 insert into PULPIT(PULPIT, PULPIT_NAME, FACULTY)
 values ('ДЭиВИ', 'Дизайн электронных и веб-изданий', 'ИТ')