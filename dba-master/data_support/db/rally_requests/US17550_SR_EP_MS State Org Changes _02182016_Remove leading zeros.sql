



--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,
   activeflag,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) dist,
	(select  id from organization_parent(o.id) where organizationtypeid=5) distid,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dist_iden,
	(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stn from organization o
where displayidentifier in (    '020',
				'004',
				'002',
				'008',
				'016',
				'024',
				'007',
				'006',
				'012') and (select  displayidentifier from organization_parent(o.id) where organizationtypeid=5)='5321'
order by (select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) ;



--update look like : 

select displayidentifier,
   case when id=79326 and  organizationname ='East Oktibbeha High School' and  displayidentifier='002' then '2'      
        when id=79327 and  organizationname ='East Oktibbeha County Elementary' and  displayidentifier='004' then '4'      
        when id=79328 and  organizationname ='West Oktibbeha County Elementary' and  displayidentifier='006' then '6'      
        when id=79329 and  organizationname ='Ward-Stewart Elementary School' and  displayidentifier='007' then '7'      
        when id=79330 and  organizationname ='Henderson Intermediate School' and  displayidentifier='008' then '8'      
        when id=79331 and  organizationname ='West Oktibbeha High School' and  displayidentifier='012' then '12'      
        when id=79332 and  organizationname ='Starkville High School' and  displayidentifier='016' then '16'      
        when id=79333 and  organizationname ='Armstrong Middle School' and  displayidentifier='020' then '20'      
        when id=79334 and  organizationname ='Sudduth Elementary School' and  displayidentifier='024' then '24'       
	else   displayidentifier end      
        from organization where id in (  79326,
					 79327,
					 79328,
					 79329,
					 79330,
					 79331,
					 79332,
					 79333,
					 79334
					);



--///////////////update code//////////////////

update organization 
set     modifieddate=now(),
	modifieduser=12,
	displayidentifier= case when id=79326 and  organizationname ='East Oktibbeha High School' and  displayidentifier='002' then '2'      
				when id=79327 and  organizationname ='East Oktibbeha County Elementary' and  displayidentifier='004' then '4'      
				when id=79328 and  organizationname ='West Oktibbeha County Elementary' and  displayidentifier='006' then '6'      
				when id=79329 and  organizationname ='Ward-Stewart Elementary School' and  displayidentifier='007' then '7'      
				when id=79330 and  organizationname ='Henderson Intermediate School' and  displayidentifier='008' then '8'      
				when id=79331 and  organizationname ='West Oktibbeha High School' and  displayidentifier='012' then '12'      
				when id=79332 and  organizationname ='Starkville High School' and  displayidentifier='016' then '16'      
				when id=79333 and  organizationname ='Armstrong Middle School' and  displayidentifier='020' then '20'      
				when id=79334 and  organizationname ='Sudduth Elementary School' and  displayidentifier='024' then '24'       
				else   displayidentifier end 
                          where id in (  79326,
					 79327,
					 79328,
					 79329,
					 79330,
					 79331,
					 79332,
					 79333,
					 79334
					);
	
----------------------------------------------------------
/*-- --select refresh_organization_detail();

   update organizationtreedetail 
   set schooldisplayidentifier= case when schoolid=79326 and  schoolname ='East Oktibbeha High School' and  schooldisplayidentifier='002' then '2'      
				when schoolid=79327 and  schoolname ='East Oktibbeha County Elementary' and  schooldisplayidentifier='004' then '4'      
				when schoolid=79328 and  schoolname ='West Oktibbeha County Elementary' and  schooldisplayidentifier='006' then '6'      
				when schoolid=79329 and  schoolname ='Ward-Stewart Elementary School' and  schooldisplayidentifier='007' then '7'      
				when schoolid=79330 and  schoolname ='Henderson Intermediate School' and  schooldisplayidentifier='008' then '8'      
				when schoolid=79331 and  schoolname ='West Oktibbeha High School' and  schooldisplayidentifier='012' then '12'      
				when schoolid=79332 and  schoolname ='Starkville High School' and  schooldisplayidentifier='016' then '16'      
				when schoolid=79333 and  schoolname ='Armstrong Middle School' and  schooldisplayidentifier='020' then '20'      
				when schoolid=79334 and  schoolname ='Sudduth Elementary School' and  schooldisplayidentifier='024' then '24'       
				else   schooldisplayidentifier end 
     where schoolid in (  79326,
					 79327,
					 79328,
					 79329,
					 79330,
					 79331,
					 79332,
					 79333,
					 79334
					);
						


*/
					   