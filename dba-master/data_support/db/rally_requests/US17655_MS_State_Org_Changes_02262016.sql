--///////////////validation//////////////////

-- organization info 
select id
      ,organizationname
      ,displayidentifier
      ,createddate::date
      ,activeflag
      ,(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stn
      ,(select  organizationname from organization_parent(o.id) where organizationtypeid=5) dist
from organization o
where displayidentifier in ( '2','4','6','7','8','12','16','20','24') 
and (select  organizationname from organization_parent(o.id) where organizationtypeid=2) = 'Mississippi'
order by stn
        ,displayidentifier
        ,createddate desc;

 

--///////////////update code//////////////////

begin;
-- update the organization.displayidentifier for MS. 
update organization o
set displayidentifier = CASE displayidentifier
                         WHEN '2' THEN '2_5321'
                         WHEN '4' THEN '4_5321'
                         WHEN '6' THEN '6_5321'
                         WHEN '7' THEN '7_5321'
                         WHEN '8' THEN '8_5321'
                         WHEN '12' THEN '12_5321'
                         WHEN '16' THEN '16_5321'
                         WHEN '20' THEN '20_5321'
                         WHEN '24' THEN '24_5321'  
                         ELSE   displayidentifier                     
                         END
    ,modifieddate=now()
    ,modifieduser=12
where displayidentifier in ( '2','4','6','7','8','12','16','20','24')  
and (select  organizationname from organization_parent(o.id) where organizationtypeid=2) = 'Mississippi'; 
	
commit;
----------------------------------------------------------
/*-- insert actived schools into organizationtreedetail --select refresh_organization_detail();

   update organizationtreedetail
   set schooldisplayidentifier = CASE schooldisplayidentifier
				 WHEN '2' THEN '2_5321'
				 WHEN '4' THEN '4_5321'
				 WHEN '6' THEN '6_5321'
				 WHEN '7' THEN '7_5321'
				 WHEN '8' THEN '8_5321'
				 WHEN '12' THEN '12_5321'
				 WHEN '16' THEN '16_5321'
				 WHEN '20' THEN '20_5321'
				 WHEN '24' THEN '24_5321'  
				 else   schooldisplayidentifier                     
				 END
   where schooldisplayidentifier in ( '2','4','6','7','8','12','16','20','24')  
   and  statename= 'Mississippi'; 


*/
					   