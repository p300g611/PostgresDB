BEGIN;

--updat asikes@gckschools.com to astoppkotte@gckschools.com

update aartuser
set    username ='astoppkotte@gckschools.com',
       email='astoppkotte@gckschools.com',
	   modifieddate = now(),
	   modifieduser =12
	where id = 89165;
	
	
--update smendoza2@gckschools.co to sarteaga1@gckschools.com

update aartuser
set    username ='sarteaga1@gckschools.com',
       email='sarteaga1@gckschools.com',
	   modifieddate = now(),
	   modifieduser =12
	where id = 89162;
	
	
--update uniquecommonidentifier 3414628686  to 1979618372

update aartuser
set    uniquecommonidentifier ='1979618372',
	   modifieddate = now(),
	   modifieduser =12
	where id = 4407;
	
COMMIT;
	