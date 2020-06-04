use SMV_UNIVER;
go
-----------------#1 ������� � ������������ ��������
create table TR_AUDIT
(
ID int identity,
STMT varchar(20) check(STMT in('INS','DEL','UPD')),
TRNAME varchar(50),
CC varchar(300)
)
go
--------------
create trigger TR_TEACHER_INS on TEACHER after insert
as declare @tchr char(10), @tchr_n varchar(100), @gen char(1), @pulp char(20), @cc varchar(300)
set @tchr = (select TEACHER from inserted)
set @tchr_n = (select TEACHER_NAME from inserted)
set @gen = (select GENDER from inserted)
set @pulp = (select PULPIT from inserted)
set @cc = @tchr + ', ' + @tchr_n +', ' + @gen+', '+@pulp
insert into TR_AUDIT(STMT, TRNAME, CC)
values ('INS', 'TR_TEACHER_INS', @cc)
return;
----------------drop trigger TR_TEACHER_DEL
insert into TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT)
values ('����','�������� �.�.','�','�����')
		--('����','������� �.�.','�','�����')
---
select * from TR_AUDIT
go
-------------#2 TR_TEACHER_DEL
create trigger TR_TEACHER_DEL on TEACHER after delete
as declare @tchr char(10), @tchr_n varchar(100), @gen char(1), @pulp char(20), @cc varchar(300)
set @tchr = (select TEACHER from deleted)
set @tchr_n = (select TEACHER_NAME from deleted)
set @gen = (select GENDER from deleted)
set @pulp = (select PULPIT from deleted)
set @cc = @tchr + ', ' + @tchr_n +', ' + @gen+', '+@pulp
insert into TR_AUDIT(STMT, TRNAME, CC)
values ('DEL', 'TR_TEACHER_DEL', @cc)
return;
----
delete TEACHER where TEACHER_NAME like '�������� �.�.'
go

-------------#3 �� �� ����� ��� �������
create trigger TR_TEACHER_UPD on TEACHER after update
as declare @tchr char(10), @tchr_n varchar(100), @gen char(1), @pulp char(20), @cc varchar(300)
set @tchr = (select TEACHER from deleted)
set @tchr_n = (select TEACHER_NAME from deleted)
set @gen = (select GENDER from deleted)
set @pulp = (select PULPIT from deleted)
set @cc = @tchr + ', ' + @tchr_n +', ' + @gen+', '+@pulp
set @tchr = (select TEACHER from inserted)
set @tchr_n = (select TEACHER_NAME from inserted)
set @gen = (select GENDER from inserted)
set @pulp = (select PULPIT from inserted)
set @cc = @cc+ '�����:'+ @tchr + ', ' + @tchr_n +', ' + @gen+', '+@pulp
insert into TR_AUDIT(STMT, TRNAME, CC)
values ('UPD', 'TR_TEACHER_UPD', @cc)
return;
--
update TEACHER set TEACHER_NAME = '������� �.�.', GENDER = '�', TEACHER = '�����' where TEACHER like '����'
go
-----------#4 after ��� 3 �������
drop trigger TR_TEACHER_DEL
drop trigger TR_TEACHER_UPD
drop trigger TR_TEACHER_INS
go
create trigger TR_TEACHER on TEACHER after insert, update, delete
as declare @ins int = (select count(*) from inserted), @del int = (select count(*) from deleted)
declare @tchr char(10), @tchr_n varchar(100), @gen char(1), @pulp char(20), @cc varchar(300)
if @ins > 0 and @del = 0
	begin
		print 'INSERT'
		set @tchr = (select TEACHER from inserted)
		set @tchr_n = (select TEACHER_NAME from inserted)
		set @gen = (select GENDER from inserted)
		set @pulp = (select PULPIT from inserted)
		set @cc = @tchr + ', ' + @tchr_n +', ' + @gen+', '+@pulp
		insert into TR_AUDIT(STMT, TRNAME, CC)
		values ('INS', 'TR_TEACHER', @cc)
		return;
	end
else if @ins = 0 and @del >0
	begin
		print 'DELETE'
		set @tchr = (select TEACHER from deleted)
		set @tchr_n = (select TEACHER_NAME from deleted)
		set @gen = (select GENDER from deleted)
		set @pulp = (select PULPIT from deleted)
		set @cc = @tchr + ', ' + @tchr_n +', ' + @gen+', '+@pulp
		insert into TR_AUDIT(STMT, TRNAME, CC)
		values ('DEL', 'TR_TEACHER', @cc)
		return;
	end
else if @ins > 0 and @del > 0
	begin
		print 'UPDATE'
		set @tchr = (select TEACHER from deleted)
		set @tchr_n = (select TEACHER_NAME from deleted)
		set @gen = (select GENDER from deleted)
		set @pulp = (select PULPIT from deleted)
		set @cc = @tchr + ', ' + @tchr_n +', ' + @gen+', '+@pulp
		set @tchr = (select TEACHER from inserted)
		set @tchr_n = (select TEACHER_NAME from inserted)
		set @gen = (select GENDER from inserted)
		set @pulp = (select PULPIT from inserted)
		set @cc = @cc+ '�����:'+ @tchr + ', ' + @tchr_n +', ' + @gen+', '+@pulp
		insert into TR_AUDIT(STMT, TRNAME, CC)
		values ('UPD', 'TR_TEACHER', @cc)
		return;
	end
go
----
--drop trigger TR_TEACHER
delete  from TR_AUDIT
insert into TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('�����','������� �.�.','�','�����')
update TEACHER set TEACHER_NAME = '������� �������� ���������' where TEACHER like '�����'
delete TEACHER where TEACHER like '�����'
select * from TR_AUDIT
go


-------------#5 ��������, ��� �������� ����������� �� �����-��������
create trigger TR_FAC on FACULTY after insert
as print 'INSERT ������ �������'
return;
go
insert into FACULTY(FACULTY, FACULTY_NAME) values('��', '�������������� ����������')
go


------------#6 ������� ���������� ���������
create trigger TR_TEACHER_DEL1 on TEACHER after delete
as declare @tchr char(10), @tchr_n varchar(100), @gen char(1), @pulp char(20), @cc varchar(300)
set @tchr = (select TEACHER from deleted)
set @tchr_n = (select TEACHER_NAME from deleted)
set @gen = (select GENDER from deleted)
set @pulp = (select PULPIT from deleted)
set @cc = @tchr + ', ' + @tchr_n +', ' + @gen+', '+@pulp
insert into TR_AUDIT(STMT, TRNAME, CC)
values ('DEL', 'TR_TEACHER_DEL1', @cc)
return;
go
create trigger TR_TEACHER_DEL2 on TEACHER after delete
as declare @tchr char(10), @tchr_n varchar(100), @gen char(1), @pulp char(20), @cc varchar(300)
set @tchr = (select TEACHER from deleted)
set @tchr_n = (select TEACHER_NAME from deleted)
set @gen = (select GENDER from deleted)
set @pulp = (select PULPIT from deleted)
set @cc = @tchr + ', ' + @tchr_n +', ' + @gen+', '+@pulp
insert into TR_AUDIT(STMT, TRNAME, CC)
values ('DEL', 'TR_TEACHER_DEL2', @cc)
return;
go
create trigger TR_TEACHER_DEL3 on TEACHER after delete
as declare @tchr char(10), @tchr_n varchar(100), @gen char(1), @pulp char(20), @cc varchar(300)
set @tchr = (select TEACHER from deleted)
set @tchr_n = (select TEACHER_NAME from deleted)
set @gen = (select GENDER from deleted)
set @pulp = (select PULPIT from deleted)
set @cc = @tchr + ', ' + @tchr_n +', ' + @gen+', '+@pulp
insert into TR_AUDIT(STMT, TRNAME, CC)
values ('DEL', 'TR_TEACHER_DEL3', @cc)
return;
go
-------��������� ��������
select t.name, e.type_desc 
         from sys.triggers  t join  sys.trigger_events e  
                  on t.object_id = e.object_id  
                            where OBJECT_NAME(t.parent_id) = 'TEACHER' and 
	                                                                        e.type_desc = 'DELETE' ;
----
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', 
	                        @order = 'First', @stmttype = 'DELETE';

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', 
	                        @order = 'Last', @stmttype = 'DELETE';
--demo
insert into TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('�����','������� �.�.','�','�����')
delete TEACHER where TEACHER like '�����'
select * from TR_AUDIT
go

--------------#7 after-triggers in transaction
create trigger TR_TRANSDEMO on TEACHER after delete
as raiserror('����� �������, �?', 10,1)
rollback
return;
go
--
begin tran
insert into TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('�����','������� �.�.','�','�����')
insert into TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('����','�������� �.�.','�','�����')
delete TEACHER where TEACHER like '����'
commit
go


--------------#8 instead-of triggers
--drop trigger TR_FAC
--drop trigger TR_TEACHER_DEL1
--drop trigger TR_TEACHER_DEL2
--drop trigger TR_TEACHER_DEL3
create trigger TR_FAC_DEL on FACULTY instead of delete
as raiserror('�������� ���������',10,1)
return;
go
delete FACULTY where FACULTY like '��'

-----------------#9 ddl-trigger for database
go
  create  trigger DDL_UNIVER on database 
                          for DDL_DATABASE_LEVEL_EVENTS  as   
  declare @t varchar(50) =  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
  declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
  declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'); 
  if @t1 = 'AUDITORIUM' OR  @t1 = 'AUDITORIUM_TYPE' OR  @t1 = 'FACULTY' OR  @t1 = 'GROUPS'
	OR  @t1 = 'PROFESSION' OR  @t1 = 'PROGRESS' OR  @t1 = 'PULPIT' OR  @t1 = 'STUDENT'
	OR  @t1 = 'SUBJECT' OR  @t1 = 'TEACHER' OR  @t1 = 'EXAMPLE'
  begin
       print '��� �������: '+@t;
       print '��� �������: '+@t1;
       print '��� �������: '+@t2;
       raiserror( N'�������� � ����� ������ ���������', 16, 1);  
       rollback;    
   end;
   drop trigger DDL_UNIVER on database
   ---------
   create table EXAMPLE (id int, string char(10))
   drop table EXAMPLE