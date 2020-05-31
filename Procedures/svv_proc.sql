use SVV_MyBase;
go
----------
create procedure PCRISIS @p real
as begin
	update КРЕДИТЫ set Ставка = Ставка - @p
	select * from КРЕДИТЫ
end
go
--drop procedure PCRISIS
---
exec PCRISIS @p = 0.1

--------------
create table #TELEPHONES (telephone nvarchar(20))
go
create procedure PPHONES
as begin
	select Телефон from КЛИЕНТЫ
end
go
---
insert #TELEPHONES exec PPHONES
select * from #TELEPHONES
--drop table #TELEPHONES
--drop procedure PPHONES