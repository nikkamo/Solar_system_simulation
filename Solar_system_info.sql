DROP DATABASE solar_system_info;
CREATE DATABASE solar_system_info ;

USE solar_system_info ;

CREATE USER 'python_user'@'localhost' IDENTIFIED BY 'mypass123';
GRANT ALL PRIVILEGES ON * . * TO 'python_user'@'localhost';

CREATE TABLE position (
ID INT NOT NULL AUTO_INCREMENT, /* auto increment automatically gives number, starts with 1 and adds 1 */
x_position DOUBLE NOT NULL,
y_position DOUBLE NOT NULL,
z_position DOUBLE NOT NULL,
PRIMARY KEY(ID)
);

CREATE TABLE velocity (
ID INT NOT NULL AUTO_INCREMENT, /* auto increment automatically gives number, starts with 1 and adds 1 */
x_velocity DOUBLE NOT NULL,
y_velocity DOUBLE NOT NULL,
z_velocity DOUBLE NOT NULL,
PRIMARY KEY(ID)
);

CREATE TABLE bodies (
ID INT NOT NULL AUTO_INCREMENT, /* auto increment automatically gives number, starts with 1 and adds 1 */
body_name VARCHAR(60) NOT NULL,
mass DOUBLE NOT NULL,
position_ID INT NOT NULL, /* because postion and velocity ID cannot be null, have to define these before planet*/
velocity_ID INT NOT NULL,
PRIMARY KEY(ID),
FOREIGN KEY (position_ID) REFERENCES position (ID),
FOREIGN KEY (velocity_ID) REFERENCES velocity (ID)
);

DELIMITER $$
/*delimitter tells us end of line, usually it's ;, now we define it as // */
CREATE PROCEDURE insert_body (
	IN bod_name CHAR(45), 
	IN m DOUBLE, 
    IN x_pos DOUBLE, 
    IN y_pos DOUBLE, 
    IN z_pos DOUBLE, 
    IN x_vel DOUBLE, 
    IN y_vel DOUBLE, 
    IN z_vel DOUBLE
    )
    
    BEGIN
    INSERT INTO position (x_position, y_position, z_position) 
	VALUES (x_pos, y_pos, z_pos);
    SET @last_pos_id = LAST_INSERT_ID();
    
	INSERT INTO velocity (x_velocity, y_velocity, z_velocity) 
	VALUES (x_vel, y_vel, z_vel);
    SET @last_vel_id = LAST_INSERT_ID();
	
	INSERT INTO bodies (body_name, mass, position_ID, velocity_ID) 
	VALUES (bod_name, m, @last_pos_id, @last_vel_id);
    
    END ;$$

DELIMITER ;

/* 
 Data is taken from JPL Horizons web interface
 Data is chosen at the date 2024-01-01 at time 00:00:00.
 Example of data from Mercury: https://ssd.jpl.nasa.gov/horizons/app.html#/ 
 Lengths are in units of km and times are in units of s, and positions are relative to the Sun.
 */

CALL insert_body ('Sun', 1988500E24, 0, 0, 0, 0, 0, 0) ; 
CALL insert_body ('Mercury', 3.302E23, -4.108411877039495E+07, 2.997375954154480E+07, 6.217890408222714E+06, -3.865743010383652E+01, -3.733889075044869E+01, 4.944436024774976E-01);
CALL insert_body ('Venus', 48.685E23, -1.069987422398024E+08, -1.145572515113905E+07, 6.016588327139664E+06, 3.513460276994624E+00, -3.497755629371660E+01, -6.830913209445484E-01);
CALL insert_body ('Earth', 5.97219E24, -2.481099325965390E+07, 1.449948612736719E+08, -8.215203670851886E+03, -2.984146365518679E+01, -5.126262286859617E+00, 1.184224839788195E-03);
CALL insert_body ('Mars', 6.4171E23, -4.388577457378983E+07, -2.170849264747524E+08, -3.473007284583151E+06, 2.466191455128526E+01, -2.722160161977370E+00, -6.619819103693254E-01);
CALL insert_body ('Jupiter', 189818722E22, 5.225708576244547E+08, 5.318268827721269E+08, -1.390073285881653E+07, -9.481190567392032E+00, 9.781942400350085E+00, 1.714274561397779E-01);
CALL insert_body ('Saturn', 5.6834E26, 1.345793242617223E+09, -5.559294178115252E+08, -4.389262609579784E+07, 3.146297313479314E+00, 8.917916155362638E+00, -2.799382290475703E-01);
CALL insert_body ('Uranus', 86.813E24, 1.835714294722568E+09, 2.288891426259816E+09, -1.529865738122165E+07, -5.371828306112230E+00, 3.954368764227032E+00, 8.423549070186587E-02);
CALL insert_body ('Neptune', 102.409E24, 4.464446647141849E+09, -2.679158335073845E+08, -9.736583677508335E+07, 2.818440617089212E-01, 5.469942022851473E+00, -1.190017755456774E-01);




