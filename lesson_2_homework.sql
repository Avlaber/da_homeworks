--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- ������� 1: ������� name, class �� ��������, ���������� ����� 1920

select name, class
from ships
where launched > 1920

-- ������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942

select name, class
from ships
where launched > 1920 and launched <= 1942

-- ������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class

select class, count(name)
from ships
group by class
order by 2 desc

-- ������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. (������� classes)

select class, country
from classes
where bore >= 16

-- ������� 5: ������� �������, ����������� � ��������� � �������� ��������� (������� Outcomes, North Atlantic). �����: ship.

select ship 
from outcomes
where result = 'sunk'
	and battle = 'North Atlantic'

-- ������� 6: ������� �������� (ship) ���������� ������������ �������

select o.ship
from outcomes o join battles b on o.battle = b.name
where result = 'sunk' 
	and date = (select max(date)
		   from outcomes o join battles b on o.battle = b.name
		   where result = 'sunk')

-- ������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������

select o.ship, s.class
from outcomes o join battles b on o.battle = b.name
		left join ships s on o.ship = s.name
where result = 'sunk' 
	and date = (select max(date)
		   from outcomes o join battles b on o.battle = b.name
		   where result = 'sunk')

-- ������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class

select o.ship, c.class
from outcomes o join battles b on o.battle = b.name
		left join ships s on o.ship = s.name
		left join classes c on s.class = c.class
where result = 'sunk' 
	and bore >= 16
				
-- ������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class

select class
from classes
where country = 'USA'
		
-- ������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). �����: name, class
		
select s.name, s.class
from classes c join ships s on s.class = c.class
where country = 'USA'		
		