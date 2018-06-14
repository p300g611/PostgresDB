-- We need to physically delete from the database.
select displayidentifier,organizationname||' ('||displayidentifier||')',specialcircumstancetype,cedscode,ksdecode,ssc.specialcircumstanceid,ssc.stateid
 from orgassessmentprogram oap
inner join organization o on oap.organizationid=o.id
inner join statespecialcircumstance ssc on o.id=ssc.stateid
inner join specialcircumstance sc on ssc.specialcircumstanceid=sc.id
where oap.activeflag is true and o.activeflag is true  and ssc.activeflag is true and sc.activeflag is true 
and oap.assessmentprogramid=3 and organizationtypeid=2
 and o.displayidentifier ='AK'
order by o.displayidentifier,specialcircumstancetype ;  


select organizationname||' ('||displayidentifier||')',specialcircumstancetype,cedscode,ksdecode,ssc.specialcircumstanceid,ssc.stateid
 from orgassessmentprogram oap
inner join organization o on oap.organizationid=o.id
inner join statespecialcircumstance ssc on o.id=ssc.stateid
inner join specialcircumstance sc on ssc.specialcircumstanceid=sc.id
where oap.activeflag is true and o.activeflag is true  and ssc.activeflag is true and sc.activeflag is true 
and oap.assessmentprogramid=3 and organizationtypeid=2
--  and o.displayidentifier ='NH'
order by 1,specialcircumstancetype ; 


  id   | displayidentifier
-------+-------------------
 69163 | 123
 35999 | AK
 58539 | AMPQCST
 68154 | ARMM2015
 58549 | ARMMQCST
 63919 | ATEAPROD
 58540 | ATEAQCST
 68376 | BIE-Choctaw
 79430 | BIE-Miccosukee
  3384 | CO
 64402 | CO-cPass
 58547 | CPASSQCST
 58510 | DL
 67877 | DLMQCEOYST
 67875 | DLMQCIMST
 58548 | DLMQCST
 67876 | DLMQCYEST
 42087 | DS
  9633 | IA
  9632 | IL
 58538 | KAPQCST
    51 | KS
 82933 | MD
  9591 | MO
  3907 | MS
 66510 | MS-cPass
 42667 | NC
 37702 | ND
 58572 | NH
  9634 | NJ
 69352 | NY
 82599 | NYTRAIN
  9592 | OK
 60080 | PA
 79479 | PII_STATE
 58550 | PLAYQCST
 82749 | SDQA
 58525 | TPS
 36560 | UT
 21814 | VA
  9588 | VT
  9631 | WI
  9590 | WV




--CO
INSERT INTO statespecialcircumstance(
            stateid, specialcircumstanceid, requireconfirmation, activeflag, 
            createdate, createduser, modifieddate, modifieduser)
select      (select id from organization where displayidentifier='CO' and activeflag is true) stateid, 
             (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Chronic Absences') and activeflag is true and cedscode='13813') specialcircumstanceid ,
             false           requireconfirmation, 
             true            activeflag, 
             now()           createdate,
             174744              createduser, 
             now()           modifieddate,
             174744              modifieduser;
--UT
INSERT INTO statespecialcircumstance(
            stateid, specialcircumstanceid, requireconfirmation, activeflag, 
            createdate, createduser, modifieddate, modifieduser)
select      (select id from organization where displayidentifier='UT' and activeflag is true) stateid, 
             (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Other reason for nonparticipation') and activeflag is true and cedscode='13831') specialcircumstanceid ,
             false           requireconfirmation, 
             true            activeflag, 
             now()           createdate,
             174744              createduser, 
             now()           modifieddate,
              174744             modifieduser;

INSERT INTO statespecialcircumstance(
            stateid, specialcircumstanceid, requireconfirmation, activeflag, 
            createdate, createduser, modifieddate, modifieduser)
select      (select id from organization where displayidentifier='UT' and activeflag is true) stateid, 
             (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Student Refusal') and activeflag is true and cedscode='13826') specialcircumstanceid ,
             false           requireconfirmation, 
             true            activeflag, 
             now()           createdate,
             174744              createduser, 
             now()           modifieddate,
              174744             modifieduser;

INSERT INTO statespecialcircumstance(
            stateid, specialcircumstanceid, requireconfirmation, activeflag, 
            createdate, createduser, modifieddate, modifieduser)
select      (select id from organization where displayidentifier='UT' and activeflag is true) stateid, 
             (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Administration or system failure') and activeflag is true and cedscode='13835') specialcircumstanceid ,
             false           requireconfirmation, 
             true            activeflag, 
             now()           createdate,
             174744              createduser, 
             now()           modifieddate,
              174744             modifieduser;             

--ND
INSERT INTO statespecialcircumstance(
            stateid, specialcircumstanceid, requireconfirmation, activeflag, 
            createdate, createduser, modifieddate, modifieduser)
select      (select id from organization where displayidentifier='ND' and activeflag is true) stateid, 
             (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Medical waiver') and activeflag is true and cedscode='3454') specialcircumstanceid ,
             false           requireconfirmation, 
             true            activeflag, 
             now()           createdate,
             174744              createduser, 
             now()           modifieddate,
              174744             modifieduser;
--AK,except mw(three things)       
update statespecialcircumstance
set modifieddate=now(),modifieduser=174744,activeflag =false 
-- select * from statespecialcircumstance
where (select id from organization where displayidentifier='AK' and activeflag is true)=stateid
and (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Absent') and activeflag is true and cedscode='9999') =specialcircumstanceid
and activeflag is true;


update statespecialcircumstance
set modifieddate=now(),modifieduser=174744,activeflag =false 
-- select * from statespecialcircumstance
where (select id from organization where displayidentifier='AK' and activeflag is true)=stateid
and (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Invalidation') and activeflag is true and cedscode='9999') =specialcircumstanceid
and activeflag is true;


update statespecialcircumstance
set modifieddate=now(),modifieduser=174744,activeflag =false 
-- select * from statespecialcircumstance
where (select id from organization where displayidentifier='AK' and activeflag is true)=stateid
and (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Parent refusal') and activeflag is true and cedscode='13820') =specialcircumstanceid
and activeflag is true;


update statespecialcircumstance
set modifieddate=now(),modifieduser=174744,activeflag =false 
-- select * from statespecialcircumstance
where (select id from organization where displayidentifier='AK' and activeflag is true)=stateid
and (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Student refusal') and activeflag is true and cedscode='13826') =specialcircumstanceid
and activeflag is true;

--ND --other need to remove 

update statespecialcircumstance
set modifieddate=now(),modifieduser=174744,activeflag =false 
-- select * from statespecialcircumstance
where (select id from organization where displayidentifier='ND' and activeflag is true)=stateid
and (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Other') and activeflag is true and cedscode='9999') =specialcircumstanceid
and activeflag is true;

--NJ 
--  Home schooled for assessed subjects  
update statespecialcircumstance
set modifieddate=now(),modifieduser=174744,activeflag =false 
-- select * from statespecialcircumstance
where (select id from organization where displayidentifier='NJ' and activeflag is true)=stateid
and (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Home schooled for assessed subjects') and activeflag is true and cedscode='13815') =specialcircumstanceid
and activeflag is true;
  
--  Other reason for nonparticipation    

update statespecialcircumstance
set modifieddate=now(),modifieduser=174744,activeflag =false 
-- select * from statespecialcircumstance
where (select id from organization where displayidentifier='NJ' and activeflag is true)=stateid
and (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Other reason for nonparticipation') and activeflag is true and cedscode='13831') =specialcircumstanceid
and activeflag is true;



--IA 
-- Homebound
update statespecialcircumstance
set modifieddate=now(),modifieduser=174744,activeflag =false 
-- select * from statespecialcircumstance
where (select id from organization where displayidentifier='IA' and activeflag is true)=stateid
and (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Homebound') and activeflag is true and cedscode='13824') =specialcircumstanceid
and activeflag is true;


--WI,      
update statespecialcircumstance
set modifieddate=now(),modifieduser=174744,activeflag =false 
-- select * from statespecialcircumstance
where (select id from organization where displayidentifier='WI' and activeflag is true)=stateid
and (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Medical Waiver') and activeflag is true and cedscode='3454') =specialcircumstanceid
and activeflag is true;


update statespecialcircumstance
set modifieddate=now(),modifieduser=174744,activeflag =false 
-- select * from statespecialcircumstance
where (select id from organization where displayidentifier='WI' and activeflag is true)=stateid
and (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Other') and activeflag is true and cedscode='9999') =specialcircumstanceid
and activeflag is true;


update statespecialcircumstance
set modifieddate=now(),modifieduser=13,activeflag =false 
-- select * from statespecialcircumstance
where (select id from organization where displayidentifier='WI' and activeflag is true)=stateid
and (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Other reason for nonparticipation') and activeflag is true and cedscode='13831') =specialcircumstanceid
and activeflag is true;


update statespecialcircumstance
set modifieddate=now(),modifieduser=174744,activeflag =false 
-- select * from statespecialcircumstance
where (select id from organization where displayidentifier='WI' and activeflag is true)=stateid
and (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Parent refusal') and activeflag is true and cedscode='13820') =specialcircumstanceid
and activeflag is true;


---

--NH


INSERT INTO statespecialcircumstance(
            stateid, specialcircumstanceid, requireconfirmation, activeflag, 
            createdate, createduser, modifieddate, modifieduser)
select      (select id from organization where displayidentifier='NH' and activeflag is true) stateid, 
             id specialcircumstanceid ,
             false           requireconfirmation, 
             true            activeflag, 
             now()           createdate,
             174744              createduser, 
             now()           modifieddate,
              174744             modifieduser 
              from specialcircumstance where activeflag is true and cedscode in ('13835'
,'13814'
,'13821'
,'13813'
,'13837'
,'13825'
,'13815'
,'13824'
,'13817'
,'13832'
,'13807'
,'3454'
,'13828'
,'13830'
,'13831'
,'13820'
,'13827'
,'13819'
,'13818'
,'13826'
,'13816'
,'13829'
,'13836'
,'13811'
,'13810') and activeflag is true;


INSERT INTO statespecialcircumstance(
            stateid, specialcircumstanceid, requireconfirmation, activeflag, 
            createdate, createduser, modifieddate, modifieduser)
select      (select id from organization where displayidentifier='NH' and activeflag is true) stateid, 
             51 specialcircumstanceid ,
             false           requireconfirmation, 
             true            activeflag, 
             now()           createdate,
             174744              createduser, 
             now()           modifieddate,
              174744             modifieduser;

INSERT INTO statespecialcircumstance(
            stateid, specialcircumstanceid, requireconfirmation, activeflag, 
            createdate, createduser, modifieddate, modifieduser)
select      (select id from organization where displayidentifier='NH' and activeflag is true) stateid, 
             43 specialcircumstanceid ,
             false           requireconfirmation, 
             true            activeflag, 
             now()           createdate,
             174744              createduser, 
             now()           modifieddate,
              174744             modifieduser;
              


begin;

update specialcircumstance
set activeflag =true 
where cedscode in ('13833','13812','13834','13822','13808','13823','13809') and activeflag is false ;

INSERT INTO statespecialcircumstance(
            stateid, specialcircumstanceid, requireconfirmation, activeflag, 
            createdate, createduser, modifieddate, modifieduser)
select      (select id from organization where displayidentifier='NH' and activeflag is true) stateid, 
             id specialcircumstanceid ,
             false           requireconfirmation, 
             true            activeflag, 
             now()           createdate,
             174744              createduser, 
             now()           modifieddate,
              174744             modifieduser 
              from specialcircumstance where activeflag is true and cedscode in ('13833','13812','13834','13822','13808','13823','13809') and activeflag is true;

commit;


select specialcircumstancetype,cedscode,id from specialcircumstance where cedscode not in ('13835'
,'13814'
,'13821'
,'13813'
,'13837'
,'13825'
,'13815'
,'13824'
,'13817'
,'13832'
,'13807'
,'3454'
,'13828'
,'13830'
,'13831'
,'13820'
,'13827'
,'13819'
,'13818'
,'13826'
,'13816'
,'13829'
,'13836'
,'13811'
,'13810') and activeflag is true;


begin;
delete from statespecialcircumstance where specialcircumstanceid=43 and stateid=37702;
delete from statespecialcircumstance where activeflag is false;



commit;


-- studentstests used SC codes for DLM --
select o.displayidentifier,statestudentidentifier,e.studentid,st.id studentstestsid,stsc.specialcircumstanceid,cedscode,specialcircumstancetype,stsc.createdate, ssc.stateid sc_stateid
 from studentspecialcircumstance stsc
 inner join studentstests st on st.id = stsc.studenttestid
 inner join enrollment e ON st.enrollmentid = e.id
 inner join student s on s.id=e.studentid and e.activeflag is true
 inner join organization o on o.id=s.stateid
 inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
 inner join specialcircumstance sc ON stsc.specialcircumstanceid = sc.id
 left outer join statespecialcircumstance ssc ON ssc.specialcircumstanceid = sc.id and ssc.stateid=o.id
 where  sap.assessmentprogramid=3;


begin; 

 INSERT INTO statespecialcircumstance(
            stateid, specialcircumstanceid, requireconfirmation, activeflag, 
            createdate, createduser, modifieddate, modifieduser)
select      (select id from organization where displayidentifier='AK' and activeflag is true) stateid, 
             (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Chronic absences') and activeflag is true and cedscode='13813') specialcircumstanceid ,
             false           requireconfirmation, 
             true            activeflag, 
             now()           createdate,
             174744              createduser, 
             now()           modifieddate,
             174744              modifieduser;

INSERT INTO statespecialcircumstance(
            stateid, specialcircumstanceid, requireconfirmation, activeflag, 
            createdate, createduser, modifieddate, modifieduser)
select      (select id from organization where displayidentifier='AK' and activeflag is true) stateid, 
             (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Parent refusal') and activeflag is true and cedscode='13820') specialcircumstanceid ,
             false           requireconfirmation, 
             true            activeflag, 
             now()           createdate,
             174744              createduser, 
             now()           modifieddate,
             174744              modifieduser;
             
INSERT INTO statespecialcircumstance(
            stateid, specialcircumstanceid, requireconfirmation, activeflag, 
            createdate, createduser, modifieddate, modifieduser)
select      (select id from organization where displayidentifier='AK' and activeflag is true) stateid, 
             (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Student refusal') and activeflag is true and cedscode='13826') specialcircumstanceid ,
             false           requireconfirmation, 
             true            activeflag, 
             now()           createdate,
             174744              createduser, 
             now()           modifieddate,
             174744              modifieduser;

 INSERT INTO statespecialcircumstance(
            stateid, specialcircumstanceid, requireconfirmation, activeflag, 
            createdate, createduser, modifieddate, modifieduser)
select      (select id from organization where displayidentifier='AK' and activeflag is true) stateid, 
             (select id from specialcircumstance where upper(specialcircumstancetype)=upper('Other') and activeflag is true and cedscode='09999') specialcircumstanceid ,
             false           requireconfirmation, 
             true            activeflag, 
             now()           createdate,
             174744              createduser, 
             now()           modifieddate,
             174744              modifieduser;             


commit;
  
          	