USE �������_UNIVER;
CREATE table STUDENT
(
	�����_������� int primary key,
	������� nvarchar(20),
	�����_������ int not null
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