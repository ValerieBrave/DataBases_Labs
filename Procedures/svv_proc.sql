use SVV_MyBase;
go
----------
create procedure PCRISIS @p real
as begin
	update ������� set ������ = ������ - @p
	select * from �������
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
	select ������� from �������
end
go
---
insert #TELEPHONES exec PPHONES
select * from #TELEPHONES
--drop table #TELEPHONES
--drop procedure PPHONES