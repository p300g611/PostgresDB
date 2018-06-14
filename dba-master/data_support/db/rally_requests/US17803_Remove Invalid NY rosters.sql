
UPDATE enrollmentsrosters
SET activeflag = false
   ,modifieddate = now()
   ,modifieduser = 12
WHERE rosterid IN (SELECT id 
                   FROM  roster 
                   WHERE coursesectionname LIKE '%ZZDoNotUse%' 
AND attendanceschoolid IN (SELECT id 
                           FROM organization_children((SELECT id 
                                                       FROM  organization 
                                                       WHERE displayidentifier='NY' 
                                                       AND   organizationtypeid=2)))); 


UPDATE roster 
SET activeflag = false
   ,modifieddate = now()
   ,modifieduser = 12
WHERE id IN (SELECT id 
             FROM  roster 
             WHERE coursesectionname like '%ZZDoNotUse%' 
AND attendanceschoolid in (SELECT id 
                           FROM organization_children((SELECT id 
                                                       FROM  organization 
                                                       WHERE displayidentifier='NY' 
                                                       AND   organizationtypeid=2)))); 









