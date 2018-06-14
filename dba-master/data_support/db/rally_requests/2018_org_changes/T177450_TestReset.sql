--3969721005  delete both subjects (ELA AND Math). 6139149200 (Math only)
--7108172836 delete both subjects (ELA AND Math)

begin;

delete from studenttrackerblueprintstatus 
 where studenttrackerid in (select id from studenttracker where studentid in (1388773) and contentareaid in (440,3))
     and operationalwindowid=10276;

delete from studenttrackerblueprintstatus 
 where studenttrackerid in (select id from studenttracker where studentid in (1344055) and contentareaid in (440))
    and operationalwindowid=10276; 
 
delete from studenttrackerblueprintstatus 
 where studenttrackerid in (select id from studenttracker where studentid in (1388786) and contentareaid in (440))
    and operationalwindowid=10276;
commit;


 studenttrackerid  │ operationalwindowid │ statuscode  │        createddate         │ createduser │
├──────────────────┼─────────────────────┼─────────────┼────────────────────────────┼─────────────┤
│           635402 │               10276 │ STCOMPLETED │ 2018-05-15 16:50:06.472+00 │          13 │
│           638600 │               10276 │ STCOMPLETED │ 2018-05-15 17:20:05.78+00  │          13 │
└──────────────────┴─────────────────────┴─────────────┴────────────────────────────┴─────────────┘




│ studenttrackerid │ operationalwindowid │ statuscode  │        createddate         │ createduser │
├──────────────────┼─────────────────────┼─────────────┼────────────────────────────┼─────────────┤
│           465818 │               10193 │ STCOMPLETED │ 2017-05-09 14:05:13.031+00 │          13 │
│           466098 │               10193 │ STCOMPLETED │ 2017-05-05 15:50:07.062+00 │          13 │
│           590371 │               10276 │ STCOMPLETED │ 2018-05-24 18:05:02.807+00 │          13 │
│           629723 │               10276 │ STCOMPLETED │ 2018-05-18 13:50:04.838+00 │          13 │
│           632978 │               10276 │ STCOMPLETED │ 2018-05-08 13:20:07.091+00 │          13 │
└──────────────────┴─────────────────────┴─────────────┴────────────────────────────┴─────────────┘


 studenttrackerid  │ operationalwindowid │ statuscode  │        createddate         │ createduser │
├──────────────────┼─────────────────────┼─────────────┼────────────────────────────┼─────────────┤
│           479959 │               10193 │ STCOMPLETED │ 2017-05-10 13:50:14.406+00 │          13 │
│           479995 │               10193 │ STCOMPLETED │ 2017-05-10 15:35:09.565+00 │          13 │
│           635404 │               10276 │ STCOMPLETED │ 2018-05-15 18:20:06.424+00 │          13 │
│           638603 │               10276 │ STCOMPLETED │ 2018-05-31 13:05:02.656+00 │          13 │

