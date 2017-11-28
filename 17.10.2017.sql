use [_Maslintsyn]
--1a
go
declare @m int, @y int
set @m = 12
set @y = 1997

select p.���������, sum(z.���� * z.���������� * (1 - z.������)) as summ
from  [dbo].[��������] as z, [dbo].[������] as y, [dbo].[����] as p,
		[dbo].[������] as t 
where z.��������� = y.��������� and z.��������� = t.��������� and 
		p.������� = t.������� and
		@m = Month(y.��������������) and @y=YEAR(y.��������������)
group by p.���������
order by 1 desc
go
--1b
create view CaMaSu 
as
select p.���������, t.�����, sum(z.���� * z.���������� * (1 - z.������)) as sr --, count(*) as r
from  [dbo].[��������] as z, [dbo].[������] as y, [dbo].[����] as p,
		[dbo].[������] as t 
where z.��������� = y.��������� and z.��������� = t.��������� and 
		p.������� = t.�������
group by p.���������, t.�����

go
create view CaSred as
select [���������], AVG([sr]) sredsum
from [dbo].[CaMaSu]
group by [���������]
go
select a.*, b.sredsum
from  [dbo].[CaMaSu] as a, [dbo].[CaSred] as b
where a.���������=b.��������� and a.sr>b.sredsum
go

-- 1c
create view SumYear
as
select s.�������������, s.�������, Year(y.��������������) as ���, sum(z.���� * z.���������� * (1 - z.������)) as summ --, count(*) as r
from  [dbo].[��������] as z, [dbo].[������] as y, [dbo].[����������] as s
where z.��������� = y.��������� and y.������������� = s.������������� and y.�������������� is not null
group by s.�������������,s.�������, Year(y.��������������)
go


create view MaxYear
as
select c.���, max(c.summ) as maxsumm
from SumYear as c
group by c.���
go

select d.*
from SumYear as d, MaxYear as m
where d.summ = m.maxsumm