USE Смелова_UNIVER;
SELECT * from STUDENT;
SELECT Фамилия, Номер_группы from STUDENT;
SELECT count(*) from STUDENT;
SELECT Фамилия, Номер_группы [Первокурсники] from STUDENT WHERE (Дата_поступления = '2019-09-01');
SELECT Top(2) Фамилия, Номер_группы [ПОИТ] from STUDENT WHERE (Номер_группы < 7 and Номер_группы > 3);
SELECT Фамилия, Дата_поступления from STUDENT WHERE (Дата_поступления BETWEEN '2015-09-01' and '2018-09-01');