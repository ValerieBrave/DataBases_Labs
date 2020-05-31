use SVV_MyBase;
go
----------------------------#1 ������� ����������
set nocount on
	if  exists (select * from  SYS.OBJECTS        -- ������� X ����?
	            where OBJECT_ID= object_id(N'DBO.EMPLOYEES') )	            
	drop table EMPLOYEES; 

declare @c int, @flag char = 'c';
SET IMPLICIT_TRANSACTIONS ON
create table EMPLOYEES( id int primary key, name nvarchar(20));
insert into EMPLOYEES (id, name) values(1, 'Peter'), (2, 'Ann'), (3, 'Vasya');
set @c = (select count(*) from EMPLOYEES);
		print '���������� ����� � ������� EMPLOYEES: ' + cast( @c as varchar(2));
if @flag = 'c'  commit;                   -- ���������� ����������: �������� 
else   rollback;                                 -- ���������� ����������: �����  
SET IMPLICIT_TRANSACTIONS  OFF   -- ������. ����� ������� ����������

if  exists (select * from  SYS.OBJECTS       -- ������� X ����?
	        where OBJECT_ID= object_id(N'DBO.EMPLOYEES') )
	print '������� EMPLOYEES ����';  
      else print '������� EMPLOYEES ���'

--------------------------#2 ����������� ����� ����������
begin try
	begin transaction
		update ������� set ����� = 300000 where ��������_������� like '������'
		insert into �������(��������_�������, ������, �����) values('��������������', 9, 100000)
		insert into �������(��������_�������, ������, �����) values('������', 12, 100000)
	commit 
end try
begin catch
print '�������� �����: ' + cast(error_number() as varchar(6)) + '--' + error_message()
if @@trancount > 0 rollback tran
end catch

------------------------------------#3 SAVE TRAN
use SMV_UNIVER
go
declare @point varchar(32)
begin try
	begin transaction
	insert into PULPIT(PULPIT, PULPIT_NAME, FACULTY) values ('��','����������� ���������','��')
	set @point = 'p1'; save tran @point
	insert into PULPIT(PULPIT, PULPIT_NAME, FACULTY) values ('�����-�� �������','� ��� ��������','��')
	set @point = 'p2'; save tran @point
	delete PULPIT where PULPIT like '�����'
	set @point = 'p3'; save tran @point
	commit
end try
begin catch
print '�������� �����: ' + cast(error_number() as varchar(6)) + '--' + error_message()
print '����������� �����: ' + @point
rollback tran @point
commit tran
end catch
--delete PULPIT where PULPIT like '��'


----------------------------#4 READ COMMITED VS READ UNCOMMITED
--A						--B � ������ �����
set transaction isolation level READ UNCOMMITTED 
begin transaction 
-------------------t1--------------------
select * from FACULTY	--  ��������� ������ - ����� ���������
---B ������ �� �� ����
select * from SUBJECT where SUBJECT.SUBJECT like '%�%'
--  + ��������������� � ���������������� ������ - ��� ��, � ������ ����
------------------t2----------------------
select * from SUBJECT where SUBJECT.SUBJECT like '%�%'
commit tran

----------------------------#5 READ COMMITED ��������������� � ��������� ������ ��� �����������������
set transaction isolation level READ COMMITTED 
begin transaction 
select * from [SUBJECT]
------------------t1----------------------
select * from [SUBJECT] --����������������� ��� ���� ��� �������
select * from FACULTY		-- ��� ���
 ----------------t2-----------------------
  --- ��������� ������
 select * from FACULTY		-- ���� ��� => ����� ��������� ������
 select * from [SUBJECT] -- ������ ���� ����� ������� � � ������ ��� ��������������� ������
 commit tran

 ---------------------------#6 REPEATABLE READ - ������ ���������
 set transaction isolation level REPEATABLE READ
 begin transaction
 ----------------
 select * from STUDENT where IDSTUDENT like 1080 --�� ������ ����
 select * from [SUBJECT] --����������������� ���
 --------
 select * from STUDENT where IDSTUDENT like 1080 -- ������ ����???
 select * from FACULTY -- ������ ��������� ������ 
 commit tran

 --------------#7 SERIALIZABLE
 set transaction isolation level SERIALIZABLE
 begin transaction
 --select * from STUDENT where IDSTUDENT like 1080
 select * from FACULTY
 ------
 select * from [SUBJECT] -- �� ���� ���������� ���������������� ���������
 ------
 select * from STUDENT where IDSTUDENT like 1080 -- �� ���� ���������� ���������������
 select * from FACULTY -- �� ���� ���������� ��������� ������
 commit tran

 ---------------#8 ��������� ����������
 begin tran
 insert into FACULTY(FACULTY, FACULTY_NAME) values ('���', '��������� ��� �������')
	 begin tran
		insert into PULPIT(PULPIT, PULPIT_NAME, FACULTY) values ('���','������� ��� �������','��')
	 commit		-- ������ ��� ��������� ����������
 select * from FACULTY
 select * from PULPIT
 if @@trancount > 0 rollback		--�������: �������� ���������� ���������� � �������
 select * from FACULTY
 select * from PULPIT
 --delete FACULTY where FACULTY like '���'
 --delete PULPIT where PULPIT like '���'

 ----------------
 begin tran
 insert into FACULTY(FACULTY, FACULTY_NAME) values ('���', '��������� ��� �������')
	begin tran
	update SUBJECT set SUBJECT = '����' where SUBJECT like '��'
	rollback		-- ���������� �������� ��������� � �������

	select * from SUBJECT
	select * from FACULTY


--update SUBJECT set SUBJECT = '��' where SUBJECT like '����'