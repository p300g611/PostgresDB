DROP FUNCTION public.load_test_enrollstudents(bigint,bigint,character varying,bigint,character varying,character varying,character varying);
CREATE OR REPLACE FUNCTION public.load_test_enrollstudents(
     ssid_min bigint,
     ssid_max bigint,
     var_assessment character varying,
     var_schoolyear bigint,
     var_grade character varying,
     var_subject character varying,
     var_school character varying
     ) 
 RETURNS character varying AS $BODY$ 
 DECLARE   var_stateid BIGINT;
 DECLARE   var_district character varying;
 DECLARE   var_schoolid bigint;
 DECLARE   var_gradeid bigint;
 DECLARE   var_subjectid bigint;
 DECLARE   var_assessmentid bigint;
 DECLARE   var_testtypeid bigint;
 DECLARE   var_subjectareaid bigint;
 DECLARE   var_mod_user BIGINT;
 DECLARE   var_mod_date timestamp with time zone;
 BEGIN 
 select id into var_stateid from organization  where displayidentifier ='LT' and organizationtypeid =(select id from organizationtype  where typecode='ST') limit 1;         
 select schoolid into var_schoolid from organizationtreedetail  where  schooldisplayidentifier=var_school and stateid=var_stateid limit 1;         
 select districtdisplayidentifier into var_district from organizationtreedetail  where  schoolid=var_schoolid limit 1;         
 select id into var_subjectid from contentarea  where lower(abbreviatedname)=lower(var_subject) limit 1;
 select gc.id into var_gradeid from gradecourse gc inner join enrollment e on e.currentgradelevel=gc.id and lower(abbreviatedname)=lower(var_grade) limit 1; 
 select id into var_assessmentid from assessmentprogram  where lower(abbreviatedname)=lower(var_assessment) limit 1;      
 select id  into var_testtypeid from testtype  where id = case when lower(var_assessment)=lower('KAP') then 2 else 0 end limit 1;      
 select id  into var_subjectareaid from subjectarea  where id = case when lower(var_subject)=lower('ELA') and lower(var_assessment)=lower('KAP') then 17
                                                                     when lower(var_subject)=lower('M') and lower(var_assessment)=lower('KAP') then 1
                                                                     when lower(var_subject)=lower('Sci') and lower(var_assessment)=lower('KAP') then 19 else 0 end  limit 1;      
 select id into var_mod_user from aartuser where email='ats_dba_team@ku.edu';    
 select clock_timestamp() into var_mod_date;   
 if(var_stateid is null or var_schoolid is null or var_district is null or var_subjectid is null or var_gradeid is null or var_assessmentid is null or var_testtypeid is null or var_subjectareaid is null) then 
    raise info 'Invalid parameters var_stateid=%,var_schoolid=%,var_district=%,var_subjectid=%,var_gradeid=%,var_assessmentid=%,var_testtypeid=%,var_subjectareaid=%'
               ,var_stateid,var_schoolid,var_district,var_subjectid,var_gradeid,var_assessmentid,var_testtypeid,var_subjectareaid;
 else  
 IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='tmp_ssid_loop' and table_type='LOCAL TEMPORARY')
                THEN DROP TABLE IF EXISTS tmp_ssid_loop; END IF; 
 create temp table tmp_ssid_loop ( id bigint);
 FOR var_ssid in ssid_min .. ssid_max   
 LOOP
   insert into tmp_ssid_loop select var_ssid;
 END LOOP; 
   
 --student
 raise info 'Trying to process ssid count:%',(select count(*) from tmp_ssid_loop);
 INSERT INTO public.student(statestudentidentifier, legalfirstname, legalmiddlename, 
            legallastname, generationcode, dateofbirth, createddate, modifieddate, 
            gender, firstlanguage, comprehensiverace, primarydisabilitycode, 
            username, password, synced, createduser, activeflag, modifieduser, 
            hispanicethnicity, commbandid, elabandid, finalelabandid, mathbandid, 
            finalmathbandid, source, usaentrydate, esolparticipationcode, 
            esolprogramendingdate, esolprogramentrydate, profilestatus, stateid, 
            scibandid, finalscibandid, writingbandid)
select var_assessment||tmp.id statestudentidentifier,'Student' legalfirstname,'loadtest' legalmiddlename, 
       var_assessment||tmp.id     legallastname,'' generationcode,(var_mod_date - interval '12 year')::date dateofbirth,var_mod_date createddate,var_mod_date modifieddate, 
       1 gender, '' firstlanguage, 1  comprehensiverace, 'ND' primarydisabilitycode, 
       'loadstud.'||lower(var_assessment)||'.'||tmp.id-1  username, 'loadstud.'||lower(var_assessment) "password"
       ,false synced,var_mod_user createduser,true  activeflag,var_mod_user modifieduser, 
       false hispanicethnicity,null commbandid,null elabandid,null finalelabandid,null mathbandid, 
       null finalmathbandid,'loadtest' source,null usaentrydate,0 esolparticipationcode, 
       null esolprogramendingdate, null esolprogramentrydate,'NO SETTINGS' profilestatus,var_stateid stateid, 
       null scibandid,null finalscibandid,null writingbandid 
 from tmp_ssid_loop tmp
 where not exists( select 1 from student s where s.statestudentidentifier= var_assessment||tmp.id and s.stateid=var_stateid and s.legalmiddlename='loadtest');
  raise info 'Noof students inserted:%',(select count(*) from student s where s.stateid=var_stateid and s.legalmiddlename='loadtest' and createduser=var_mod_user and var_mod_date=createddate );
  
 --studentassessmentprogram
INSERT INTO public.studentassessmentprogram(studentid, assessmentprogramid, activeflag, createddate,createduser, modifieddate, modifieduser, kelpa2017flag)
select s.id studentid,var_assessmentid assessmentprogramid,true activeflag,var_mod_date createddate,var_mod_user createduser,var_mod_date modifieddate,var_mod_user modifieduser,null kelpa2017flag 
   from student s 
  inner join tmp_ssid_loop tmp on s.statestudentidentifier= var_assessment||tmp.id and s.stateid=var_stateid and s.legalmiddlename='loadtest' 
  where not exists (select 1 from studentassessmentprogram sap where sap.studentid=s.id and sap.assessmentprogramid=var_assessmentid);
  raise info 'Noof studentassessmentprogram inserted:%',(select count(*) from studentassessmentprogram s where createduser=var_mod_user and var_mod_date=createddate );

--enrollment
INSERT INTO enrollment(
            aypschoolidentifier, residencedistrictidentifier, currentgradelevel, 
            localstudentidentifier, currentschoolyear, fundingschool, schoolentrydate, 
            districtentrydate, stateentrydate, exitwithdrawaldate, exitwithdrawaltype, 
            specialcircumstancestransferchoice, giftedstudent, specialedprogramendingdate, 
            qualifiedfor504, studentid, attendanceschoolid, restrictionid, 
            createddate, createduser, activeflag, modifieddate, modifieduser, 
            source, aypschoolid, sourcetype, notes)
select      '' aypschoolidentifier, var_district residencedistrictidentifier,
            var_gradeid currentgradelevel, '' localstudentidentifier,
            var_schoolyear currentschoolyear, null fundingschool,var_mod_date- interval '90 day'  schoolentrydate, 
            null districtentrydate,null stateentrydate, null exitwithdrawaldate,0 exitwithdrawaltype, 
            null specialcircumstancestransferchoice, null giftedstudent,null specialedprogramendingdate, 
            null qualifiedfor504,s.id studentid,var_schoolid attendanceschoolid,1 restrictionid, 
            var_mod_date createddate,var_mod_user createduser, true activeflag,
            var_mod_date modifieddate,var_mod_user modifieduser, 
            null source, var_schoolid aypschoolid,'loadtest' sourcetype,'loadtest' notes
 from student s 
  inner join tmp_ssid_loop tmp on s.statestudentidentifier= var_assessment||tmp.id and s.stateid=var_stateid and s.legalmiddlename='loadtest' 
  where not exists (select 1 from enrollment e where e.studentid=s.id and currentschoolyear=var_schoolyear and sourcetype='loadtest');
  raise info 'Noof enrollment inserted:%',(select count(*) from enrollment  where createduser=var_mod_user and var_mod_date=createddate and sourcetype='loadtest');
  
--enrollmenttesttypesubjectarea
INSERT INTO enrollmenttesttypesubjectarea(
            enrollmentid, testtypeid, subjectareaid, createddate, modifieddate, 
            createduser, modifieduser, activeflag, groupingindicator1, groupingindicator2, 
            exited)
select      e.id enrollmentid,var_testtypeid testtypeid,
            var_subjectareaid subjectareaid,
            var_mod_date createddate,var_mod_date modifieddate, 
            var_mod_user createduser,var_mod_user modifieduser,
            true activeflag, null groupingindicator1, null groupingindicator2, 
            null exited
 from enrollment e 
 inner join student s on e.studentid=s.id and e.currentschoolyear=var_schoolyear and e.sourcetype='loadtest'
 inner join tmp_ssid_loop tmp on s.statestudentidentifier= var_assessment||tmp.id and s.stateid=var_stateid and s.legalmiddlename='loadtest' 
 where not exists (select 1 from enrollmenttesttypesubjectarea enrl where enrl.enrollmentid=e.id and enrl.subjectareaid=var_subjectareaid); 
 raise info 'Noof enrollmenttesttypesubjectarea inserted:%',(select count(*) from enrollmenttesttypesubjectarea  where createduser=var_mod_user and var_mod_date=createddate);
   
 IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='tmp_ssid_loop' and table_type='LOCAL TEMPORARY')
                THEN DROP TABLE IF EXISTS tmp_ssid_loop; END IF; 
 END IF;
 RETURN 'SUCCESS';  END;
 -- select public.load_test_enrollstudents(ssid_min:=800101,ssid_max:=801000,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH1.1');
 $BODY$
 LANGUAGE plpgsql VOLATILE
 COST 100;
 ALTER FUNCTION public.load_test_enrollstudents(bigint,bigint,character varying,bigint,character varying,character varying,character varying)   OWNER TO aart;


-- IF load test state not exists run below script  
select * from organization  where id in (
select schoolid from organizationtreedetail where statedisplayidentifier    ='LT' union
select districtid from organizationtreedetail where statedisplayidentifier    ='LT' union 
select stateid from organizationtreedetail where statedisplayidentifier    ='LT') 
order by organizationtypeid,displayidentifier;

 DO $$ begin
 IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='tmp_ssid_loop' and table_type='LOCAL TEMPORARY')
                THEN DROP TABLE IF EXISTS tmp_ssid_loop; END IF; 
 create temp table tmp_ssid_loop ( id bigint);
 FOR var_ssid in 1 .. 127   
 LOOP
   insert into tmp_ssid_loop select var_ssid;
 END LOOP; 
 end; $$;

 
--for state
INSERT INTO public.organization(
            organizationname, displayidentifier, organizationtypeid, 
            welcomemessage, createddate, activeflag, createduser, modifieduser, 
            modifieddate, buildinguniqueness, schoolstartdate, schoolenddate, 
            contractingorganization, expirepasswords, expirationdatetype, 
            pooltype, multitestassignment, reportprocess, reportyear, testingmodel, 
            ismerged, timezoneid, observesdaylightsavings)
 select  'Load Test' organizationname,'LT' displayidentifier,2 organizationtypeid, 
            null welcomemessage,now() createddate,true activeflag,174744 createduser,174744 modifieduser, 
            now() modifieddate,null buildinguniqueness,'2017-12-14 00:00:00+00' schoolstartdate, '2018-07-31 00:00:00+00' schoolenddate, 
            true contractingorganization,true  expirepasswords,null expirationdatetype, 
            'MULTIEEOFG' pooltype,null multitestassignment,true reportprocess,2017 reportyear,703 testingmodel, 
            false ismerged,null timezoneid,true observesdaylightsavings from tmp_ssid_loop tmp  where id=1
            and not exists (select 1 from organization o where o.displayidentifier='LT' and 2=o.organizationtypeid);
            
 INSERT INTO public.organizationrelation(organizationid, parentorganizationid, createddate, activeflag, createduser, modifieduser, modifieddate)           
 select o.id organizationid,
        50 parentorganizationid,now() createddate,true activeflag,174744 createduser,174744 modifieduser,now() modifieddate  
        from organization o where o.displayidentifier='LT' and 2=o.organizationtypeid
        and not exists (select 1 from organizationrelation ol where o.id=ol.organizationid);

--for districts
INSERT INTO public.organization(
            organizationname, displayidentifier, organizationtypeid, 
            welcomemessage, createddate, activeflag, createduser, modifieduser, 
            modifieddate, buildinguniqueness, schoolstartdate, schoolenddate, 
            contractingorganization, expirepasswords, expirationdatetype, 
            pooltype, multitestassignment, reportprocess, reportyear, testingmodel, 
            ismerged, timezoneid, observesdaylightsavings)
 select  'District '||tmp.id organizationname,'DT'||tmp.id displayidentifier,5 organizationtypeid, 
            null welcomemessage,now() createddate,true activeflag,174744 createduser,174744 modifieduser, 
            now() modifieddate,null buildinguniqueness,null schoolstartdate, null schoolenddate, 
            case when tmp.id <=10 then false else null end contractingorganization,case when tmp.id <=10 then true else null end  expirepasswords,null expirationdatetype, 
            null pooltype,null multitestassignment,true reportprocess,0 reportyear,null testingmodel, 
            false ismerged,null timezoneid,true observesdaylightsavings from tmp_ssid_loop tmp 
            where not exists (select 1 from organization o where o.displayidentifier='DT'||tmp.id and 5=o.organizationtypeid);

 INSERT INTO public.organizationrelation(organizationid, parentorganizationid, createddate, activeflag, createduser, modifieduser, modifieddate)           
 select o.id organizationid,
        (select id from organization o where o.displayidentifier='LT' and 2=o.organizationtypeid) parentorganizationid,
        now() createddate,true activeflag,174744 createduser,174744 modifieduser,now() modifieddate  
        from organization o 
        inner join  tmp_ssid_loop tmp on 'DT'||tmp.id=o.displayidentifier and 5=o.organizationtypeid and 'District '||tmp.id=o.organizationname
        and not exists (select 1 from organizationrelation ol where o.id=ol.organizationid);            
--for school
INSERT INTO public.organization(
            organizationname, displayidentifier, organizationtypeid, 
            welcomemessage, createddate, activeflag, createduser, modifieduser, 
            modifieddate, buildinguniqueness, schoolstartdate, schoolenddate, 
            contractingorganization, expirepasswords, expirationdatetype, 
            pooltype, multitestassignment, reportprocess, reportyear, testingmodel, 
            ismerged, timezoneid, observesdaylightsavings)
 select  'School '||tmp.id||'.1' organizationname,'SCH'||tmp.id||'.1' displayidentifier,7 organizationtypeid, 
            null welcomemessage,now() createddate,true activeflag,174744 createduser,174744 modifieduser, 
            now() modifieddate,null buildinguniqueness,null schoolstartdate, null schoolenddate, 
            case when tmp.id <=10 then false else null end contractingorganization,case when tmp.id <=10 then true else null end  expirepasswords,null expirationdatetype, 
            null pooltype,null multitestassignment,true reportprocess,0 reportyear,null testingmodel, 
            false ismerged,null timezoneid,true observesdaylightsavings from tmp_ssid_loop tmp 
            where not exists (select 1 from organization o where o.displayidentifier='SCH'||tmp.id||'.1' and 7=organizationtypeid);

  INSERT INTO public.organization(
            organizationname, displayidentifier, organizationtypeid, 
            welcomemessage, createddate, activeflag, createduser, modifieduser, 
            modifieddate, buildinguniqueness, schoolstartdate, schoolenddate, 
            contractingorganization, expirepasswords, expirationdatetype, 
            pooltype, multitestassignment, reportprocess, reportyear, testingmodel, 
            ismerged, timezoneid, observesdaylightsavings) 
 select  'School '||tmp.id||'.2' organizationname,'SCH'||tmp.id||'.2' displayidentifier,7 organizationtypeid, 
            null welcomemessage,now() createddate,true activeflag,174744 createduser,174744 modifieduser, 
            now() modifieddate,null buildinguniqueness,null schoolstartdate, null schoolenddate, 
            case when tmp.id <=10 then false else null end contractingorganization,case when tmp.id <=10 then true else null end  expirepasswords,null expirationdatetype, 
            null pooltype,null multitestassignment,true reportprocess,0 reportyear,null testingmodel, 
            false ismerged,null timezoneid,true observesdaylightsavings from tmp_ssid_loop tmp 
            where not exists (select 1 from organization o where o.displayidentifier='SCH'||tmp.id||'.2' and 7=o.organizationtypeid);
   
 INSERT INTO public.organizationrelation(organizationid, parentorganizationid, createddate, activeflag, createduser, modifieduser, modifieddate)           
 select o.id organizationid,
        (select id from organization o where o.displayidentifier='DT'||tmp.id and 5=o.organizationtypeid) parentorganizationid,
        now() createddate,true activeflag,174744 createduser,174744 modifieduser,now() modifieddate  
        from organization o 
        inner join  tmp_ssid_loop tmp on 'SCH'||tmp.id||'.1'=o.displayidentifier and 7=o.organizationtypeid and 'School '||tmp.id||'.1'=o.organizationname
        and not exists (select 1 from organizationrelation ol where o.id=ol.organizationid); 

 INSERT INTO public.organizationrelation(organizationid, parentorganizationid, createddate, activeflag, createduser, modifieduser, modifieddate)           
 select o.id organizationid,
        (select id from organization o where o.displayidentifier='DT'||tmp.id and 5=o.organizationtypeid) parentorganizationid,
        now() createddate,true activeflag,174744 createduser,174744 modifieduser,now() modifieddate  
        from organization o 
        inner join  tmp_ssid_loop tmp on 'SCH'||tmp.id||'.2'=o.displayidentifier and 7=o.organizationtypeid and 'School '||tmp.id||'.2'=o.organizationname
        and not exists (select 1 from organizationrelation ol where o.id=ol.organizationid); 
        
select public.refresh_organization_detail();

select * from organizationtreedetail where statedisplayidentifier    ='LT'
order by split_part(replace(schooldisplayidentifier,'SCH',''),'.',1)::int,split_part(replace(schooldisplayidentifier,'SCH',''),'.',2)::int;

--Organization assessment program
INSERT INTO orgassessmentprogram(organizationid, assessmentprogramid, createddate, createduser, 
            activeflag, modifieddate, modifieduser, isdefault)--, reportyear)
select (select id  from organization  where displayidentifier ='LT' and 2=organizationtypeid),12,now(),174744,true,now(),174744,null;--,2017;

INSERT INTO orgassessmentprogram(organizationid, assessmentprogramid, createddate, createduser, 
            activeflag, modifieddate, modifieduser, isdefault)--, reportyear)
select (select id  from organization  where displayidentifier ='LT' and 2=organizationtypeid),3,now(),174744,true,now(),174744,null;--,2017;

INSERT INTO orgassessmentprogram(organizationid, assessmentprogramid, createddate, createduser, 
            activeflag, modifieddate, modifieduser, isdefault)--, reportyear)
select (select id  from organization  where displayidentifier ='LT' and 2=organizationtypeid),47,now(),174744,true,now(),174744,null;--,2017;

--Organization hierarchy for drop down
insert into organizationhierarchy 
select (select id  from organization  where displayidentifier ='LT' and 2=organizationtypeid),1 union all
select (select id  from organization  where displayidentifier ='LT' and 2=organizationtypeid),2 union all
select (select id  from organization  where displayidentifier ='LT' and 2=organizationtypeid),5 union all
select (select id  from organization  where displayidentifier ='LT' and 2=organizationtypeid),7 ;

--Validation after students loaded
select schooldisplayidentifier,districtdisplayidentifier,count(distinct s.id) from student s 
inner join enrollment e on e.studentid=s.id
inner join enrollmenttesttypesubjectarea enrl on enrl.enrollmentid=e.id 
inner join organizationtreedetail ot on e.attendanceschoolid=ot.schoolid
inner join studentassessmentprogram sap on s.id=sap.studentid
where statedisplayidentifier    ='LT' and currentschoolyear=2018 
and s.legalmiddlename='loadtest' and s.statestudentidentifier ilike 'KAP%'
group by schooldisplayidentifier,districtdisplayidentifier
order by split_part(replace(schooldisplayidentifier,'SCH',''),'.',1)::int,split_part(replace(schooldisplayidentifier,'SCH',''),'.',2)::int;

select count(distinct s.id) from student s 
inner join enrollment e on e.studentid=s.id
inner join enrollmenttesttypesubjectarea enrl on enrl.enrollmentid=e.id 
inner join organizationtreedetail ot on e.attendanceschoolid=ot.schoolid
inner join studentassessmentprogram sap on s.id=sap.studentid
where statedisplayidentifier    ='LT' and currentschoolyear=2018 
and s.legalmiddlename='loadtest' and s.statestudentidentifier ilike 'KAP%';


 DO $$ begin
 IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='tmp_count_loop' and table_type='LOCAL TEMPORARY')
                THEN DROP TABLE IF EXISTS tmp_count_loop; END IF; 
 create temp table tmp_count_loop ( id bigint);
 FOR var_ssid in 1 .. 127   
 LOOP
   insert into tmp_ssid_loop select var_ssid;
 END LOOP; 
 end; $$;

-- script to run
select row_number() over( order by split_part(replace(schooldisplayidentifier,'SCH',''),'.',1)::int,split_part(replace(schooldisplayidentifier,'SCH',''),'.',2)::int) *2000-1999 min_val,
       row_number() over( order by split_part(replace(schooldisplayidentifier,'SCH',''),'.',1)::int,split_part(replace(schooldisplayidentifier,'SCH',''),'.',2)::int) *2000 max_val,
       schooldisplayidentifier sch
       into temp tmp_script
       from organizationtreedetail where statedisplayidentifier    ='LT'
order by split_part(replace(schooldisplayidentifier,'SCH',''),'.',1)::int,split_part(replace(schooldisplayidentifier,'SCH',''),'.',2)::int;


select 'select public.load_test_enrollstudents(ssid_min:='||min_val||' ,ssid_max:= '||max_val||' ,var_assessment:=''KAP'',var_schoolyear:=2018,var_grade:=''7'',var_subject:=''ELA'',var_school:='''||sch||''');'from tmp_script;

--Script need to run one by one 
select public.load_test_enrollstudents(ssid_min:=1 ,ssid_max:= 2000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH1.1');
select public.load_test_enrollstudents(ssid_min:=2001 ,ssid_max:= 4000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH1.2');
select public.load_test_enrollstudents(ssid_min:=4001 ,ssid_max:= 6000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH2.1');
select public.load_test_enrollstudents(ssid_min:=6001 ,ssid_max:= 8000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH2.2');
select public.load_test_enrollstudents(ssid_min:=8001 ,ssid_max:= 10000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH3.1');
select public.load_test_enrollstudents(ssid_min:=10001 ,ssid_max:= 12000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH3.2');
select public.load_test_enrollstudents(ssid_min:=12001 ,ssid_max:= 14000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH4.1');
select public.load_test_enrollstudents(ssid_min:=14001 ,ssid_max:= 16000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH4.2');
select public.load_test_enrollstudents(ssid_min:=16001 ,ssid_max:= 18000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH5.1');
select public.load_test_enrollstudents(ssid_min:=18001 ,ssid_max:= 20000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH5.2');
select public.load_test_enrollstudents(ssid_min:=20001 ,ssid_max:= 22000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH6.1');
select public.load_test_enrollstudents(ssid_min:=22001 ,ssid_max:= 24000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH6.2');
select public.load_test_enrollstudents(ssid_min:=24001 ,ssid_max:= 26000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH7.1');
select public.load_test_enrollstudents(ssid_min:=26001 ,ssid_max:= 28000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH7.2');
select public.load_test_enrollstudents(ssid_min:=28001 ,ssid_max:= 30000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH8.1');
select public.load_test_enrollstudents(ssid_min:=30001 ,ssid_max:= 32000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH8.2');
select public.load_test_enrollstudents(ssid_min:=32001 ,ssid_max:= 34000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH9.1');
select public.load_test_enrollstudents(ssid_min:=34001 ,ssid_max:= 36000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH9.2');
select public.load_test_enrollstudents(ssid_min:=36001 ,ssid_max:= 38000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH10.1');
select public.load_test_enrollstudents(ssid_min:=38001 ,ssid_max:= 40000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH10.2');
select public.load_test_enrollstudents(ssid_min:=40001 ,ssid_max:= 42000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH11.1');
select public.load_test_enrollstudents(ssid_min:=42001 ,ssid_max:= 44000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH11.2');
select public.load_test_enrollstudents(ssid_min:=44001 ,ssid_max:= 46000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH12.1');
select public.load_test_enrollstudents(ssid_min:=46001 ,ssid_max:= 48000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH12.2');
select public.load_test_enrollstudents(ssid_min:=48001 ,ssid_max:= 50000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH13.1');
select public.load_test_enrollstudents(ssid_min:=50001 ,ssid_max:= 52000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH13.2');
select public.load_test_enrollstudents(ssid_min:=52001 ,ssid_max:= 54000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH14.1');
select public.load_test_enrollstudents(ssid_min:=54001 ,ssid_max:= 56000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH14.2');
select public.load_test_enrollstudents(ssid_min:=56001 ,ssid_max:= 58000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH15.1');
select public.load_test_enrollstudents(ssid_min:=58001 ,ssid_max:= 60000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH15.2');
select public.load_test_enrollstudents(ssid_min:=60001 ,ssid_max:= 62000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH16.1');
select public.load_test_enrollstudents(ssid_min:=62001 ,ssid_max:= 64000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH16.2');
select public.load_test_enrollstudents(ssid_min:=64001 ,ssid_max:= 66000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH17.1');
select public.load_test_enrollstudents(ssid_min:=66001 ,ssid_max:= 68000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH17.2');
select public.load_test_enrollstudents(ssid_min:=68001 ,ssid_max:= 70000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH18.1');
select public.load_test_enrollstudents(ssid_min:=70001 ,ssid_max:= 72000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH18.2');
select public.load_test_enrollstudents(ssid_min:=72001 ,ssid_max:= 74000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH19.1');
select public.load_test_enrollstudents(ssid_min:=74001 ,ssid_max:= 76000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH19.2');
select public.load_test_enrollstudents(ssid_min:=76001 ,ssid_max:= 78000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH20.1');
select public.load_test_enrollstudents(ssid_min:=78001 ,ssid_max:= 80000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH20.2');
select public.load_test_enrollstudents(ssid_min:=80001 ,ssid_max:= 82000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH21.1');
select public.load_test_enrollstudents(ssid_min:=82001 ,ssid_max:= 84000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH21.2');
select public.load_test_enrollstudents(ssid_min:=84001 ,ssid_max:= 86000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH22.1');
select public.load_test_enrollstudents(ssid_min:=86001 ,ssid_max:= 88000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH22.2');
select public.load_test_enrollstudents(ssid_min:=88001 ,ssid_max:= 90000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH23.1');
select public.load_test_enrollstudents(ssid_min:=90001 ,ssid_max:= 92000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH23.2');
select public.load_test_enrollstudents(ssid_min:=92001 ,ssid_max:= 94000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH24.1');
select public.load_test_enrollstudents(ssid_min:=94001 ,ssid_max:= 96000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH24.2');
select public.load_test_enrollstudents(ssid_min:=96001 ,ssid_max:= 98000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH25.1');
select public.load_test_enrollstudents(ssid_min:=98001 ,ssid_max:= 100000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH25.2');
select public.load_test_enrollstudents(ssid_min:=100001 ,ssid_max:= 102000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH26.1');
select public.load_test_enrollstudents(ssid_min:=102001 ,ssid_max:= 104000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH26.2');
select public.load_test_enrollstudents(ssid_min:=104001 ,ssid_max:= 106000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH27.1');
select public.load_test_enrollstudents(ssid_min:=106001 ,ssid_max:= 108000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH27.2');
select public.load_test_enrollstudents(ssid_min:=108001 ,ssid_max:= 110000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH28.1');
select public.load_test_enrollstudents(ssid_min:=110001 ,ssid_max:= 112000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH28.2');
select public.load_test_enrollstudents(ssid_min:=112001 ,ssid_max:= 114000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH29.1');
select public.load_test_enrollstudents(ssid_min:=114001 ,ssid_max:= 116000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH29.2');
select public.load_test_enrollstudents(ssid_min:=116001 ,ssid_max:= 118000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH30.1');
select public.load_test_enrollstudents(ssid_min:=118001 ,ssid_max:= 120000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH30.2');
select public.load_test_enrollstudents(ssid_min:=120001 ,ssid_max:= 122000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH31.1');
select public.load_test_enrollstudents(ssid_min:=122001 ,ssid_max:= 124000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH31.2');
select public.load_test_enrollstudents(ssid_min:=124001 ,ssid_max:= 126000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH32.1');
select public.load_test_enrollstudents(ssid_min:=126001 ,ssid_max:= 128000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH32.2');
select public.load_test_enrollstudents(ssid_min:=128001 ,ssid_max:= 130000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH33.1');
select public.load_test_enrollstudents(ssid_min:=130001 ,ssid_max:= 132000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH33.2');
select public.load_test_enrollstudents(ssid_min:=132001 ,ssid_max:= 134000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH34.1');
select public.load_test_enrollstudents(ssid_min:=134001 ,ssid_max:= 136000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH34.2');
select public.load_test_enrollstudents(ssid_min:=136001 ,ssid_max:= 138000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH35.1');
select public.load_test_enrollstudents(ssid_min:=138001 ,ssid_max:= 140000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH35.2');
select public.load_test_enrollstudents(ssid_min:=140001 ,ssid_max:= 142000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH36.1');
select public.load_test_enrollstudents(ssid_min:=142001 ,ssid_max:= 144000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH36.2');
select public.load_test_enrollstudents(ssid_min:=144001 ,ssid_max:= 146000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH37.1');
select public.load_test_enrollstudents(ssid_min:=146001 ,ssid_max:= 148000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH37.2');
select public.load_test_enrollstudents(ssid_min:=148001 ,ssid_max:= 150000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH38.1');
select public.load_test_enrollstudents(ssid_min:=150001 ,ssid_max:= 152000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH38.2');
select public.load_test_enrollstudents(ssid_min:=152001 ,ssid_max:= 154000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH39.1');
select public.load_test_enrollstudents(ssid_min:=154001 ,ssid_max:= 156000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH39.2');
select public.load_test_enrollstudents(ssid_min:=156001 ,ssid_max:= 158000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH40.1');
select public.load_test_enrollstudents(ssid_min:=158001 ,ssid_max:= 160000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH40.2');
select public.load_test_enrollstudents(ssid_min:=160001 ,ssid_max:= 162000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH41.1');
select public.load_test_enrollstudents(ssid_min:=162001 ,ssid_max:= 164000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH41.2');
select public.load_test_enrollstudents(ssid_min:=164001 ,ssid_max:= 166000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH42.1');
select public.load_test_enrollstudents(ssid_min:=166001 ,ssid_max:= 168000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH42.2');
select public.load_test_enrollstudents(ssid_min:=168001 ,ssid_max:= 170000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH43.1');
select public.load_test_enrollstudents(ssid_min:=170001 ,ssid_max:= 172000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH43.2');
select public.load_test_enrollstudents(ssid_min:=172001 ,ssid_max:= 174000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH44.1');
select public.load_test_enrollstudents(ssid_min:=174001 ,ssid_max:= 176000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH44.2');
select public.load_test_enrollstudents(ssid_min:=176001 ,ssid_max:= 178000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH45.1');
select public.load_test_enrollstudents(ssid_min:=178001 ,ssid_max:= 180000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH45.2');
select public.load_test_enrollstudents(ssid_min:=180001 ,ssid_max:= 182000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH46.1');
select public.load_test_enrollstudents(ssid_min:=182001 ,ssid_max:= 184000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH46.2');
select public.load_test_enrollstudents(ssid_min:=184001 ,ssid_max:= 186000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH47.1');
select public.load_test_enrollstudents(ssid_min:=186001 ,ssid_max:= 188000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH47.2');
select public.load_test_enrollstudents(ssid_min:=188001 ,ssid_max:= 190000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH48.1');
select public.load_test_enrollstudents(ssid_min:=190001 ,ssid_max:= 192000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH48.2');
select public.load_test_enrollstudents(ssid_min:=192001 ,ssid_max:= 194000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH49.1');
select public.load_test_enrollstudents(ssid_min:=194001 ,ssid_max:= 196000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH49.2');
select public.load_test_enrollstudents(ssid_min:=196001 ,ssid_max:= 198000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH50.1');
select public.load_test_enrollstudents(ssid_min:=198001 ,ssid_max:= 200000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH50.2');
select public.load_test_enrollstudents(ssid_min:=200001 ,ssid_max:= 202000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH51.1');
select public.load_test_enrollstudents(ssid_min:=202001 ,ssid_max:= 204000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH51.2');
select public.load_test_enrollstudents(ssid_min:=204001 ,ssid_max:= 206000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH52.1');
select public.load_test_enrollstudents(ssid_min:=206001 ,ssid_max:= 208000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH52.2');
select public.load_test_enrollstudents(ssid_min:=208001 ,ssid_max:= 210000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH53.1');
select public.load_test_enrollstudents(ssid_min:=210001 ,ssid_max:= 212000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH53.2');
select public.load_test_enrollstudents(ssid_min:=212001 ,ssid_max:= 214000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH54.1');
select public.load_test_enrollstudents(ssid_min:=214001 ,ssid_max:= 216000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH54.2');
select public.load_test_enrollstudents(ssid_min:=216001 ,ssid_max:= 218000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH55.1');
select public.load_test_enrollstudents(ssid_min:=218001 ,ssid_max:= 220000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH55.2');
select public.load_test_enrollstudents(ssid_min:=220001 ,ssid_max:= 222000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH56.1');
select public.load_test_enrollstudents(ssid_min:=222001 ,ssid_max:= 224000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH56.2');
select public.load_test_enrollstudents(ssid_min:=224001 ,ssid_max:= 226000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH57.1');
select public.load_test_enrollstudents(ssid_min:=226001 ,ssid_max:= 228000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH57.2');
select public.load_test_enrollstudents(ssid_min:=228001 ,ssid_max:= 230000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH58.1');
select public.load_test_enrollstudents(ssid_min:=230001 ,ssid_max:= 232000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH58.2');
select public.load_test_enrollstudents(ssid_min:=232001 ,ssid_max:= 234000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH59.1');
select public.load_test_enrollstudents(ssid_min:=234001 ,ssid_max:= 236000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH59.2');
select public.load_test_enrollstudents(ssid_min:=236001 ,ssid_max:= 238000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH60.1');
select public.load_test_enrollstudents(ssid_min:=238001 ,ssid_max:= 240000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH60.2');
select public.load_test_enrollstudents(ssid_min:=240001 ,ssid_max:= 242000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH61.1');
select public.load_test_enrollstudents(ssid_min:=242001 ,ssid_max:= 244000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH61.2');
select public.load_test_enrollstudents(ssid_min:=244001 ,ssid_max:= 246000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH62.1');
select public.load_test_enrollstudents(ssid_min:=246001 ,ssid_max:= 248000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH62.2');
select public.load_test_enrollstudents(ssid_min:=248001 ,ssid_max:= 250000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH63.1');
select public.load_test_enrollstudents(ssid_min:=250001 ,ssid_max:= 252000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH63.2');
select public.load_test_enrollstudents(ssid_min:=252001 ,ssid_max:= 254000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH64.1');
select public.load_test_enrollstudents(ssid_min:=254001 ,ssid_max:= 256000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH64.2');
select public.load_test_enrollstudents(ssid_min:=256001 ,ssid_max:= 258000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH65.1');
select public.load_test_enrollstudents(ssid_min:=258001 ,ssid_max:= 260000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH65.2');
select public.load_test_enrollstudents(ssid_min:=260001 ,ssid_max:= 262000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH66.1');
select public.load_test_enrollstudents(ssid_min:=262001 ,ssid_max:= 264000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH66.2');
select public.load_test_enrollstudents(ssid_min:=264001 ,ssid_max:= 266000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH67.1');
select public.load_test_enrollstudents(ssid_min:=266001 ,ssid_max:= 268000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH67.2');
select public.load_test_enrollstudents(ssid_min:=268001 ,ssid_max:= 270000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH68.1');
select public.load_test_enrollstudents(ssid_min:=270001 ,ssid_max:= 272000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH68.2');
select public.load_test_enrollstudents(ssid_min:=272001 ,ssid_max:= 274000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH69.1');
select public.load_test_enrollstudents(ssid_min:=274001 ,ssid_max:= 276000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH69.2');
select public.load_test_enrollstudents(ssid_min:=276001 ,ssid_max:= 278000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH70.1');
select public.load_test_enrollstudents(ssid_min:=278001 ,ssid_max:= 280000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH70.2');
select public.load_test_enrollstudents(ssid_min:=280001 ,ssid_max:= 282000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH71.1');
select public.load_test_enrollstudents(ssid_min:=282001 ,ssid_max:= 284000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH71.2');
select public.load_test_enrollstudents(ssid_min:=284001 ,ssid_max:= 286000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH72.1');
select public.load_test_enrollstudents(ssid_min:=286001 ,ssid_max:= 288000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH72.2');
select public.load_test_enrollstudents(ssid_min:=288001 ,ssid_max:= 290000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH73.1');
select public.load_test_enrollstudents(ssid_min:=290001 ,ssid_max:= 292000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH73.2');
select public.load_test_enrollstudents(ssid_min:=292001 ,ssid_max:= 294000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH74.1');
select public.load_test_enrollstudents(ssid_min:=294001 ,ssid_max:= 296000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH74.2');
select public.load_test_enrollstudents(ssid_min:=296001 ,ssid_max:= 298000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH75.1');
select public.load_test_enrollstudents(ssid_min:=298001 ,ssid_max:= 300000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH75.2');
select public.load_test_enrollstudents(ssid_min:=300001 ,ssid_max:= 302000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH76.1');
select public.load_test_enrollstudents(ssid_min:=302001 ,ssid_max:= 304000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH76.2');
select public.load_test_enrollstudents(ssid_min:=304001 ,ssid_max:= 306000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH77.1');
select public.load_test_enrollstudents(ssid_min:=306001 ,ssid_max:= 308000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH77.2');
select public.load_test_enrollstudents(ssid_min:=308001 ,ssid_max:= 310000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH78.1');
select public.load_test_enrollstudents(ssid_min:=310001 ,ssid_max:= 312000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH78.2');
select public.load_test_enrollstudents(ssid_min:=312001 ,ssid_max:= 314000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH79.1');
select public.load_test_enrollstudents(ssid_min:=314001 ,ssid_max:= 316000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH79.2');
select public.load_test_enrollstudents(ssid_min:=316001 ,ssid_max:= 318000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH80.1');
select public.load_test_enrollstudents(ssid_min:=318001 ,ssid_max:= 320000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH80.2');
select public.load_test_enrollstudents(ssid_min:=320001 ,ssid_max:= 322000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH81.1');
select public.load_test_enrollstudents(ssid_min:=322001 ,ssid_max:= 324000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH81.2');
select public.load_test_enrollstudents(ssid_min:=324001 ,ssid_max:= 326000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH82.1');
select public.load_test_enrollstudents(ssid_min:=326001 ,ssid_max:= 328000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH82.2');
select public.load_test_enrollstudents(ssid_min:=328001 ,ssid_max:= 330000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH83.1');
select public.load_test_enrollstudents(ssid_min:=330001 ,ssid_max:= 332000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH83.2');
select public.load_test_enrollstudents(ssid_min:=332001 ,ssid_max:= 334000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH84.1');
select public.load_test_enrollstudents(ssid_min:=334001 ,ssid_max:= 336000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH84.2');
select public.load_test_enrollstudents(ssid_min:=336001 ,ssid_max:= 338000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH85.1');
select public.load_test_enrollstudents(ssid_min:=338001 ,ssid_max:= 340000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH85.2');
select public.load_test_enrollstudents(ssid_min:=340001 ,ssid_max:= 342000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH86.1');
select public.load_test_enrollstudents(ssid_min:=342001 ,ssid_max:= 344000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH86.2');
select public.load_test_enrollstudents(ssid_min:=344001 ,ssid_max:= 346000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH87.1');
select public.load_test_enrollstudents(ssid_min:=346001 ,ssid_max:= 348000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH87.2');
select public.load_test_enrollstudents(ssid_min:=348001 ,ssid_max:= 350000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH88.1');
select public.load_test_enrollstudents(ssid_min:=350001 ,ssid_max:= 352000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH88.2');
select public.load_test_enrollstudents(ssid_min:=352001 ,ssid_max:= 354000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH89.1');
select public.load_test_enrollstudents(ssid_min:=354001 ,ssid_max:= 356000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH89.2');
select public.load_test_enrollstudents(ssid_min:=356001 ,ssid_max:= 358000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH90.1');
select public.load_test_enrollstudents(ssid_min:=358001 ,ssid_max:= 360000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH90.2');
select public.load_test_enrollstudents(ssid_min:=360001 ,ssid_max:= 362000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH91.1');
select public.load_test_enrollstudents(ssid_min:=362001 ,ssid_max:= 364000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH91.2');
select public.load_test_enrollstudents(ssid_min:=364001 ,ssid_max:= 366000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH92.1');
select public.load_test_enrollstudents(ssid_min:=366001 ,ssid_max:= 368000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH92.2');
select public.load_test_enrollstudents(ssid_min:=368001 ,ssid_max:= 370000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH93.1');
select public.load_test_enrollstudents(ssid_min:=370001 ,ssid_max:= 372000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH93.2');
select public.load_test_enrollstudents(ssid_min:=372001 ,ssid_max:= 374000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH94.1');
select public.load_test_enrollstudents(ssid_min:=374001 ,ssid_max:= 376000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH94.2');
select public.load_test_enrollstudents(ssid_min:=376001 ,ssid_max:= 378000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH95.1');
select public.load_test_enrollstudents(ssid_min:=378001 ,ssid_max:= 380000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH95.2');
select public.load_test_enrollstudents(ssid_min:=380001 ,ssid_max:= 382000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH96.1');
select public.load_test_enrollstudents(ssid_min:=382001 ,ssid_max:= 384000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH96.2');
select public.load_test_enrollstudents(ssid_min:=384001 ,ssid_max:= 386000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH97.1');
select public.load_test_enrollstudents(ssid_min:=386001 ,ssid_max:= 388000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH97.2');
select public.load_test_enrollstudents(ssid_min:=388001 ,ssid_max:= 390000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH98.1');
select public.load_test_enrollstudents(ssid_min:=390001 ,ssid_max:= 392000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH98.2');
select public.load_test_enrollstudents(ssid_min:=392001 ,ssid_max:= 394000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH99.1');
select public.load_test_enrollstudents(ssid_min:=394001 ,ssid_max:= 396000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH99.2');
select public.load_test_enrollstudents(ssid_min:=396001 ,ssid_max:= 398000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH100.1');
select public.load_test_enrollstudents(ssid_min:=398001 ,ssid_max:= 400000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH100.2');
select public.load_test_enrollstudents(ssid_min:=400001 ,ssid_max:= 402000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH101.1');
select public.load_test_enrollstudents(ssid_min:=402001 ,ssid_max:= 404000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH101.2');
select public.load_test_enrollstudents(ssid_min:=404001 ,ssid_max:= 406000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH102.1');
select public.load_test_enrollstudents(ssid_min:=406001 ,ssid_max:= 408000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH102.2');
select public.load_test_enrollstudents(ssid_min:=408001 ,ssid_max:= 410000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH103.1');
select public.load_test_enrollstudents(ssid_min:=410001 ,ssid_max:= 412000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH103.2');
select public.load_test_enrollstudents(ssid_min:=412001 ,ssid_max:= 414000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH104.1');
select public.load_test_enrollstudents(ssid_min:=414001 ,ssid_max:= 416000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH104.2');
select public.load_test_enrollstudents(ssid_min:=416001 ,ssid_max:= 418000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH105.1');
select public.load_test_enrollstudents(ssid_min:=418001 ,ssid_max:= 420000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH105.2');
select public.load_test_enrollstudents(ssid_min:=420001 ,ssid_max:= 422000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH106.1');
select public.load_test_enrollstudents(ssid_min:=422001 ,ssid_max:= 424000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH106.2');
select public.load_test_enrollstudents(ssid_min:=424001 ,ssid_max:= 426000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH107.1');
select public.load_test_enrollstudents(ssid_min:=426001 ,ssid_max:= 428000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH107.2');
select public.load_test_enrollstudents(ssid_min:=428001 ,ssid_max:= 430000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH108.1');
select public.load_test_enrollstudents(ssid_min:=430001 ,ssid_max:= 432000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH108.2');
select public.load_test_enrollstudents(ssid_min:=432001 ,ssid_max:= 434000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH109.1');
select public.load_test_enrollstudents(ssid_min:=434001 ,ssid_max:= 436000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH109.2');
select public.load_test_enrollstudents(ssid_min:=436001 ,ssid_max:= 438000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH110.1');
select public.load_test_enrollstudents(ssid_min:=438001 ,ssid_max:= 440000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH110.2');
select public.load_test_enrollstudents(ssid_min:=440001 ,ssid_max:= 442000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH111.1');
select public.load_test_enrollstudents(ssid_min:=442001 ,ssid_max:= 444000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH111.2');
select public.load_test_enrollstudents(ssid_min:=444001 ,ssid_max:= 446000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH112.1');
select public.load_test_enrollstudents(ssid_min:=446001 ,ssid_max:= 448000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH112.2');
select public.load_test_enrollstudents(ssid_min:=448001 ,ssid_max:= 450000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH113.1');
select public.load_test_enrollstudents(ssid_min:=450001 ,ssid_max:= 452000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH113.2');
select public.load_test_enrollstudents(ssid_min:=452001 ,ssid_max:= 454000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH114.1');
select public.load_test_enrollstudents(ssid_min:=454001 ,ssid_max:= 456000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH114.2');
select public.load_test_enrollstudents(ssid_min:=456001 ,ssid_max:= 458000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH115.1');
select public.load_test_enrollstudents(ssid_min:=458001 ,ssid_max:= 460000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH115.2');
select public.load_test_enrollstudents(ssid_min:=460001 ,ssid_max:= 462000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH116.1');
select public.load_test_enrollstudents(ssid_min:=462001 ,ssid_max:= 464000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH116.2');
select public.load_test_enrollstudents(ssid_min:=464001 ,ssid_max:= 466000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH117.1');
select public.load_test_enrollstudents(ssid_min:=466001 ,ssid_max:= 468000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH117.2');
select public.load_test_enrollstudents(ssid_min:=468001 ,ssid_max:= 470000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH118.1');
select public.load_test_enrollstudents(ssid_min:=470001 ,ssid_max:= 472000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH118.2');
select public.load_test_enrollstudents(ssid_min:=472001 ,ssid_max:= 474000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH119.1');
select public.load_test_enrollstudents(ssid_min:=474001 ,ssid_max:= 476000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH119.2');
select public.load_test_enrollstudents(ssid_min:=476001 ,ssid_max:= 478000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH120.1');
select public.load_test_enrollstudents(ssid_min:=478001 ,ssid_max:= 480000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH120.2');
select public.load_test_enrollstudents(ssid_min:=480001 ,ssid_max:= 482000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH121.1');
select public.load_test_enrollstudents(ssid_min:=482001 ,ssid_max:= 484000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH121.2');
select public.load_test_enrollstudents(ssid_min:=484001 ,ssid_max:= 486000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH122.1');
select public.load_test_enrollstudents(ssid_min:=486001 ,ssid_max:= 488000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH122.2');
select public.load_test_enrollstudents(ssid_min:=488001 ,ssid_max:= 490000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH123.1');
select public.load_test_enrollstudents(ssid_min:=490001 ,ssid_max:= 492000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH123.2');
select public.load_test_enrollstudents(ssid_min:=492001 ,ssid_max:= 494000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH124.1');
select public.load_test_enrollstudents(ssid_min:=494001 ,ssid_max:= 496000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH124.2');
select public.load_test_enrollstudents(ssid_min:=496001 ,ssid_max:= 498000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH125.1');
select public.load_test_enrollstudents(ssid_min:=498001 ,ssid_max:= 500000 ,var_assessment:='KAP',var_schoolyear:=2018,var_grade:='7',var_subject:='ELA',var_school:='SCH125.2');