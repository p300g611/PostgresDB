



--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) distnmae,
	(select  id from organization_parent(o.id) where organizationtypeid=5) dtid,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dtcode,
	(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stname,
	(select  id from organization_parent(o.id) where organizationtypeid=2) stid from organization o
where displayidentifier in ('2178','2174','2170','2176','2171') and (select  id from organization_parent(o.id) where organizationtypeid=2) =51 -- only the KS state 
order by displayidentifier , createddate desc;


--///////////////update code//////////////////

-- NOTE:: user story reguested  for delete the org

--improtant not::Here is small dependency moving 2171 to 2176 first then 2178,2174 to 2171 other wise logic will change all move to 2176
--- moving 2171 to 2176 

			   --delete the org --2171
			 select * from usersorganizations where organizationid=1993;
			---move the user to "72I006135"
					update usersorganizations 
					set organizationid=1990
					where organizationid=1993;

			-- moving enrollment  
			select * from enrollment where attendanceschoolid =1993;

			       --no need to run this block  
				  update enrollment 
				  set modifieduser=12,
				      modifieddate =now(),
				      attendanceschoolid =1990
				  where attendanceschoolid =1993;    
				  
				  

			 -- moving enrollment roster 
			 select * from roster where attendanceschoolid=1993;

				       --no need to run this block  
				  update roster  
				  set modifieduser=12,
				      modifieddate =now(),
				      attendanceschoolid =1990
				  where attendanceschoolid =1993;   


--- moving 2178,2174 to 2171 

			   --delete the org --2171
			 select * from usersorganizations where organizationid in (1989,1991);
			---move the user to "72I006135"
					update usersorganizations 
					set organizationid=1993
					where organizationid in (1989,1991);

			-- moving enrollment  
			select * from enrollment where attendanceschoolid in (1989,1991);

			       --no need to run this block  
				  update enrollment 
				  set modifieduser=12,
				      modifieddate =now(),
				      attendanceschoolid =1993
				  where attendanceschoolid in (1989,1991);    
				  
				  

			 -- moving enrollment roster 
			 select * from roster where attendanceschoolidin (1989,1991);

				       --no need to run this block  
				  update roster  
				  set modifieduser=12,
				      modifieddate =now(),
				      attendanceschoolid =1993
				  where attendanceschoolid in (1989,1991);   





update organization 
set activeflag=false,
    modifieddate=now(),
    modifieduser=12
	where id in (1989,1991,1993)  and displayidentifier in ('2178','2174','2171') and activeflag=true;  
	
-- update the organizaion 2176 name to "Lakeside High School at Downs" to "Lakeside Jr/Sr High at Downs"



update organization 
set organizationname='Lakeside Jr/Sr High at Downs',
    modifieddate=now(),
    modifieduser=12
	where id=1990 and displayidentifier='2176'; 

-- update the organizaion 2170 to 2071 and  "Lakeside Intermediate School" to "Lakeside Elementary at Cawker City"

update organization 
set organizationname='Lakeside Elementary at Cawker City',
    displayidentifier='2171',
    modifieddate=now(),
    modifieduser=12
	where id=1994 and displayidentifier='2170'; 
	