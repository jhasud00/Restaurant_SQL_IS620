--IS 620 Team 5
--This script is from Erik Jones, Atefeh Jebeli, Sudhanshu Jha, Sudarshan Jarabandahalli Nagesh Rao, Udaykiran Reddy Kakumanu

--ORGANIZATION OF SCRIPT
--SECTION 1: Drop commands
--SECTION 2: Table creation
--SECTION 3: Sequence creation
--SECTION 4: Creation of helper functions
--SECTION 5: Creation of reports/procedures
--SECTION 6: Insertion of data values
--SECTION 7: Calling reports


SET SERVEROUTPUT ON;

--1: Dropping of DDL commands---------------------------------------------------------------------------------

DROP TABLE orders;
DROP SEQUENCE orders_seq;
DROP TABLE waiter;
DROP SEQUENCE waiter_seq;
DROP TABLE inventory_item;
DROP TABLE menu_items;
DROP SEQUENCE menu_items_seq;
drop table restaurant;
drop table cuisine;
drop sequence cuisine_seq;
drop sequence restaurant_seq;
DROP TABLE customer;
DROP SEQUENCE cust_seq;
--DROP PROCEDURE list_customer_zip;
--DROP PROCEDURE add_customer;

--2: Table creation-----------------------------------------------------------------------------------------------------
-------Member 1 table-------                                        
create table cuisine (
    cuid int NOT NULL,
    cuname varchar(100) NOT NULL,
    CONSTRAINT cuisine_pk primary key (cuid)
);

-------Member 1 table------- 
CREATE TABLE restaurant(
    rid int NOT NULL,
    rname varchar(50) NOT NULL,
    cuid int NOT NULL,
    rstreet varchar(100) NOT NULL,
    rcity varchar(30),
    rstate char(2),
    rzip char(5) NOT NULL,
    CONSTRAINT restaurant_pk primary key (rid), 
    foreign key (cuid) references cuisine(cuid)
);

-------Member 2 table------- 
create table waiter(
    WID int,
    Wname varchar(30) NOT NULL,
    RID int Not null,
    constraint waiter_pk Primary key (wid),
    constraint waiter_fk foreign key (RID) references restaurant(RID)
);
 
-------Member 5 table-------  
CREATE TABLE customer (
	cid            INT,
    cname          VARCHAR(50) NOT NULL,
    cemail         VARCHAR(50) NOT NULL,
    cstreet        VARCHAR(50),
    ccity          VARCHAR(50),
    cstate         CHAR(2),
    czip           NUMBER,
    ccredit        NUMBER,
    CONSTRAINT customer_pk PRIMARY KEY (cid)
);

-------Member 3 table------- 
CREATE TABLE menu_items (
    mid NUMBER,
    cuid NUMBER,
    iname VARCHAR(50) NOT NULL,
    iprice NUMBER,
    CONSTRAINT menu_items_pk primary key (mid), 
    foreign key (cuid) references cuisine(cuid)
);

-------Member 3 table------- 
CREATE TABLE inventory_item (
    mid NUMBER,
    rid NUMBER,
    ivname VARCHAR(50) NOT NULL,
    ivquantity NUMBER,
    CONSTRAINT inventory_item_pk primary key (mid,rid),
    foreign key (rid) references restaurant(rid),
    foreign key (mid) references menu_items(mid)
);

-------Member 4 table------- 
create table Orders(
    oid int,
    rid int NOT NULL,
    Cid int NOT NULL,
    odate date,
    mid int NOT NULL,
    wid int NOT NULL,
    amount int,
    tip int,
    PRIMARY KEY (oid),
    FOREIGN KEY (rid) REFERENCES restaurant(rid),
    FOREIGN KEY (Cid) REFERENCES customer(Cid),
    FOREIGN KEY (mid) REFERENCES Menu_items(mid),
    FOREIGN KEY (wid) REFERENCES waiter(wid)
);

--3: Creation of sequences for Primary Key of Each Table--------------------------------------------------------------------------------------------

CREATE SEQUENCE orders_seq START WITH 40000;                  -----------sequence created by member 4 for orders table---------------
CREATE SEQUENCE menu_items_seq START WITH 10000;              -----------sequence created by member 3 for Menu_Items table-----------
CREATE SEQUENCE cust_seq START WITH 30000;                    -----------sequence created by member 5 for Customer table-------------
CREATE SEQUENCE cuisine_seq START WITH 1000;                  -----------sequence created by member 1 for Cuisine table--------------
CREATE SEQUENCE restaurant_seq START WITH 2000;               -----------sequence created by member 1 for Restaurant table-----------
create sequence waiter_seq start with 20000;                  -----------sequence created by member 2 for Waiter table---------------

--4: Creation of helper functions-----------------------------------------------------------------------------------

/
-- Atefeh Jebeli, team 5, member 1: Task 2 (Definning the helper functions)
create or replace function FIND_CUISINE_TYPE_ID ( cuisine_name in varchar) return int
is 
-- Define a local variable to keep the result of select
	cusine_id int;
begin
-- The select looks for a cuisine ID matches with the input cuisine name.
-- Since we suppose that the cuisine name is unique, I use an implicit cursor (the implicit cursor returns one row)inside the function.
-- If it finds an ID, it returns its values to the defined variable by the implicit cursor.
	select cuid into cusine_id from Cuisine where cuname= cuisine_name;
	return cusine_id;
-- If there is no row match, an error will happen, so the exception part will handle it, and return -1.
-- If more than one rows is found, an error will happen, so the exception part will handle it.
-- else, the handler will print the Error!
exception
	when no_data_found then
	return -1;
    when too_many_rows then
	dbms_output.put_line('too many rows');
    when others then
    dbms_output.put_line('ERROR Message ' ||SQLERRM);
end;
/


-- Atefeh Jebeli, team 5, member 1: Task 2 (Definning the helper functions)
--- Creating FIND_RESTAURANT_ID Function
--- This function gets a Restaurant Name as an input and returns its ID as the function output.
create or replace function	FIND_RESTAURANT_ID ( restaurant_name in varchar) return int
is 
-- define a local variable that keeps the result of select.
	restaurant_id int;
begin
-- Since we suppose that the restaurant name is unique, I use an implicit cursor (the implicit cursor returns one row)inside the function.
-- The select looks for a Restaurant ID that matches with the input Restaurant name.
-- If it finds an ID, it returns its values to the defined variable.
	select rid into restaurant_id from Restaurant where rname= restaurant_name;
	return restaurant_id;
-- If there is no row match, an error will happen, so the exception part will handle it, and return -1.
-- If more than one rows is found, an error will happen, so the exception part will handle it.
-- else, the handler will print the Error!
exception
	when no_data_found then
	return -1;
    when too_many_rows then
	dbms_output.put_line('too many rows');
    when others then
    dbms_output.put_line('ERROR Message ' ||SQLERRM);
end;
/


-----------Helper function to find waiter_id from waiter_name--------------
------------------------MEMBER -2 Helper Function -------------------------
Create or replace function FIND_WAITER_ID( waiter_name in varchar) return int 
is
	Waiter_id int;
begin
    Select wid into waiter_id from waiter where wname=waiter_name;
    Return waiter_id;
Exception
    When no_data_found then
        dbms_output.put_line('no waiter found');
End;
/


-----------Helper function to find menu_item_id from menu_item_name---------
------------------------MEMBER - 3 Helper Function -------------------------
create or replace function FIND_MENU_ITEM_ID ( menu_item_name in varchar) return int
is 
	menu_item_id int;
begin
	select mid into menu_item_id from menu_items where iname= menu_item_name;
return menu_item_id;
exception
    when no_data_found then
    dbms_output.put_line('no menu found');
    return -1;
End;
/


-----------Helper function to find customer_id from customer_name---------
------------------------MEMBER - 5 Helper Function -------------------------
create or replace function FIND_CUSTOMER_ID (customer_name in varchar) return int
is 
customer_id int;
begin
select cid into customer_id from customer where cname = customer_name;
return customer_id;
exception
    when no_data_found then
    dbms_output.put_line('no customer found');
    return -1;
End;
/


------------------------------5: CREATION OF REPORTS/PROCEDURES------------------------------------

------------------------Creation of member 1 reports/procedures------------------------------------


-- Atefeh Jebeli, team 5, member 1: Task 3 (Inserting into Cuisine and Restaurant tables)
-- Define add_cuisine procedure
-- This procedure gets a cuisine type as input parameter, and adds it to a new row into the cuisine table.
-- The procedure does not return a value.
CREATE OR REPLACE  PROCEDURE add_cuisine (cuisine_type in varchar) 
IS
BEGIN
-- The input cuisine type will be added to its table.
-- A cuisine sequence creates a unique id for the input cuisine type.
	insert into Cuisine values(cuisine_seq.nextval,cuisine_type);
-- If an error happens, the exception part will handle it.
exception
	when others then
    DBMS_OUTPUT.Put_line( 'Cannot add to Cuisine. Please check the input parameters.');
    DBMS_OUTPUT.PUT_LINE('ERROR Message ' ||SQLERRM);
END;
/


-- Create  add_restaurant procedure to add a new restaurant in its table with all pertinent input information
-- The restaurant table has 7 columns. This is procedure has 6 input parameters because the ID will automatically create by sequence inside the procedure when we add a new row to its table.
CREATE OR REPLACE  PROCEDURE add_restaurant (cuisine_name in varchar, r_name in varchar,  r_street in varchar, r_city in varchar, r_state in char, r_zip in char) 
IS
-- The procedure gets all of a restaurant values as input parameters to insert into its table.
-- Since we get Cuisine type instead its ID to the procedure, it calls cuisine helper function to gets its ID for inserting into restaurant table with other restaurants's parameers.

 -- Define a variable to keep the output of  FIND_CUISINE_TYPE_ID function.
	cuisine_id int;
BEGIN
-- Call  FIND_CUISINE_TYPE_ID and pass the cuisine name as an input parameter to it.
-- Then, the function returns its ID. The returned ID is kept in the defined variable
cuisine_id := FIND_CUISINE_TYPE_ID(cuisine_name);  
-- Next, the returned Cuisine ID plus other input parameters will be added to the restaurant table. Also, we use the sequence to add a unique restaurant ID.
	insert into restaurant values(restaurant_seq.nextval,r_name, cuisine_id,r_street, r_city, r_state,r_zip );
-- If an error happens, the exception part will handle it.
exception
	when others then
    DBMS_OUTPUT.Put_line( 'Cannot add to Restaurant.Please check the input paramenters.');
    DBMS_OUTPUT.PUT_LINE('ERROR Message ' ||SQLERRM);

end;
/


-- Atefeh Jebeli, team 5, member 1: Task 4 
-- Display restaurant by cuisine: Given a cuisine type, show name and address about all restaurants that offer that cuisine. 

Create or replace procedure display_restaurant_by_cuisine (cuisine_name in varchar) 
IS
-- Defining a local variable to keep the finded cuisine ID
	cu_id int;
-- creating an explicit cursor for returning rows
	Cursor c1 is select rname,rstreet,rcity,rstate,rzip from restaurant where cuid = cu_id;
-- Defining variables to keep the result of select
	r_name restaurant.rname%type;
	r_street restaurant.rstreet%type;
	r_state  restaurant.rstate%type;
	r_city  restaurant.rcity%type;
	r_zip  restaurant.rzip%type;
BEGIN
-- Finding cuisine ID for the inputed Cuisine type
	cu_id := FIND_CUISINE_TYPE_ID(cuisine_name);
	Open c1;
	Loop
		fetch c1 into r_name,r_street,r_city,r_state,r_zip;
		exit when c1%notfound;
		dbms_output.put_line('Restaurant by the '||cuisine_name|| ' cuisine is: '||r_name|| '  Address: ' ||r_street|| ',' ||r_city|| ',' ||r_state || ',' ||r_zip );  
	End loop;
	close c1;
END;
/




-- Atefeh Jebeli, team 5, member 1: Task 4 

-- Calling FIND_RESTAURANT_ID  function to get the ID of a restaurant for inserting into the order table
-- This procedure prints the income of each state per cuisine


Create or replace procedure report_income 
IS
-- creating an explicit cursor for returning rows
	cursor c1 is  select  restaurant.rstate , cuisine.cuname  , to_char(sum(amount), '$9,999') as income
	from Orders,restaurant,cuisine where restaurant.rid=orders.rid and restaurant.cuid=cuisine.cuid
	group by restaurant.rstate,cuisine.cuname,cuisine.cuid;

-- Defining variables to keep the result of select 
	state_name char(2);
	total_income varchar2(32767);
	cuisine_type varchar(100);
Begin
	open c1;
	loop
		fetch c1 into state_name ,cuisine_type,total_income;
		exit when c1%NOTFOUND;
		dbms_output.put_line('Income of state '||state_name||' is: '||total_income||' on '||cuisine_type||' cuisine');
	END Loop;
	close c1;
END;
/



--Creation of member 2 reports/procedures---------------------------------------------------------------------


-- this is a procedure that takes restaurant name and waiter name as variables and insert them
--into waiter table

Create or Replace Procedure Add_waiter (Restaurant_name varchar,w_name varchar)
IS
	R_Id int := FIND_RESTAURANT_ID(Restaurant_name);
Begin
   Insert into waiter 
   (wid,Rid,wname)
   values
   (waiter_seq.nextval,R_Id,w_name);
Exception
   When others Then
   dbms_output.put_line('try another name');
End;
/
--task 2 of the scenario is to list the waiters using Restaurant name as the input.
-- to do that a Procedure is created to list the waiters
/
create or replace procedure list_of_waiters ( Restaurant_name in varchar)
is
	R_ID int := FIND_RESTAURANT_ID (Restaurant_name);
begin  
	for LW in (select * from waiter where  Rid= R_ID)
		loop
		dbms_output.put_line('waiter id :' || lw.wID || ', waiter name: ' || lw.wname || ', Restaurant ID: ' || lw.Rid);
	end loop;
end;
/


/
Set Serveroutput on;
create or replace procedure Report_Tips
is
CURSOR cur_res IS
    select waiter.Wname, sum(orders.tip) from waiter , orders where orders.wid=waiter.wid group by waiter.Wname;
    v_name  waiter.Wname%type;
    v_sum orders.tip%type;   
BEGIN
       dbms_output.put_line('========================================================================');
       dbms_output.put_line(' -------------------------- REPORT BY MEMBER 2 -----------------------');
       dbms_output.Put_line('------------------------REPORTING TIPS BY WAITER ---------------');
    OPEN cur_res;
    LOOP
    FETCH cur_res INTO v_name,v_sum;
 EXIT WHEN cur_res%NOTFOUND;
    dbms_output.Put_line('Waiter Name : '||v_name ||'  Tips: '|| v_sum); 
  END LOOP;
CLOSE cur_res;
   dbms_output.put_line('========================================================================');
END;
/
---Member2 Reports
/
Set Serveroutput on;
create or replace procedure Per_StateTips
is
CURSOR cur_res IS
    select restaurant.rstate, sum(orders.tip) 
    from waiter , orders, restaurant where orders.wid=waiter.wid and orders.rid=restaurant.rid group by restaurant.rstate;
    s_name  varchar(20);
    s_sum number;
BEGIN
    dbms_output.put_line('========================================================================');
    dbms_output.put_line(' -------------------------- REPORT BY MEMBER 2 -----------------------');
    dbms_output.Put_line('------------------------REPORTING TIPS BY STATE ---------------');
    OPEN cur_res;
    LOOP
    FETCH cur_res INTO s_name,s_sum;
 EXIT WHEN cur_res%NOTFOUND;
    dbms_output.Put_line('State: '||s_name ||' Tips: '|| s_sum); 
  END LOOP;
CLOSE cur_res;
    dbms_output.put_line('========================================================================');
END;
/


--Creation of member 3 reports/procedures--------------------------------------------------------------------
----------------------Member 3 : Task 1(Inserting into menu_items table)------------------------


----------------------Member 3 : task 1(inserting into menu_items table)------------------------- 
------Given a cuisine type id, create a menu item (name and price) for that cuisine type--------- 
/
CREATE or REPLACE PROCEDURE create_menu_item(cuisine in varchar , menu_item_name in varchar, price in number)
IS 
	x NUMBER;          --local variable--
BEGIN 
     x := find_cuisine_type_id(cuisine);  ----retrieving cusine_id
	INSERT INTO menu_items  VALUES 
    ( 
    menu_items_seq.nextval ,x ,menu_item_name ,price                    
    );
Exception
	WHEN OTHERS THEN
	DBMS_OUTPUT.Put_line('Error creating Menu_Items Please check the parameters.');
END ;
/
----------------------Member 3 : task 2 (Inserting into inventory_item table)-------------------------
----------Given all pertinent information, add a menu item with a given quantity to-------------------
---------------a given restaurant in the Restaurant Inventory table ----------------------------------
/
CREATE or REPLACE PROCEDURE add_menu_item(restaurant in varchar , menu_name in varchar, i_quantity in Number)
IS 
	a NUMBER;              --local variables--
	b NUMBER;
BEGIN 
    a := find_restaurant_id(restaurant);    --retrieving restaurant_id---
    b := find_menu_item_id(menu_name);      --retrieving menu_item_id----
    INSERT INTO inventory_item  VALUES 
    ( 
    b ,a ,menu_name ,i_quantity                    
    );
Exception
	WHEN OTHERS THEN
	DBMS_OUTPUT.Put_line('Error adding desired Menu_Items Please check the parameters.');
	DBMS_OUTPUT.PUT_LINE('ERROR Message ' ||SQLERRM);

END;
/
----------------------Member 3 : task 3 (updating inventory_item table)-------------------------
--Given a restaurant id, a menu item id, along with a given quantity, reduce the inventory of--- 
------------that menu item by the amount specified by the quantity------------------------------
/
create or replace procedure update_menu_item(r_name in varchar , m_name in varchar , quantity in number )
IS
	r_id number;                      ----local variables----
	m_id number;
	temp1 varchar(50);
	temp2 varchar(50);
Begin
	r_id := find_restaurant_id(r_name);    --retrieving restaurant_id---    
	m_id := find_menu_item_id(m_name);     --retrieving menu_item_id----
	Select ivname into temp1 from inventory_item where mid = m_id AND rid = r_id;
	update inventory_item
	SET
	ivquantity = ivquantity - quantity
	where
	mid = m_id
	AND
	rid = r_id;
Exception
	when no_data_found then
	DBMS_OUTPUT.Put_line('No such items in inventory table');
	WHEN OTHERS THEN
	DBMS_OUTPUT.Put_line('Error updating desired Menu_Items Please check the parameters.');
END;
/
----------------------Member 3 : task 4(report_menu_Items)------------------------- 
-----------------report to show totals of each menu item by type of cuisine--------
/
Create or replace procedure report_menu_item
IS
	cursor c1 is Select distinct c.cuname,ivname,sum(i.ivquantity) from menu_items m , inventory_item i ,cuisine c where m.mid = i.mid and c.cuid = m.cuid
	group by c.cuname,ivname
	order by cuname desc;
	cu_name VARCHAR(50);
	item_name VARCHAR(50);
	item_quantity Number;
	temp Number;
	menu_item_id number;
Begin
	DBMS_OUTPUT.Put_line('===============Report by Member 3====================');
DBMS_OUTPUT.Put_line('===============Showing menu items left in the stock by their cuisine name====================');
	Select count(*) into temp from menu_items m , inventory_item i ,cuisine c where m.mid = i.mid and c.cuid = m.cuid;    ---for exception handling---
	if (temp = 0) then      ---Exception  
		DBMS_OUTPUT.Put_line('Report is empty');
	else
	open c1;
	loop
		fetch c1 into cu_name,item_name,item_quantity;
		exit when c1%NOTFOUND;
		dbms_output.put_line(item_name ||' of cuisine type '||cu_name||' are only '||item_quantity||' left in the stock ');
	END Loop;
	close c1;
	end if;
END;
/

--Creation of member 5 reports/procedures-----------------------------------------------------------------


--This is the ADD_CUSTOMER procedure, created by Erik Jones. It simply 
--inserts a customer into the customer table given a set of inputs. Currently, 
--it uses hard coded values instead of a sequence because this was permitted
--for this portion of the assignment. It will be updated at a later time. 
/
create or replace PROCEDURE add_customer (c_name IN customer.cname%TYPE, 
    c_email IN customer.cemail%TYPE, c_street IN customer.cstreet%TYPE,
    c_city IN customer.ccity%TYPE, c_state IN customer.cstate%TYPE, 
    c_zip IN customer.czip%TYPE, c_credit IN customer.ccredit%TYPE)
IS
BEGIN
    INSERT INTO customer VALUES (cust_seq.NEXTVAL, c_name, c_email, 
    c_street, c_city, c_state, c_zip, c_credit);
END;
/

--Member 5 'Find customers in zip code'
--This procedure finds the customers within a certain zip code using the zip code
--as the input parameter. Although it does not use an exception block, it does deal
--with the one logical exception, which is if there are no customers found within that 
--zip code, using an if/else statement and the ROWCOUNT function. 
/
CREATE OR REPLACE PROCEDURE list_customer_zip (c_zip IN customer.czip%TYPE)
IS 
    CURSOR customers IS SELECT cname FROM customer WHERE czip = c_zip;
    r customers%ROWTYPE;
BEGIN
    OPEN customers;
    LOOP
	--This loop simply prints out the name of all customers in the cursor
        FETCH customers INTO r;
        EXIT WHEN customers%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(r.cname);
    END LOOP;
    IF customers%ROWCOUNT = 0 THEN
                DBMS_OUTPUT.PUT_LINE('No customers in this zip code');
        END IF;
    CLOSE customers;
END;
/

--This procedure is procedure 20. It ranks the customers by their total 
--spending. It uses two cursors. They are both identical in that they list 
--the total spending of each customer id, but one of them sorts by ascending
--and the other by descending. 
/
CREATE OR REPLACE PROCEDURE customer_ranking 
IS
    CURSOR find_top_customers IS 
    SELECT customer.cid, sum(amount) AS total 
    FROM customer
    JOIN orders
    ON customer.cid = orders.cid
    GROUP BY customer.cid
    ORDER BY sum(amount) DESC;

    CURSOR find_bottom_customers IS
    SELECT customer.cid, sum(amount) 
    FROM customer
    JOIN orders
    ON customer.cid = orders.cid
    GROUP BY customer.cid
    ORDER BY sum(amount) ASC;

    temp_cname customer.cname%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Member 5: Top and Bottom Customers');

    --This loop lists the top customers. It uses a FOR IN loop to go through
    --each customer, which the cursor lists in descending order of amount spent.
    --The loop will exit when 3 customers have been found, OR will exit naturally
    --if there are less than 3 customers. The implicit cursor will find the name
    --associated with the customer. It shouldn't throw an error, as the loop would
    --exit if there's no data, and furthermore cname cannot be null.
    DBMS_OUTPUT.PUT_LINE('Top Customers:');
    FOR person IN find_top_customers
		LOOP
        SELECT cname
        INTO temp_cname
        FROM customer 
        WHERE customer.cid = person.cid;
        DBMS_OUTPUT.PUT_LINE(temp_cname);
        EXIT WHEN find_top_customers%ROWCOUNT = 3;
    END LOOP;
    
	DBMS_OUTPUT.PUT_LINE('');

    --This loop lists the bottom customers. It also uses a FOR IN loop to go through
    --each customer, which the cursor lists in ascending order of amount spent.
    --The loop will exit when 3 customers have been found, OR will exit naturally
    --if there are less than 3 customers. The implicit cursor will find the name
    --associated with each customer. It shouldn't throw an error, as the loop would
    --exit if there's no data, and furthermore cname is NOT NULL.
	DBMS_OUTPUT.PUT_LINE('Bottom Customers:');
	FOR person IN find_bottom_customers
		LOOP
        SELECT cname
        INTO temp_cname
        FROM customer 
        WHERE customer.cid = person.cid;
        DBMS_OUTPUT.PUT_LINE(temp_cname);
        EXIT WHEN find_bottom_customers%ROWCOUNT = 3;
    END LOOP;

END;
/

--This procedure is pretty simple. It consists of a cursor, which lists the 
--total tips of each state in descending order. Basically this does the processing
--of the entire function. It selects the total tips of each state and groups them
--by the state name. There are no clear error scenarios present, so it should not
--require exceptions
/
CREATE OR REPLACE PROCEDURE generous_customer_states 
IS
    CURSOR top_tipping_states IS
    SELECT SUM(tip) AS total_tips, cstate AS state_name
    FROM customer
    JOIN orders
    ON customer.cid = orders.cid
	GROUP BY cstate 
	ORDER BY total_tips DESC;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Member 5: Generous Customer States');
    --This FOR IN loop simply formats the output of the cursor nicely. 
    FOR state IN top_tipping_states
    LOOP
        DBMS_OUTPUT.PUT_LINE('State ' || state.state_name || ' has total tips of '
        || state.total_tips);
    END LOOP;
END;
/
--Creation of member 4 reports/procedures------------------------------------------------------------------
----------------------Member 4 : Task 1(Inserting into orders table)------------------------
/
create or replace procedure create_orders(r_name in varchar, c_name in varchar, menu_item_name in varchar, waiter_name in varchar, o_date in date, amt in number) 
is
	r_id int;
	c_id int;
	m_id int;
	w_id int;
	tip_amount float;
begin
	tip_amount := (amt * 20 ) / 100;
	m_id:= FIND_MENU_ITEM_ID ( menu_item_name);
	w_id:=FIND_WAITER_ID( waiter_name);
	r_id:= FIND_RESTAURANT_ID ( r_name);
	c_id:= FIND_CUSTOMER_ID (c_name);
	insert into orders values(orders_seq.nextval,r_id,c_id,o_date,m_id,w_id,amt,tip_amount);
exception
	when others then
    DBMS_OUTPUT.PUT_LINE('ERROR Message='||SQLERRM);

end;
/
----------------------Member 4 : Task 2(Listing all orders on given date)------------------------
/
SET SERVEROUTPUT ON;
CREATE OR REPLACE procedure LIST_ALL_ORDER_ON_GIVEN_DAT(res_name in varchar ,date_time_given in DATE)
as cursor c7 is SELECT o.oid, r.rname, c.cname, o.odate, m.iname, cus.cuname, w.wname, o.amount, o.tip   
    FROM orders o LEFT JOIN restaurant r on r.rid  = o.rid 
    LEFT JOIN customer c on c.cid = o.cid
    LEFT JOIN menu_items m on m.mid = o.mid
    LEFT JOIN waiter w on w.wid = o.wid
    LEFT JOIN cuisine cus on cus.cuid = m.cuid
    WHERE o.odate = date_time_given  and r.rname=res_name;
    id number;
    r_name varchar(20);
    c_name varchar(20);
    date_time date;
    m_name varchar(20);
    cu_name varchar(20);
    w_name varchar(20);
    amount number;
    tip number;


BEGIN
open c7;
dbms_output.put_line('Order_id'||'======'||'Restaurant name'||'==='||'Customer_name'||'==='||'Date'||'===='||'Menu_item'||'==='||'cuisine NAme'||'Waiter '||'=='|| 'amount'||'==='||'tip');
loop
fetch c7 into id,r_name,c_name,date_time,m_name,cu_name,w_name,amount,tip;

exit when c7%NOTFOUND;

    
    dbms_output.put_line(id||'====='||r_name||'====='  ||c_name||'====='||date_time||'====='||m_name||'====='||cu_name||'====='||w_name||'====='||amount||'====='||tip);
end loop;
END;


/
----------------------Member 4 : Task 3(popular items of each cuisine)------------------------
/
SET SERVEROUTPUT ON;
CREATE OR REPLACE procedure LIST_ALL_MENU_FORM_CUISINe
IS cursor c6 is select cuname, iname from 
 (SELECT cuname, iname , max(o_count),  row_number () over(partition by cuname order by max(o_count) DESC) r
    FROM (
        SELECT cus.cuname, m.iname , count(o.oid) as o_count
        FROM orders o 
        left JOIN menu_items m on m.mid = o.mid
       LEFT JOIN cuisine cus on cus.cuid = m.cuid
       GROUP BY cus.cuname , m.iname
      
    )
    
    GROUP BY cuname ,iname
    ORDER BY max(o_count) DESC
)
where r<2;
    m_name varchar(20);
    cu_name varchar(20);
    count_order number;

BEGIN 
open c6;
loop

fetch c6 into m_name,cu_name;
   
exit when c6%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(cu_name||'=================='||m_name);
end loop;

END;



/
----------------------Member 4 : Task 4(REPORT)(Top 3 restaurant of each state)------------------------
/
set serveroutput on;
create or replace procedure m4_report is
cursor c6 is select sum(o.amount),row_number() over(partition by r.rstate order by sum(o.amount) desc) ,r.rstate,r.rname
from orders o, restaurant r
where o.rid=r.rid
group by r.rstate,r.rname
order by r.rstate desc;
r_state varchar(20);
sum_amt number;
r_name varchar(20);
x number;
Begin
open c6;
Loop
fetch c6 into sum_amt,x,r_state,r_name;
exit when c6%NOTFOUND;
dbms_output.put_line('Total Amount: '||sum_amt||' Rank: '||x|| ' =========='||' Name of state: '||r_state||' ========== '||'Restaurant: '||r_name);
end loop;
close c6;
end;
/


-----------------------------------------------6: INSERTION OF VALUES------------------------------------

--Member 1 insert values----------------------------------------------------------------------------------------

-----------------Scenario -1 Member 1 Atefeh Jebeli-----------------------------------
begin
dbms_output.put_line('========== Member 1: Adding Cuisines and Restaurants to Tables ==========');
end;
/

-- 	Add cuisines in the DB by calling the appropriate procedure/function
Exec add_cuisine('American');
Exec add_cuisine('Italian');
Exec add_cuisine('BBQ');
Exec add_cuisine('Indian');
Exec add_cuisine('Ethiopian');

-- 	Add a restaurant called Ribs_R_US that serves American cuisine, in the DB by calling the appropriate procedure/function
-- (zip should be 21250, the fill in the rest of the information on your own). 
Exec add_restaurant( 'American','Ribs_R_US','Omega Dr','Rockville','MD','21250');

-- 	Add a restaurant called Bella Italia that serves Italian cuisine in the DB by calling the appropriate procedure/function
-- (zip should be 21043, fill in the rest of the information on your own).
Exec add_restaurant( 'Italian','Bella Italia','Key west Ave','Rockville','MD','21043');

-- Add a restaurant called Roma that serves Italian cuisine in the DB by calling the appropriate procedure/function
-- (zip should be 21043, fill in the rest of the information on your own).
Exec add_restaurant( 'Italian','Roma','Rockvile Pike','Rockville','MD','21043');

--  Add a restaurant called Bull Roast that serves BBQ cuisine in the DB by calling the appropriate procedure/function 
-- (zip should be 10013, NY, fill in the rest of the information on your own).
Exec add_restaurant( 'BBQ','Bull Roast','1street','New york','NY','10013');

-- Add a restaurant called Taj Mahal that serves Indian cuisine in the DB by calling the appropriate procedure/function
-- (zip should be 10013, NY, fill in the rest of the information on your own).
Exec add_restaurant( 'Indian','Taj Mahal','20street','New york','NY','10013');

-- Add a restaurant called Selasie that serves Ethiopian cuisine in the DB by calling the appropriate procedure/function
-- (zip should be 16822, PA, fill in the rest of the information on your own).
Exec add_restaurant( 'Ethiopian','Selasie','kstreet','Philadelphia','PA','16822');

-- Add a restaurant called Ethiop that serves Ethiopian cuisine in the DB by calling the appropriate procedure/function 
--  (zip should be 16822, PA, fill in the rest of the information on your own).
Exec add_restaurant( 'Ethiopian','Ethiop','M street','Philadelphia','PA','16822');


-- 	Run a query to show all information about all restaurants that were added to the DB.
/
begin
dbms_output.put_line('========== Member 1: List of All Restaurants ==========');
end;

/

select * from restaurant;
/
-- 	Display restaurant by cuisine: Italian
begin
dbms_output.put_line('========== Member 1: List of Restaurants Serving Italian Cuisine ==========');
dbms_output.new_line();
display_restaurant_by_cuisine ('Italian');
dbms_output.new_line();
-- 	Display restaurant by cuisine: Ethiopian
dbms_output.put_line('========== Member 1: List of Restaurant Serving Ethiopian Cuisine ==========');
dbms_output.new_line();
display_restaurant_by_cuisine ('Ethiopian');
end;

/
begin
dbms_output.new_line();
dbms_output.put_line('========== Member 1: The End of Scenario ==========');
end;
/



--Member 2 insert values---------------------------------------------------------------------------------------
/
Begin
	Add_waiter('Ribs_R_US','jack');
	Add_waiter('Ribs_R_US','jill');
	Add_waiter('Ribs_R_US','Wendy');
	Add_waiter('Ribs_R_US','Hailey');
	Add_waiter('Bella Italia','Mary');
	Add_waiter('Bella Italia','Pat');
	Add_waiter('Bella Italia','Michael');
	Add_waiter('Bella Italia','Rakesh');
	Add_waiter('Bella Italia','Verma');
	Add_waiter('Roma','Mike');
	Add_waiter('Roma','judy');
	Add_waiter('Selasie','Trevor');
	Add_waiter('Ethiop','Trudy');
	Add_waiter('Ethiop','Trisha');
	Add_waiter('Ethiop','Tariq');
	Add_waiter('Taj Mahal','Chap');
	Add_waiter('Bull Roast','Hannah');
End;
/

--Member 3 insert values---------------------------------------------------------------------------------------
-----------------Scenario -1 Member 3-----------------------------------
exec create_menu_item('American','burger',10);
exec create_menu_item('American','Fries',5);
exec create_menu_item('American','Pasta',15);
exec create_menu_item('American','Salad',10);
exec create_menu_item('American','Salmon',20);
-----------------Scenario -2 Member 3-----------------------------------
exec create_menu_item('Italian','Lasagna',15);
exec create_menu_item('Italian','Meatballs',10);
exec create_menu_item('Italian','Spaghetti',15);
exec create_menu_item('Italian','Pizza',20);
-----------------Scenario -3 Member 3-----------------------------------
exec create_menu_item('BBQ','Steak',25);
exec create_menu_item('BBQ','Burger',10);
exec create_menu_item('BBQ','Pork Loin',15);
exec create_menu_item('BBQ','Fillet Mignon',30);
-----------------Scenario -4 Member 3-----------------------------------
exec create_menu_item('Indian','Dal Soup',10);
exec create_menu_item('Indian','Rice',5);
exec create_menu_item('Indian','Tandori Chicken',10);
exec create_menu_item('Indian','Samosa',8);
-----------------Scenario -5 Member 3-----------------------------------
exec create_menu_item('Ethiopian','Meat Chunks',12);
exec create_menu_item('Ethiopian','Legume Stew',10);
exec create_menu_item('Ethiopian','Flat Bread',3);
-----------------Scenario -5 Member 3-----------------------------------
exec add_menu_item('Ribs_R_US','burger',50);
-----------------Scenario -7 Member 3-----------------------------------
exec add_menu_item('Ribs_R_US','Fries',150);
-----------------Scenario -8 Member 3-----------------------------------
exec add_menu_item('Bella Italia','Lasagna',10);
-----------------Scenario -9 Member 3-----------------------------------
exec add_menu_item('Bull Roast','Steak',15);
-----------------Scenario -10 Member 3----------------------------------
exec add_menu_item('Bull Roast','Pork Loin',50);
-----------------Scenario -11 Member 3----------------------------------
exec add_menu_item('Bull Roast','Fillet Mignon',5);
-----------------Scenario -12 Member 3 ----------------------------------
exec add_menu_item('Taj Mahal','Dal Soup',50);
-----------------Scenario -13 Member 3----------------------------------
exec add_menu_item('Taj Mahal','Rice',500);
-----------------Scenario -14 Member 3----------------------------------
exec add_menu_item('Taj Mahal','Samosa',150);
-----------------Scenario -15 Member 3----------------------------------
exec add_menu_item('Selasie','Meat Chunks',150);
-----------------Scenario -16 Member 3----------------------------------
exec add_menu_item('Selasie','Legume Stew',150);
-----------------Scenario -17 Member 3----------------------------------
exec add_menu_item('Selasie','Flat Bread',500);
---------------Scenario -18 Member 3-------------------------------------
exec add_menu_item('Ethiop','Meat Chunks',150);
---------------Scenario -19 Member 3-------------------------------------
exec add_menu_item('Ethiop','Legume Stew',150);
---------------Scenario - 21 Member 3-------------------------------------
exec add_menu_item('Ethiop','Flat Bread',500);

--Member 5 insert values-----------------------------------------------------------------------------------------

BEGIN
	ADD_CUSTOMER('Cust1', 'cust1@gmail.com', '6300 Linden Ave.', 'Columbia', 'MD', 21045, 650);
	ADD_CUSTOMER('Cust11', 'cust11@gmail.com', '24 Alderton Ct.', 'Columbia', 'MD', 21045, 534);
    ADD_CUSTOMER('Cust3', 'cust3@gmail.com', '333 Jameson Blvd.', 'Columbia', 'MD', 21046, 620);
    ADD_CUSTOMER('Cust111', 'cust111@gmail.com', '11 Sawmill Rd.', 'Columbia', 'MD', 21045, 720);
    ADD_CUSTOMER('CustNY1', 'custny1@gmail.com', '1156 5th St.', 'New York', 'NY', 10045, 690);
    ADD_CUSTOMER('CustNY2', 'custny2@gmail.com', '9450 Patterson St.', 'New York', 'NY', 10045, 780);
    ADD_CUSTOMER('CustNY3', 'custny3@gmail.com', '1040 5th St.', 'New York', 'NY', 10045, 499);
    ADD_CUSTOMER('CustPA1', 'custpa1@gmail.com', '12100 Kentucky St.', 'Beech Creek', 'PA', 16822, 690);
    ADD_CUSTOMER('CustPA2', 'custpa2@gmail.com', '120 Little Sugar Run Rd.', 'Beech Creek', 'PA', 16822, 459);
    ADD_CUSTOMER('CustPA3', 'custpa3@gmail.com', '130 Little Sugar Run Rd.', 'Beech Creek', 'PA', 16822, 740);
    ADD_CUSTOMER('CustPA4', 'custpa4@gmail.com', '1000 Reams Rd.', 'Beech Creek', 'PA', 16822, 570);
    ADD_CUSTOMER('CustPA5', 'custpa5@gmail.com', '2000 Singer Struble Ln', 'Beech Creek', 'PA', 16822, 645);
    ADD_CUSTOMER('CustPA6', 'custpa6@gmail.com', '455 Haagen Ln.', 'Beech Creek', 'PA', 16822, 670);
END;
/

--Member 4 insert values-----------------------------------------------------------------------------------------

exec create_orders('Bella Italia','Cust1','Pizza','Mary',date'2020-03-10',20);
exec create_orders('Bella Italia','Cust11','Spaghetti','Mary',date'2020-03-15',30);
exec create_orders('Bella Italia','Cust11','Pizza','Mary',date'2020-03-15',20);
exec create_orders('Bull Roast','CustNY1','Fillet Mignon','Hannah',date'2020-04-01',60);
exec create_orders('Bull Roast','CustNY1','Fillet Mignon','Hannah',date'2020-04-02',60);
exec create_orders('Bull Roast','CustNY2','Pork Loin','Hannah',date'2020-04-02',15);
exec create_orders('Ethiop','CustPA1','Meat Chunks','Trisha',date'2020-04-01',120);
exec create_orders('Ethiop','CustPA1','Meat Chunks','Trisha',date'2020-05-01',120);
exec create_orders('Ethiop','CustPA1','Meat Chunks','Trisha',date'2020-05-10',120);
exec create_orders('Ethiop','CustPA2','Legume Stew','Trevor',date'2020-05-01',100);
exec create_orders('Ethiop','CustPA2','Legume Stew','Trevor',date'2020-05-11',100);



---------------Scenario - 22 Member 3-------------------------------------
exec update_menu_item('Taj Mahal','Rice',25);
---------------Scenario - 23 Member 3-------------------------------------
exec update_menu_item('Selasie','Meat Chunks',50);
---------------Scenario - 24 Member 3-------------------------------------
exec update_menu_item('Bull Roast','Fillet Mignon',2);
---------------Scenario - 25 Member 3-------------------------------------
exec update_menu_item('Bull Roast','Fillet Mignon',2);

---------------Scenario - 26 Member 3-------------------------------------
/
Declare 
	cursor c1 is select i.ivname , r.rid , i.mid ,i.ivquantity from restaurant r , inventory_item i where i.rid = r.rid AND  r.rname = 'Ethiop';
	iv_name varchar(50);
	r_id number;
	m_id number;
	i_quantity number;
	temp number;
Begin 
	dbms_output.put_line(' -----------Initial inventory for Ethiop Restaurant ---------');
	select count(*) into temp from restaurant r , inventory_item i where i.rid = r.rid AND  r.rname = 'Ethiop';          ---for exception handling---
	If (temp = 0) then   ---EXCEPTION----
		DBMS_OUTPUT.Put_line('No item in this restaurant');
	ELSE
		open c1;
		loop
			fetch c1 into iv_name,r_id,m_id,i_quantity;
			exit when c1%NOTFOUND;
			dbms_output.put_line(iv_name ||' are only '||i_quantity||' left in the stock ');
		END Loop;
		close c1;
	END IF;
END;
/
---------------Scenario - 27 Member 3-------------------------------------
exec update_menu_item('Ethiop','Meat Chunks',30);
---------------Scenario - 28 Member 3-------------------------------------
exec update_menu_item('Ethiop','Meat Chunks',30);
---------------Scenario - 29 Member 3-------------------------------------
exec update_menu_item('Ethiop','Legume Stew',20);
---------------Scenario - 30 Member 3-------------------------------------
/
Declare 
	cursor c1 is select i.ivname , r.rid , i.mid ,i.ivquantity from restaurant r , inventory_item i where i.rid = r.rid AND  r.rname = 'Ethiop';
	iv_name varchar(50);
	r_id number;
	m_id number;
	i_quantity number;
	temp number;
Begin 
	dbms_output.put_line(' -----------Final inventory for Ethiop Restaurant ---------');
	select count(*) into temp from restaurant r , inventory_item i where i.rid = r.rid AND  r.rname = 'Ethiop';
	If (temp = 0) then
		DBMS_OUTPUT.Put_line('No item in this restaurant');
	ELSE
		open c1;
		loop
			fetch c1 into iv_name,r_id,m_id,i_quantity;
			exit when c1%NOTFOUND;
			dbms_output.put_line(iv_name ||' are only '||i_quantity||' left in the stock ');
		END Loop;
		close c1;
	END IF;
END;
/

--------------------------------------7: CALLING REPORTS----------------------------------------------------------

BEGIN
	DBMS_OUTPUT.PUT_LINE('========================================================================');
	DBMS_OUTPUT.PUT_LINE('========================================================================');
	DBMS_OUTPUT.PUT_LINE('--------------------------       R E P O R T S below -------------------');
	DBMS_OUTPUT.PUT_LINE('========================================================================');
	DBMS_OUTPUT.PUT_LINE('========================================================================');
END;
/


--Member 1 call reports-----------------------------------------------------------------------------------------------


/
Begin

DBMS_OUTPUT.PUT_LINE('-------------------------------REPORTS BY MEMBER 1---------------------------');
    DBMS_OUTPUT.PUT_LINE('-----------------------------Report Income by State–------------------------');

dbms_output.put_line(' ');
	report_Income();
end;
/

--Member 2 call reports-----------------------------------------------------------------------------------------------

-------------listing of waiters form restaurant ‘ethiop’-----
/
Begin
	DBMS_OUTPUT.PUT_LINE('------------------------------REPORTS BY MEMBER 2---------------------------');
	list_of_waiters('Ethiop');
End;
/

--getting the report for waiters and their tips-------
/
set serveroutput on;
Begin
Report_tips();
end;
/

--report based on state of the restaurant—
/
set serveroutput on;
Begin
per_stateTips();
End;
/






--Member 3 call reports------------------------------------------------------------------------------------------------


------------------Scenario 31 Member 3---------------------
exec report_menu_item;





--Member 4 call reports------------------------------------------------------------------------------------------------


/
BEGIN 
	DBMS_OUTPUT.PUT_LINE('------------------------------REPORTS BY MEMBER 4---------------------------');
	LIST_ALL_MENU_FORM_CUISINe;
END;
/

exec m4_report;




--Member 5 call reports-----------------------------------------------------------------------------------------------


/
BEGIN
	DBMS_OUTPUT.PUT_LINE('------------------------------REPORTS BY MEMBER 5---------------------------');
	customer_ranking;
	DBMS_OUTPUT.PUT_LINE('');
	generous_customer_states;
END;
/










