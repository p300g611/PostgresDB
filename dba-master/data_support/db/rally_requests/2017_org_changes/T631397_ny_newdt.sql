BEGIN;
INSERT INTO organization(
            organizationname, displayidentifier, organizationtypeid, 
            welcomemessage, createddate, activeflag, createduser, modifieduser, 
            modifieddate, buildinguniqueness, schoolstartdate, schoolenddate, 
            contractingorganization, expirepasswords, expirationdatetype, 
            pooltype, multitestassignment, reportprocess, reportyear)            
select organizationname,'D'||displayidentifier displayidentifier,5 organizationtypeid, 
            welcomemessage, now() createddate, activeflag, 12 createduser, 12 modifieduser, 
            now() modifieddate, buildinguniqueness, schoolstartdate, schoolenddate, 
            contractingorganization, expirepasswords, expirationdatetype, 
            pooltype, multitestassignment, reportprocess, reportyear
 from organization o 
 where id in (select schoolid  from organizationtreedetail ot 
             where districtid in (69353,69354,69355))
 order by id;

update organizationrelation op
set parentorganizationid=(select id from organization o where o.displayidentifier='D'||schooldisplayidentifier and organizationtypeid=5 order by id desc limit 1),
    modifieduser=12,
    modifieddate=now()
 from organizationtreedetail ot 
 where  ot.schoolid=op.organizationid and op.parentorganizationid=ot.districtid
       and ot.districtid in (69353,69354,69355);

INSERT INTO organizationrelation(
            organizationid, parentorganizationid, createddate, activeflag, 
            createduser, modifieduser, modifieddate)
 select ol.parentorganizationid organizationid, 69352 parentorganizationid, now() createddate,true activeflag, 
           12 createduser, 12 modifieduser, now() modifieddate
  from organization o 
  inner join organizationrelation ol on o.id=ol.organizationid
  where id in (select schoolid  from organizationtreedetail ot 
             where districtid in (69353,69354,69355))
  order by id;   

delete from organizationtreedetail
where districtid in (69353,69354,69355);

 INSERT INTO organizationtreedetail(schoolid,
					      schoolname,
					      schooldisplayidentifier,
					      districtid,
					      districtname,                                
					      districtdisplayidentifier,
					      stateid,
					      statename,
					      statedisplayidentifier,
					      createddate)
			       SELECT upd.id                schoolid,
				      upd.organizationname  schoolname,
				      upd.displayidentifier schooldisplayidentifier,
				      (select id from organization_parent(upd.id) where organizationtypeid=5 limit 1) districtid,
				      (select organizationname from organization_parent(upd.id) where organizationtypeid=5 limit 1) districtname,                                
				      (select displayidentifier from organization_parent(upd.id) where organizationtypeid=5 limit 1) districtdisplayidentifier,
				      (select id from organization_parent(upd.id) where organizationtypeid=2 limit 1) stateid,
				      (select organizationname from organization_parent(upd.id) where organizationtypeid=2 limit 1) statename,
				      (select displayidentifier from organization_parent(upd.id) where organizationtypeid=2 limit 1) statedisplayidentifier,
				      now() createddate
					 FROM organization upd
					  LEFT OUTER JOIN organizationtreedetail curr
						       ON curr.schoolid=upd.id
					   WHERE  curr.schoolid IS NULL and upd.organizationtypeid=7 and upd.activeflag=true;


update organization  
set activeflag =false,
  modifieduser=12,
    modifieddate=now()
    where id in (69353,69354,69355);  					   

commit;