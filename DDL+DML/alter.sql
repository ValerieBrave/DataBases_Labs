USE �������_UNIVER;
ALTER table STUDENT ADD ����_����������� date default '2020-09-01' check (����_����������� < GETDATE());
