--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing


--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

with sunked as 				-- все затопленные корабли
	(select ship, class 
	from outcomes o left join ships s on o.ship=s.name 
	where result = 'sunk'
		union 
	select ship, class 
	from outcomes o left join classes c on o.ship=c.class 
	where result = 'sunk')

select c.class, 
		count(ship) as cnt_sunked
from classes c left join sunked s on c.class = s.class 
group by c.class

 				
--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. 
--Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

with min_data_launched as				-- минимальный год спуска на воду кораблей в каждом классе
(select class, min(launched) as min_data
from ships s 
group by class)

select c.class,
		case 
			when s.launched is null then min.min_data		
			else s.launched
		end as launched_first
from classes c left join ships s on c.class = s.name					-- головные корабли в классах
				left join min_data_launched min on c.class = min.class 	-- таблица с минимальными годами спуска на воду кораблей в каждом классе

				
--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

with sunked_ships as 				-- все затопленные корабли
	(select ship, class 
	from outcomes o left join ships s on o.ship=s.name 
	where result = 'sunk'
		union 
	select ship, class 
	from outcomes o left join classes c on o.ship=c.class 
	where result = 'sunk'),
	
all_ships as 				-- все корабли, по которым можно определить класс
	(select name, class 
	from ships
		union 
	select ship as name, ship as class -- головные корабли из Outcomes
	from outcomes
	where ship in (select class from classes))

select c.class, 
		count(ship) as cnt_sunked
from classes c join sunked_ships s on c.class = s.class 
where c.class in (select class 
					from all_ships
					group by class
					having count(*) >= 3)
group by c.class				
				

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

-- т.к. число орудий и водоизмещение находятся в таблице classes, нам нужны только те корабли, по которым можно определить класс

with all_ships as 				-- все корабли, по которым можно определить класс
	(select name, class 
	from ships
		union 
	select ship as name, ship as class -- головные корабли из Outcomes
	from outcomes
	where ship in (select class from classes)),
	
displ_numguns as 				-- определяем максимальное число орудий в каждой группе по весу водоизмещения
	(select displacement,
			max(numGuns) as max_guns
	from classes	
	group by displacement)
	
select al.name, 
		d.displacement,
		d.max_guns
from classes c join all_ships al on c.class = al.class
				join displ_numguns d on d.displacement = c.displacement and d.max_guns = c.numGuns 
order by c.displacement desc

				
--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
				
with pc_product as 
(select maker, pc.model, pc.ram, pc.speed
from product join pc on product.model = pc.model),

pc_selected as 
(select model, maker, ram, speed
from pc_product
where ram = (select min(ram)
			from pc_product)
	and 
	speed = (select max(speed)
				from pc_product
				where ram = (select min(ram)
							from pc_product)))

select distinct(maker)
from product
where type = 'Printer' 
	and maker in (select maker from pc_selected)
