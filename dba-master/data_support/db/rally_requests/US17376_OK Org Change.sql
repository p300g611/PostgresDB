



--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) distnmae,
	(select  id from organization_parent(o.id) where organizationtypeid=5) dtid,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dtcode,
	(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stname,
	(select  id from organization_parent(o.id) where organizationtypeid=2) stid from organization o
where displayidentifier in ('72I006135','55I089273','72I006115','55I089515') 
order by displayidentifier , createddate desc;


--///////////////update code//////////////////

--update the org_dispy_idntf "55I089515" to "55I089273" and name Jackson MS to "Jackson ES"

update organization 
set displayidentifier='55I089273',
    organizationname='Jackson ES',
    modifieddate=now(),
    modifieduser=12
	where id =33494 and displayidentifier='55I089515';      
	 
    
--delete the org --72I006115
 select * from usersorganizations where organizationid=34457;
---move the user to "72I006135"
		update usersorganizations 
		set organizationid=34456
		where organizationid=34457;

-- do not have any enrollment yet!     
select * from enrollment where attendanceschoolid =34457;

       --no need to run this block  
          update enrollment 
          set modifieduser=12,
              modifieddate =now(),
              attendanceschoolid =34456
          where attendanceschoolid =34457;    
          
          

 -- do not have any roster yet! 
 select * from roster where attendanceschoolid=34457;

               --no need to run this block  
          update roster  
          set modifieduser=12,
              modifieddate =now(),
              attendanceschoolid =34456
          where attendanceschoolid =34457;   

-- final delete 
update organization 
set activeflag=false,
    modifieddate=now(),
    modifieduser=12
	where id =34457 and displayidentifier='72I006115' and activeflag=true ;  



--request info: update the org "Collinsville 6th Grade Center" to "Wilson 6th Grade Center"  and move one "Lawton" to "Collinsville"

update organization 
set organizationname='Wilson 6th Grade Center',
    modifieddate=now(),
    modifieduser=12
	where id =34456 and displayidentifier='72I006135'; 

   --moving dist  "Lawton"(32209)  to "Collinsville" (32337)
	update organizationrelation
	set parentorganizationid=32337,
	   modifieduser=12,
	   modifieddate=now()
	where organizationid=34456 and parentorganizationid=32209;

--validation:  select * from organization_parent(34457);











