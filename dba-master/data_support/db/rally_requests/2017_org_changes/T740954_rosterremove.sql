update enrollmentsrosters
set activeflag=false,
    modifieddate=now(),
    modifieduser=12
where enrollmentid =2414168 and rosterid=1073331;