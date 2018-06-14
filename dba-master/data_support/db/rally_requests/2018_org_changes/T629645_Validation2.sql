--deactivate the student test grade 
--funciton address:https://code.cete.us/svn/dlm/aart/trunk/aart-web-dependencies/data_support/db/rally_requests/DLM_testreset/update_grade_validation2.sql
--SSID:1694249 ,4576610419 ,7183249008 ,3604682814
begin;


select updatedategradevalidation2(2018,1403938,'for ticket#629645') ;
select updatedategradevalidation2(2018,1398162,'for ticket#629645') ;
select updatedategradevalidation2(2018,1398164,'for ticket#629645') ;
select updatedategradevalidation2(2018,1398163,'for ticket#629645') ;

commit;

