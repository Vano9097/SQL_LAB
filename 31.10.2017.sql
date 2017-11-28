use [_Name]
-- изменить 30 34 40 "1 по "+

go
create function exam(@k int)
returns int
begin
return(select cast(substring(t.[ЕдиницаИзмерения], 1, PATINDEX('% %', t.[ЕдиницаИзмерения]) - 1) as int)
	   from [dbo].[Товары] as T
	   where t.КодТовара = @k
)
end
go
select [dbo].[exam](30)
go

create function TovPos (@k int)
returns table 

return(
	select t.Марка, t.НаСкладе*t.Цена as Склад, 
			sum(z.Количество*z.Цена*(1-z.Скидка)) as Продано,
			sum(z.Количество*t.Цена/dbo.exam(t.КодТовара)) as Затраты,
			sum(z.Количество*z.Цена*(1-z.Скидка)) - sum(z.Количество*t.Цена/dbo.exam(t.КодТовара)) as Прибыль	
	from  [dbo].[Товары] as t inner join [dbo].[Заказано] as z 
	on t.КодТовара = z.КодТовара and t.КодПоставщика = @k
	group by t.Марка, t.НаСкладе*t.Цена
)
go

select * from TovPos(8)

go

create function TovPosYM (@k int,@y int, @m int)
returns table 

return(
	select t.Марка, t.НаСкладе*t.Цена as Склад, 
			sum(z.Количество*z.Цена*(1-z.Скидка)) as Продано,
			sum(z.Количество*t.Цена/dbo.exam(t.КодТовара)) as Затраты,
			sum(z.Количество*z.Цена*(1-z.Скидка)) - sum(z.Количество*t.Цена/dbo.exam(t.КодТовара)) as Прибыль	
	from [dbo].[Заказы], [dbo].[Товары] as t inner join [dbo].[Заказано] as z 
	on t.КодТовара = z.КодТовара and t.КодПоставщика = @k
	inner join [dbo].[Заказы] as zak on z.КодЗаказа = zak.КодЗаказа and zak.ДатаИсполнения is not null and
	YEAR(zak.ДатаИсполнения) = @y and Month(zak.ДатаИсполнения) = @m
	group by t.Марка, t.НаСкладе*t.Цена
	order by 5 desc
)
go

select * from TovPosYM(8,1997,7)
go
create function TovPosYMPost (@y int, @m int)
returns table 

return(
	select t.КодПоставщика, t.Марка, t.НаСкладе*t.Цена as Склад, 
			sum(z.Количество*z.Цена*(1-z.Скидка)) as Продано,
			sum(z.Количество*t.Цена/dbo.exam(t.КодТовара)) as Затраты,
			sum(z.Количество*z.Цена*(1-z.Скидка)) - sum(z.Количество*t.Цена/dbo.exam(t.КодТовара)) as Прибыль	
	from [dbo].[Заказы], [dbo].[Товары] as t inner join [dbo].[Заказано] as z 
	on t.КодТовара = z.КодТовара
	inner join [dbo].[Заказы] as zak on z.КодЗаказа = zak.КодЗаказа and zak.ДатаИсполнения is not null and
	YEAR(zak.ДатаИсполнения) = @y and Month(zak.ДатаИсполнения) = @m
	group by t.КодПоставщика,t.Марка, t.НаСкладе*t.Цена

)
go
select * from TovPosYMPost(1997,7)