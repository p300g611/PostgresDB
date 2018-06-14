select s.statestudentidentifier,
       s.id studentid,
       e.id enrollmentid,
       e.modifieddate,
       e.createddate,
       e.modifieduser,
       e.createduser,
       (select  organizationname  from organization_parent(attendanceschoolid) where organizationtypeid=5 ) dt_organizationname,
       (select  displayidentifier  from organization_parent(attendanceschoolid) where organizationtypeid=5 ) dt_displayidentifier,
       (select  organizationname  from organization_parent(attendanceschoolid) where organizationtypeid=2 ) st_organizationname,
       (select  displayidentifier  from organization_parent(attendanceschoolid) where organizationtypeid=2 ) st_displayidentifier,
       org.organizationname school_organizationname,   
       org.displayidentifier school_displayidentifier,
	   e.sourcetype,
	   e.currentgradelevel
	   into temp tmp_currentgradelevel
 from student s
 inner join enrollment e  on s.id=e.studentid
  left outer join organization org on org.id=e.attendanceschoolid
 where  currentschoolyear =2016 and currentgradelevel is null and sourcetype='LOCK_DOWN_SCRIPT';

 \copy (SELECT * FROM tmp_currentgradelevel ) TO 'currentgradelevel.csv' DELIMITER ',' CSV HEADER;

