SELECT CONCAT(table_schema, '.', table_name) as 'TABLE', 
       ENGINE, CONCAT(ROUND(table_rows / 1000000, 2), 'M')  ROWS, 
       CONCAT(ROUND(data_length / ( 1024 * 1024 * 1024 ), 2), 'G') DATA, 
       CONCAT(ROUND(index_length / ( 1024 * 1024 * 1024 ), 2), 'G') IDX, 
       CONCAT(ROUND(( data_length + index_length ) / ( 1024 * 1024 * 1024 ), 2), 'G') 'TOTAL SIZE', 
       ROUND(index_length / data_length, 2)  Idx_frag_pct, CONCAT(ROUND(( data_free / 1024 / 1024),2), 'MB') AS data_free,
create_time as create_timeo,
update_time as upd_timeo,
check_time as last_checked
       FROM information_schema.TABLES  

rder by data_length+index_length desc limit 100;
