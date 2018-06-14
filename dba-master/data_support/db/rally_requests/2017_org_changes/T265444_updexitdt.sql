begin;
update enrollment
set exitwithdrawaldate = '2016-12-11 06:00:00+00', modifieddate = now(), modifieduser = 174744,
notes='Ticket#265444'
where id = 2587113;
commit;