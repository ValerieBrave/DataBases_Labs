USE Смелова_UNIVER;
ALTER table STUDENT ADD Дата_поступления date default '2020-09-01' check (Дата_поступления < GETDATE());
