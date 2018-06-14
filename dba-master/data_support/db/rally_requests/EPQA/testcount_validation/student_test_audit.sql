drop table if exists tmp_epqa;
select 
st.status 
,c.categoryname                            
,st.testsessionid                      
,st.createddate  st_createddate                        
,st.createduser  st_createduser                     
,st.activeflag   st_activeflag                      
,st.modifieduser st_modifieduser                      
,st.modifieddate st_modifieddate                      
,st.enrollmentid                       
,transferedenrollmentid             
,ts.rosterid                           
,ts.name        ts_name                       
,ts.activeflag 
,s.id          std_id                       
,s.statestudentidentifier             
,s.legalfirstname                     
,s.legallastname                      
,e.id                                 
,e.aypschoolidentifier                
,e.currentschoolyear                  
,e.fundingschool                      
,e.exitwithdrawaldate                 
,e.exitwithdrawaltype                 
,e.specialcircumstancestransferchoice 
,e.attendanceschoolid                 
,e.createddate   e_createddate                   
,e.createduser   e_createduser                     
,e.activeflag    e_activeflag                     
,e.modifieddate  e_modifieddate                    
,e.modifieduser  e_modifieduser                     
,e.source        e_source                     
,e.aypschoolid                        
,e.sourcetype                         
,e.notes                              
,sap.assessmentprogramid                
,sap.activeflag     sap_activeflag                    
,gc.name                               
,gc.contentareaid                      
,sub.id           sub_id                      
,sub.subjectareaname                    
,sub.activeflag      sub_activeflag                   
,tt.testtypename  
,ot.statename
,ot.districtname
,ot.schoolname   
into temp tmp_epqa             
 from student s 
left outer join enrollment e on s.id=e.studentid -- and e.activeflag is true and s.activeflag is true
left outer join studentassessmentprogram sap on sap.studentid=s.id  --and sap.activeflag is true 
left outer join gradecourse gc on e.currentgradelevel=gc.id --and gc.activeflag is true
left outer join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
left outer join subjectarea sub on ets.subjectareaid=sub.id --and sub.activeflag is true and ets.activeflag is true
left outer join testtype tt on ets.testtypeid=tt.id --and tt.activeflag is true --and sub.id=10 and tt.id=50  
left outer join studentstests st on st.enrollmentid=e.id and s.id=st.studentid --and st.activeflag is true 
left outer join testsession ts on st.testsessionid=ts.id-- and ts.activeflag is true and ts.schoolyear=2017 
left outer join category c on c.id=st.status
left outer join organizationtreedetail ot on e.attendanceschoolid=ot.schoolid
where s.statestudentidentifier='6913117655' and ts.operationaltestwindowid=10171
order by st.modifieddate desc;

\copy (select * from tmp_epqa) to 'student_test_audit.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);