/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
SELECT TOP 1000 [КодДоставки]
      ,[Название]
      ,[Телефон]
  FROM [_Maslintsyn].[dbo].[Доставка]
  go 
  alter table [dbo].[Доставка]
  add constraint pk_доставка
  primary key([КодДоставки])
  go 

   alter table [dbo].[Поставщики]
  add constraint pk_поставщики
  primary key([КодПоставщика])
  go
    alter table [dbo].[Типы]
  add constraint pk_типы
  primary key([КодТипа])
  go
  
  alter table [dbo].[Товары]
  add constraint pk_товары
  primary key([КодТовара])

  go
  alter table [dbo].[Сотрудники]
  add constraint pk_сотрудники
  primary key([КодСотрудника])
  go
    alter table [dbo].[Поставщики]
  add constraint pk_поставщики
  primary key([КодПоставщика])
  go
  alter table [dbo].[Заказы]
  add constraint pk_заказы
  primary key([КодЗаказа])
  go
  alter table [dbo].[Клиенты]
  add constraint uk_клиенты
  unique ([КодКлиента])
  go
  alter table [dbo].[Заказано]
  add [НомерЗаписи] int identity(1,1) primary key
  go
  FROM  [dbo].[Заказано]
  go
  alter table [dbo].[Заказано]
  add constraint fk_товары
  foreign key ([КодТовара]) references [dbo].[Товары]([КодТовара])
  go
 alter table [dbo].[Заказано]
  add constraint fk_заказ
  foreign key ([КодЗаказа]) references [dbo].[Заказы]([КодЗаказа])











  go


  alter table [dbo].[Заказы]
  add constraint fk_клиенты
  foreign key ([КодКлиента]) references [dbo].[Клиенты]([КодКлиента])
  go
  alter table [dbo].[Заказы]
  add constraint fk_сотрудники
  foreign key ([КодСотрудника]) references [dbo].[Сотрудники]([КодСотрудника])
  go
    alter table [dbo].[Заказы]
  add constraint fk_доставка
  foreign key ([Доставка]) references [dbo].[Доставка]([КодДоставки])

  /*сотрудники*/

    alter table [dbo].[Сотрудники]
  add constraint fk_сотрудники_под
  foreign key ([Подчиняется]) references [dbo].[Сотрудники]([КодСотрудника])
  go

    /*товары*/

    alter table [dbo].[Товары]
  add constraint fk_типы
  foreign key ([КодТипа]) references [dbo].[Типы]([КодТипа])
  go

  alter table [dbo].[Товары]
  add constraint fk_типы_постав
  foreign key ([КодПоставщика]) references [dbo].[Поставщики]([КодПоставщика])
  go