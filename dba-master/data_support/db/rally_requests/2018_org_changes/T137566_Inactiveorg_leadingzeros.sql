begin
update organization set displayidentifier='00000'||displayidentifier, modifieddate=now(), modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'), activeflag='f' 

--select * from organization 

where id in 
(
51316,
51460,
51859,
52003,
64459,
64596,
64599,
64616,
64624,
64662,
64673,
64675,
64693,
64714,
64742,
64756,
64792,
64800,
64807,
64810,
64815,
64836,
64860,
64869,
64890,
64904,
64921,
64957,
64974,
64979,
65018,
65050,
65064,
65095,
65097,
65111,
65116,
65126,
65173,
65199,
65220,
65228,
65235,
65283,
65320,
65322,
65331,
65344,
65360,
65365,
65406,
65413,
65489,
65502,
65583,
65585,
65594,
65619,
65633,
65639,
65646,
65655,
65658,
65672,
65689,
65711,
65725,
65729,
65739,
65752,
65753,
65754,
65757,
65761,
65777,
65799,
65818,
65835,
65855,
65856,
65865,
65879,
65882,
65902,
65913,
65914,
65933,
65934,
65937,
65947,
65959,
65989,
66018,
66023,
66024,
66032,
66036,
66039,
66042,
66043,
66064,
66094,
66141,
66153,
66157,
66167,
66177,
66234,
66243,
66252,
66289,
66297,
66317,
66335,
66374,
66380,
66386,
66395,
66401,
66452,
66496
)
order by id;

commit;
-- validation

select enrl.id,o.id from organization o
inner join enrollment enrl  on enrl.attendanceschoolid = o.id and enrl.currentschoolyear = 2018 and enrl.activeflag is true
where o.id in 
(
51316,
51460,
51859,
52003,
64459,
64596,
64599,
64616,
64624,
64662,
64673,
64675,
64693,
64714,
64742,
64756,
64792,
64800,
64807,
64810,
64815,
64836,
64860,
64869,
64890,
64904,
64921,
64957,
64974,
64979,
65018,
65050,
65064,
65095,
65097,
65111,
65116,
65126,
65173,
65199,
65220,
65228,
65235,
65283,
65320,
65322,
65331,
65344,
65360,
65365,
65406,
65413,
65489,
65502,
65583,
65585,
65594,
65619,
65633,
65639,
65646,
65655,
65658,
65672,
65689,
65711,
65725,
65729,
65739,
65752,
65753,
65754,
65757,
65761,
65777,
65799,
65818,
65835,
65855,
65856,
65865,
65879,
65882,
65902,
65913,
65914,
65933,
65934,
65937,
65947,
65959,
65989,
66018,
66023,
66024,
66032,
66036,
66039,
66042,
66043,
66064,
66094,
66141,
66153,
66157,
66167,
66177,
66234,
66243,
66252,
66289,
66297,
66317,
66335,
66374,
66380,
66386,
66395,
66401,
66452,
66496
);

select distinct a.email,o.id from organization o
inner join usersorganizations u  on u.organizationid = o.id  and u.activeflag is true
inner join aartuser a on a.id=u.aartuserid and a.activeflag is true 
where o.id in 
(
51316,
51460,
51859,
52003,
64459,
64596,
64599,
64616,
64624,
64662,
64673,
64675,
64693,
64714,
64742,
64756,
64792,
64800,
64807,
64810,
64815,
64836,
64860,
64869,
64890,
64904,
64921,
64957,
64974,
64979,
65018,
65050,
65064,
65095,
65097,
65111,
65116,
65126,
65173,
65199,
65220,
65228,
65235,
65283,
65320,
65322,
65331,
65344,
65360,
65365,
65406,
65413,
65489,
65502,
65583,
65585,
65594,
65619,
65633,
65639,
65646,
65655,
65658,
65672,
65689,
65711,
65725,
65729,
65739,
65752,
65753,
65754,
65757,
65761,
65777,
65799,
65818,
65835,
65855,
65856,
65865,
65879,
65882,
65902,
65913,
65914,
65933,
65934,
65937,
65947,
65959,
65989,
66018,
66023,
66024,
66032,
66036,
66039,
66042,
66043,
66064,
66094,
66141,
66153,
66157,
66167,
66177,
66234,
66243,
66252,
66289,
66297,
66317,
66335,
66374,
66380,
66386,
66395,
66401,
66452,
66496
);