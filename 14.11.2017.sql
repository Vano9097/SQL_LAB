use [_Maslintsyn]
go
create proc ZakSot @fam varchar(100) 
as
select  s.�������������, s.�������, z.���������, z.�������������� from [dbo].[����������] as s 
inner join [dbo].[������] as z on 
z.������������� = s.�������������
and s.������� = @fam and (not z.�������������� is Null)
go
exec ZakSot '������'
go
alter trigger ZapSkl on [dbo].[��������] 
instead of insert, update 
as
begin
declare @kt int, @k int, @ks int
select @kt = [���������], @k = [����������] from inserted
select @ks = [��������]*[dbo].exam(@kt) from [dbo].[������] as t where t.��������� = @kt

if @k<=@ks 
begin if not exists(select * from deleted)
	insert into [dbo].[��������]([���������],[���������],[����],[����������],[������])
			select [���������],[���������],
			[����],[����������],[������] from inserted
	else 
		update [dbo].[��������]
			set [���������] = i.[���������],
			[���������] = i.[���������],
			[����] = i.[����],
			[����������] = i.[����������],
			[������] = i.[������]
			from inserted as i, deleted as d, [dbo].[��������] as z where i.[�����������] = d.[�����������] and i.[�����������] = z.[�����������] 
end
else raiserror('����� ��������� ������',11,1)
end
go
insert into [dbo].[��������]([���������],[���������],
[����],[����������],[������])
values(11111,1,50,20,0.5)
go
update [dbo].[��������] 
set [����������] = 0
where [�����������]=2170