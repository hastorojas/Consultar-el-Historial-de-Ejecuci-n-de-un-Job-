  use msdb
  go
 select
	b.name,
    convert(varchar(10),convert(date,CONVERT(varchar(8), run_date)),103) as [fecha_ejecuta],
 case
   len(run_duration) when  6 then left(convert(varchar(6), run_duration),2)+':'+substring(convert(varchar(6), run_duration),3,2)+':'+right(convert(varchar(6),run_duration),2)
                     when  5 then '0'+left(convert(varchar(5), run_duration),1)+':'+substring(convert(varchar(5), run_duration),2,2)+':'+right(convert(varchar(6),run_duration),2)
                     when  4 then '00'+':'+left(convert(varchar(4),run_duration),2)+':'+right(convert(varchar(4),run_duration),2)
                     when  3 then '00:0'+left(convert(varchar(3),run_duration),1)+':'+right(convert(varchar(4),run_duration),2)
					 when  2 then '00:00:'+right(convert(varchar(2),run_duration),2)
					 when  1 then '00:00:0'+convert(varchar(2),run_duration)
        end       
         as [run_duration],
 case run_status when 0 then 'failed'
                  when  1 then 'succeded'
                  when 2 then 'retry'
                  when 3 then 'canceled'
                 end as [run_status],
				 [message]
 from
 SysJobHistory as a
 left join SysJobs  as b
 on a.job_id = b.job_id
 where  step_id=0 and
 b.name not in ('SSIS Server Maintenance Job','syspolicy_purge_history')
order by run_date desc
