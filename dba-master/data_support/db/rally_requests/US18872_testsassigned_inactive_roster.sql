select distinct 
       s.id studentid,
       s.statestudentidentifier,
       s.legalfirstname,
       s.legallastname,
       ot.districtdisplayidentifier,
       ot.districtname,
       ot.schooldisplayidentifier attendanceschoolIdnt,
       ot.schoolname attendanceschoolname,
       r.coursesectionname rostername,
       a.displayname educator_displayname,
       (select case when otatt.schooldisplayidentifier is not null then otatt.schooldisplayidentifier
                    when   ot.schooldisplayidentifier is not null then ot.schooldisplayidentifier
                    else o.displayidentifier end schooldisplayidentifier from usersorganizations uo 
                    left outer join organizationtreedetail otatt on uo.organizationid=otatt.schoolid and e.attendanceschoolid=otatt.schoolid
                left outer join organizationtreedetail ot on uo.organizationid=ot.schoolid 
                left outer join organization o on o.id=uo.organizationid
                where uo.aartuserid=a.id limit 1) educator_schoolIdnt,
       (select case when otatt.schoolname is not null then  otatt.schoolname
                    when  ot.schoolname is not null then ot.schoolname
                    else o.organizationname  end schooldisplayidentifier from usersorganizations uo 
                     left outer join organizationtreedetail otatt on uo.organizationid=otatt.schoolid and e.attendanceschoolid=otatt.schoolid
                left outer join organizationtreedetail ot on uo.organizationid=ot.schoolid 
                left outer join organization o on o.id=uo.organizationid
                where uo.aartuserid=a.id limit 1) educator_schoolname ,
       e.activeflag enrollment_active, 
       otst.schoolname testsession_schoolname,
       --st.id studentstestsid,
       --ts.id  testsessionid,
       g.abbreviatedname grade   
       into temp tmp_testsession_roster              
    from student s
        inner join enrollment e on e.studentid=s.id
        left outer join organizationtreedetail ot on e.attendanceschoolid=ot.schoolid
        left outer join gradecourse g on e.currentgradelevel=g.id
        inner join enrollmentsrosters er on er.enrollmentid=e.id
        inner join roster r on r.id=er.rosterid 
        inner join aartuser a on r.teacherid=a.id
        inner join studentstests st on st.studentid=s.id
        inner join testsession ts on st.testsessionid=ts.id and r.id=ts.rosterid
        left outer join organizationtreedetail otst on ts.attendanceschoolid=otst.schoolid
       where s.stateid=9592
             and s.activeflag is true
             and er.activeflag is false
             and st.activeflag is true
             and ts.activeflag is true
             and ts.status<>86;
\copy (SELECT * FROM tmp_testsession_roster order by 1) TO 'tmp_testsession_roster.csv' DELIMITER ',' CSV HEADER;             



