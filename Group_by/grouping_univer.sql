use SMV_UNIVER;
--�1
select min(AUDITORIUM.AUDITORIUM_CAPACITY) [�����������],
	   max(AUDITORIUM.AUDITORIUM_CAPACITY) [������������],
	   avg(AUDITORIUM.AUDITORIUM_CAPACITY) [�������],
	   count(*)							   [����� ���������],
	   sum(AUDITORIUM.AUDITORIUM_CAPACITY) [�����]
from AUDITORIUM
--�2 ��� ������� ���� ���������
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [��� ���������],
	   min(AUDITORIUM.AUDITORIUM_CAPACITY) [�����������],
	   max(AUDITORIUM.AUDITORIUM_CAPACITY) [������������],
	   avg(AUDITORIUM.AUDITORIUM_CAPACITY) [�������],
	   count(*)							   [����� ���������],
	   sum(AUDITORIUM.AUDITORIUM_CAPACITY) [�����]
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE like AUDITORIUM_TYPE.AUDITORIUM_TYPE
group by AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
--�3 ���������� ���� ������
select *
from (select case when PROGRESS.NOTE like 10 then '10'
				  when PROGRESS.NOTE between 8 and 9 then '8-9'
				  when PROGRESS.NOTE between 6 and 7 then '6-7'
				  when PROGRESS.NOTE between 4 and 5 then '4-5'
				  else '����'
				  end [������], count(*) [����������]
			from PROGRESS group by case
			when PROGRESS.NOTE like 10 then '10'
				  when PROGRESS.NOTE between 8 and 9 then '8-9'
				  when PROGRESS.NOTE between 6 and 7 then '6-7'
				  when PROGRESS.NOTE between 4 and 5 then '4-5'
				  else '����'
				  end) as M
			order by case [������]
					 when '10' then 1
					 when '8-9' then 2
					 when '6-7' then 3
					 when '4-5' then 4
					 else 5
					 end


--�4 - ������ ������� ����� ������ �������������
select g.FACULTY [���������],
	   g.PROFESSION [�������������],
	   case
	   when g.YEAR_FIRST like 2010 then 4
	   when g.YEAR_FIRST like 2011 then 3
	   when g.YEAR_FIRST like 2012 then 2
	   when g.YEAR_FIRST like 2013 then 1
	   end [����],
	  round(avg(cast(p.NOTE as float(4))), 2)  [������]
from GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, g.YEAR_FIRST, g.FACULTY
order by [������] desc
---�5
select p.SUBJECT [����������],
	   g.PROFESSION [�������������],
	   round(avg(cast(p.NOTE as float(4))), 2)  [������� ������]
from GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
where g.FACULTY like '���'
group by rollup (p.SUBJECT, g.PROFESSION)
---�6
select p.SUBJECT [����������],
	   g.PROFESSION [�������������],
	   round(avg(cast(p.NOTE as float(4))), 2)  [������� ������]
from GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
where g.FACULTY like '���'
group by cube (p.SUBJECT, g.PROFESSION)
---�7
select g.PROFESSION [�������������],
	   p.SUBJECT [����������],
	   round(avg(cast(p.NOTE as float(4))), 2)  [������� ������]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like '���')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
------
select g.PROFESSION [�������������],
	   p.SUBJECT [����������],
	   round(avg(cast(p.NOTE as float(4))), 2)  [������� ������]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like '���')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
------------------------------------------------------------

select g.PROFESSION [�������������],
	   p.SUBJECT [����������],
	   round(avg(cast(p.NOTE as float(4))), 2)  [������� ������]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like '���')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
union
select g.PROFESSION [�������������],
	   p.SUBJECT [����������],
	   round(avg(cast(p.NOTE as float(4))), 2)  [������� ������]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like '���')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
------
select g.PROFESSION [�������������],
	   p.SUBJECT [����������],
	   round(avg(cast(p.NOTE as float(4))), 2)  [������� ������]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like '���')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
union all
select g.PROFESSION [�������������],
	   p.SUBJECT [����������],
	   round(avg(cast(p.NOTE as float(4))), 2)  [������� ������]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like '���')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT


---�8
select g.PROFESSION [�������������],
	   p.SUBJECT [����������],
	   round(avg(cast(p.NOTE as float(4))), 2)  [������� ������]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like '���')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
union
select g.PROFESSION [�������������],
	   p.SUBJECT [����������],
	   round(avg(cast(p.NOTE as float(4))), 2)  [������� ������]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like '���')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
intersect -------------------------------------������ ������ ���
select g.PROFESSION [�������������],
	   p.SUBJECT [����������],
	   round(avg(cast(p.NOTE as float(4))), 2)  [������� ������]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like '���')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT


----�9
select g.PROFESSION [�������������],
	   p.SUBJECT [����������],
	   round(avg(cast(p.NOTE as float(4))), 2)  [������� ������]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like '���')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
union
select g.PROFESSION [�������������],
	   p.SUBJECT [����������],
	   round(avg(cast(p.NOTE as float(4))), 2)  [������� ������]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like '���')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
except ----------------------------------------������ ������ ���
select g.PROFESSION [�������������],
	   p.SUBJECT [����������],
	   round(avg(cast(p.NOTE as float(4))), 2)  [������� ������]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like '���')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT




---�10
select t.s,
		sum(t.c)
from
(select p.SUBJECT s,
		p.NOTE n,
		count(*) [c]
from PROGRESS p
group by p.SUBJECT , p.NOTE 
having P.NOTE between 8 and 9) as t (s,n,c)
group by t.s



