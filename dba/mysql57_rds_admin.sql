SELECT CONCAT('ALTER TABLE `', 
REPLACE(LEFT(NAME , INSTR((NAME), '/') - 1), '`', '``'), '`.`', 
REPLACE(SUBSTR(NAME FROM INSTR(NAME, '/') + 1), '`', '``'), '` ENGINE=InnoDB, ALGORITHM=COPY;') AS Query 
FROM INFORMATION_SCHEMA.INNODB_SYS_TABLES 
WHERE SPACE <> 0 AND LEFT(NAME, INSTR((NAME), '/') - 1) NOT IN ('mysql','');
