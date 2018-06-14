--///////////////validation//////////////////

-- organization info 
select id, organizationname,displayidentifier,
     createddate::date,activeflag,modifieddate::date,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) dist,
	(select  id from organization_parent(o.id) where organizationtypeid=5) distid,
	(select  displayidentifier from organization_parent(o.id) where organizationtypeid=5) dist_iden,
	(select  organizationname from organization_parent(o.id) where organizationtypeid=2) stn from organization o
where displayidentifier in ('210402060000') 
order by displayidentifier , createddate desc;



 select * from aartuser where email in (
				'mpratt@nasboces.org',
				'fwerner@nasboces.org',
				'jwiener@nasboces.org',
				'rmuscarella@nasboces.org',
				'rfaltz@nasboces.org',
				'esainsbury@nasboces.org');
				

select * from usersorganizations where organizationid=69564
     and aartuserid in ( 160279,
			 160265,
			 160268,
			 159771,
			 160275,
			 160271);


--///////////////update code//////////////////
BEGIN;


update usersorganizations 
  set isdefault = true
 where   organizationid=69665 and aartuserid =159771;


delete from userorganizationsgroups
where id in (
	 select uog.id  from userorganizationsgroups uog
	   inner join usersorganizations uo on uog.userorganizationid= uo.id
	   inner join aartuser a on a.id=uo.aartuserid 
	   inner join organization o on o.id = uo.organizationid
	  where o.displayidentifier in ('210402060000') 
		        and a.email in ('mpratt@nasboces.org',
					'fwerner@nasboces.org',
					'jwiener@nasboces.org',
					'rmuscarella@nasboces.org',
					'rfaltz@nasboces.org',
					'esainsbury@nasboces.org')
               );

delete from usersorganizations 
where id in (
	  select uo.id from usersorganizations uo 
	  inner join aartuser a on a.id=uo.aartuserid 
	  inner join organization o on o.id = uo.organizationid
	  where o.displayidentifier in ('210402060000') 
		        and a.email in ('mpratt@nasboces.org',
					'fwerner@nasboces.org',
					'jwiener@nasboces.org',
					'rmuscarella@nasboces.org',
					'rfaltz@nasboces.org',
					'esainsbury@nasboces.org')
         );


COMMIT ;
           

				   