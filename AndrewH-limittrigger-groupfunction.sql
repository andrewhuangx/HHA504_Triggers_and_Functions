use synthea;
show tables;

### Create Table

CREATE table AHuang_List( 
id INT AUTO_INCREMENT PRIMARY KEY, 
patient_UID INT NOT NULL, 
last_name VARCHAR(50) NOT NULL,
age INT NOT NULL,
systolic INT NOT NULL, diastolic INT NOT NULL);

### Insert Values

insert into AHuang_List(patient_UID, last_name, age, systolic, diastolic) 
value (121891, 'Huang', 22, 120, 170), 
(235898, 'Hu', 29, 130, 190),
(343437, 'Ma', 18, 120, 180),
(343438, 'Mei', 77, 100, 150);

select * from AHuang_List;

### Create trigger code

delimiter $$
create trigger DiastolicError before insert on AHuang_List
for each row
begin
if new.diastolic >=300 then
signal sqlstate '45000'
set message_text = 'ERROR: Diastolic BP Must Be Below 300!';
end if;
end; $$
delimiter ;

### Test Error Message

insert into AHuang_List(patient_UID, last_name, age, systolic, diastolic) 
value (986124, 'ErrorTest', 404, 404, 404);

### Results: Error Code: 1644. ERROR: Diastolic BP Must Be Below 300!

insert into AHuang_List(patient_UID, last_name, age, systolic, diastolic) 
value (912734, 'Chen', 41, 100, 100);

### Create Function
delimiter $$
create function agebracket (ranges int)
returns varchar(50)
begin
declare Age_Group varchar(50);
if ranges <= 19 then
set Age_Group = 'Teen';
elseif ranges <= 35 then
set Age_Group = 'Young Adult';
elseif ranges <= 55 then
set Age_Group = 'Middle Aged';
elseif ranges >= 56 then
set Age_Group = 'Old';
end if;
return (Age_Group);
end; $$
delimiter ;

### Testing Function
select patient_UID, last_name, age, agebracket(age) from AHuang_List
