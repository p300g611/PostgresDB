begin;

update studenttracker
set status='UNTRACKED',modifieddate=now(),modifieduser=174744
where studentid=1438182 and contentareaid=3 and schoolyear=2018;

commit;
