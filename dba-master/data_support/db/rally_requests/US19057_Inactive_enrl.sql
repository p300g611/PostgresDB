DO 
$BODY$
DECLARE
now_date timestamp with time zone;
aartuserid integer;
BEGIN
  now_date :=now();
  select into aartuserid (select id from aartuser where username = 'cetesysadmin' and activeflag = true);
          update enrollment 
		   set   activeflag = false,
		         modifieduser = aartuserid,
				 modifieddate = now_date,
                 notes='As per us19057 inactive'			 
		   where id in ( select en.id from enrollment en
                        inner join organization o on en.attendanceschoolid = o.id
						inner join organizationtype ot on o.organizationtypeid = ot.id
						inner join student s on en.studentid = s.id
						where en.activeflag = true and 
						en.currentschoolyear = 2016  and 
						o.organizationtypeid = 5 
                        )
		                and activeflag is true;
END;
$BODY$;
