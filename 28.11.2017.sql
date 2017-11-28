use [_Maslintsyn]

alter table [dbo].[Сотрудники]
add [Статус] nvarchar(1) null
go

create trigger D_sot on [dbo].[Сотрудники]
instead of delete
as
begin
if (exists( select * from [dbo].[Заказы] as z inner join deleted as d
on z.КодСотрудника = d.КодСотрудника where [ДатаИсполнения] is not null)) 
	begin update s
	set s.[Статус]='a'
	from  [dbo].[Сотрудники] as s inner join
	deleted as v on v.КодСотрудника = s.КодСотрудника
	end
	
	else delete [dbo].[Сотрудники] from [dbo].[Сотрудники] as s inner join
	deleted as v on v.КодСотрудника = s.КодСотрудника
end
go

update [dbo].[Заказы]
set [ДатаРазмещения] = '01/01/2017' ,
[ДатаНазначения] = '01/01/2017' ,
[ДатаИсполнения] = null --'01/02/2017'
where [КодЗаказа] = 11111

delete from [dbo].[Сотрудники]
where [КодСотрудника] = 10
go

select k.Страна, p.Категория, year(z.ДатаИсполнения) as [Год], 
		MONTH(z.ДатаИсполнения) as [Месяц], 
		sum(n.Количество*n.Цена*(1-n.Скидка)) as [Сумма]
from [dbo].[Заказы] as z inner join [dbo].[Заказано] as n
on z.КодЗаказа = n.КодЗаказа inner join [dbo].[Клиенты] as k
on k.КодКлиента = z.КодКлиента inner join [dbo].[Товары] as t
on t.КодТовара = n.КодТовара inner join [dbo].[Типы] as p
on p.КодТипа = t.КодТипа
and z.ДатаИсполнения is not null
group by k.Страна, p.Категория,  year(z.ДатаИсполнения), MONTH(z.ДатаИсполнения)
go

declare kd cursor
dynamic scroll_locks
for 
	select k.Страна, p.Категория, year(z.ДатаИсполнения) as [Год], 
			MONTH(z.ДатаИсполнения) as [Месяц], 
			sum(n.Количество*n.Цена*(1-n.Скидка)) as [Сумма]
	from [dbo].[Заказы] as z inner join [dbo].[Заказано] as n
	on z.КодЗаказа = n.КодЗаказа inner join [dbo].[Клиенты] as k
	on k.КодКлиента = z.КодКлиента inner join [dbo].[Товары] as t
	on t.КодТовара = n.КодТовара inner join [dbo].[Типы] as p
	on p.КодТипа = t.КодТипа
	and z.ДатаИсполнения is not null
	group by k.Страна, p.Категория,  year(z.ДатаИсполнения), MONTH(z.ДатаИсполнения)
for update
go

open kd 
fetch next from kd 

update [dbo].[Заказано]
set
[Количество] = 150
where current of kd -- [КодЗаказа] = 258 and [КодТовара] = 2 
fetch next from kd
close kd 
deallocate kd