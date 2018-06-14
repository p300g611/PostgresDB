--///////////////validation//////////////////

-- organization info 
select id
      ,organizationname
      ,displayidentifier
      ,organizationtypeid
      ,activeflag
      ,modifieddate::date
      ,(select  organizationname from organization_parent(o.id) where organizationtypeid=5) distnmae
      ,(select  id from organization_parent(o.id) where organizationtypeid=5) dtid
      ,(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dtcode
      ,(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stname
      ,(select  id from organization_parent(o.id) where organizationtypeid=2) stid 
from  organization o
where displayidentifier in ('28_0130','0130','6_5720') and (select  displayidentifier from organization_parent(o.id) where organizationtypeid=2) ilike '%ms%'
order by displayidentifier
        ,createddate desc;


--///////////////update code//////////////////

--update the org_name "CONCORDIA LEARNING CENTER" to "St. Joseph’s School for the Blind" 
begin;

update organization 
set organizationname ='MORGANTOWN ARTS ACADEMY'
   ,modifieddate=now()
   ,modifieduser=12
where id=4272;


INSERT INTO organization(displayidentifier,organizationname,organizationtypeid,createddate,activeflag,createduser,modifieduser,modifieddate,reportprocess)
	select  '6_5720'                   displayidentifier,
	        'SUMMIT ELEMENTARY SCHOOL' organizationname,
	        5 organizationtypeid,
	        now() createddate,
	        true activeflag,
	        12 createduser,
	        12 modifieduser,
	        now() modifieddate,
	        false reportprocess ;

	       INSERT INTO organizationrelation
				   (organizationid
				   ,parentorganizationid
				   ,createddate
				   ,activeflag
				   ,createduser
				   ,modifieduser
				   ,modifieddate)
   
				   select 
				   
					   (select  id from organization where '6_5720' =displayidentifier and 'SUMMIT ELEMENTARY SCHOOL' = organizationname)             organizationid
					   ,3907 parentorganizationid
					   ,now()        createddate
					   ,true               activeflag
					   ,12                createduser
					   ,12                modifieduser
					   ,now()          modifieddate;
				  




commit;

----------------------------------------------------------
/*
-- insert actived schools into organizationtreedetail --select refresh_organization_detail()
*/
	


