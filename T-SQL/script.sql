use SVV_MyBase;
--№1-----------------------------------
declare @ch char = 'A',
		@nvch nvarchar(9) = 'Приветули',
		@dtme datetime,
		@tme time,
		@in int,
		@smlin smallint,
		@tinin tinyint,
		@nmrc numeric(12,5)		--12 знаков до запятой, точность 5 знаков
select @ch ch, @nvch nvch, @tme
set @in = 100; set @smlin = 20; set @tinin = 10; set @nmrc = 4444.55555555;
set @dtme = (select Дата_выдачи from СДЕЛКИ where Фирма_клиент like 'Молочный гостинец')
select @dtme dtme
print 'in = '+cast(@in as varchar(10))

--№2-----------------------------------
use SMV_UNIVER;
declare @cap int = (select sum(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM),
		@all_au int, @avg_cap int, @less_avg_au int, @less_percent numeric(7,4)
if @cap > 200
begin
set @all_au = (select count(*) from AUDITORIUM)
set @avg_cap = (select avg(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM)
set @less_avg_au = (select count(*) from AUDITORIUM where AUDITORIUM.AUDITORIUM_CAPACITY < @avg_cap)
set @less_percent = cast(@less_avg_au as numeric(7,4))/cast(@all_au as numeric(7,4)) * 100
print 'Всего аудиторий ' + cast(@all_au as varchar(10))
print 'Средняя вместимость ' + cast(@avg_cap as varchar(10))
print 'Аудиторий с вмест. < сред. ' + cast(@less_avg_au as varchar(10))
print 'Процент ' + cast(@less_percent as varchar(10))
end
else print 'Общая вместимость ' + cast(@cap as varchar(10))

--№3-------------------------------------------------------
print 'обработанных строк '+ cast(@@ROWCOUNT as varchar(20))
print 'версия SQL Server '+ cast(@@VERSION  as varchar(20))
print 'системный идентификатор процесса '+ cast(@@SPID   as varchar(20))
print 'код последней ошибки '+ cast(@@ERROR   as varchar(20))
print 'имя сервера '+ cast(@@SERVERNAME  as varchar(40))
print 'уровень вложенности транзакции '+ cast(@@TRANCOUNT  as varchar(20))
print 'результат считывания строк результирующего набора '+ cast(@@FETCH_STATUS  as varchar(20))
print 'уровень вложенности текущей процедуры '+ cast(@@NESTLEVEL  as varchar(20))

--№4------------------------------------------------------
declare @z numeric(8,2), @t int = 4, @x int = 2
if @t > @x
begin
set @z = cast(power(cast(sin(@t) as numeric(8,2)),2) as numeric(8,2))
end
else if @t < @x
begin
set @z = 4*(@t+@x)
end
else set @z = 1 - exp(@x-2)
select @t t, @x x, @z z

------------------------------------

declare @long_name nvarchar(100) = (select NAME from STUDENT where STUDENT.NAME like '%Силюк%'),
		@shorter_name nvarchar(100),
		@short_name nvarchar(100)
set @shorter_name = replace(@long_name, 'Валерия', 'В.')
set @short_name = replace(@shorter_name, 'Ивановна','И.')
print 'Было - ' +@long_name
print 'Стало - '+@short_name

-----------------------------------
declare @may_stud table (name nvarchar(100), bday date);
insert @may_stud select STUDENT.NAME, STUDENT.BDAY from STUDENT where month(STUDENT.BDAY) like month(GETDATE())+1
select * from @may_stud

-----------------------------------

declare @sybd_ex_gr date
declare @group int = 5;
set @sybd_ex_gr =( select top 1  PROGRESS.PDATE
					from STUDENT inner join PROGRESS on STUDENT.IDSTUDENT like PROGRESS.IDSTUDENT
					where STUDENT.IDGROUP like @group)
select @sybd_ex_gr
select DATEPART(dw, @sybd_ex_gr)

--№7----------------------------------------
go
create table #MYTEMP (
coun int,
ranint int,
ranstr nvarchar(20)
)

set nocount on
declare @i int = 0
while @i < 10
begin
insert #MYTEMP(coun, ranint, ranstr)
values (@i, floor(3000* rand()), 'string'+cast(@i as varchar(2)))
set @i = @i + 1
end

select * from #MYTEMP

--№8---------------------------------------
go
declare @ch1 char = 'A', @ch2 char = 'B', @ch3 char = 'C'
print @ch1
print @ch2
return
print @ch3

--№9--------------------------------------------
go
begin try
insert into PULPIT(PULPIT, PULPIT_NAME, FACULTY)
values ('ПОИТ', 'Программное обеспечение информационных технологий', 'TRY')
end try
begin catch
print ERROR_NUMBER()
print ERROR_MESSAGE()
print ERROR_LINE()
print ERROR_SEVERITY()
print ERROR_STATE()
end catch