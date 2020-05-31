use SMV_UNIVER;
go
--#1-------------------���������� ����� �������

declare isit_disciplines cursor global
						for select SUBJECT.SUBJECT 
						from SUBJECT 
						where SUBJECT.PULPIT like '����'
open isit_disciplines;
declare @dis char(10), @res char(300)=''
fetch isit_disciplines into @dis
while @@fetch_status = 0
begin
set @res = rtrim(@dis) + ', ' + @res
fetch isit_disciplines into @dis
end
print @res
close isit_disciplines
deallocate isit_disciplines
go

--#2--------------------������� ���������� �� �����������
-----------------------------����������
declare all_fac cursor global
					for select FACULTY.FACULTY from FACULTY
declare @f char(6)
open all_fac
fetch all_fac into @f
while @@fetch_status = 0
begin
print @f
fetch all_fac into @f
end
close all_fac
--go
--deallocate all_fac
-----------------------------���������
declare all_aud cursor local
				for select a.AUDITORIUM_NAME, ay.AUDITORIUM_TYPENAME
				from AUDITORIUM a inner join AUDITORIUM_TYPE ay
				on a.AUDITORIUM_TYPE like ay.AUDITORIUM_TYPE
declare @name varchar(50), @type varchar(30)
open all_aud
fetch all_aud into @name, @type
while @@fetch_status = 0
begin
print @name + '-' + @type
fetch all_aud into @name, @type
end
close all_aud
go		-------------------------�������� ����������, �� �� ���������
declare @f char(6)
open all_fac
fetch all_fac into @f
while @@fetch_status = 0
begin
print @f
fetch all_fac into @f
end
close all_fac
--
open all_aud
go		--------------------------

--#3---------------------------------������� ������������ �� �������������
---��������� ��� �������
declare pul_stat cursor local static 
								for select PULPIT.PULPIT from PULPIT
								where PULPIT.FACULTY like '��'

open pul_stat
-----------------
insert into PULPIT(PULPIT, PULPIT_NAME, FACULTY)
values ('������', '����������� ����������� � ������������ ��������� ������', '��')
-------------------
declare @pulp char(20)
fetch pul_stat into @pulp
while @@fetch_status = 0                                    
begin 
print @pulp
fetch pul_stat into @pulp
end
close pul_stat
-------
delete PULPIT where PULPIT.PULPIT like '������'
select * from PULPIT where PULPIT.FACULTY like '��'

----������������
declare pul_dyn cursor local dynamic 
								for select PULPIT.PULPIT from PULPIT
								where PULPIT.FACULTY like '��'

open pul_dyn

insert into PULPIT(PULPIT, PULPIT_NAME, FACULTY)
values ('������', '����������� ����������� � ������������ ��������� ������', '��')
--delete PULPIT where PULPIT.PULPIT like '������'
delete PULPIT where PULPIT.PULPIT like '����'

declare @p char(20)
fetch pul_dyn into @p
while @@fetch_status = 0                                    
begin 
print @p
fetch pul_dyn into @p
end
close pul_dyn
go
--#4----------------- SCROLL
declare @rn int, @tc char(10)
declare c_teacher cursor local dynamic scroll
					for select row_number() over(order by TEACHER) RN, TEACHER
					from TEACHER where PULPIT like '����'
open c_teacher
fetch c_teacher into @rn, @tc
print '��������� : ' + cast(@rn as varchar(3))+'['+ rtrim(@tc)+']'
fetch last from c_teacher into @rn, @tc
print '��������� : '+ cast(@rn as varchar(3))+'['+ rtrim(@tc)+']'
fetch first from c_teacher into @rn, @tc
print '������ : '+ cast(@rn as varchar(3))+'['+ rtrim(@tc)+']'
fetch absolute 4 from c_teacher into @rn, @tc
print '4�� � ������ : '+ cast(@rn as varchar(3))+'['+ rtrim(@tc)+']'
fetch absolute -4 from c_teacher into @rn, @tc
print '4�� � ����� : '+ cast(@rn as varchar(3))+'['+ rtrim(@tc)+']'
fetch relative 5 from c_teacher into @rn, @tc
print '� ���. �� 5 ������ : '+ cast(@rn as varchar(3))+'['+ rtrim(@tc)+']'
fetch relative -5 from c_teacher into @rn, @tc
print '� ���. �� 5 ����� : '+ cast(@rn as varchar(3))+'['+ rtrim(@tc)+']'
fetch next from c_teacher into @rn, @tc
print '��������� : '+ cast(@rn as varchar(3))+'['+ rtrim(@tc)+']'
fetch prior from c_teacher into @rn, @tc
print '���������� : '+ cast(@rn as varchar(3))+'['+ rtrim(@tc)+']'
close c_teacher
go

--#5--------------FOR UPDATE
use SVV_MyBase
go
declare credits cursor local dynamic scroll
				for select ��������_�������, ������
				from ������� for update
declare @nm nvarchar(20), @prc real
open credits
fetch credits into @nm, @prc
fetch relative 6 from credits into @nm, @prc
print @nm + ' ' + cast(@prc as varchar(3))+ '%'
update ������� set ������ = -1 + ������ where current of credits
fetch prior from credits into @nm, @prc
fetch next from credits into @nm, @prc
print @nm + ' ' + cast(@prc as varchar(3))+ '%'
close credits 

select * from �������

--#6-------------------------
use SMV_UNIVER;
go
-------------------------------------------------------1
---��
select * from PROGRESS where NOTE < 7

declare @note int, @dt date, @id int, @sub char(10)
declare prog_cur cursor local dynamic
				for select SUBJECT, IDSTUDENT, PDATE, NOTE from PROGRESS
open prog_cur
fetch prog_cur into @sub,@id,@dt, @note
while @@fetch_status = 0
begin
	if @note like 6
	begin
	fetch prior from prog_cur into @sub,@id,@dt, @note
	fetch next from prog_cur into @sub,@id,@dt, @note
	delete PROGRESS where current of prog_cur
	end
	else print cast(@note as varchar(2))
fetch prog_cur into @sub,@id,@dt, @note
end
close prog_cur

-----�����
select * from PROGRESS where NOTE < 7

--------------------------------------------------------------------2
select IDSTUDENT, NOTE
from PROGRESS
where IDSTUDENT like 1023

declare @i int, @nt int
declare studs cursor local dynamic
				for select IDSTUDENT, NOTE
				from PROGRESS for update
open studs
fetch studs into @i, @nt
while @@fetch_status = 0
begin
	if @i like 1023
	begin
	fetch prior from studs into @i, @nt
	fetch next from studs into @i, @nt
	update PROGRESS set NOTE = NOTE + 1 where current of studs
	end
	fetch studs into @i, @nt
end
close studs