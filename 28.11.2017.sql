use [_Maslintsyn]

alter table [dbo].[����������]
add [������] nvarchar(1) null
go

create trigger D_sot on [dbo].[����������]
instead of delete
as
begin
if (exists( select * from [dbo].[������] as z inner join deleted as d
on z.������������� = d.������������� where [��������������] is not null)) 
	begin update s
	set s.[������]='a'
	from  [dbo].[����������] as s inner join
	deleted as v on v.������������� = s.�������������
	end
	
	else delete [dbo].[����������] from [dbo].[����������] as s inner join
	deleted as v on v.������������� = s.�������������
end
go

update [dbo].[������]
set [��������������] = '01/01/2017' ,
[��������������] = '01/01/2017' ,
[��������������] = null --'01/02/2017'
where [���������] = 11111

delete from [dbo].[����������]
where [�������������] = 10
go

select k.������, p.���������, year(z.��������������) as [���], 
		MONTH(z.��������������) as [�����], 
		sum(n.����������*n.����*(1-n.������)) as [�����]
from [dbo].[������] as z inner join [dbo].[��������] as n
on z.��������� = n.��������� inner join [dbo].[�������] as k
on k.���������� = z.���������� inner join [dbo].[������] as t
on t.��������� = n.��������� inner join [dbo].[����] as p
on p.������� = t.�������
and z.�������������� is not null
group by k.������, p.���������,  year(z.��������������), MONTH(z.��������������)
go

declare kd cursor
dynamic scroll_locks
for 
	select k.������, p.���������, year(z.��������������) as [���], 
			MONTH(z.��������������) as [�����], 
			sum(n.����������*n.����*(1-n.������)) as [�����]
	from [dbo].[������] as z inner join [dbo].[��������] as n
	on z.��������� = n.��������� inner join [dbo].[�������] as k
	on k.���������� = z.���������� inner join [dbo].[������] as t
	on t.��������� = n.��������� inner join [dbo].[����] as p
	on p.������� = t.�������
	and z.�������������� is not null
	group by k.������, p.���������,  year(z.��������������), MONTH(z.��������������)
for update
go

open kd 
fetch next from kd 

update [dbo].[��������]
set
[����������] = 150
where current of kd -- [���������] = 258 and [���������] = 2 
fetch next from kd
close kd 
deallocate kd