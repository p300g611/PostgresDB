select ts.name,ts.id tsid,ts.rosterid,st.id stid,st.enrollmentid,st.testid,st.status,contentareaid,st.activeflag,st.id ,tc.id,st.createddate from studentstests st
inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
inner join testcollection tc on tc.id=ts.testcollectionid
where studentid =1269243   order by contentareaid,enrollmentid,rosterid;
--==================================================================================
--student:1269243
--==================================================================================
begin;
update testsession 
set    activeflag =false,
       modifieddate =now(),
       modifieduser =174744
where id in (5874694,5870713,5999115) and activeflag is true ;


update studentstests 
set    activeflag =false,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='Ticket Number#DE17074'
where studentid =1269243 and testsessionid in (5874694,5870713,5999115) and activeflag is true;

commit;


select ts.name,ts.id tsid,ts.rosterid,st.id stid,st.enrollmentid,st.testid,st.status,contentareaid,st.activeflag,st.id ,tc.id,st.createddate from studentstests st
inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
inner join testcollection tc on tc.id=ts.testcollectionid
where studentid =1398161   order by contentareaid,enrollmentid,rosterid;
--==================================================================================
--student:1398161
--==================================================================================
begin;
update testsession 
set    activeflag =false,
       modifieddate =now(),
       modifieduser =174744
where id in (5870711,5999114,5874693) and activeflag is true ;


update studentstests 
set    activeflag =false,
       modifieddate =now(),
       modifieduser =174744,
       manualupdatereason='Ticket Number#DE17074'
where studentid =1398161 and testsessionid in (5870711,5999114,5874693) and activeflag is true;

commit;