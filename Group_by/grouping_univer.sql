use SMV_UNIVER;
--№1
select min(AUDITORIUM.AUDITORIUM_CAPACITY) [минимальная],
	   max(AUDITORIUM.AUDITORIUM_CAPACITY) [максимальная],
	   avg(AUDITORIUM.AUDITORIUM_CAPACITY) [средняя],
	   count(*)							   [всего аудиторий],
	   sum(AUDITORIUM.AUDITORIUM_CAPACITY) [общая]
from AUDITORIUM
--№2 Для каждого типа аудитории
select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME [тип аудитории],
	   min(AUDITORIUM.AUDITORIUM_CAPACITY) [минимальная],
	   max(AUDITORIUM.AUDITORIUM_CAPACITY) [максимальная],
	   avg(AUDITORIUM.AUDITORIUM_CAPACITY) [средняя],
	   count(*)							   [всего аудиторий],
	   sum(AUDITORIUM.AUDITORIUM_CAPACITY) [общая]
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE like AUDITORIUM_TYPE.AUDITORIUM_TYPE
group by AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
--№3 статистика всех оценок
select *
from (select case when PROGRESS.NOTE like 10 then '10'
				  when PROGRESS.NOTE between 8 and 9 then '8-9'
				  when PROGRESS.NOTE between 6 and 7 then '6-7'
				  when PROGRESS.NOTE between 4 and 5 then '4-5'
				  else 'неуд'
				  end [Оценки], count(*) [Количество]
			from PROGRESS group by case
			when PROGRESS.NOTE like 10 then '10'
				  when PROGRESS.NOTE between 8 and 9 then '8-9'
				  when PROGRESS.NOTE between 6 and 7 then '6-7'
				  when PROGRESS.NOTE between 4 and 5 then '4-5'
				  else 'неуд'
				  end) as M
			order by case [Оценки]
					 when '10' then 1
					 when '8-9' then 2
					 when '6-7' then 3
					 when '4-5' then 4
					 else 5
					 end


--№4 - оценки каждого курса каждой специальности
select g.FACULTY [факультет],
	   g.PROFESSION [специальность],
	   case
	   when g.YEAR_FIRST like 2010 then 4
	   when g.YEAR_FIRST like 2011 then 3
	   when g.YEAR_FIRST like 2012 then 2
	   when g.YEAR_FIRST like 2013 then 1
	   end [курс],
	  round(avg(cast(p.NOTE as float(4))), 2)  [оценка]
from GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, g.YEAR_FIRST, g.FACULTY
order by [оценка] desc
---№5
select p.SUBJECT [дисциплина],
	   g.PROFESSION [специальность],
	   round(avg(cast(p.NOTE as float(4))), 2)  [средняя оценка]
from GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
where g.FACULTY like 'ПИМ'
group by rollup (p.SUBJECT, g.PROFESSION)
---№6
select p.SUBJECT [дисциплина],
	   g.PROFESSION [специальность],
	   round(avg(cast(p.NOTE as float(4))), 2)  [средняя оценка]
from GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
where g.FACULTY like 'ПИМ'
group by cube (p.SUBJECT, g.PROFESSION)
---№7
select g.PROFESSION [специальность],
	   p.SUBJECT [дисциплина],
	   round(avg(cast(p.NOTE as float(4))), 2)  [средняя оценка]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like 'ПИМ')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
------
select g.PROFESSION [специальность],
	   p.SUBJECT [дисциплина],
	   round(avg(cast(p.NOTE as float(4))), 2)  [средняя оценка]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like 'ТОВ')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
------------------------------------------------------------

select g.PROFESSION [специальность],
	   p.SUBJECT [дисциплина],
	   round(avg(cast(p.NOTE as float(4))), 2)  [средняя оценка]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like 'ПИМ')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
union
select g.PROFESSION [специальность],
	   p.SUBJECT [дисциплина],
	   round(avg(cast(p.NOTE as float(4))), 2)  [средняя оценка]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like 'ТОВ')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
------
select g.PROFESSION [специальность],
	   p.SUBJECT [дисциплина],
	   round(avg(cast(p.NOTE as float(4))), 2)  [средняя оценка]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like 'ПИМ')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
union all
select g.PROFESSION [специальность],
	   p.SUBJECT [дисциплина],
	   round(avg(cast(p.NOTE as float(4))), 2)  [средняя оценка]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like 'ТОВ')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT


---№8
select g.PROFESSION [специальность],
	   p.SUBJECT [дисциплина],
	   round(avg(cast(p.NOTE as float(4))), 2)  [средняя оценка]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like 'ПИМ')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
union
select g.PROFESSION [специальность],
	   p.SUBJECT [дисциплина],
	   round(avg(cast(p.NOTE as float(4))), 2)  [средняя оценка]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like 'ТОВ')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
intersect -------------------------------------вернет только ПИМ
select g.PROFESSION [специальность],
	   p.SUBJECT [дисциплина],
	   round(avg(cast(p.NOTE as float(4))), 2)  [средняя оценка]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like 'ПИМ')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT


----№9
select g.PROFESSION [специальность],
	   p.SUBJECT [дисциплина],
	   round(avg(cast(p.NOTE as float(4))), 2)  [средняя оценка]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like 'ПИМ')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
union
select g.PROFESSION [специальность],
	   p.SUBJECT [дисциплина],
	   round(avg(cast(p.NOTE as float(4))), 2)  [средняя оценка]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like 'ТОВ')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT
except ----------------------------------------вернет только ТОВ
select g.PROFESSION [специальность],
	   p.SUBJECT [дисциплина],
	   round(avg(cast(p.NOTE as float(4))), 2)  [средняя оценка]
from (GROUPS g inner join STUDENT s on g.IDGROUP like s.IDGROUP and g.FACULTY like 'ПИМ')
			  inner join PROGRESS p on s.IDSTUDENT like p.IDSTUDENT
group by g.PROFESSION, p.SUBJECT




---№10
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



