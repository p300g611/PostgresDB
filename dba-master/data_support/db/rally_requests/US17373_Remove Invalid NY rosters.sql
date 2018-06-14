
update enrollmentsrosters
set activeflag = false
   ,modifieddate = now()
   ,modifieduser = 12
where rosterid in (select id 
                   from  roster 
                   where coursesectionname like '%ZZDoNotUse%' 
and attendanceschoolid in (select id 
                           from organization_children((select id 
                                                       from  organization 
                                                       where displayidentifier='NY' 
                                                       and   organizationtypeid=2)))); -- 1078 rows


update roster 
set activeflag = false
   ,modifieddate = now()
   ,modifieduser = 12
where id in (select id 
             from  roster 
             where coursesectionname like '%ZZDoNotUse%' 
and   attendanceschoolid in (select id 
                             from organization_children((select id 
                                                         from  organization 
                                                         where displayidentifier='NY' 
                                                         and   organizationtypeid=2)))); -- 150 rows




