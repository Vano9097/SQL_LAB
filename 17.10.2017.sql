use [_Maslintsyn]
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
order by 2 desc

go