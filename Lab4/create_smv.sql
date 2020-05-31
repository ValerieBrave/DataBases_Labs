use master;
create database SMV_UNIVER
on primary
(name=N'SMV_UNIVER_mdf', filename = N'D:\DataBases\Lab4\SMV_UNIVER_mdf.mdf',
size = 5Mb, maxsize = 10Mb, filegrowth = 1Mb),
(name=N'SMV_UNIVER_ndf', filename = N'D:\DataBases\Lab4\SMV_UNIVER_ndf.ndf',
size = 5Mb, maxsize = 10Mb, filegrowth = 10%),
filegroup G1
(name=N'SMV_UNIVER11_ndf', filename = N'D:\DataBases\Lab4\SMV_UNIVER11_ndf.ndf',
size = 10Mb, maxsize = 15Mb, filegrowth = 1Mb),
(name=N'SMV_UNIVER12_ndf', filename = N'D:\DataBases\Lab4\SMV_UNIVER12_ndf.ndf',
size = 2Mb, maxsize = 5Mb, filegrowth = 1Mb),
filegroup G2
(name=N'SMV_UNIVER21_ndf', filename = N'D:\DataBases\Lab4\SMV_UNIVER21_ndf.ndf',
size = 5Mb, maxsize = 10Mb, filegrowth = 1Mb),
(name=N'SMV_UNIVER22_ndf', filename = N'D:\DataBases\Lab4\SMV_UNIVER22_ndf.ndf',
size = 2Mb, maxsize = 5Mb, filegrowth = 1Mb)
log on
(name=N'SMV_UNIVER_log', filename = N'D:\DataBases\Lab4\SMV_UNIVER_log.ldf',
size = 5Mb, maxsize = UNLIMITED, filegrowth = 1Mb)