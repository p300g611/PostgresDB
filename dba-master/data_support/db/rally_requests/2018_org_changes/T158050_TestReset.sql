--1288558 delete both subjects,1474633 delete both subjects,1471763 delete ELA,1471765 delete ela

begin;

delete from studenttrackerblueprintstatus 
 where studenttrackerid in (select id from studenttracker where studentid in (1288558,1474633) and contentareaid in (440,3));

delete from studenttrackerblueprintstatus 
 where studenttrackerid in (select id from studenttracker where studentid in (1471763,1471765) and contentareaid in (3)); 
 
commit;


│ studenttrackerid │ operationalwindowid │ statuscode  │        createddate         │ createduser │
├──────────────────┼─────────────────────┼─────────────┼────────────────────────────┼─────────────┤
│           696137 │               10276 │ STCOMPLETED │ 2018-05-24 14:50:02.407+00 │          13 │
│           696354 │               10276 │ STCOMPLETED │ 2018-05-04 14:50:04.493+00 │          13 │
│           759347 │               10276 │ STCOMPLETED │ 2018-05-29 14:20:07.655+00 │          13 │
│           759340 │               10276 │ STCOMPLETED │ 2018-05-24 15:35:04.302+00 │          13 │
└──────────────────┴─────────────────────┴─────────────┴────────────────────────────┴─────────────┘



│ studenttrackerid │ operationalwindowid │ statuscode  │        createddate         │ createduser │
├──────────────────┼─────────────────────┼─────────────┼────────────────────────────┼─────────────┤
│           696528 │               10276 │ STCOMPLETED │ 2018-05-07 15:05:11.927+00 │          13 │
│           696529 │               10276 │ STCOMPLETED │ 2018-05-03 14:05:14.712+00 │          13 │
└──────────────────┴─────────────────────┴─────────────┴────────────────────────────┴─────────────┘
