  use msdb
  go
 select
 'Server'       = left(@@ServerName,20),
 SST.database_name,
 'NombreJob'      = S.name,--left(S.name,90),
  'Enabled'      = CASE (S.enabled)
 WHEN 0 THEN 'No'
 WHEN 1 THEN 'Yes'
 ELSE '??'
 END,
  S.description,
 S.date_created,
 S.date_modified,
 SST.step_id as Step_ID,
  SST.step_name as NombrePaso,
  'On Succes Action' = CASE (SST.on_success_action) WHEN 1 THEN 'Quit with success' WHEN 2 THEN 'Quit with failure' WHEN 3 THEN 'Go to next step' WHEN 4 THEN 'GO to step on success_step_id' ELSE '??' END,
  SST.subsystem,
  SST.command,
 'ScheduleName' = left(ss.name,25),
   'Enabled'      = CASE (SS.enabled)
 WHEN 0 THEN 'No'
 WHEN 1 THEN 'Yes'
 ELSE '??'
 END,
 --'Frequency'    = CASE(ss.freq_type)
 --WHEN 1  THEN 'Once'
 --WHEN 4  THEN 'Daily'
 --WHEN 8  THEN
 --(case when (ss.freq_recurrence_factor > 1)
 --then  'Every ' + convert(varchar(3),ss.freq_recurrence_factor) + ' Weeks'  else 'Weekly'  end)
 --WHEN 16 THEN
 --(case when (ss.freq_recurrence_factor > 1)
 --then  'Every ' + convert(varchar(3),ss.freq_recurrence_factor) + ' Months' else 'Monthly' end)
 --WHEN 32 THEN 'Every ' + convert(varchar(3),ss.freq_recurrence_factor) + ' Months' -- RELATIVE
 --WHEN 64 THEN 'SQL Startup'
 --WHEN 128 THEN 'SQL Idle'
 --ELSE '??'
 --END,
 /*nuevas lineas*/
  CASE [freq_type]
        WHEN 1 THEN 'One Time'
        WHEN 4 THEN 'Daily'
        WHEN 8 THEN 'Weekly'
        WHEN 16 THEN 'Monthly'
        WHEN 32 THEN 'Monthly - Relative to Frequency Interval'
        WHEN 64 THEN 'Start automatically when SQL Server Agent starts'
        WHEN 128 THEN 'Start whenever the CPUs become idle'
      END [Occurrence],
 /**/
 --'Interval'    = CASE
 --WHEN (freq_type = 1)                       then 'One time only'
 --WHEN (freq_type = 4 and freq_interval = 1) then 'Every Day'
 --WHEN (freq_type = 4 and freq_interval > 1) then 'Every ' + convert(varchar(10),freq_interval) + ' Days'
 --WHEN (freq_type = 8) then (select 'Weekly Schedule' = D1+ D2+D3+D4+D5+D6+D7
 --from (select ss.schedule_id,
 --freq_interval,
 --'D1' = CASE WHEN (freq_interval & 1  <> 0) then 'Sunday ' ELSE '' END,
 --'D2' = CASE WHEN (freq_interval & 2  <> 0) then 'Monday '  ELSE '' END,
 --'D3' = CASE WHEN (freq_interval & 4  <> 0) then 'Tuesday '  ELSE '' END,
 --'D4' = CASE WHEN (freq_interval & 8  <> 0) then 'Wednesday '  ELSE '' END,
 --'D5' = CASE WHEN (freq_interval & 16 <> 0) then 'Thursday '  ELSE '' END,
 --'D6' = CASE WHEN (freq_interval & 32 <> 0) then 'Friday '  ELSE '' END,
 --'D7' = CASE WHEN (freq_interval & 64 <> 0) then 'Saturday '  ELSE '' END
 --from msdb..sysschedules ss
 --where freq_type = 8
 --) as F
 --where schedule_id = sj.schedule_id
 --)
 --WHEN (freq_type = 16) then 'Day ' + convert(varchar(2),freq_interval)
 --WHEN (freq_type = 32) then (select freq_rel + WDAY
 --from (select ss.schedule_id,
 --'freq_rel' = CASE(freq_relative_interval)
 --WHEN 1 then 'First'
 --WHEN 2 then 'Second'
 --WHEN 4 then 'Third'
 --WHEN 8 then 'Fourth'
 --WHEN 16 then 'Last'
 --ELSE '??'
 --END,
 --'WDAY'     = CASE (freq_interval)
 --WHEN 1 then ' Sunday'
 --WHEN 2 then ' Monday'
 --WHEN 3 then ' Tuesday'
 --WHEN 4 then ' Wednesday'
 --WHEN 5 then ' Thursday'
 --WHEN 6 then ' Friday'
 --WHEN 7 then ' Saturday'
 --WHEN 8 then ' Day'
 --WHEN 9 then ' Weekday'
 --WHEN 10 then ' Weekend'
 --ELSE '??'
 --END
 --from msdb..sysschedules ss
 --where ss.freq_type = 32
 --) as WS
 --where WS.schedule_id =ss.schedule_id
 --)
 --END,
 --'Time' = CASE (freq_subday_type)
 --WHEN 1 then   left(stuff((stuff((replicate('0', 6 -  len(Active_Start_Time)))+  convert(varchar(6),Active_Start_Time),3,0,':')),6,0,':'),8)
 --WHEN 2 then 'Every ' + convert(varchar(10),freq_subday_interval) + ' seconds'
 --WHEN 4 then 'Every ' + convert(varchar(10),freq_subday_interval) + ' minutes'
 --WHEN 8 then 'Every ' + convert(varchar(10),freq_subday_interval) + ' hours'
 --ELSE '??'
 --END,
 /*nuevas lineas*/
 CASE [freq_type]
        WHEN 4 THEN 'Occurs every ' + CAST([freq_interval] AS VARCHAR(3)) + ' day(s)'
        WHEN 8 THEN 'Occurs every ' + CAST([freq_recurrence_factor] AS VARCHAR(3)) 
                    + ' week(s) on '
                    + CASE WHEN [freq_interval] & 1 = 1 THEN 'Sunday' ELSE '' END
                    + CASE WHEN [freq_interval] & 2 = 2 THEN ', Monday' ELSE '' END
                    + CASE WHEN [freq_interval] & 4 = 4 THEN ', Tuesday' ELSE '' END
                    + CASE WHEN [freq_interval] & 8 = 8 THEN ', Wednesday' ELSE '' END
                    + CASE WHEN [freq_interval] & 16 = 16 THEN ', Thursday' ELSE '' END
                    + CASE WHEN [freq_interval] & 32 = 32 THEN ', Friday' ELSE '' END
                    + CASE WHEN [freq_interval] & 64 = 64 THEN ', Saturday' ELSE '' END
        WHEN 16 THEN 'Occurs on Day ' + CAST([freq_interval] AS VARCHAR(3)) 
                     + ' of every '
                     + CAST([freq_recurrence_factor] AS VARCHAR(3)) + ' month(s)'
        WHEN 32 THEN 'Occurs on '
                     + CASE [freq_relative_interval]
                        WHEN 1 THEN 'First'
                        WHEN 2 THEN 'Second'
                        WHEN 4 THEN 'Third'
                        WHEN 8 THEN 'Fourth'
                        WHEN 16 THEN 'Last'
                       END
                     + ' ' 
                     + CASE [freq_interval]
                        WHEN 1 THEN 'Sunday'
                        WHEN 2 THEN 'Monday'
                        WHEN 3 THEN 'Tuesday'
                        WHEN 4 THEN 'Wednesday'
                        WHEN 5 THEN 'Thursday'
                        WHEN 6 THEN 'Friday'
                        WHEN 7 THEN 'Saturday'
                        WHEN 8 THEN 'Day'
                        WHEN 9 THEN 'Weekday'
                        WHEN 10 THEN 'Weekend day'
                       END
                     + ' of every ' + CAST([freq_recurrence_factor] AS VARCHAR(3)) 
                     + ' month(s)'
      END AS [Recurrence]
    , CASE [freq_subday_type]
        WHEN 1 THEN 'Occurs once at ' 
                    + STUFF(
                 STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
        WHEN 2 THEN 'Occurs every ' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + ' Second(s) between ' 
                    + STUFF(
                   STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
                    + ' & ' 
                    + STUFF(
                    STUFF(RIGHT('000000' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
        WHEN 4 THEN 'Occurs every ' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + ' Minute(s) between ' 
                    + STUFF(
                   STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
                    + ' & ' 
                    + STUFF(
                    STUFF(RIGHT('000000' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
        WHEN 8 THEN 'Occurs every ' 
                    + CAST([freq_subday_interval] AS VARCHAR(3)) + ' Hour(s) between ' 
                    + STUFF(
                    STUFF(RIGHT('000000' + CAST([active_start_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
                    + ' & ' 
                    + STUFF(
                    STUFF(RIGHT('000000' + CAST([active_end_time] AS VARCHAR(6)), 6)
                                , 3, 0, ':')
                            , 6, 0, ':')
      END [Frequency],
 /**/
 CONCAT('Schedule will be used starting on ',right(SS.active_start_date,2),'/',RIGHT(LEFT(SS.active_start_date,6),2),'/',LEFT(SS.active_start_date,4)) as 'Start Date',
'Next Run Time' = CASE SJ.next_run_date
 WHEN 0 THEN cast('n/a' as char(10))
 ELSE convert(char(10), convert(datetime,  convert(char(8),SJ.next_run_date)),120)  + ' ' +  left(stuff((stuff((replicate('0', 6 - len(next_run_time)))+  convert(varchar(6),next_run_time),3,0,':')),6,0,':'),8)
 END

 from msdb.dbo.sysjobschedules SJ
 join msdb.dbo.sysjobs         S  on S.job_id       = SJ.job_id
 join msdb.dbo.sysschedules    SS on ss.schedule_id = sj.schedule_id
 join msdb.dbo.sysjobsteps SST ON  SST.job_id = S.job_id
 order by S.name

