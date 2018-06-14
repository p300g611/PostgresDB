
begin;
update enrollmenttesttypesubjectarea
set   activeflag =false, 
      modifieddate= now(),
	  modifieduser= (select id from aartuser where username ='ats_dba_team@ku.edu')
	  where enrollmentid in (select id from enrollment where studentid in  (select id from student where statestudentidentifier
	  in ('5334546588','3031770455','9770190977','2943948519','7836256154')) 
	  and currentschoolyear=2018 and activeflag is true);

	  
	  
update studentassessmentprogram
set    activeflag =false,
       modifieddate=now(),
	   modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu')
	   where studentid in  (select id from student where statestudentidentifier
	  in ('5334546588','3031770455','9770190977','2943948519','7836256154')) and assessmentprogramid=47 and activeflag is true;


update enrollment 
set   activeflag =false, 
      modifieddate= now(),
	  modifieduser= (select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (3156976,3157075,3156854,3154845,3157338) and activeflag is true and currentschoolyear=2018;


update enrollmentsrosters  
set   activeflag =false, 
      modifieddate= now(),
	  modifieduser= (select id from aartuser where username ='ats_dba_team@ku.edu')
where enrollmentid in (3156976,3157075,3156854,3154845,3157338) and activeflag is true;


commit;
