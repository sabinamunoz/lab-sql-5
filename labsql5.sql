use sakila;

-- 1. Drop column picture from staff. 

alter table staff
drop column picture;

-- 2. A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.

insert into staff (staff_id, first_name, last_name, address_id, email, store_id, active, username)
values (3,'Tammy', 'Sanders', 79, 'Tammy.Sanders@sakilastaff.com', 2, 1, 'Tammy');


-- 3. Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. 

-- to get rental_id: 
select max(rental_id)+1
from sakila.rental;
-- -- RESULT: 16050

-- to get inventory_id
select inventory_id from sakila.inventory
where film_id = (select film_id from sakila.film where title = 'Academy dinosaur') and store_id = '1';
-- -- RESULT: 1,2,3,4 - this store owns 4 copies of this movie, I will asign the rental to the first copy 

-- to get the customer_id: 
select customer_id from sakila.customer 
where first_name = 'CHARLOTTE' and last_name = 'HUNTER';
-- -- RESULT: 130

-- to get staff_id: 
select staff_id from sakila.staff
where first_name = 'Mike' and last_name = 'Hillyer';
-- -- RESULT: 1

insert into rental (rental_id, rental_date, inventory_id, customer_id, return_date, staff_id)
values (16050, (select now()), 1, 130, null, 1);

-- checking if the information was added to the table: 
select * from rental
order by rental_id desc
limit 5;

-- 4. Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users that would be deleted. 
-- Follow these steps:
-- Check if there are any non-active users"
select * from sakila.customer
where active != 1;

-- Create a table backup table as suggested & insert the non active users in the table backup table

create table deleted_users2
select customer_id, email, now() from sakila.customer where active = 0;

select * from deleted_users2;

-- Delete the non active users from the table customer
set sql_safe_updates = 0;
delete from sakila.customer where customer_id = (select customer_id from sakila.customer where active = 0);

delete from sakila.customer where active = 0;