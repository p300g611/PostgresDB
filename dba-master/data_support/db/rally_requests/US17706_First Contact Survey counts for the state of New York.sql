


SELECT sv.status,c.categorycode,a.programname,count(distinct s.id)
 FROM student s
            JOIN enrollment e ON e.studentid = s.id and e.activeflag = true
            JOIN survey sv ON s.id = sv.studentid
            JOIN category c ON c.id=sv.status
            JOIN studentassessmentprogram sap ON sap.studentid = s.id
	    JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
	WHERE s.stateid=69352  and s.activeflag is true 
GROUP BY sv.status,c.categorycode,a.programname;
