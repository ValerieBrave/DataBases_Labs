USE �������_UNIVER;
SELECT * from STUDENT;
SELECT �������, �����_������ from STUDENT;
SELECT count(*) from STUDENT;
SELECT �������, �����_������ [�������������] from STUDENT WHERE (����_����������� = '2019-09-01');
SELECT Top(2) �������, �����_������ [����] from STUDENT WHERE (�����_������ < 7 and �����_������ > 3);
SELECT �������, ����_����������� from STUDENT WHERE (����_����������� BETWEEN '2015-09-01' and '2018-09-01');