use SMV_UNIVER
go
------#4 B
begin transaction 
	insert into FACULTY(FACULTY, FACULTY_NAME) values ('���', '���������� ����� ���������') -- ��������� ������
	-------------t1---------------
	update SUBJECT set SUBJECT = '����' where SUBJECT like '��' --����������������
	-------------t2---------------
rollback tran

------#5 B
set transaction isolation level READ COMMITTED 
begin transaction
--------------------t1----------------------
update SUBJECT set SUBJECT = '����' where SUBJECT like '��' -- ���������������� ������
--update SUBJECT set SUBJECT = '��' where SUBJECT like '����'
--------------------t2--------------------
--��������� ������ � ��������
insert into FACULTY(FACULTY, FACULTY_NAME) values ('���', '���������� ����� ���������') --��������� ������ �����
update SUBJECT set SUBJECT = '������' where SUBJECT like '��' -- ��������������� ������
--delete FACULTY where FACULTY like '���'
--update SUBJECT set SUBJECT = '��' where SUBJECT like '������'
commit tran

-------------#6 B
set transaction isolation level READ COMMITTED 
begin transaction
update SUBJECT set SUBJECT = '����' where SUBJECT like '��' -- ���������������� ������ - �� �����
----------------
update STUDENT set NAME = '������� �.�.' where NAME like '��������� ����� ��������' -- ��������������� ������ - �� �����
insert into FACULTY(FACULTY, FACULTY_NAME) values ('���', '���������� ����� ���������') --��������� ������ �����
commit tran
--delete FACULTY where FACULTY like '���'
--update STUDENT set NAME = '��������� ����� ��������' where NAME like '������� �.�.'
--update SUBJECT set SUBJECT = '��' where SUBJECT like '����'

--------------#7 B
set transaction isolation level READ COMMITTED 
begin transaction
update SUBJECT set SUBJECT = '����' where SUBJECT like '��' -- �� ������� - ���������������� ������
---------------------
update STUDENT set NAME = '������� �.�.' where NAME like '��������� ����� ��������' -- ��������������� ������ - �� ���� ���������
insert into FACULTY(FACULTY, FACULTY_NAME) values ('���', '���������� ����� ���������') --��������� ������ �� ���� ���������
commit tran