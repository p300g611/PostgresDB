BEGIN;

--ssid:3090232065
--ela
update testsession 
set    rosterid =1067097, 
       modifieddate =now(),
	   modifieduser=174744
where id in (3990031,3917404,3917390,3917375,3990018,3990046,3990050,3990040,3846134)and rosterid =1094252;


update  ititestsessionhistory
set     rosterid =1067097,
        modifieddate=now(),
	    modifieduser =174744
where id in (706015,549757,547532,547533,714295,706012,706021,706019,547528)and rosterid=1094252;


--math
update testsession 
set    rosterid =1067098, 
       modifieddate =now(),
	   modifieduser=174744
where id in (4041124,4041122,3917387,3932750,4041120,4041121,4041123,3941187,3932759)and rosterid =1094253;


update  ititestsessionhistory
set     rosterid =1067098,
        modifieddate=now(),
	    modifieduser =174744
where id in (706171,706168,544315,544321,706177,706167,706174,544320,544318)and rosterid=1094253;


--ssid:5301472877
--ela
update testsession 
set    rosterid =1067097, 
       modifieddate =now(),
	   modifieduser=174744
where id in (3821639,4041126,3920510,3920447,4041125,4041127,4041129,4041128,3846135)and rosterid =1094252;


update  ititestsessionhistory
set     rosterid =1067097,
        modifieddate=now(),
	    modifieduser =174744
where id in (547551,706099,547558,549743,714300,706104,706103,706102,547555)and rosterid=1094252;

--math
update testsession 
set    rosterid =1067098, 
       modifieddate =now(),
	   modifieduser=174744
where id in (4041131,3844430,4041132,4041130,3941272,3942448,3932768,4041134,4041133)and rosterid =1094253;


update  ititestsessionhistory
set     rosterid =1067098,
        modifieddate=now(),
	    modifieduser =174744
where id in (706186,545340,706190,706201,670029,670985,545342,706183,706181)and rosterid=1094253;


--ssid:8950092317
--ela
update testsession 
set    rosterid =1067084, 
       modifieddate =now(),
	   modifieduser=174744
where id in (4041011,4041015,4041014,4041013,3846136,3821638,3920529,3920574,4041012)and rosterid =1094252;


update  ititestsessionhistory
set     rosterid =1067084,
        modifieddate=now(),
	    modifieduser =174744
where id in (714303,706133,706114,706122,547586,547582,549724,653889,706118)and rosterid=1094252;

--math
update testsession 
set    rosterid =1067085, 
       modifieddate =now(),
	   modifieduser=174744
where id in (4041118,4041116,3932793,3932785,4041117,4041119,4041115,3941274,3941332)and rosterid =1094253;


update  ititestsessionhistory
set     rosterid =1067085,
        modifieddate=now(),
	    modifieduser =174744
where id in (706211,706208,544185,544192,706204,706215,706213,544175,544190)and rosterid=1094253;

commit;