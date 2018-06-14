--Remove entries in studenttrackerblueprintstatus and set to untracked for ELA and M for the following students
--SSID:'2780769092','5043153924'


BEGIN;

delete from studenttrackerblueprintstatus
where studenttrackerid in (751910,753491);

┌──────────────────┬─────────────────────┬─────────────┬────────────────────────────┬─────────────┐
│ studenttrackerid │ operationalwindowid │ statuscode  │        createddate         │ createduser │
├──────────────────┼─────────────────────┼─────────────┼────────────────────────────┼─────────────┤
│           751910 │               10276 │ STCOMPLETED │ 2018-04-27 17:05:09.177+00 │          13 │
│           753491 │               10276 │ STCOMPLETED │ 2018-04-27 15:20:14.314+00 │          13 │
└──────────────────┴─────────────────────┴─────────────┴────────────────────────────┴─────────────┘

delete from studenttrackerblueprintstatus  where studenttrackerid in (744509,744580);



├──────────────────┼─────────────────────┼─────────────┼────────────────────────────┼─────────────┤
│           744509 │               10276 │ STCOMPLETED │ 2018-04-16 17:20:13.104+00 │          13 │
│           744580 │               10276 │ STCOMPLETED │ 2018-04-16 16:50:09.123+00 │          13 │


commit;
