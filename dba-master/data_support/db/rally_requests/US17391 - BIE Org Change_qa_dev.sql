/*-- from prod 
drop table if exists  tmp_organization ;

select * into temp tmp_organization from (
		select * from organization 
		where id in ( select id from organization_children((select id from organization where displayidentifier='BIE-Choctaw' limit 1))) 
		     or id in (select id from organization where displayidentifier='BIE-Choctaw' limit 1) 
		union
		select * from organization 
		where id in ( select id from organization_children((select id from organization where displayidentifier='BIE-Miccosukee' limit 1)))
		     or id in (select id from organization where displayidentifier='BIE-Miccosukee' limit 1) 
                                     ) org;

\COPY tmp_organization to 'tmp_organization.csv' DELIMITER '|' CSV HEADER ; 
*/

--move the file to qa
-- on QA 
BEGIN;
CREATE temp TABLE tmp_organization
(
  id bigint NOT NULL,
  organizationname character varying(100),
  displayidentifier character varying(100) NOT NULL,
  organizationtypeid bigint NOT NULL,
  welcomemessage character varying(75),
  createddate timestamp with time zone DEFAULT ('now'::text)::timestamp without time zone,
  activeflag boolean DEFAULT true,
  createduser integer NOT NULL,
  modifieduser integer NOT NULL,
  modifieddate timestamp with time zone DEFAULT ('now'::text)::timestamp without time zone,
  buildinguniqueness bigint,
  schoolstartdate timestamp with time zone,
  schoolenddate timestamp with time zone,
  contractingorganization boolean DEFAULT false,
  expirepasswords boolean DEFAULT false,
  expirationdatetype bigint,
  pooltype character varying(30),
  multitestassignment boolean,
  reportprocess boolean DEFAULT true,
  reportyear integer);

\COPY tmp_organization from 'tmp_organization.csv' DELIMITER '|' CSV HEADER ; 
-- step1: create new state for "BIE-Miccosukee"
INSERT INTO organization(
             organizationname,
             displayidentifier,
             organizationtypeid, 
             welcomemessage, 
             createddate, 
             activeflag,
             createduser, 
             modifieduser, 
             modifieddate, 
             buildinguniqueness,
             schoolstartdate,
             schoolenddate, 
             contractingorganization,
             expirepasswords,
             expirationdatetype, 
             pooltype,
             multitestassignment,
             reportprocess,
             reportyear)
   select    tmp.organizationname,                      
             tmp.displayidentifier,
             tmp.organizationtypeid, 
             tmp.welcomemessage, 
             tmp.createddate ,              
             tmp.activeflag,
             tmp.createduser , 
             tmp.modifieduser , 
             tmp.modifieddate , 
             tmp.buildinguniqueness,
             tmp.schoolstartdate,
             tmp.schoolenddate, 
             tmp.contractingorganization,
             tmp.expirepasswords,
             tmp.expirationdatetype, 
             tmp.pooltype,
             tmp.multitestassignment,
             tmp.reportprocess,
             tmp.reportyear 
              from tmp_organization tmp 
               left outer join organization org on tmp.organizationname=org.organizationname and tmp.displayidentifier=org.displayidentifier
               where org.id is null
               ;

insert into organizationhierarchy (organizationid, organizationtypeid) 
	values ((select id from organization where 'BIE-Choctaw'= organizationname and 'BIE-Choctaw' = displayidentifier)
			, (select id from organizationtype where typecode='CONS'));
insert into organizationhierarchy (organizationid, organizationtypeid) 
	values ((select id from organization where 'BIE-Choctaw'= organizationname and 'BIE-Choctaw' = displayidentifier)
			, (select id from organizationtype where typecode='ST'));
insert into organizationhierarchy (organizationid, organizationtypeid) 
	values ((select id from organization where 'BIE-Choctaw'= organizationname and 'BIE-Choctaw' = displayidentifier)
			, (select id from organizationtype where typecode='DT'));
insert into organizationhierarchy (organizationid, organizationtypeid) 
	values ((select id from organization where 'BIE-Choctaw'= organizationname and 'BIE-Choctaw' = displayidentifier)
			, (select id from organizationtype where typecode='SCH'));


insert into organizationhierarchy (organizationid, organizationtypeid) 
	values ((select id from organization where 'BIE-Miccosukee'= organizationname and 'BIE-Miccosukee' = displayidentifier)
			, (select id from organizationtype where typecode='CONS'));
insert into organizationhierarchy (organizationid, organizationtypeid) 
	values ((select id from organization where 'BIE-Miccosukee'= organizationname and 'BIE-Miccosukee' = displayidentifier)
			, (select id from organizationtype where typecode='ST'));
insert into organizationhierarchy (organizationid, organizationtypeid) 
	values ((select id from organization where 'BIE-Miccosukee'= organizationname and 'BIE-Miccosukee' = displayidentifier)
			, (select id from organizationtype where typecode='DT'));
insert into organizationhierarchy (organizationid, organizationtypeid) 
	values ((select id from organization where 'BIE-Miccosukee'= organizationname and 'BIE-Miccosukee' = displayidentifier)
			, (select id from organizationtype where typecode='SCH'));			



--ST
INSERT INTO organizationrelation(
            organizationid, parentorganizationid, createddate, activeflag, 
            createduser, modifieduser, modifieddate)
select  org.id,50,now(),true,12,12,now() from tmp_organization tmp 
               join organization org on tmp.organizationname=org.organizationname and tmp.displayidentifier=org.displayidentifier
               and tmp.createddate=org.createddate and org.organizationtypeid= (select id from organizationtype where typecode='ST')  ;     

--DT
INSERT INTO organizationrelation( 
            organizationid, parentorganizationid, createddate, activeflag, 
            createduser, modifieduser, modifieddate)
select  org.id,
      case when 'Miccosukee'=org.organizationname then (select id from organization where 'BIE-Miccosukee'= organizationname and 'BIE-Miccosukee' = displayidentifier)
           else (select id from organization where 'BIE-Choctaw'= organizationname and 'BIE-Choctaw' = displayidentifier) end ,
           now(),true,12,12,now() from tmp_organization tmp 
               join organization org on tmp.organizationname=org.organizationname and tmp.displayidentifier=org.displayidentifier
               and tmp.createddate=org.createddate and tmp.modifieddate=org.modifieddate and tmp.createduser=org.createduser and org.organizationtypeid= (select id from organizationtype where typecode='DT') ;


--SCH
INSERT INTO organizationrelation(
            organizationid, parentorganizationid, createddate, activeflag, 
            createduser, modifieduser, modifieddate)
select  org.id,case when 'Miccosukee Indian School'=org.organizationname then (select id from organization where 'Miccosukee'= organizationname and 'MDT' = displayidentifier and organizationtypeid= (select id from organizationtype where typecode='DT') )
               else (select id from organization where 'Choctaw Tribal Schools'= organizationname and '5007' = displayidentifier and organizationtypeid= (select id from organizationtype where typecode='DT') ) end
               ,now(),true,12,12,now() from tmp_organization tmp 
               join organization org on tmp.organizationname=org.organizationname and tmp.displayidentifier=org.displayidentifier
               and tmp.createddate=org.createddate and tmp.modifieddate=org.modifieddate and tmp.createduser=org.createduser and org.organizationtypeid= (select id from organizationtype where typecode='SCH') ;
               

-- select * from organization_children(77278);
-- select * from organization_children(77290); 
-- select * from organization_parent(77284);
-- select * from organization_parent(77280);
Commit;









               