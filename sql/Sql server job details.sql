select
c.instance_id,
case a.enabled when '1' then 'Enabled' when '0' then 'Disabled' else 'Denied' end as 'Job State',
a.name,
case b.server when '' then 'Denied' when null then 'Denied' else b.server end as 'Server',
b.database_name,
b.database_user_name,
c.run_date,
LEFT(CAST(c.run_date AS VARCHAR),4)+ '-'
+SUBSTRING(CAST(c.run_date AS VARCHAR),5,2)+'-'
+SUBSTRING(CAST(c.run_date AS VARCHAR),7,2) last_run_date,
CASE
 WHEN LEN(CAST(b.last_run_time AS VARCHAR)) = 6
  THEN SUBSTRING(CAST(b.last_run_time AS VARCHAR),1,2)
    +':' + SUBSTRING(CAST(b.last_run_time AS VARCHAR),3,2)
    +':' + SUBSTRING(CAST(b.last_run_time AS VARCHAR),5,2)
 WHEN LEN(CAST(b.last_run_time AS VARCHAR)) = 5
  THEN '0' + SUBSTRING(CAST(b.last_run_time AS VARCHAR),1,1)
    +':'+SUBSTRING(CAST(b.last_run_time AS VARCHAR),2,2)
    +':'+SUBSTRING(CAST(b.last_run_time AS VARCHAR),4,2)
 WHEN LEN(CAST(b.last_run_time AS VARCHAR)) = 4
  THEN '00:'
    + SUBSTRING(CAST(b.last_run_time AS VARCHAR),1,2)
    +':' + SUBSTRING(CAST(b.last_run_time AS VARCHAR),3,2)
 WHEN LEN(CAST(b.last_run_time AS VARCHAR)) = 3
  THEN '00:'
    +'0' + SUBSTRING(CAST(b.last_run_time AS VARCHAR),1,1)
    +':' + SUBSTRING(CAST(b.last_run_time AS VARCHAR),2,2)
 WHEN LEN(CAST(b.last_run_time AS VARCHAR)) = 2  THEN '00:00:' + CAST(b.last_run_time AS VARCHAR)
 WHEN LEN(CAST(b.last_run_time AS VARCHAR)) = 1  THEN '00:00:' + '0'+ CAST(b.last_run_time AS VARCHAR)
END last_run_time
,LEFT(CAST(d.next_run_date AS VARCHAR),4)+ '-'
+SUBSTRING(CAST(d.next_run_date AS VARCHAR),5,2)+'-'
+SUBSTRING(CAST(d.next_run_date AS VARCHAR),7,2) next_run_date,
/*
e.job_history_id,
e.run_requested_date,
e.run_requested_source,
e.start_execution_date,
e.last_executed_step_date,
e.last_executed_step_id,
e.stop_execution_date,
e.next_scheduled_run_date,
*/
c.run_time,
c.run_duration,
b.step_id,
b.step_name,
b.command,
convert(varchar(8),c.sql_message_id)+','+convert(varchar(8),c.sql_severity) as 'SQLCODE Xact',
c.message as 'SQL Message Body Xact'

from msdb.dbo.sysjobs a
left outer join msdb.dbo.sysjobsteps b
on b.job_id=a.job_id
inner join msdb.dbo.sysjobhistory c
on c.job_id=a.job_id
inner join msdb.dbo.sysjobschedules d
on d.job_id=c.job_id
--inner join msdb.dbo.sysjobactivity e
--on e.job_id=c.job_id
where

a.name not like '$%'
--and a.name not like '%syspolicy%'
and c.run_date >=convert(varchar(4),datepart(YYYY,getdate()))+convert(varchar(2),datepart(MM,getdate()))+convert(varchar(2),datepart(dd,getdate()))-1
order by a.name,c.run_date desc --,a.run_time desc
