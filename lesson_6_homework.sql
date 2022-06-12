--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing


--task3  (lesson6)
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model

with all_product as
(select maker, price, product.model
from product join pc on pc.model = product.model
union all
select maker, price, product.model
from product join printer on printer.model = product.model
union all
select maker, price, product.model
from product join laptop on laptop.model = product.model)


select pall.model
from all_product pall join product p on pall.model = p.model 
where price = (select max(price)
	      from all_product)
					

--task5  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code (union all) 
-- и сделать флаг (flag) по цене > максимальной по принтеру. 
-- Также добавить нумерацию (через оконные функции) по каждой категории продукта в порядке возрастания цены (price_index). По этому price_index сделать индекс

create table all_products_with_index_task5 as

with all_products as
(select code, model, price
from pc
union all
select code, model, price
from printer
union all
select code, model, price
from laptop)

select pall.*,
	case 	
		when price > (select max(price) from printer) then '1'
		else '0'
	end as flag,
	type,
	row_number() over (partition by type order by price asc) as price_index
from all_products pall join product p on pall.model = p.model

create index price_index_idx on all_products_with_index_task5(price_index);


--task1  (lesson6, дополнительно)
-- SQL: Создайте таблицу с синтетическими данными (10000 строк, 3 колонки, все типы int) и заполните ее случайными данными от 0 до 1 000 000. Проведите EXPLAIN операции и сравните базовые операции.

-- создаём таблицу с 3-мя колонками с типами данных int

CREATE TABLE randomtable (
    one int NOT NULL,
    two int NOT NULL,
    three int NOT NULL
);		

-- заполняем таблицу случайными данными от 0 до 1000000

INSERT INTO randomtable
SELECT
   (random()*1000000)::int,
   (random()*1000000)::int,
   (random()*1000000)::int   
FROM  
   generate_series (0,1000000);
   
EXPLAIN select * from randomtable; 

Вывод:
Seq Scan on randomtable  (cost=0.00..15406.01 rows=1000001 width=12)


EXPLAIN select avg(one) from randomtable; 

Вывод:
Finalize Aggregate  (cost=11614.56..11614.57 rows=1 width=32)
  ->  Gather  (cost=11614.34..11614.55 rows=2 width=32)
        Workers Planned: 2
        ->  Partial Aggregate  (cost=10614.34..10614.35 rows=1 width=32)
              ->  Parallel Seq Scan on randomtable  (cost=0.00..9572.67 rows=416667 width=4)


EXPLAIN select sum(two) from randomtable; 

Вывод:
Finalize Aggregate  (cost=11614.55..11614.56 rows=1 width=8)
  ->  Gather  (cost=11614.34..11614.55 rows=2 width=8)
        Workers Planned: 2
        ->  Partial Aggregate  (cost=10614.34..10614.35 rows=1 width=8)
              ->  Parallel Seq Scan on randomtable  (cost=0.00..9572.67 rows=416667 width=4) 


EXPLAIN select sum(two) from randomtable group by three; 

Вывод:
GroupAggregate  (cost=128738.46..141255.11 rows=501664 width=12)
  Group Key: three
  ->  Sort  (cost=128738.46..131238.46 rows=1000001 width=8)
        Sort Key: three
        ->  Seq Scan on randomtable  (cost=0.00..15406.01 rows=1000001 width=8)
JIT:
  Functions: 7
  Options: Inlining false, Optimization false, Expressions true, Deforming true 


--task2 (lesson6, дополнительно)
-- GCP (Google Cloud Platform): Через GCP загрузите данные csv в базу PSQL по личным реквизитам (используя только bash и интерфейс bash) 

Alibaba Cloud не понимает команду psql, на любые попытки вызова/узнать/прописать путь отвечает: command not found
Сама команда на загрузку данных csv в базу:

COPY avocado FROM '/path/to/csv/avocado.csv' WITH (FORMAT csv);
