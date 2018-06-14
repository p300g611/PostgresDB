WITH dup_roster
 AS 
(  
	SELECT e.studentid,r.statesubjectareaid, count( DISTINCT (CASE  COALESCE (r.statecoursesid,0) WHEN 0 THEN 0 ELSE 1 END) ) record_cnt
	    FROM enrollment e
	    INNER JOIN enrollmentsrosters er ON e.id=er.enrollmentid
	    INNER JOIN roster r ON er.rosterid=r.id
	    LEFT OUTER JOIN contentarea ca ON r.statesubjectareaid=ca.id
	    LEFT OUTER JOIN gradecourse gc ON r.statecoursesid=gc.id
	WHERE r.currentschoolyear=2016 
	    AND r.activeflag=true 
	    AND e.activeflag=true
	GROUP BY e.studentid,r.statesubjectareaid
	HAVING count( DISTINCT (CASE  COALESCE (r.statecoursesid,0) WHEN 0 THEN 0 ELSE 1 END) ) >1

 )  
  SELECT 
   s.id   studentid,
   s.legalfirstname ,
   s.stateid,
   e.id enrollmentid,
   e.currentschoolyear,
   e.attendanceschoolid,
   er.id enrollmentsrostersid,
   r.id rosterid,
   r.coursesectionname,
   r.teacherid,
   r.statesubjectareaid,
   ca.name contentareaname,
   r.statecoursesid,
   gc.name gradecoursename,
   r.createddate rcreateddate,
   r.attendanceschoolid rattendanceschoolid
    FROM student s
        INNER JOIN enrollment e ON s.id=e.studentid 
        INNER JOIN enrollmentsrosters er ON e.id=er.enrollmentid
	INNER JOIN roster r ON er.rosterid=r.id
	LEFT OUTER JOIN contentarea ca ON r.statesubjectareaid=ca.id
	LEFT OUTER JOIN gradecourse gc ON r.statecoursesid=gc.id
	INNER JOIN dup_roster dup ON  dup.studentid=s.id
	                          AND dup.statesubjectareaid=r.statesubjectareaid
    WHERE r.currentschoolyear=2016 AND r.activeflag=true AND e.activeflag=true
    ORDER BY s.id,s.stateid,r.statesubjectareaid;
