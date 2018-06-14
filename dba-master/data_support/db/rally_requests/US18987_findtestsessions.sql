Begin;
select  s.id studentid,
        s.statestudentidentifier,
        s.legalfirstname||'.'||legallastname fullname, 
        s.activeflag student_active,
        e.activeflag enrollment_active,
        st.activeflag test_active,
        st.status test_status,
        ts.activeflag session_active,
        ts.status session_status,
        ts.name
        into temp tmp
        from student s
         left outer join enrollment e on e.studentid=s.id 
         left outer join studentstests st on s.id=st.studentid and st.enrollmentid=e.id
         left outer join testsession ts on ts.id=st.testsessionid
     where s.statestudentidentifier in ('2091',
					'232740746',
					'220372852',
					'61206',
					'209551480',
					'000951989',
					'215669623',
					'4259046332_x',
					'4259046332')
         and s.stateid=69352;

\copy (select * from tmp) to US18987_new.csv delimiter ',' CSV HEADER;
rollback;
