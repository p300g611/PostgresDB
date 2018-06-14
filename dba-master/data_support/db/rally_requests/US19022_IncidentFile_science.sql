create temporary table tmp_eoi(ssid text,conarea text ,err text);--Routing Issue reported for students from DLM 
\COPY tmp_eoi FROM 'eoi.csv' DELIMITER ',' CSV HEADER ;

 create temporary table tmp_EEcode(cc text,grf text); --GRF  match EE codes
\COPY tmp_EEcode FROM 'Science_GRF_EEs.csv' DELIMITER ',' CSV HEADER ;



--batch-3 : Missouri, New York, West Virginia, New Hampshire, Utah, North Dakota

select opw.id,opw.windowname,organizationname,effectivedate,expirydate,o.id  from operationaltestwindowstate opws
   inner join operationaltestwindow opw on opw.id=opws.operationaltestwindowid
   inner join organization o on o.id=opws.stateid
    where displayidentifier in ('KS','MO','IA','OK','WV','IL','WI','MS','BIE-Choctaw','BIE-Miccosukee')
    order by organizationname;

 
--10123 | 2015-16 Oklahoma Winter Window      --please eliminate this window


 -- Find the student and codes related to window(EOI)(need to eliminate if test name like "R-")
  select distinct statestudentidentifier,
                  --t.testname,
                  cfd.contentcode,  
                   stn.organizationname,
                   s.legallastname,
                   s.legalfirstname,
                   s.legalmiddlename,
                   s.generationcode,
                   s.dateofbirth
                    into temp tmp_Incidentfile   
                    --select  stb.operationalwindowid,s.stateid,count( *)                
              from studenttracker str
		    join studenttrackerband stb on stb.studenttrackerid = str.id
		    join studentstests st on st.testsessionid = stb.testsessionid
		    JOIN test t ON st.testid = t.id
		    JOIN testsection as ts ON (t.id = ts.testid)
		    JOIN testsectionstaskvariants AS tstv ON (ts.id = tstv.testsectionid)
		    JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id) 
		    LEFT JOIN taskvariantlearningmapnode AS tvlm ON (tv.id = tvlm.taskvariantid)
		    LEFT JOIN tasktype tt ON tv.tasktypeid = tt.id 
		    LEFT JOIN frameworktype ft ON ft.id = tv.frameworktypeid
		    LEFT JOIN contentarea ca ON ca.id = tv.contentareaid
		    LEFT JOIN taskvariantcontentframeworkdetail tvcfd ON tv.id = tvcfd.taskvariantid
		    LEFT JOIN contentframeworkdetail cfd ON tvcfd.contentframeworkdetailid = cfd.id
		    LEFT JOIN operationaltestwindowstate ows on ows.operationaltestwindowid=stb.operationalwindowid
		    join student s on s.id = str.studentid
		    left JOIN organization stn on  stn.id=s.stateid
		    join tmp_eoi eoi on eoi.ssid=s.statestudentidentifier
		    where stb.operationalwindowid in (10150,10154,10122,10157,10146,10149,10153,10143,10119,10145,10131,10133,10147,10155,10124,10132,10123,10152,10151,10159,10142,10138,10144) and
		          s.stateid in (3907,9590,9631,9632,9591,79430,9592,9633,51,68376)
		          and  t.testname not like '%R-%'
		          and st.activeflag is true 
				and s.activeflag is true
				and t.contentareaid=441
		         --group by s.stateid,stb.operationalwindowid
		         ;

select 
distinct tmp.statestudentidentifier,
         tmp.contentcode contentframeworkdetailcode,
         1 issue_code,
         organizationname state ,
                   tmp.legallastname,
                   tmp.legalfirstname,
                   tmp.legalmiddlename,
                   tmp.generationcode,
                   tmp.dateofbirth,
         grf
into temp tmp_Incidentfile_ee
  from tmp_Incidentfile tmp 
   inner join tmp_EEcode ee on ee.cc=tmp.contentcode;

\copy (SELECT distinct statestudentidentifier,legallastname,legalmiddlename,legalfirstname,generationcode,dateofbirth,contentframeworkdetailcode,issue_code,state FROM tmp_Incidentfile_ee order by 1) TO 'tmp_Incidentfile_ee1.csv' DELIMITER ',' CSV HEADER;--(FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (SELECT distinct statestudentidentifier,legallastname,legalmiddlename,legalfirstname,generationcode,dateofbirth,grf contentframeworkdetailcode,issue_code,state FROM tmp_Incidentfile_ee order by 1) TO 'tmp_Incidentfile_grf1.csv' DELIMITER ',' CSV HEADER;

--============================================================================
--Issue code2:Misrouting due to NA scores not being scored as incorrect.(need to eliminate if test name like "R-")
   


select distinct statestudentidentifier,
                  --t.testname,
                  cfd.contentcode,  
                   stn.organizationname,
                   s.legallastname,
                   s.legalfirstname,
                   s.legalmiddlename,
                   s.generationcode,
                   s.dateofbirth
                    into temp tmp_Incidentfile2
                   --select s.stateid,count(distinct s.id),stb.operationalwindowid,tss.status
               from studenttracker str
		    join studenttrackerband stb on stb.studenttrackerid = str.id
		    join studentstests st on st.testsessionid = stb.testsessionid
		    JOIN test t ON st.testid = t.id
		    JOIN testsection as ts ON (t.id = ts.testid)
		    JOIN testsectionstaskvariants AS tstv ON (ts.id = tstv.testsectionid)
		    join testsession tss on tss.id=st.testsessionid
		    JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id) 
		    LEFT JOIN taskvariantlearningmapnode AS tvlm ON (tv.id = tvlm.taskvariantid)
		    LEFT JOIN tasktype tt ON tv.tasktypeid = tt.id 
		    LEFT JOIN frameworktype ft ON ft.id = tv.frameworktypeid
		    LEFT JOIN contentarea ca ON ca.id = tv.contentareaid
		    LEFT JOIN taskvariantcontentframeworkdetail tvcfd ON tv.id = tvcfd.taskvariantid
		    LEFT JOIN contentframeworkdetail cfd ON tvcfd.contentframeworkdetailid = cfd.id
		    LEFT OUTER JOIN  studentsresponses sres1 ON st.id = sres1.studentstestsid 
		    join student s on s.id = str.studentid
		    LEFT JOIN operationaltestwindowstate ows on ows.operationaltestwindowid=stb.operationalwindowid
		    left JOIN organization stn on  stn.id=ows.stateid
		    inner join studentassessmentprogram sap on sap.studentid=s.id and sap.assessmentprogramid=3
		    where stb.operationalwindowid in (10150,10154,10122,10157,10146,10149,10153,10143,10119,10145,10131,10133,10147,10155,10124,10132,10123,10152,10151,10159,10142,10138,10144) and 
		     s.stateid in (3907,9590,9631,9632,9591,79430,9592,9633,51,68376)
		                and sres1.studentstestsid is null 
				and str.activeflag is true 
				and stb.activeflag is true 
				and t.testname not like '%R-%'
				and st.activeflag is true 
				and tss.activeflag is true
				and sap.activeflag is true
				and s.activeflag is true
				and st.status=86
				AND tss.activeflag is true 
				and t.contentareaid=441
				--AND tss.status=86
				--group by stb.operationalwindowid,s.stateid,tss.status
				;



select 
distinct tmp.statestudentidentifier,
         tmp.contentcode contentframeworkdetailcode,
         2 issue_code,
         organizationname state ,
                   tmp.legallastname,
                   tmp.legalfirstname,
                   tmp.legalmiddlename,
                   tmp.generationcode,
                   tmp.dateofbirth,
         grf
into temp tmp_Incidentfile_ee2
  from tmp_Incidentfile2 tmp 
   inner join tmp_EEcode ee on ee.cc=tmp.contentcode;

\copy (SELECT distinct statestudentidentifier,legallastname,legalmiddlename,legalfirstname,generationcode,dateofbirth,contentframeworkdetailcode,issue_code,state FROM tmp_Incidentfile_ee2 order by 1) TO 'tmp_Incidentfile_ee2.csv' DELIMITER ',' CSV HEADER;--(FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (SELECT distinct statestudentidentifier,legallastname,legalmiddlename,legalfirstname,generationcode,dateofbirth,grf contentframeworkdetailcode,issue_code,state FROM tmp_Incidentfile_ee2 order by 1) TO 'tmp_Incidentfile_grf2.csv' DELIMITER ',' CSV HEADER;

--============================================================================
--issue cod:5 Testing on two devices (test returns to unused status and scores show as NA; Spring and ITI)
--1210744 | 9145761
 select  distinct statestudentidentifier,
                 -- t.testname,
                  cfd.contentcode,  
                   stn.organizationname,
                   s.legallastname,
                   s.legalfirstname,
                   s.legalmiddlename,
                   s.generationcode,
                   s.dateofbirth
                   into temp tmp_Incidentfile5
                   --select ts.operationaltestwindowid, count(distinct s.id)
      from exitwithoutsavetest ews
	     inner join studentstestsections sts on ews.studenttestsectionid=sts.id
	     inner join studentstests st on st.id=sts.studentstestid
	     inner join testsession ts on ts.id=st.testsessionid
	     JOIN test t ON st.testid = t.id
	     JOIN testsection as tst ON (t.id = tst.testid)
	     JOIN testsectionstaskvariants AS tstv ON (tst.id = tstv.testsectionid)
	     JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id) 
	     LEFT JOIN taskvariantlearningmapnode AS tvlm ON (tv.id = tvlm.taskvariantid)
	     LEFT JOIN tasktype tt ON tv.tasktypeid = tt.id 
	     LEFT JOIN frameworktype ft ON ft.id = tv.frameworktypeid
	     LEFT JOIN contentarea ca ON ca.id = tv.contentareaid
	     LEFT JOIN taskvariantcontentframeworkdetail tvcfd ON tv.id = tvcfd.taskvariantid
	     LEFT JOIN contentframeworkdetail cfd ON tvcfd.contentframeworkdetailid = cfd.id
	     inner join student s on s.id=st.studentid
	     left JOIN organization stn on  stn.id=s.stateid    
	     inner join studentassessmentprogram sap on sap.studentid=s.id and sap.assessmentprogramid=3
	     LEFT OUTER JOIN  studentsresponses sres1 ON st.id = sres1.studentstestsid and sts.id=sres1.studentstestsectionsid
     where ( (ts.operationaltestwindowid in (10150,10154,10122,10157,10146,10149,10153,10143,10119,10145,10131,10133,10147,10155,10124,10132,10123,10152,10151,10159,10142,10138,10144) and t.testname not like '%R-%')or t.testname ilike '%ITI%')  and 
     s.stateid in (3907,9590,9631,9632,9591,79430,9592,9633,51,68376)       
     and  sres1.studentstestsid is null 
				--and str.activeflag is true 
				--and stb.activeflag is true 
				and st.activeflag is true 
				--and sap.activeflag is true
				--and t.testname not like '%R-%'
				and s.activeflag is true
				and ts.activeflag is true
				and st.status=84
				and sts.activeflag is true
				--and ews.createddate>'03/16/2016'
				and coalesce(st.enddatetime,'01-01-9999'::date)<>'01-01-9999'::date
				and t.contentareaid=441
				--group by ts.operationaltestwindowid
				;

				
select 
distinct tmp.statestudentidentifier,
         tmp.contentcode contentframeworkdetailcode,
         5 issue_code,
         organizationname state ,
                   tmp.legallastname,
                   tmp.legalfirstname,
                   tmp.legalmiddlename,
                   tmp.generationcode,
                   tmp.dateofbirth,
         grf
into temp tmp_Incidentfile_ee5
  from tmp_Incidentfile5 tmp 
   inner join tmp_EEcode ee on ee.cc=tmp.contentcode;

\copy (SELECT distinct statestudentidentifier,legallastname,legalmiddlename,legalfirstname,generationcode,dateofbirth,contentframeworkdetailcode,issue_code,state FROM tmp_Incidentfile_ee5 order by 1) TO 'tmp_Incidentfile_ee5.csv' DELIMITER ',' CSV HEADER;--(FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (SELECT distinct statestudentidentifier,legallastname,legalmiddlename,legalfirstname,generationcode,dateofbirth,grf contentframeworkdetailcode,issue_code,state FROM tmp_Incidentfile_ee5 order by 1) TO 'tmp_Incidentfile_grf5.csv' DELIMITER ',' CSV HEADER;

--==================================================

--Issue code4:find non BVI students and BVI tests  (none of the student have braille ITI tests)
--find braille student 
select distinct s.id
    into temp tmp_Braille
 from profileitemattributenameattributecontainer pianac
 join profileitemattribute pia on pianac.attributenameid = pia.id 
 join profileitemattributecontainer piac on pianac.attributecontainerid = piac.id  
 join studentprofileitemattributevalue spav on
  pianac.id = spav.profileitemattributenameattributecontainerid 
 inner join student s on spav.studentid = s.id
 where piac.attributecontainer='Braille' and pia.attributename = 'assignedSupport' and spav.selectedvalue ='true'
       and  s.stateid in (3907,9590,9631,9632,9591,79430,9592,9633,51,68376);

 --find BVI students and non BVI tests  
 select distinct statestudentidentifier,
                  --t.testname,
                  cfd.contentcode,  
                   stn.organizationname,
                   s.legallastname,
                   s.legalfirstname,
                   s.legalmiddlename,
                   s.generationcode,
                   s.dateofbirth,
                   ts.operationaltestwindowid
                    into temp tmp_Incidentfile4  
                   --select ts.operationaltestwindowid  ,s.id,t.id             
 from profileitemattributenameattributecontainer pianac
 join profileitemattribute pia on pianac.attributenameid = pia.id 
 join profileitemattributecontainer piac on pianac.attributecontainerid = piac.id  
 join studentprofileitemattributevalue spav on pianac.id = spav.profileitemattributenameattributecontainerid 
 inner join tmp_Braille tmp on spav.studentid = tmp.id
 inner join studentstests st on st.studentid=tmp.id
 inner join test t on t.id =st.testid 
 inner join testsession ts on ts.id=st.testsessionid 
 JOIN testsection as tst ON (t.id = tst.testid)
 left outer join testaccessibilityflag taf on taf.testid=t.id and accessibilityflagcode in ('braille','visual_impairment')
 JOIN testsectionstaskvariants AS tstv ON (tst.id = tstv.testsectionid)
		   JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id) 
		   LEFT JOIN taskvariantlearningmapnode AS tvlm ON (tv.id = tvlm.taskvariantid)
		   LEFT JOIN tasktype tt ON tv.tasktypeid = tt.id 
		   LEFT JOIN frameworktype ft ON ft.id = tv.frameworktypeid
		   LEFT JOIN contentarea ca ON ca.id = tv.contentareaid
		   LEFT JOIN taskvariantcontentframeworkdetail tvcfd ON tv.id = tvcfd.taskvariantid
		   LEFT JOIN contentframeworkdetail cfd ON tvcfd.contentframeworkdetailid = cfd.id
		   LEFT JOIN operationaltestwindowstate ows on ows.operationaltestwindowid=ts.operationaltestwindowid
		   join student s on s.id = tmp.id
		   left JOIN organization stn on  stn.id=s.stateid
 where ts.source ilike '%ITI%'-- and t.testname  ilike '%BVI%'
      --and t.testname not like '%R-%'
      and pia.attributename = 'visualImpairment' and spav.selectedvalue ='true'
      and st.activeflag is true
      and ts.activeflag is true
      and taf.testid is null
      and t.contentareaid=441
      --group by ts.operationaltestwindowid,s.id,t.id 
      ;
 
select 
distinct tmp.statestudentidentifier,
         tmp.contentcode contentframeworkdetailcode,
         4 issue_code,
         organizationname state ,
                   tmp.legallastname,
                   tmp.legalfirstname,
                   tmp.legalmiddlename,
                   tmp.generationcode,
                   tmp.dateofbirth,
         grf
into temp tmp_Incidentfile_ee4
  from tmp_Incidentfile4 tmp 
   inner join tmp_EEcode ee on ee.cc=tmp.contentcode;

\copy (SELECT distinct statestudentidentifier,legallastname,legalmiddlename,legalfirstname,generationcode,dateofbirth,contentframeworkdetailcode,issue_code,state FROM tmp_Incidentfile_ee4 order by 1) TO 'tmp_Incidentfile_ee4.csv' DELIMITER ',' CSV HEADER;--(FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (SELECT distinct statestudentidentifier,legallastname,legalmiddlename,legalfirstname,generationcode,dateofbirth,grf contentframeworkdetailcode,issue_code,state FROM tmp_Incidentfile_ee4 order by 1) TO 'tmp_Incidentfile_grf4.csv' DELIMITER ',' CSV HEADER;

--=========================================================================
 /* 
--Issue code3:BVI forms administered to non-BVI students (ITI).(need to eliminate if test name like "R-")
--Method-1 (both combination did not exists)
 select distinct s.id--,tafVI.accessibilityflagcode
     into temp tmp_braille_st 
     from student s
 inner join studentstests st on st.studentid=s.id
 inner join test t on t.id =st.testid 
 inner join testsession ts on ts.id=st.testsessionid
 --left outer join testaccessibilityflag tafb on tafb.testid=t.id --and tafb.accessibilityflagcode in ('braille')
 join testaccessibilityflag tafVI on tafVI.testid=t.id and tafVI.accessibilityflagcode in ('visual_impairment')
 where ts.source ilike '%ITI%'
      and s.stateid in (3907,9590,9631,9632,9591,79430,9592,9633,51,68376)
      and st.activeflag is true
      and ts.activeflag is true
      --group by tafVI.accessibilityflagcode;


select count(distinct s.id )--, pia.attributename, spav.selectedvalue,piac.attributecontainer
 from profileitemattributenameattributecontainer pianac
 join profileitemattribute pia on pianac.attributenameid = pia.id 
 join profileitemattributecontainer piac on pianac.attributecontainerid = piac.id  
 join studentprofileitemattributevalue spav on pianac.id = spav.profileitemattributenameattributecontainerid 
 inner join tmp_braille_st s on spav.studentid = s.id
 where (piac.attributecontainer in ('Braille','Spoken') and pia.attributename = 'assignedSupport'
     or pia.attributename = 'visualImpairment');   


 select count(distinct s.id)
    
 from profileitemattributenameattributecontainer pianac
 join profileitemattribute pia on pianac.attributenameid = pia.id 
 join profileitemattributecontainer piac on pianac.attributecontainerid = piac.id  
 join studentprofileitemattributevalue spav on pianac.id = spav.profileitemattributenameattributecontainerid 
 inner join tmp_braille_st s on spav.studentid = s.id
 where piac.attributecontainer='Braille' and pia.attributename = 'assignedSupport' and spav.selectedvalue ='true';    

select distinct s.id
     into temp tmp_braille_std from tmp_braille_st s
 inner join studentstests st on st.studentid=s.id
 inner join test t on t.id =st.testid 
 inner join testsession ts on ts.id=st.testsessionid
 join testaccessibilityflag tafb on tafb.testid=t.id and tafb.accessibilityflagcode in ('visual_impairment')
--  join testaccessibilityflag tafVI on tafVI.testid=t.id and tafVI.accessibilityflagcode in ('visual_impairment')
 where ts.source ilike '%ITI%'
      and st.activeflag is true
      and ts.activeflag is true
      */
-- or method-2
 --find non BVI students and BVI tests  (none of the student have braille ITI tests)
--Find the BVI tests 
 select distinct s.id
     into temp tmp_braille_st 
    -- select tafb.accessibilityflagcode, count(distinct s.id)
     from student s
     inner join enrollment e on e.studentid=s.id and e.activeflag is true
 inner join studentstests st on st.studentid=s.id and st.enrollmentid=e.id
 inner join test t on t.id =st.testid 
 inner join testsession ts on ts.id=st.testsessionid
 left outer join testaccessibilityflag tafb on tafb.testid=t.id --and tafb.accessibilityflagcode in ('braille')
  --join testaccessibilityflag tafVI on tafVI.testid=t.id and tafVI.accessibilityflagcode in ('visual_impairment')
 where ts.source ilike '%ITI%' 
      and t.testname  ilike '%BVI%'
      --and t.testname not like '%R-%'
      and s.stateid in (3907,9590,9631,9632,9591,79430,9592,9633,51,68376)
      and t.activeflag is true
      and st.activeflag is true
      and ts.activeflag is true
      and s.activeflag is true;
      --and tafb.accessibilityflagcode is null
     --group by tafb.accessibilityflagcode;
--find the BVI students
select distinct s.id
   into temp tmp_BVI_stu
 from profileitemattributenameattributecontainer pianac
 join profileitemattribute pia on pianac.attributenameid = pia.id 
 join profileitemattributecontainer piac on pianac.attributecontainerid = piac.id  
 join studentprofileitemattributevalue spav on pianac.id = spav.profileitemattributenameattributecontainerid 
 inner join tmp_braille_st s on spav.studentid = s.id
 where (piac.attributecontainer in ('Braille','Spoken') and pia.attributename = 'assignedSupport'
     or pia.attributename = 'visualImpairment') and spav.selectedvalue ='true'; 

--Eliminate tests bvi students for BVI tests
select distinct statestudentidentifier,
                  --t.testname,
                  cfd.contentcode,  
                   stn.organizationname,
                   s.legallastname,
                   s.legalfirstname,
                   s.legalmiddlename,
                   s.generationcode,
                   s.dateofbirth,
                   ts.operationaltestwindowid
                  -- ,t.testname
                    into temp tmp_Incidentfile3  
                   -- select s.state ,count(distinct s.id)              
 from tmp_braille_st tmp 
		   inner join studentstests st on st.studentid=tmp.id
		   inner join test t on t.id =st.testid 
		   inner join testsession ts on ts.id=st.testsessionid 
		   JOIN testsection as tst ON (t.id = tst.testid)
		   JOIN testsectionstaskvariants AS tstv ON (tst.id = tstv.testsectionid)
		   JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id) 
		   LEFT JOIN taskvariantlearningmapnode AS tvlm ON (tv.id = tvlm.taskvariantid)
		   LEFT JOIN tasktype tt ON tv.tasktypeid = tt.id 
		   LEFT JOIN frameworktype ft ON ft.id = tv.frameworktypeid
		   LEFT JOIN contentarea ca ON ca.id = tv.contentareaid
		   LEFT JOIN taskvariantcontentframeworkdetail tvcfd ON tv.id = tvcfd.taskvariantid
		   LEFT JOIN contentframeworkdetail cfd ON tvcfd.contentframeworkdetailid = cfd.id
		   LEFT JOIN operationaltestwindowstate ows on ows.operationaltestwindowid=ts.operationaltestwindowid
		   join student s on s.id = tmp.id
		   inner join enrollment e on s.id=e.studentid and st.enrollmentid=e.id
		   left JOIN organization stn on  stn.id=s.stateid
		   left outer join tmp_BVI_stu bvi on bvi.id=tmp.id
 where ts.source ilike '%ITI%' 
      and t.testname  ilike '%BVI%'
      --and t.testname not like '%R-%'
      and t.activeflag is true
      and st.activeflag is true
      and ts.activeflag is true
      and s.activeflag is true
      and bvi.id is null
      and t.contentareaid=441
      --group by s.state
      ;

select 
distinct tmp.statestudentidentifier,
         tmp.contentcode contentframeworkdetailcode,
         3 issue_code,
         organizationname state ,
                   tmp.legallastname,
                   tmp.legalfirstname,
                   tmp.legalmiddlename,
                   tmp.generationcode,
                   tmp.dateofbirth,
         grf
into temp tmp_Incidentfile_ee3
  from tmp_Incidentfile3 tmp 
   inner join tmp_EEcode ee on ee.cc=tmp.contentcode;

\copy (SELECT distinct statestudentidentifier,legallastname,legalmiddlename,legalfirstname,generationcode,dateofbirth,contentframeworkdetailcode,issue_code,state FROM tmp_Incidentfile_ee3 order by 1) TO 'tmp_Incidentfile_ee3.csv' DELIMITER ',' CSV HEADER;--(FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (SELECT distinct statestudentidentifier,legallastname,legalmiddlename,legalfirstname,generationcode,dateofbirth,grf contentframeworkdetailcode,issue_code,state FROM tmp_Incidentfile_ee3 order by 1) TO 'tmp_Incidentfile_grf3.csv' DELIMITER ',' CSV HEADER;

