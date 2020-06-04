use SMV_UNIVER
go;

---------------------#1 XML-документ в режиме PATH из таблицы TEACHER для преподавателей кафедры ИСиТ
 select PULPIT [кафедра/@код], 
		TEACHER [кафедра/преподаватель/@код],
		TEACHER_NAME [кафедра/преподаватель/имя/data()],
		GENDER [кафедра/преподаватель/пол/data()]
		from TEACHER where PULPIT like 'ИСиТ'
 for xml path(''), root ('Преподаватели_ИСиТ'), elements

 --------------------#2 авто
 select AUDITORIUM_TYPENAME, AUDITORIUM_NAME,  AUDITORIUM_CAPACITY 
 from AUDITORIUM inner join AUDITORIUM_TYPE
 on AUDITORIUM.AUDITORIUM_TYPE like AUDITORIUM_TYPE.AUDITORIUM_TYPE
 where AUDITORIUM_TYPE.AUDITORIUM_TYPE like 'ЛК'
 for xml auto

 --------------------#3 Добавление строк из XML-документа
 declare @h int = 0, @x varchar(2000) = 
	   ' <?xml version="1.0" encoding="windows-1251" ?>
       <SUBJECTS> 
       <subject SUBJECT="ОЗИ" SUBJECT_NAME="Основы защиты информации" PULPIT="ИСиТ" /> 
       <subject SUBJECT="КСИС" SUBJECT_NAME="Компьютерные системы и сети" PULPIT="ДЭиВИ" /> 
       <subject SUBJECT="КГИГ" SUBJECT_NAME="Компьютерная геометрия и графика" PULPIT="ДЭиВИ"/>  
       </SUBJECTS>';
exec sp_xml_preparedocument @h output, @x; -- получаем дескриптор

insert SUBJECT select [SUBJECT], [SUBJECT_NAME], [PULPIT]
from openxml(@h, '/SUBJECTS/subject', 0)
with ([SUBJECT] char(10), [SUBJECT_NAME] varchar(100), [PULPIT] char(20))
    exec sp_xml_removedocument @h; 
--delete SUBJECT where SUBJECT like 'ОЗИ'
--delete SUBJECT where SUBJECT like 'КСИС'
--delete SUBJECT where SUBJECT like 'КГИГ'


-----------------#4 
create table #STUDENT_TEMP
(
idstudent int primary key,
idgroup int,
name nvarchar(100),
passport_data xml
)
go
declare @pass1 char(1000) = 
'<passport number="MR9837392">
<person_id id="00383899922"/>
<address coord="Минск, Семенова 32, кв4"/>
</passport>'
declare @pass2 char(1000) = 
'<passport number="MP9644292">
<person_id id="0065438722"/>
<address coord="Минск, Одинцова 7, кв9"/>
</passport>'
insert into #STUDENT_TEMP(idstudent, idgroup, name, passport_data)
values (1081, 4, 'Луговой Антон Викторович', @pass1),
		(1082, 5, 'Войтик Анна Сергеевна', @pass2)
--
select * from #STUDENT_TEMP
select name [имя], 
		passport_data.value('(/passport/@number)[1]','varchar(10)') [номер паспорта],
		passport_data.value('(/passport/person_id/@id)[1]','varchar(20)') [личный номер],
		passport_data.value('(/passport/address/@coord)[1]','varchar(40)') [прописка]
		from #STUDENT_TEMP
---
update #STUDENT_TEMP set passport_data = '<passport number="MP9644292">
<person_id id="0065438722"/>
<address coord="Минск, Одинцова 7, кв9"/>
</passport>'
where passport_data.value('(/passport/@number)[1]', 'varchar(10)') like 'MP9644292'

----------------------#5 
create xml schema collection info_schema as 
N'<?xml version="1.0" encoding="utf-16" ?>
  <xs:schema attributeFormDefault="unqualified" 
  elementFormDefault="qualified"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xs:element name="студент">
		<xs:complexType>
		<xs:sequence>
		<xs:element name="паспорт" maxOccurs="1" minOccurs="1">
			<xs:complexType>
				<xs:attribute name="серия" type="xs:string" use="required" />
				<xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
				<xs:attribute name="дата"  use="required">
				<xs:simpleType>  
					<xs:restriction base ="xs:string">
						<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
					</xs:restriction> 	
					</xs:simpleType>
				</xs:attribute>
			</xs:complexType>
		</xs:element>
		<xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
		<xs:element name="адрес">   <xs:complexType><xs:sequence>
		<xs:element name="страна" type="xs:string" />
		<xs:element name="город" type="xs:string" />
		<xs:element name="улица" type="xs:string" />
		<xs:element name="дом" type="xs:string" />
		<xs:element name="квартира" type="xs:string" />
	</xs:sequence>
	</xs:complexType>
	</xs:element>
</xs:sequence>
</xs:complexType>
</xs:element>
</xs:schema>';
go
create table STUDENT2_0
(
IDSTUDENT integer  identity(1000,1)  primary key,
      IDGROUP integer  foreign key  references GROUPS(IDGROUP),        
      NAME nvarchar(100), 
      BDAY  date,
      STAMP timestamp,
      INFO   xml(info_schema),    -- типизированный столбец XML-типа, данные должны соответствовать схеме
      FOTO  varbinary
)
---
insert into STUDENT2_0(IDGROUP, NAME, BDAY, INFO)
values (1, 'Петя Сидоров', '07.07.1999',
'<студент>
	<паспорт серия="МР" номер="22233333" дата = "09.09.2011"/>
	<телефон>444445</телефон>
	<адрес>
		<страна>Беларусь</страна>
		<город>Минск</город>
		<улица>Маяковского</улица>
		<дом>190</дом>
		<квартира>230</квартира>
	</адрес>
</студент>'
)
--------с ошибочкой
insert into STUDENT2_0(IDGROUP, NAME, BDAY, INFO)
values (1, 'Петя Петров', '07.07.1999',
'<студент>
	<паспорт серия="МР" номер="22233333" дата = "09.09.2011"/>
	
	<адрес>
		<страна>Беларусь</страна>
		<город>Минск</город>
		<улица>Маяковского</улица>
		<дом>190</дом>
		<квартира>230</квартира>
	</адрес>
</студент>'
)