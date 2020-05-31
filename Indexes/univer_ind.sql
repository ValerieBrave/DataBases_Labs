use SMV_UNIVER;
go
--№1----------------посмотреть все индексы
select* from sys.indexes
---------план запроса до и после создания индекса
create table #MYTEMP (
coun int,
ranint int,
ranstr nvarchar(20)
)

--drop table #MYTEMP

set nocount on
declare @i int = 0
while @i < 1000
begin
insert #MYTEMP(coun, ranint, ranstr)
values (@i, floor(3000* rand()), 'string'+cast(@i as varchar(4)))
set @i = @i + 1
end
go

checkpoint;  --фиксация БД
 DBCC DROPCLEANBUFFERS

select * from #MYTEMP 
where ranint between 1000 and 2500
order by ranint desc

create clustered index  CL on #MYTEMP(ranint asc)
drop index CL on #MYTEMP

--№2------------------------------некластеризованный составной
create table #MYTEMP2 (
coun int,
ranint int
)
set nocount on
declare @i int = 0
while @i < 10000
begin
insert #MYTEMP2(coun, ranint)
values (@i, floor(3000* rand()))
set @i = @i + 1
end
-- drop table #MYTEMP2
go

select * from #MYTEMP2 where ranint between 100 and 900 order by ranint desc
create index nonclu on #MYTEMP2(coun, ranint)
drop index nonclu on #MYTEMP2
select * from #MYTEMP2 where coun = 10
select * from #MYTEMP2 where coun between 10 and 20 and ranint < 2000		--- все равно индекс используется

--№3-------------------------------------некластеризованный индекс покрытия
create table #MYTEMP3 (
coun int,
ranint int,
ranstr nvarchar(20)
)
set nocount on
declare @i int = 0
while @i < 30000
begin
insert #MYTEMP3(coun, ranint, ranstr)
values (@i, floor(3000* rand()), 'string'+cast(@i as varchar(4)))
set @i = @i + 1
end
go
--drop table #MYTEMP3
--индекс покрытия
create index cover_ind on #MYTEMP3(ranint) include (ranstr)
create clustered index clust_ind on #MYTEMP3(ranint)
drop index cover_ind on #MYTEMP3
drop index clust_ind on #MYTEMP3
select ranstr from #MYTEMP3  order by ranstr

--№4---------------------------------------фильтруемый индекс
create table #MYTEMP4 (
coun int,
ranint int,
ranstr nvarchar(20)
)
--drop table #MYTEMP4
set nocount on
declare @i int = 0
while @i < 20000
begin
insert #MYTEMP4(coun, ranint, ranstr)
values (@i, floor(4000* rand()), 'string'+cast(@i as varchar(4)))
set @i = @i + 1
end
go
select coun from #MYTEMP4 where coun between 15000 and 17899
create index filter_ind on #MYTEMP4(coun) where coun > 14000 and coun < 18000 -- будет искать в индексе, иначе сканировать все строки
drop index filter_ind on #MYTEMP4

--№5---------------------------------------фрагментация
use tempdb
create table #MYTEMP5 (
coun int,
ranint int,
ranstr nvarchar(20)
)
--drop table #MYTEMP5
set nocount on
declare @i int = 0
while @i < 15000
begin
insert #MYTEMP5(coun, ranint, ranstr)
values (@i, floor(3500* rand()), 'string'+cast(@i as varchar(4)))
set @i = @i + 1
end
go
create index noncl on #MYTEMP5(ranint)
     INSERT top(10000) #MYTEMP5(coun, ranint, ranstr) select coun, ranint, ranstr from #MYTEMP5
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), 
        OBJECT_ID(N'noncl'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
                                                                                       WHERE name is not null;
--drop index noncl on #MYTEMP5
alter index noncl on #MYTEMP5 reorganize
alter index noncl on #MYTEMP5 rebuild with (online = off)

--№6---------------------------------------------------fillfactor
drop index nonclu on #MYTEMP5
create index nonclu on #MYTEMP5(ranint) with (fillfactor = 65)
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID(N'tempdb'), 
        OBJECT_ID(N'nonclu'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
                                                                                       WHERE name is not null;