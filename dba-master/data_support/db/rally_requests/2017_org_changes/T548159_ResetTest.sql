BEGIN;
--sid:1261972 
update studentstests
set    activeflag =false,
      modifieddate=now(),
      modifieduser =174744,
      manualupdatereason='Ticket#548159'
where id in (15917196,16144091);


update studentstestsections
set    activeflag =false,
       modifieddate=now(),
       modifieduser =174744
where studentstestid in (15917196,16144091);


update studentsresponses
set    activeflag =false,
       modifieddate=now(),
       modifieduser =174744
where studentid = 1261972  and studentstestsid in (15917196,16144091);

COMMIT;

