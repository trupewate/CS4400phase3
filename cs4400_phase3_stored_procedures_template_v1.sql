-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase III: Stored Procedures & Views [v1] Wednesday, March 27, 2024 @ 5:20pm EST

-- Team 105
-- Sergei Novikov (snovikov6)
-- Gaurang Kamat (gkamat8)
-- Team Member Name (GT username)
-- Team Member Name (GT username)
-- Team Member Name (GT username)

-- Directions:
-- Please follow all instructions for Phase III as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'drone_dispatch';
drop database if exists drone_dispatch;
create database if not exists drone_dispatch;
use drone_dispatch;

-- -----------------------------------------------
-- table structures
-- -----------------------------------------------

create table users (
uname varchar(40) not null,
first_name varchar(100) not null,
last_name varchar(100) not null,
address varchar(500) not null,
birthdate date default null,
primary key (uname)
) engine = innodb;

create table customers (
uname varchar(40) not null,
rating integer not null,
credit integer not null,
primary key (uname)
) engine = innodb;

create table employees (
uname varchar(40) not null,
taxID varchar(40) not null,
service integer not null,
salary integer not null,
primary key (uname),
unique key (taxID)
) engine = innodb;

create table drone_pilots (
uname varchar(40) not null,
licenseID varchar(40) not null,
experience integer not null,
primary key (uname),
unique key (licenseID)
) engine = innodb;

create table store_workers (
uname varchar(40) not null,
primary key (uname)
) engine = innodb;

create table products (
barcode varchar(40) not null,
pname varchar(100) not null,
weight integer not null,
primary key (barcode)
) engine = innodb;

create table orders (
orderID varchar(40) not null,
sold_on date not null,
purchased_by varchar(40) not null,
carrier_store varchar(40) not null,
carrier_tag integer not null,
primary key (orderID)
) engine = innodb;

create table stores (
storeID varchar(40) not null,
sname varchar(100) not null,
revenue integer not null,
manager varchar(40) not null,
primary key (storeID)
) engine = innodb;

create table drones (
storeID varchar(40) not null,
droneTag integer not null,
capacity integer not null,
remaining_trips integer not null,
pilot varchar(40) not null,
primary key (storeID, droneTag)
) engine = innodb;

create table order_lines (
orderID varchar(40) not null,
barcode varchar(40) not null,
price integer not null,
quantity integer not null,
primary key (orderID, barcode)
) engine = innodb;

create table employed_workers (
storeID varchar(40) not null,
uname varchar(40) not null,
primary key (storeID, uname)
) engine = innodb;

-- -----------------------------------------------
-- referential structures
-- -----------------------------------------------

alter table customers add constraint fk1 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table employees add constraint fk2 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table drone_pilots add constraint fk3 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table store_workers add constraint fk4 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk8 foreign key (purchased_by) references customers (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk9 foreign key (carrier_store, carrier_tag) references drones (storeID, droneTag)
	on update cascade on delete cascade;
alter table stores add constraint fk11 foreign key (manager) references store_workers (uname)
	on update cascade on delete cascade;
alter table drones add constraint fk5 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table drones add constraint fk10 foreign key (pilot) references drone_pilots (uname)
	on update cascade on delete cascade;
alter table order_lines add constraint fk6 foreign key (orderID) references orders (orderID)
	on update cascade on delete cascade;
alter table order_lines add constraint fk7 foreign key (barcode) references products (barcode)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk12 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk13 foreign key (uname) references store_workers (uname)
	on update cascade on delete cascade;

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

insert into users values
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'),
('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'),
('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'),
('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28');

insert into customers values
('jstone5', 4, 40),
('sprince6', 5, 30),
('awilson5', 2, 100),
('lrodriguez5', 4, 60),
('bsummers4', 3, 110),
('cjordan5', 3, 50);

insert into employees values
('awilson5', '111-11-1111', 9, 46000),
('lrodriguez5', '222-22-2222', 20, 58000),
('tmccall5', '333-33-3333', 29, 33000),
('eross10', '444-44-4444', 10, 61000),
('hstark16', '555-55-5555', 20, 59000),
('echarles19', '777-77-7777', 3, 27000),
('csoares8', '888-88-8888', 26, 57000),
('agarcia7', '999-99-9999', 24, 41000),
('bsummers4', '000-00-0000', 17, 35000),
('fprefontaine6', '121-21-2121', 5, 20000);

insert into store_workers values
('eross10'),
('hstark16'),
('echarles19');

insert into stores values
('pub', 'Publix', 200, 'hstark16'),
('krg', 'Kroger', 300, 'echarles19');

insert into employed_workers values
('pub', 'eross10'),
('pub', 'hstark16'),
('krg', 'eross10'),
('krg', 'echarles19');

insert into drone_pilots values
('awilson5', '314159', 41),
('lrodriguez5', '287182', 67),
('tmccall5', '181633', 10),
('agarcia7', '610623', 38),
('bsummers4', '411911', 35),
('fprefontaine6', '657483', 2);

insert into drones values
('pub', 1, 10, 3, 'awilson5'),
('pub', 2, 20, 2, 'lrodriguez5'),
('krg', 1, 15, 4, 'tmccall5'),
('pub', 9, 45, 1, 'fprefontaine6');

insert into products values
('pr_3C6A9R', 'pot roast', 6),
('ss_2D4E6L', 'shrimp salad', 3),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ap_9T25E36L', 'antipasto platter', 4);

insert into orders values
('pub_303', '2024-05-23', 'sprince6', 'pub', 1),
('pub_305', '2024-05-22', 'sprince6', 'pub', 2),
('krg_217', '2024-05-23', 'jstone5', 'krg', 1),
('pub_306', '2024-05-22', 'awilson5', 'pub', 2);

insert into order_lines values
('pub_303', 'pr_3C6A9R', 20, 1),
('pub_303', 'ap_9T25E36L', 4, 1),
('pub_305', 'clc_4T9U25X', 3, 2),
('pub_306', 'hs_5E7L23M', 3, 2),
('pub_306', 'ap_9T25E36L', 10, 1),
('krg_217', 'pr_3C6A9R', 15, 2);

-- -----------------------------------------------
-- stored procedures and views
-- -----------------------------------------------

-- add customer
delimiter // 
create procedure add_customer
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_rating integer, in ip_credit integer)
sp_main: begin
	-- place your solution here
    
    -- perhaps we need to update the customer information  if it is present already in users and/or customers (update instread of insert)
    if ip_uname not in (select uname from customers) then
		insert into users values(ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
    end if;
    if ip_rating < 1 or ip_rating > 5 then leave sp_main; end if;
    
    -- the credit must always be >= the total orders the customer is currently waiting
    -- new customer has no orders yet, hence just make sure it is greater than zero I guess
    if ip_credit < 0 then leave sp_main; end if;
    
    if ip_uname not in (select uname from customers) then
		insert into customers values(ip_uname, ip_rating, ip_credit);
	end if;
    -- Sergei: add to two tables (users and customers)
end //
delimiter ;

-- add drone pilot
delimiter // 
create procedure add_drone_pilot
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_taxID varchar(40), in ip_service integer, 
    in ip_salary integer, in ip_licenseID varchar(40),
    in ip_experience integer)
sp_main: begin
	-- place your solution here
    
    if ip_uname not in (select uname from users) then
		insert into users values (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
	end if;
    
    if ip_uname not in (select uname from employees) then
		-- service is number of months they have worked, make sure it is non-negative
        if ip_service < 0 then leave sp_main; end if;
		insert into employees values (ip_uname, ip_taxID, ip_service, ip_salary);
	end if;
    if ip_uname in (select uname from store_workers) then leave sp_main; end if;
    if ip_uname in (select uname from drone_pilots) then leave sp_main; end if;
    if ip_licenseID in (select licenseID from drone_pilots) then leave sp_main; end if;
    
	insert into drone_pilots values (ip_uname, ip_licenseID, ip_experience);

end //
delimiter ;


-- add product
delimiter // 
create procedure add_product
	(in ip_barcode varchar(40), in ip_pname varchar(100),
    in ip_weight integer)
sp_main: begin
	-- place your solution here
    if ip_barcode in (select barcode from products) then leave sp_main; end if;
    if ip_weight < 0 then leave sp_main; end if;
    insert into products values (ip_barcode, ip_pname, ip_weight);
end //
delimiter ;

-- add drone
delimiter // 
create procedure add_drone
	(in ip_storeID varchar(40), in ip_droneTag integer,
    in ip_capacity integer, in ip_remaining_trips integer,
    in ip_pilot varchar(40))
sp_main: begin
	-- place your solution 
    if ip_storeId not in (select storeId from stores) then leave sp_main; end if;
    if ip_pilot in (select pilot from drones) then leave sp_main; end if;
    if (ip_storeID, ip_droneTag) in 
    (select storeID, droneTag from drones) then leave sp_main; end if;
    if ip_capacity <= 0 then leave sp_main; end if;
    if ip_remaining_trips < 0 then leave sp_main; end if;
    insert into drones values (ip_storeID, ip_droneTag, ip_capacity, ip_remaining_trips, ip_pilot);
end //
delimiter ;

-- increase customer credits
delimiter // 
create procedure increase_customer_credits
	(in ip_uname varchar(40), in ip_money integer)
sp_main: begin
	-- place your solution here
    Declare sum INT Default 0;
    if ip_uname not in (select uname from customers) then leave sp_main; end if;
    set sum = (select credit from customers where uname = ip_uname);
    set sum = sum + ip_money;
    update customers set credit = sum where uname = ip_uname;
end //
delimiter ;

-- swap drone control
delimiter // 
create procedure swap_drone_control
	(in ip_incoming_pilot varchar(40), in ip_outgoing_pilot varchar(40))
sp_main: begin
	-- place your solution here
    declare temp_pilot varchar(40);
    if ip_outgoing_pilot not in (select pilot from drones) then leave sp_main; end if;
    if ip_incoming_pilot in (select pilot from drones) then leave sp_main; end if;
    update drones set pilot = ip_incoming_pilot where pilot = ip_outgoing_pilot;
end //
delimiter ;

-- repair and refuel a drone
delimiter // 
create procedure repair_refuel_drone
	(in ip_drone_store varchar(40), in ip_drone_tag integer,
    in ip_refueled_trips integer)
sp_main: begin
	-- place your solution here
    declare rem_trips integer;
    if (ip_drone_store, ip_drone_tag) not in (select storeID, droneTag from drones) then leave sp_main; end if;
    set rem_trips = (select remaining_trips from drones where drones.storeID = ip_drone_store and drones.droneTag = ip_drone_tag);
    update drones set remaining_trips = rem_trips + ip_refueled_trips where drones.storeID = ip_drone_store and drones.droneTag = ip_drone_tag;
end //
delimiter ;

-- begin order

delimiter // 
create procedure begin_order
	(in ip_orderID varchar(40), in ip_sold_on date,
    in ip_purchased_by varchar(40), in ip_carrier_store varchar(40),
    in ip_carrier_tag integer, in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	-- place your solution here
    -- ip_orderID, ip_purchased_by, ip_barcode
    
    DECLARE pc_credits INTEGER;
    DECLARE pd_capacity INTEGER;
    
     IF NOT EXISTS (SELECT * FROM orders WHERE orderID = ip_orderID) THEN
       
       IF ip_price >= 0 AND ip_quantity > 0 THEN
       
			IF EXISTS (SELECT * FROM customers WHERE uname = ip_purchased_by) THEN
	   
				SET pc_credits = (SELECT credit FROM customers WHERE uname = ip_purchased_by);
                
                IF pc_credits >= (ip_quantity * ip_price) THEN
                
                IF EXISTS (SELECT * FROM drones WHERE droneTag = ip_carrier_tag AND storeID = ip_carrier_store) THEN
					
						SET pd_capacity = (SELECT capacity FROM drones WHERE droneTag = ip_carrier_tag AND storeID = ip_carrier_store);
                        
                       IF EXISTS (SELECT * FROM products WHERE barcode = ip_barcode) THEN
                        
                        IF pd_capacity >= (ip_quantity * (SELECT weight FROM products WHERE barcode = ip_barcode)) THEN
                        
								INSERT INTO orders (orderID, sold_on, purchased_by, carrier_store, carrier_tag)
								VALUES (ip_orderID, ip_sold_on, ip_purchased_by, ip_carrier_store, ip_carrier_tag);
                                
                                INSERT INTO order_lines (orderID, barcode, price, quantity)
                                VALUES (ip_orderID, ip_barcode, ip_price, ip_quantity);
								
								-- UPDATE customers SET credit = credit - (ip_price * ip_quantity) WHERE uname = ip_purchased_by;
                                
                                -- UPDATE drones SET capacity = capacity - (ip_quantity * (SELECT weight FROM products WHERE barcode = ip_barcode)) WHERE droneTag = ip_carrier_tag;
						END IF;
						END IF;
					END IF;
				END IF;
            
            END IF;
            
       END IF; 
			
	 END IF;
end //
delimiter ;

-- add order line
delimiter // 
create procedure add_order_line
	(in ip_orderID varchar(40), in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	-- place your solution here
    DECLARE pc_credits INTEGER;
    DECLARE pd_capacity INTEGER;
    
    IF EXISTS (SELECT * FROM orders WHERE orderID = ip_orderID) AND EXISTS(SELECT * FROM products WHERE barcode = ip_barcode) THEN
    
		IF NOT EXISTS (SELECT * from order_lines WHERE barcode = ip_barcode AND orderID = ip_orderID) THEN
        
			IF ip_price >= 0 AND ip_quantity > 0 THEN
				
                SET pc_credits = (SELECT credit FROM customers WHERE uname = (SELECT purchased_by FROM orders WHERE orderID = ip_orderID));
                
                IF pc_credits >= (ip_price * ip_quantity) THEN
                
					SET pd_capacity = (SELECT capacity FROM drones WHERE droneTag = (SELECT carrier_tag FROM orders WHERE orderID = ip_orderID) AND storeID = (SELECT carrier_store FROM orders WHERE orderID = ip_orderID));
                    
                    IF pd_capacity >= ip_quantity * (SELECT weight FROM products WHERE barcode = ip_barcode) THEN
                    
						INSERT INTO order_lines (orderID, barcode, price, quantity)
                        VALUES (ip_orderID, ip_barcode, ip_price, ip_quantity);
                        
                        -- UPDATE customers SET credit = credit - (ip_price * ip_quantity) WHERE uname = ip_purchased_by;
                    
                    END IF;
                
                END IF;
                
			END IF;
        END IF;
    END IF;
    
end //
delimiter ;

-- deliver order
delimiter // 
create procedure deliver_order
	(in ip_orderID varchar(40))
sp_main: begin
	-- place your solution here
    
end //
delimiter ;

-- cancel an order
delimiter // 
create procedure cancel_order
	(in ip_orderID varchar(40))
sp_main: begin
	-- place your solution here
    DECLARE custname VARCHAR(40);
    
    IF EXISTS(SELECT * FROM orders WHERE orderID = ip_orderID) THEN
		
        SET custname = (SELECT purchased_by FROM orders WHERE orderID = ip_orderID);
        
        UPDATE customers SET rating = GREATEST(rating - 1, 1) WHERE uname = custname;
        
        DELETE FROM order_lines WHERE orderID = ip_orderID;
        
		DELETE FROM orders WHERE orderID = ip_orderID;
        
    END IF;
end //
delimiter ;

-- display persons distribution across roles
create or replace view role_distribution (category, total) as
-- replace this select query with your solution
-- select 'col1', 'col2' from users;
select 'users', count(*) from users union
select 'customers', count(*) from customers union 
select 'employees', count(*) from employees union
select 'customer_employer_overlap', count(*) from customers inner join employees on customers.uname = employees.uname union
select 'drone_pilots', count(*) from drone_pilots union
select 'store_workers', count(*) from store_workers union
select 'other_employee_roles', count(*) from employees where uname not in (select uname from drone_pilots union select uname from store_workers);

-- display customer status and current credit and spending activity
create or replace view customer_credit_check (customer_name, rating, current_credit,
	credit_already_allocated) as
-- replace this select query with your solution
-- select 'col1', 'col2', 'col3', 'col4' from customers;
select uname, rating, credit, ifnull(sum(order_lines.price * quantity),0) from customers
left join orders on customers.uname = orders.purchased_by
left join order_lines on  order_lines.orderID = orders.orderID
group by uname;


-- display drone status and current activity
create or replace view drone_traffic_control (drone_serves_store, drone_tag, pilot,
	total_weight_allowed, current_weight, deliveries_allowed, deliveries_in_progress) as
-- replace this select query with your solution
-- select 'col1', 'col2', 'col3', 'col4', 'col5', 'col6', 'col7' from drones;

select storeID as 'drone_serves_store', droneTag as 'drone_tag', pilot, capacity as 'total_weight_allowed',
ifnull(sum(products.weight * order_lines.quantity),0) as 'current_weight', 
remaining_trips as 'deliveries_allowed', 
count(distinct orders.orderID)  as 'deliveries_in_progress' from drones
left join orders on drones.droneTag = orders.carrier_tag and drones.storeID = orders.carrier_store left join order_lines on orders.orderID = order_lines.orderID
left join products on products.barcode = order_lines.barcode group by drones.storeID, drones.droneTag;

-- display product status and current activity including most popular products
create or replace view most_popular_products (barcode, product_name, weight, lowest_price,
	highest_price, lowest_quantity, highest_quantity, total_quantity) as
-- replace this select query with your solution
-- select 'col1', 'col2', 'col3', 'col4', 'col5', 'col6', 'col7', 'col8' from products;
select products.barcode as 'barcode', pname as 'product_name', weight, min(price), max(price), 
ifnull(min(quantity), 0), ifnull(max(quantity), 0), ifnull(sum(quantity), 0) from products left join order_lines 
on order_lines.barcode = products.barcode group by barcode;

-- display drone pilot status and current activity including experience
create or replace view drone_pilot_roster (pilot, licenseID, drone_serves_store,
	drone_tag, successful_deliveries, pending_deliveries) as
-- replace this select query with your solution
-- select 'col1', 'col2', 'col3', 'col4', 'col5', 'col6' from drone_pilots;
select dp.uname as 'pilot', dp.licenseID, d.storeID as 'drone_serves_store',
d.droneTag as 'drone_tag', dp.experience as 'successful_deliveries', ifnull(o.pending_deliveries, 0)
from drone_pilots as dp
left join (select pilot, droneTag, storeID from drones) d on d.pilot = dp.uname
left join (select carrier_store, carrier_tag, count(orderID) as pending_deliveries from orders group by carrier_store, carrier_tag) o 
on o.carrier_store = d.storeId and o.carrier_tag = d.droneTag;


-- display store revenue and activity
create or replace view store_sales_overview (store_id, sname, manager, revenue,
	incoming_revenue, incoming_orders) as
-- replace this select query with your solution
select 'col1', 'col2', 'col3', 'col4', 'col5', 'col6' from stores;
select s.storeID, s.sname, s.revenue, o.incoming_revenue, s.manager, o.incoming_orders from stores as s
left join (select carrier_store, count(orders.orderID) as incoming_orders, sum(order_revenue) as incoming_revenue from orders
left join (select order_lines.orderID, sum(price * quantity) as order_revenue from order_lines group by order_lines.orderID) 
ol on orders.orderID = ol.orderID group by orders.carrier_store) 
o on o.carrier_store = s.storeID;


-- display the current orders that are being placed/in progress
create or replace view orders_in_progress (orderID, cost, num_products, payload,
	contents) as
-- select 'col1', 'col2', 'col3', 'col4', 'col5' from orders;
SELECT
    o.orderID,
    SUM(d.price * d.quantity) AS cost,
    COUNT(d.orderID) AS num_products,
    SUM(p.weight * d.quantity) AS payload,
    GROUP_CONCAT(DISTINCT p.pname ORDER BY p.pname ASC SEPARATOR ',') AS contents
FROM
    orders o
JOIN
    order_lines d ON o.orderID = d.orderID
JOIN
    products p ON d.barcode = p.barcode
GROUP BY
    o.orderID;

-- remove customer
delimiter // 
create procedure remove_customer
	(in ip_uname varchar(40))
sp_main: begin
    IF NOT EXISTS (SELECT * FROM orders WHERE purchased_By = ip_uname) THEN
        -- Remove the customer
        DELETE FROM customers WHERE uname = ip_uname;
        -- Check if the customer is also an employee
        IF NOT EXISTS (SELECT * FROM employees WHERE uname = ip_uname) THEN
            -- If not an employee, delete the user as well
            DELETE FROM users WHERE uname = ip_uname;
        END IF;
    END IF;
end //
delimiter ;

-- remove drone pilot
delimiter // 
create procedure remove_drone_pilot
	(in ip_uname varchar(40))
sp_main: begin
	-- place your solution here
    -- DECLARE pilotID VARCHAR(40);
    -- DECLARE is_cust BOOLEAN;
    
    -- SET pilotID = (SELECT licenseID FROM drone_pilots WHERE uname = ip_uname);
    
    -- SET is_cust = EXISTS (SELECT * FROM customers WHERE uname = ip_uname);
	IF NOT EXISTS (SELECT * FROM drones WHERE pilot = ip_uname) THEN
		
		-- IF is_cust THEN 
			DELETE FROM drone_pilots WHERE uname = ip_uname;
			DELETE FROM employees WHERE uname = ip_uname;
			
			IF NOT EXISTS (SELECT * FROM customers WHERE uname = ip_uname) THEN
				DELETE FROM users WHERE uname = ip_uname;
			END IF;
		-- END IF;
	END IF;
end //
delimiter ;

-- remove product
delimiter // 
create procedure remove_product
	(in ip_barcode varchar(40))
sp_main: begin
	-- place your solution here
end //
delimiter ;

-- remove drone
delimiter // 
create procedure remove_drone
	(in ip_storeID varchar(40), in ip_droneTag integer)
sp_main: begin
	-- place your solution here
end //
delimiter ;
