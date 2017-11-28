use [_Maslintsyn]
go
create proc ZakSot @fam varchar(100) 
as
select  s.КодСотрудника, s.Фамилия, z.КодЗаказа, z.ДатаИсполнения from [dbo].[Сотрудники] as s 
inner join [dbo].[Заказы] as z on 
z.КодСотрудника = s.КодСотрудника
and s.Фамилия = @fam and (not z.ДатаИсполнения is Null)
go
exec ZakSot 'Белова'
go
alter trigger ZapSkl on [dbo].[Заказано] 
instead of insert, update 
as
begin
declare @kt int, @k int, @ks int
select @kt = [КодТовара], @k = [Количество] from inserted
select @ks = [НаСкладе]*[dbo].exam(@kt) from [dbo].[Товары] as t where t.КодТовара = @kt

if @k<=@ks 
begin if not exists(select * from deleted)
	insert into [dbo].[Заказано]([КодЗаказа],[КодТовара],[Цена],[Количество],[Скидка])
			select [КодЗаказа],[КодТовара],
			[Цена],[Количество],[Скидка] from inserted
	else 
		update [dbo].[Заказано]
			set [КодЗаказа] = i.[КодЗаказа],
			[КодТовара] = i.[КодТовара],
			[Цена] = i.[Цена],
			[Количество] = i.[Количество],
			[Скидка] = i.[Скидка]
			from inserted as i, deleted as d, [dbo].[Заказано] as z where i.[НомерЗаписи] = d.[НомерЗаписи] and i.[НомерЗаписи] = z.[НомерЗаписи] 
end
else raiserror('Заказ превышает запасы',11,1)
end
go
insert into [dbo].[Заказано]([КодЗаказа],[КодТовара],
[Цена],[Количество],[Скидка])
values(11111,1,50,20,0.5)
go
update [dbo].[Заказано] 
set [Количество] = 0
where [НомерЗаписи]=2170