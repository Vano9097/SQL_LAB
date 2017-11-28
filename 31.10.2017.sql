use [_Name]
-- �������� 30 34 40 "1 �� "+

go
create function exam(@k int)
returns int
begin
return(select cast(substring(t.[����������������], 1, PATINDEX('% %', t.[����������������]) - 1) as int)
	   from [dbo].[������] as T
	   where t.��������� = @k
)
end
go
select [dbo].[exam](30)
go

create function TovPos (@k int)
returns table 

return(
	select t.�����, t.��������*t.���� as �����, 
			sum(z.����������*z.����*(1-z.������)) as �������,
			sum(z.����������*t.����/dbo.exam(t.���������)) as �������,
			sum(z.����������*z.����*(1-z.������)) - sum(z.����������*t.����/dbo.exam(t.���������)) as �������	
	from  [dbo].[������] as t inner join [dbo].[��������] as z 
	on t.��������� = z.��������� and t.������������� = @k
	group by t.�����, t.��������*t.����
)
go

select * from TovPos(8)

go

create function TovPosYM (@k int,@y int, @m int)
returns table 

return(
	select t.�����, t.��������*t.���� as �����, 
			sum(z.����������*z.����*(1-z.������)) as �������,
			sum(z.����������*t.����/dbo.exam(t.���������)) as �������,
			sum(z.����������*z.����*(1-z.������)) - sum(z.����������*t.����/dbo.exam(t.���������)) as �������	
	from [dbo].[������], [dbo].[������] as t inner join [dbo].[��������] as z 
	on t.��������� = z.��������� and t.������������� = @k
	inner join [dbo].[������] as zak on z.��������� = zak.��������� and zak.�������������� is not null and
	YEAR(zak.��������������) = @y and Month(zak.��������������) = @m
	group by t.�����, t.��������*t.����
	order by 5 desc
)
go

select * from TovPosYM(8,1997,7)
go
create function TovPosYMPost (@y int, @m int)
returns table 

return(
	select t.�������������, t.�����, t.��������*t.���� as �����, 
			sum(z.����������*z.����*(1-z.������)) as �������,
			sum(z.����������*t.����/dbo.exam(t.���������)) as �������,
			sum(z.����������*z.����*(1-z.������)) - sum(z.����������*t.����/dbo.exam(t.���������)) as �������	
	from [dbo].[������], [dbo].[������] as t inner join [dbo].[��������] as z 
	on t.��������� = z.���������
	inner join [dbo].[������] as zak on z.��������� = zak.��������� and zak.�������������� is not null and
	YEAR(zak.��������������) = @y and Month(zak.��������������) = @m
	group by t.�������������,t.�����, t.��������*t.����

)
go
select * from TovPosYMPost(1997,7)