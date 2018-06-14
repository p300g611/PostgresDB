--///////////////validation//////////////////
-- users info 
select * from aartuser 
where email ilike '%michelle.harris@cusd4.com%'
     or email ilike '%brandy.schlieper@cusd4.com%';

--///////////////update code//////////////////
BEGIN;

update aartuser 
set activeflag=true,
    modifieddate=now(),
    modifieduser=12,
    email='brandy.schlieper@cusd4.com',
    username='brandy.schlieper@cusd4.com'
	where id =120031; 


update aartuser 
set activeflag=true,
    modifieddate=now(),
    modifieduser=12,
    email='michelle.harris@cusd4.com',
    username='michelle.harris@cusd4.com'
	where id =120030; 
COMMIT;	  



--///////////////validation//////////////////
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
where (organizationname ilike '%Unity Middle School%'
       or  organizationname ilike '%Unity Elementary%' ) and (select  displayidentifier from organization_parent(o.id) where organizationtypeid=2) ='IL';


select uo.*,g.groupname from usersorganizations uo
   inner join userorganizationsgroups uog on uog.userorganizationid= uo.id 
   inner join groups g on g.id=uog.groupid
   where uo.aartuserid= 120031; 


   select * from usersorganizations uo
   inner join userorganizationsgroups uog on uog.userorganizationid= uo.id 
   inner join groups g on g.id=uog.groupid
   where uo.aartuserid= 120030; 


-- moving the user to inactive org to active org 
Begin;

update  usersorganizations
set organizationid=46512,
    modifieduser=12,
   modifieddate=now()
    where aartuserid=120031 and organizationid=46511;


 update  usersorganizations
set organizationid=79432,
    modifieduser=12,
   modifieddate=now()
    where aartuserid=120030 and organizationid=46510;

commit;    
  









   
	 