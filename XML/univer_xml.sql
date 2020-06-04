use SMV_UNIVER
go;

---------------------#1 XML-�������� � ������ PATH �� ������� TEACHER ��� �������������� ������� ����
 select PULPIT [�������/@���], 
		TEACHER [�������/�������������/@���],
		TEACHER_NAME [�������/�������������/���/data()],
		GENDER [�������/�������������/���/data()]
		from TEACHER where PULPIT like '����'
 for xml path(''), root ('�������������_����'), elements

 --------------------#2 ����
 select AUDITORIUM_TYPENAME, AUDITORIUM_NAME,  AUDITORIUM_CAPACITY 
 from AUDITORIUM inner join AUDITORIUM_TYPE
 on AUDITORIUM.AUDITORIUM_TYPE like AUDITORIUM_TYPE.AUDITORIUM_TYPE
 where AUDITORIUM_TYPE.AUDITORIUM_TYPE like '��'
 for xml auto

 --------------------#3 ���������� ����� �� XML-���������
 declare @h int = 0, @x varchar(2000) = 
	   ' <?xml version="1.0" encoding="windows-1251" ?>
       <SUBJECTS> 
       <subject SUBJECT="���" SUBJECT_NAME="������ ������ ����������" PULPIT="����" /> 
       <subject SUBJECT="����" SUBJECT_NAME="������������ ������� � ����" PULPIT="�����" /> 
       <subject SUBJECT="����" SUBJECT_NAME="������������ ��������� � �������" PULPIT="�����"/>  
       </SUBJECTS>';
exec sp_xml_preparedocument @h output, @x; -- �������� ����������

insert SUBJECT select [SUBJECT], [SUBJECT_NAME], [PULPIT]
from openxml(@h, '/SUBJECTS/subject', 0)
with ([SUBJECT] char(10), [SUBJECT_NAME] varchar(100), [PULPIT] char(20))
    exec sp_xml_removedocument @h; 
--delete SUBJECT where SUBJECT like '���'
--delete SUBJECT where SUBJECT like '����'
--delete SUBJECT where SUBJECT like '����'


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
<address coord="�����, �������� 32, ��4"/>
</passport>'
declare @pass2 char(1000) = 
'<passport number="MP9644292">
<person_id id="0065438722"/>
<address coord="�����, �������� 7, ��9"/>
</passport>'
insert into #STUDENT_TEMP(idstudent, idgroup, name, passport_data)
values (1081, 4, '������� ����� ����������', @pass1),
		(1082, 5, '������ ���� ���������', @pass2)
--
select * from #STUDENT_TEMP
select name [���], 
		passport_data.value('(/passport/@number)[1]','varchar(10)') [����� ��������],
		passport_data.value('(/passport/person_id/@id)[1]','varchar(20)') [������ �����],
		passport_data.value('(/passport/address/@coord)[1]','varchar(40)') [��������]
		from #STUDENT_TEMP
---
update #STUDENT_TEMP set passport_data = '<passport number="MP9644292">
<person_id id="0065438722"/>
<address coord="�����, �������� 7, ��9"/>
</passport>'
where passport_data.value('(/passport/@number)[1]', 'varchar(10)') like 'MP9644292'

----------------------#5 
create xml schema collection info_schema as 
N'<?xml version="1.0" encoding="utf-16" ?>
  <xs:schema attributeFormDefault="unqualified" 
  elementFormDefault="qualified"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xs:element name="�������">
		<xs:complexType>
		<xs:sequence>
		<xs:element name="�������" maxOccurs="1" minOccurs="1">
			<xs:complexType>
				<xs:attribute name="�����" type="xs:string" use="required" />
				<xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
				<xs:attribute name="����"  use="required">
				<xs:simpleType>  
					<xs:restriction base ="xs:string">
						<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
					</xs:restriction> 	
					</xs:simpleType>
				</xs:attribute>
			</xs:complexType>
		</xs:element>
		<xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
		<xs:element name="�����">   <xs:complexType><xs:sequence>
		<xs:element name="������" type="xs:string" />
		<xs:element name="�����" type="xs:string" />
		<xs:element name="�����" type="xs:string" />
		<xs:element name="���" type="xs:string" />
		<xs:element name="��������" type="xs:string" />
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
      INFO   xml(info_schema),    -- �������������� ������� XML-����, ������ ������ ��������������� �����
      FOTO  varbinary
)
---
insert into STUDENT2_0(IDGROUP, NAME, BDAY, INFO)
values (1, '���� �������', '07.07.1999',
'<�������>
	<������� �����="��" �����="22233333" ���� = "09.09.2011"/>
	<�������>444445</�������>
	<�����>
		<������>��������</������>
		<�����>�����</�����>
		<�����>�����������</�����>
		<���>190</���>
		<��������>230</��������>
	</�����>
</�������>'
)
--------� ���������
insert into STUDENT2_0(IDGROUP, NAME, BDAY, INFO)
values (1, '���� ������', '07.07.1999',
'<�������>
	<������� �����="��" �����="22233333" ���� = "09.09.2011"/>
	
	<�����>
		<������>��������</������>
		<�����>�����</�����>
		<�����>�����������</�����>
		<���>190</���>
		<��������>230</��������>
	</�����>
</�������>'
)