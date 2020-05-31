use SMV_UNIVER
go
-----------#1 кол-во студентов на факультете + поменять функцию
create function COUNT_STUDENTS(@faculty char(10)) returns int
as begin
	declare @rc int = 1
	set @rc = (select count(*) from STUDENT inner join GROUPS on STUDENT.IDGROUP like GROUPS.IDGROUP
	where GROUPS.FACULTY like @faculty);
	return @rc
end
go
--drop function dbo.COUNT_STUDENTS
declare @studs int = dbo.COUNT_STUDENTS('ТОВ')
print 'насчитано студентов ' + cast(@studs as varchar(3))
go
---
alter function dbo.COUNT_STUDENTS(@faculty char(10), @prof char(20)) returns int
as begin
declare @rc int = 1
	set @rc = (select count(*) from STUDENT inner join GROUPS on STUDENT.IDGROUP like GROUPS.IDGROUP
	where GROUPS.FACULTY like @faculty and GROUPS.PROFESSION like @prof);
	return @rc
end
go
--
declare @studs int = dbo.COUNT_STUDENTS('ПИМ','1-47 01 01          ')
print 'насчитано студентов специальности 1-47 01 01: ' + cast(@studs as varchar(3))
go
select FACULTY.FACULTY from FACULTY where dbo.COUNT_STUDENTS(FACULTY.FACULTY, default) > 0
------------------#2 Дисциплины на каждой кафедре
create function FSUBJECTS(@p char(20)) returns char(300)
as begin
	declare @sub char(10), @ret char(500)=''
	declare disciplines cursor local 
	for select [SUBJECT].SUBJECT 
	from [SUBJECT] where [SUBJECT].PULPIT like @p
	open disciplines
	fetch disciplines into @sub
	while @@fetch_status = 0
		begin
			set @ret = rtrim(@sub)+ ', ' + @ret
			fetch disciplines into @sub
		end
	close disciplines
	return @ret
end
go
--drop function dbo.FSUBJECTS
---
select PULPIT, dbo.FSUBJECTS(PULPIT) from [SUBJECT] group by PULPIT
go

--------------------#3 
create function FFACPUL(@fac char(10), @pulp char(20)) returns table
as return
select f.FACULTY, p.PULPIT
from FACULTY f left outer join PULPIT p
on f.FACULTY like p.FACULTY
where f.FACULTY like isnull(@fac, f.FACULTY) and
p.PULPIT like isnull(@pulp, p.PULPIT)
go
select * from dbo.FFACPUL(null, null)	-- все кафедры на всех факультетах
select * from dbo.FFACPUL('ИТ', null)	-- все кафедры ИТ
select * from dbo.FFACPUL(null, 'ИСиТ')	-- кафедра ИСиТ
select * from dbo.FFACPUL('ПИМ', 'БФ')	-- одна строка
go
-----------------#4 
create function FCTEACHER(@pulp char(20)) returns int
as begin
	declare @ret int =0
	if @pulp is null
		begin
			set @ret = (select count(*) from TEACHER)
		end
	else 
		begin
			set @ret = (select count(*) from TEACHER where TEACHER.PULPIT like @pulp)
		end
	return @ret
end
go
--drop function dbo.FCTEACHER
---
declare @tchrs int
set @tchrs = dbo.FCTEACHER(null)
print 'Преподавателей насчитано ' + cast(@tchrs as varchar(3))
select PULPIT.PULPIT, dbo.FCTEACHER(PULPIT.PULPIT) from PULPIT
go
---------------#6 переделать функцию
create function COUNT_PULPITS(@fac char(10)) returns int
as begin
	declare @ret int
	set @ret = (select count(*) from PULPIT where FACULTY like @fac)
	return @ret
end
go
create function COUNT_GROUPS(@fac char(10)) returns int
as begin
	declare @ret int
	set @ret = (select count(*) from GROUPS where FACULTY like @fac)
	return @ret
end
go
create function COUNT_PROFESSIONS(@fac char(10)) returns int
as begin
	declare @ret int
	set @ret = (select count(*) from PROFESSION where FACULTY like @fac)
	return @ret
end
go
----------
create function FACULTY_REPORT(@c int) returns @fr table
( [Факультет] char(10), [Количество кафедр] int, [Количество групп]  int, 
[Количество студентов] int, [Количество специальностей] int )
as begin 
	declare cc CURSOR static for select FACULTY from FACULTY 
								 where dbo.COUNT_STUDENTS(FACULTY) > @c; 
	declare @f char(10);
	open cc;  
    fetch cc into @f;
	while @@fetch_status = 0
		begin
	    insert @fr 
		values (@f,  
				dbo.COUNT_PULPITS(@f),
	            dbo.COUNT_GROUPS(@f),   
				dbo.COUNT_STUDENTS(@f),
	            dbo.COUNT_PROFESSIONS(@f)); 
	            fetch cc into @f;  
		end;   
        return; 
end;
go
--drop function dbo.FACULTY_REPORT
----

select * from dbo.FACULTY_REPORT(0)
go