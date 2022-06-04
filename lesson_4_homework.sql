--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing


--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

select model, maker, type 
from product			


--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *,
	case  
	    when price > (select avg(price) from pc) then '1'
	    else '0'
	end as flag
from printer


--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

select name
from ships
where class is null


--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду

with launched as 
	(select launched
	from ships),

date_battles as
	(select *,  
		date_part('year', date) as year_battle
	from battles)

select name, year_battle
from date_battles
where year_battle <> all (select launched from launched)


--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships

select battle
from ships s join outcomes o on s.name = o.ship
where class = 'Kongo'


--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300 
-- Во view три колонки: model, price, flag

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
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней 
-- Во view три колонки: model, price, flag

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
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with product_printer as
	(select p.model, 
		price, 
		maker
	from product p join printer on p.model = printer.model)

select distinct(model)
from product_printer
where maker = 'A'
	and price > (select avg(price) 
		     from product_printer
		     where maker in ('D', 'C'))


--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

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
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

-- уникальность проверила за счёт чистки дублей при объединении (union)
				
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
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers as

select maker, count(*)
from product
group by maker
order by 1;

select * 
from count_products_by_makers


--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

Доступ к colab по ссылке:
https://colab.research.google.com/drive/17BWziSPmQCCe5qEAuangRf8hKyjsQW4N?usp=sharing

Ссылка на ячейку с кодом и графиком:
https://colab.research.google.com/drive/17BWziSPmQCCe5qEAuangRf8hKyjsQW4N#scrollTo=toXcLgy0jGxZ&line=1&uniqifier=1


--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

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
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers as

select pup.*, p.maker
from printer_updated pup join product p on pup.model = p.model;

select *
from printer_updated_with_makers


--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes)
-- Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

create view sunk_ships_by_classes as

with sunked as 				-- все затопленные корабли
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
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

Ссылка на ячейку с кодом и графиком:
https://colab.research.google.com/drive/17BWziSPmQCCe5qEAuangRf8hKyjsQW4N#scrollTo=53L3RtCq5FCF&line=3&uniqifier=1


--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

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
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

Ссылка на ячейку с кодом и графиком:
https://colab.research.google.com/drive/17BWziSPmQCCe5qEAuangRf8hKyjsQW4N#scrollTo=sHjYUC368DBq&line=3&uniqifier=1


--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

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
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

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
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)
	 
Ссылка на ячейку с кодом и графиком:
https://colab.research.google.com/drive/17BWziSPmQCCe5qEAuangRf8hKyjsQW4N#scrollTo=z9tcOUoC9AK7&line=8&uniqifier=1
	 
	 
