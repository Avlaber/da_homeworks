--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing


--task13 (lesson3)
--������������ �����: ������� ������ ���� ��������� � ������������� � ��������� ���� �������� (pc, printer, laptop). �������: model, maker, type

select model, maker, type 
from product			


--task14 (lesson3)
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", � ��������� - "0"

select *,
	case  
		when price > (select avg(price) from pc) then '1'
		else '0'
	end as flag
from printer


--task15 (lesson3)
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)

select name
from ships
where class is null


--task16 (lesson3)
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����

with launched as 
(select launched
from ships),

date_battles as
(select *,  date_part('year', date) as year_battle
from battles)

select name, year_battle
from date_battles
where year_battle <> all (select launched from launched)


--task17 (lesson3)
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships

select battle
from ships s join outcomes o on s.name = o.ship
where class = 'Kongo'


--task1  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_300) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ > 300 
-- �� view ��� �������: model, price, flag

create view all_products_flag_300 as 

with all_products as
(select model, price 
 from pc
  union all 
 select model, price  
 from printer
  union all 
 select model, price 
 from laptop) 

select p.model, 
       price, 
       case 
           when price > 300 then '1'
           else '0'
       end as flag
from product p join all_products on p.model = all_products.model
; 

select * 
from all_products_flag_300


--task2  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_avg_price) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ c������ 
-- �� view ��� �������: model, price, flag

create view all_products_flag_avg_price as 

with all_products as
(select model, price 
 from pc
  union all 
 select model, price  
 from printer
  union all 
 select model, price 
 from laptop) 

select p.model, 
       price, 
       case 
           when price > (select avg(price) from all_products) then '1'
           else '0'
       end as flag
from product p join all_products on p.model = all_products.model
; 

select * 
from all_products_flag_avg_price


--task3  (lesson4)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

with product_printer as
(select p.model, price, maker
from product p join printer on p.model = printer.model)

select distinct(model)
from product_printer
where maker = 'A'
	and price > (select avg(price) 
				from product_printer
				where maker in ('D', 'C'))


--task4 (lesson4)
-- ������������ �����: ������� ��� ������ ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

with all_products as
(select model, price 
 from pc
  union all 
 select model, price  
 from printer
  union all 
 select model, price 
 from laptop) 

select distinct(p.model)
from product p join all_products on p.model = all_products.model
where maker = 'A'
	and price > (select avg(price) 
				from product p join printer on p.model = printer.model
				where maker in ('D', 'C'))
				
				
--task5 (lesson4)
-- ������������ �����: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (printer & laptop & pc)

-- ������������ ��������� �� ���� ������ ������ ��� ����������� (union)
				
with all_products as
(select model, price 
 from pc
  union 
 select model, price  
 from printer
  union 
 select model, price 
 from laptop) 
 
select avg(price)
from product p join all_products on p.model = all_products.model
where maker = 'A'
				
--task6 (lesson4)
-- ������������ �����: ������� view � ����������� ������� (�������� count_products_by_makers) �� ������� �������������. �� view: maker, count

create view count_products_by_makers as

select maker, count(*)
from product
group by maker
order by 1;

select * 
from count_products_by_makers


--task7 (lesson4)
-- �� ����������� view (count_products_by_makers) ������� ������ � colab (X: maker, y: count)

������ � colab �� ������:
https://colab.research.google.com/drive/17BWziSPmQCCe5qEAuangRf8hKyjsQW4N?usp=sharing

������ �� ������ � ����� � ��������:
https://colab.research.google.com/drive/17BWziSPmQCCe5qEAuangRf8hKyjsQW4N#scrollTo=toXcLgy0jGxZ&line=1&uniqifier=1


--task8 (lesson4)
-- ������������ �����: ������� ����� ������� printer (�������� printer_updated) � ������� �� ��� ��� �������� ������������� 'D'

create table printer_updated as

select * 
from printer
where model not in (select model
					from product
					where type = 'Printer'
						and maker = 'D');
					
select *
from printer_updated


--task9 (lesson4)
-- ������������ �����: ������� �� ���� ������� (printer_updated) view � �������������� �������� ������������� (�������� printer_updated_with_makers)

create view printer_updated_with_makers as

select pup.*, p.maker
from printer_updated pup join product p on pup.model = p.model;

select *
from printer_updated_with_makers


--task10 (lesson4)
-- �������: ������� view c ����������� ����������� �������� � ������� ������� (�������� sunk_ships_by_classes)
-- �� view: count, class (���� �������� ������ ���/IS NULL, �� �������� �� 0)

create view sunk_ships_by_classes as

with sunked as 				-- ��� ����������� �������
	(select ship, class 
	from outcomes o left join ships s on o.ship=s.name 
	where result = 'sunk'
		union 
	select ship, class 
	from outcomes o left join classes c on o.ship=c.class 
	where result = 'sunk')
	
select count(ship) as count,
    	case 
		    when class is null then '0'
		    else class
		end as class
from sunked
group by class;

select *
from sunk_ships_by_classes


--task11 (lesson4)
-- �������: �� ����������� view (sunk_ships_by_classes) ������� ������ � colab (X: class, Y: count)

������ �� ������ � ����� � ��������:
https://colab.research.google.com/drive/17BWziSPmQCCe5qEAuangRf8hKyjsQW4N#scrollTo=53L3RtCq5FCF&line=3&uniqifier=1


--task12 (lesson4)
-- �������: ������� ����� ������� classes (�������� classes_with_flag) � �������� � ��� flag: ���� ���������� ������ ������ ��� ����� 9 - �� 1, ����� 0

create table classes_with_flag as

select *,
	   case 
	       when numguns >= 9 then '1'
	       else '0'
	   end as flag    
from classes;

select *
from classes_with_flag


--task13 (lesson4)
-- �������: ������� ������ � colab �� ������� classes � ����������� ������� �� ������� (X: country, Y: count)

������ �� ������ � ����� � ��������:
https://colab.research.google.com/drive/17BWziSPmQCCe5qEAuangRf8hKyjsQW4N#scrollTo=sHjYUC368DBq&line=3&uniqifier=1


--task14 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ���������� � ����� "O" ��� "M".

with all_ships as
(select name
from ships
union
select ship
from outcomes
order by name)

select count(*)
from all_ships
where name like 'O%'
	or name like 'M%'

	
--task15 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ������� �� ���� ����.

with all_ships as
(select name
from ships
union
select ship
from outcomes
order by name)

select count(*)
from all_ships
where name like '% %' 
	 and name not like '% % %'


--task16 (lesson4)
-- �������: ��������� ������ � ����������� ���������� �� ���� �������� � ����� ������� (X: year, Y: count)
	 
������ �� ������ � ����� � ��������:
https://colab.research.google.com/drive/17BWziSPmQCCe5qEAuangRf8hKyjsQW4N#scrollTo=z9tcOUoC9AK7&line=8&uniqifier=1
	 
	 
