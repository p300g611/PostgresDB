
--change Schools Names for US17673


--///////////////validation//////////////////

-- organization info 
select id
      ,organizationname
      ,displayidentifier
      ,createddate::date
      ,activeflag
      ,modifieddate::date
      ,(select  organizationname from organization_parent(o.id) where organizationtypeid=5) distnmae
      ,(select  id from organization_parent(o.id) where organizationtypeid=5) dtid
      ,(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dtcode
      ,(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stname
      ,(select  id from organization_parent(o.id) where organizationtypeid=2) stid 
from  organization o
where displayidentifier in ( '800000060976'
                            ,'660802999880' ) 
order by displayidentifier
        ,createddate desc;


--///////////////update code//////////////////

--update the org_name "HAWTHORNE COUNTRY DAY SCHOOL" to "Hawthorne CtryDaySch-NY" or "Hawthorne CtryDaySch-WCHSTR"
begin;

update organization o
set organizationname = CASE displayidentifier
                          WHEN '660802999880' THEN 'Hawthorne CtryDaySch-WCHSTR'
                          WHEN '800000060976' THEN 'Hawthorne CtryDaySch-NY'
                          ELSE organizationname                     
                       END
   ,modifieddate=now()
   ,modifieduser=12
where displayidentifier in ( '800000060976', '660802999880' )   
and (select  organizationname from organization_parent(o.id) where organizationtypeid=2) = 'New York'; 

commit;

----------------------------------------------------------
/*-- insert actived schools into organizationtreedetail --select refresh_organization_detail();

   update organizationtreedetail
   set schoolname = CASE schooldisplayidentifier
                       WHEN '660802999880' THEN 'Hawthorne CtryDaySch-WCHSTR'
                       WHEN '800000060976' THEN 'Hawthorne CtryDaySch-NY'
                       ELSE schooldisplayidentifier                     
		    END
   where schooldisplayidentifier in ( '800000060976', '660802999880' )  
   and  statename= 'New York''; 


*/
	


