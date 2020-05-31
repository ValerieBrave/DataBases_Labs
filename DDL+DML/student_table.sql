USE Смелова_UNIVER;
CREATE table STUDENT
(
	Номер_зачетки int primary key,
	Фамилия nvarchar(20),
	Номер_группы int not null
);
CREATE table RESULTS
(
	Id int primary key identity(1,1),
	Student_name nvarchar(40),
	Math int,
	Physics int,
	Oop int,
	Aver_value as (Math+Physics+Oop)/3
);