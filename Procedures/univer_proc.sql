use SMV_UNIVER;
go
--------------#1
create procedure PSUBJECT
as
begin
	declare @c int = (select count(*) from [SUBJECT])
	select * from [SUBJECT]
	return @c
end
------
declare @subs int = 0
exec @subs = PSUBJECT
print 'количество предметов: ' + cast (@subs as varchar(3))
go
------------------#2 изменить PSUBJECT + выходной параметр
alter procedure PSUBJECT @p varchar(20), @c int output
as begin
select * from SUBJECT where PULPIT like @p
set @c = @@rowcount
declare @k int = (select count(*) from [SUBJECT])
return @k
end
go
----
declare @sub int =0, @p varchar(20) , @all int = 0
exec @all = PSUBJECT @p = 'ИСиТ', @c = @sub output
print '@sub = ' + cast(@sub as varchar(5))
print '@all = ' + cast(@all as varchar(5))

------------------------#3 вставка в таблицу выходного набора
create table #SUBJECT
(
	subject char(10) primary key not null,
	subject_name varchar(100),
	pulpit char(20)
)
go
alter procedure PSUBJECT @p varchar(20)
as begin
select * from SUBJECT where PULPIT like @p
end
go
----
insert #SUBJECT exec PSUBJECT @p = 'ИСиТ'	-- если нет выходного параметра, можно делать так
select * from #SUBJECT
drop table #SUBJECT
go
--------------#4 вставка в AUDITORIUM
create procedure PAUDITORIUM_INSERT @a char(20), @t char(10), @c int =0, @n varchar(50) 
as begin
	declare @ret int = 1
	begin try
	insert into AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME)
	values (@a, @t, @c, @n)
	return @ret
	end try
	begin catch
	print error_message()
	set @ret = -1
	return @ret
	end catch
end
go
-----
declare @a char(20) = '523-1', @t char(10) = 'ЛБ-К', @c int = 90, @n varchar(50) = '423-1', @r int =0
exec @r = PAUDITORIUM_INSERT @a, @t, @c,@n
print 'Результат = ' + cast(@r as varchar(2))
--delete AUDITORIUM where AUDITORIUM like '523-1'
go
---------------------#5 Дисциплины на конкретной кафедре
create procedure SUBJECT_REPORT @p char(10)
as begin
	begin try
			declare disciplines cursor local
								for select SUBJECT.SUBJECT 
								from SUBJECT 
								where SUBJECT.PULPIT like @p
		open disciplines;
		if not exists (select SUBJECT.SUBJECT from SUBJECT where SUBJECT.PULPIT like @p)
		raiserror('нет такой кафедры', 11,1);
		declare @dis char(10), @res char(300)='', @ret int = 0
		fetch disciplines into @dis
		while @@fetch_status = 0
			begin
			set @res = rtrim(@dis) + ', ' + @res
			fetch disciplines into @dis
			end
		close disciplines
		select SUBJECT.SUBJECT 
				from SUBJECT 
				where SUBJECT.PULPIT like @p
		set @ret = (select count(*) from (select SUBJECT.SUBJECT from SUBJECT where SUBJECT.PULPIT like @p) as A)
		
		return @ret
	end try
	begin catch
		print 'ошибочка вышла: ' + error_message();
	end catch
end
go
--drop procedure SUBJECT_REPORT
----------------
declare @s int =0
exec @s = SUBJECT_REPORT @p = 'ТНВиОХТ'
print '@s = ' + cast(@s as varchar(3))
go
----------------------#6 процедура в процедуре
create procedure PAUDITORIUM_INSERTX @a char(20), @t char(10), @c int =0, @n varchar(50), @tn varchar(30)
as begin
	declare @ret int, @r int
	begin try
		set transaction isolation level SERIALIZABLE         
		begin tran
			insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
			values (@t, @tn)
			exec @r = PAUDITORIUM_INSERT @a, @t, @c,@n
		commit tran
		set @ret = 1
		return @ret
	end try
	begin catch
		print 'ошибочка вышла: ' + error_message();
		set @ret = -1
		return @ret
	end catch
end
go
---------------
declare @a char(20) = '103-3', @t char(10) = 'ЧК', @c int = 15, @n varchar(50) = '103-3', @tn varchar(30) = 'Чертежный класс',  @r int =0
exec @r = PAUDITORIUM_INSERTX @a, @t, @c,@n, @tn
print 'Результат = ' + cast(@r as varchar(2))