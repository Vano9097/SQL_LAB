use [_Maslintsyn]
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
order by 2 desc

go