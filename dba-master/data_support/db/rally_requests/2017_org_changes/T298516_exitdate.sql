begin;
update enrollment 
set exitwithdrawaldate ='2017-02-06 06:00:00+00',
    modifieddate=now(),
    modifieduser =174744,
    notes='Ticket#298516'
where  id = 2468314;
commit;