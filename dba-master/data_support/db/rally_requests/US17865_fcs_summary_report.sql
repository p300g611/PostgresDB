with dlm_std
    as ( select s.id,
         ost.organizationname
					  from student s
					        inner join enrollment e  on s.id=e.studentid and e.activeflag is true					  
						inner join organization ost on s.stateid=ost.id  
						inner join studentassessmentprogram saps ON saps.studentid = s.id 
						inner join assessmentprogram ap ON ap.id = saps.assessmentprogramid and ap.activeflag is true
						where     ap.abbreviatedname ='DLM' and s.activeflag is true and saps.activeflag is true 
       )						
    select
	    s.organizationname                                                 "STATE_NAME",
	    sum(case when categorycode='COMPLETE' then 1 else 0 end )          "COMPLETE",
	    sum(case when categorycode='READY_TO_SUBMIT' then 1 else 0 end )   "READY_TO_SUBMIT",
	    sum(case when categorycode='IN_PROGRESS' then 1 else 0 end )       "IN_PROGRESS",
	    sum(case when categorycode='NOT_STARTED' 
		       or categorycode is null then 1 else 0 end )             "NOT_STARTED",
	    count(*)                                                           "TOTAL_FCS",
	    count(distinct s.id)                                               "TOTAL_STUDENTS"      
     from dlm_std s
	      left outer join survey sr on sr.studentid=s.id and sr.activeflag is true
	      left outer join category c on c.id=sr.status
	      left outer join categorytype ctype on ctype.id = c.categorytypeid and ctype.typecode = 'SURVEY_STATUS'
	      left outer join (select s.id
					  from dlm_std s
						inner join studentassessmentprogram saps ON saps.studentid = s.id and saps.activeflag is true
						inner join assessmentprogram ap ON ap.id = saps.assessmentprogramid and ap.activeflag is true
						where      (organizationname ='Alaska' and ap.abbreviatedname ='AMP')
						        or (organizationname ='Kansas' and ap.abbreviatedname ='KAP') 
					group by s.id) ak on ak.id=s.id
	      where  ak.id is null
	      group by s.organizationname
      order by s.organizationname; 