use SMV_UNIVER;
--�1
select FACULTY.FACULTY_NAME as [���������], PROFESSION.PROFESSION_NAME as [�������������]
from FACULTY, PROFESSION
where FACULTY.FACULTY = PROFESSION.FACULTY
	and
	PROFESSION.PROFESSION_NAME in (select PROFESSION_NAME 
									from PROFESSION 
									where PROFESSION.PROFESSION_NAME like '%����������%' 
									or
									PROFESSION.PROFESSION_NAME like '%����������%'
									or
									PROFESSION.PROFESSION_NAME like '%����������%')
--�2
select FACULTY.FACULTY_NAME as [���������], PROFESSION.PROFESSION_NAME as [�������������]
from FACULTY inner join PROFESSION
on FACULTY.FACULTY = PROFESSION.FACULTY
where PROFESSION.PROFESSION_NAME in (select PROFESSION_NAME 
									from PROFESSION 
									where PROFESSION.PROFESSION_NAME like '%����������%' 
									or
									PROFESSION.PROFESSION_NAME like '%����������%'
									or
									PROFESSION.PROFESSION_NAME like '%����������%')
--�3
select FACULTY.FACULTY_NAME as [���������], PROFESSION.PROFESSION_NAME as [�������������]
from FACULTY inner join PROFESSION
on FACULTY.FACULTY = PROFESSION.FACULTY
where PROFESSION.PROFESSION_NAME like '%����������%' 
									or
									PROFESSION.PROFESSION_NAME like '%����������%'
									or
									PROFESSION.PROFESSION_NAME like '%����������%'
--�4
select AUDITORIUM_TYPE, AUDITORIUM_CAPACITY
from AUDITORIUM a
where AUDITORIUM_CAPACITY = (select top(1) AUDITORIUM_CAPACITY from AUDITORIUM aa
						 where a.AUDITORIUM_TYPE like aa.AUDITORIUM_TYPE
						 order by AUDITORIUM_CAPACITY desc)
--��������� �������������, ������ ��� ��� ������� ���� ��������� ����������� ������������ �����������
--�5
select FACULTY.FACULTY_NAME from FACULTY
where not exists (select * from PULPIT where PULPIT.FACULTY like FACULTY.FACULTY)
--�6
select top 1
	(select avg(PROGRESS.NOTE) from PROGRESS
								where PROGRESS.SUBJECT like '����') [����],
	(select avg(PROGRESS.NOTE) from PROGRESS
								where PROGRESS.SUBJECT like '��') [��],
	(select avg(PROGRESS.NOTE) from PROGRESS
								where PROGRESS.SUBJECT like '����') [����]
from PROGRESS
--�7
select PROGRESS.SUBJECT, PROGRESS.NOTE from PROGRESS
where PROGRESS.NOTE >= all(select PROGRESS.NOTE from PROGRESS where PROGRESS.SUBJECT like '%�')