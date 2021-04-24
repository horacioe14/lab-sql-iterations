-- 1. Write a query to find what is the total business done by each store.
use sakila;
select inventory.store_id, sum(payment.amount) as total_business_done
from sakila.inventory, sakila.rental, sakila.payment
where inventory.inventory_id = rental.inventory_id and rental.customer_id = payment.customer_id
group by inventory.store_id;


-- 2. Convert the previous query into a stored procedure.
delimiter $$
create procedure total_business ()
begin
select inventory.store_id, sum(payment.amount) as total_business_done
from sakila.inventory, sakila.rental, sakila.payment
where inventory.inventory_id = rental.inventory_id and rental.customer_id = payment.customer_id
group by inventory.store_id;
end $$
delimiter ;

call total_business();

-- 3. Convert the previous query into a stored procedure that takes the input 
--    for store_id and displays the total sales for that store.
delimiter $$
create procedure total_business_2 (in param int)
begin
select inventory.store_id, sum(payment.amount) as total_business_done
from sakila.inventory, sakila.rental, sakila.payment
where inventory.inventory_id = rental.inventory_id and rental.customer_id = payment.customer_id
group by inventory.store_id
having inventory.store_id COLLATE utf8mb4_general_ci = param;
end $$
delimiter ;

call total_business_2(2);


-- 4. Update the previous query. 
--    Declare a variable total_sales_value of float type,
--    that will store the returned result (of the total sales amount for the store).
--    Call the stored procedure and print the results.


delimiter $$
create procedure total_business_3 (in param int)
begin
declare total_sales_value float default 0.0;
select sum(payment.amount) into total_sales_value
from sakila.inventory, sakila.rental, sakila.payment
where inventory.inventory_id = rental.inventory_id and rental.customer_id = payment.customer_id
group by inventory.store_id
having inventory.store_id COLLATE utf8mb4_general_ci = param;
select total_sales_value;
end $$
delimiter ;
call total_business_3(1);
drop procedure total_business_3;


delimiter $$
create procedure total_business_extra (in param int, out param2 int, out total_sales_value float)
begin
 -- declare total_sales_value float default 0.0;
select sum(payment.amount) into total_sales_value 
from sakila.inventory, sakila.rental, sakila.payment
where inventory.inventory_id = rental.inventory_id and rental.customer_id = payment.customer_id
group by inventory.store_id
having inventory.store_id COLLATE utf8mb4_general_ci = param;
select total_sales_value;

select inventory.store_id into param2
from sakila.inventory, sakila.rental, sakila.payment
where inventory.inventory_id = rental.inventory_id and rental.customer_id = payment.customer_id
group by inventory.store_id
having inventory.store_id COLLATE utf8mb4_general_ci = param;

select param2;

end $$
delimiter ;
call total_business_extra(1, @average, @store);
select @store, @average;
drop procedure total_business_extra;


-- 5. In the previous query, add another variable flag.
--     If the total sales value for the store is over 30.000, 
--     then label it as green_flag, otherwise label is as red_flag.
--     Update the stored procedure that takes an input as the store_id and
--     returns total sales value for that store and flag value.


delimiter $$
create procedure total_business_4 (in param int, out total_sales_value float, out param3 varchar(20))
begin
-- declare total_sales_value float default 0.0;
declare flag varchar(20) default "";
select sum(payment.amount) into total_sales_value
from sakila.inventory, sakila.rental, sakila.payment
where inventory.inventory_id = rental.inventory_id and rental.customer_id = payment.customer_id
group by inventory.store_id
having inventory.store_id COLLATE utf8mb4_general_ci = param;
select total_sales_value;
if total_sales_value > 30000 then
set flag = 'green_flag';
else
set flag = 'red_flag';
end if;
select flag into param3;

end $$
delimiter ;
call total_business_4(1, @average, @flag);
select @average, @flag;

drop procedure total_business_4;