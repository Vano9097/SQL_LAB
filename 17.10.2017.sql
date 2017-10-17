use [_Maslintsyn]
--1a
go
declare @m int, @y int
set @m = 12
set @y = 1997

select p.Категория, sum(z.Цена * z.Количество * (1 - z.Скидка)) as summ
from  [dbo].[Заказано] as z, [dbo].[Заказы] as y, [dbo].[Типы] as p,
		[dbo].[Товары] as t 
where z.КодЗаказа = y.КодЗаказа and z.КодТовара = t.КодТовара and 
		p.КодТипа = t.КодТипа and
		@m = Month(y.ДатаИсполнения) and @y=YEAR(y.ДатаИсполнения)
group by p.Категория
order by 1 desc
go
--1b
create view CaMaSu 
as
select p.Категория, t.Марка, sum(z.Цена * z.Количество * (1 - z.Скидка)) as sr --, count(*) as r
from  [dbo].[Заказано] as z, [dbo].[Заказы] as y, [dbo].[Типы] as p,
		[dbo].[Товары] as t 
where z.КодЗаказа = y.КодЗаказа and z.КодТовара = t.КодТовара and 
		p.КодТипа = t.КодТипа
group by p.Категория, t.Марка

go
create view CaSred as
select [Категория], AVG([sr]) sredsum
from [dbo].[CaMaSu]
group by [Категория]
go
select a.*, b.sredsum
from  [dbo].[CaMaSu] as a, [dbo].[CaSred] as b
where a.Категория=b.Категория and a.sr>b.sredsum
go

-- 1c
create view SumYear
as
select s.КодСотрудника, s.Фамилия, Year(y.ДатаИсполнения) as год, sum(z.Цена * z.Количество * (1 - z.Скидка)) as summ --, count(*) as r
from  [dbo].[Заказано] as z, [dbo].[Заказы] as y, [dbo].[Сотрудники] as s
where z.КодЗаказа = y.КодЗаказа and y.КодСотрудника = s.КодСотрудника and y.ДатаИсполнения is not null
group by s.КодСотрудника,s.Фамилия, Year(y.ДатаИсполнения)
go


create view MaxYear
as
select c.год, max(c.summ) as maxsumm
from SumYear as c
group by c.год
go

select d.*
from SumYear as d, MaxYear as m
where d.summ = m.maxsumm