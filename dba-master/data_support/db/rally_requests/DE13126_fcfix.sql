BEGIN;
DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
 row_count integer;
 modified_user integer;
BEGIN
now_date :=now();
modified_user= (SELECT id FROM aartuser WHERE username = 'cetesysadmin');

With s_count as  (
	select s.id,sum( case when ss.activeflag is false then 0 
			      else 1 end ) cnt 
        from studentassessmentprogram sap
		inner join student s on sap.studentid=s.id
		inner join survey ss on ss.studentid=s.id
	where assessmentprogramid=3 
	   and sap.activeflag is true
	   and s.stateid=51 
	group by s.id
 )
   UPDATE studentsurveyresponse
	SET activeflag = TRUE,
	modifieduser = modified_user,
	modifieddate = now_date
	WHERE activeflag = FALSE
	   AND surveyid IN (select ss.id from s_count c
				inner join survey ss on ss.studentid=c.id
				where cnt=0 and ss.activeflag is false);

			row_count := ( select count(*) from studentsurveyresponse where modifieduser = modified_user and modifieddate = now_date);
			RAISE NOTICE 'rows updated studentsurveyresponse : %' , row_count;	
		       
With s_count as  (
	select s.id,sum( case when ss.activeflag is false then 0 
			      else 1 end ) cnt 
        from studentassessmentprogram sap
		inner join student s on sap.studentid=s.id
		inner join survey ss on ss.studentid=s.id
	where assessmentprogramid=3 
	   and sap.activeflag is true
	   and s.stateid=51 
	group by s.id
 )
   UPDATE survey
	SET activeflag = TRUE,
	modifieduser = modified_user,
	modifieddate = now_date
	WHERE activeflag = FALSE
	   AND id IN (select ss.id from s_count c
				inner join survey ss on ss.studentid=c.id
				where cnt=0 and ss.activeflag is false);

			row_count := ( select count(*) from survey where modifieduser = modified_user and modifieddate = now_date);
			RAISE NOTICE 'rows updated survey : %' , row_count;		   
END;
$BODY$; 
COMMIT;				