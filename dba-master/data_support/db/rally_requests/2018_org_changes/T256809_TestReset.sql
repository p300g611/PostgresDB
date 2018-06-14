--ssid:7768954232

begin;

delete from studenttrackerblueprintstatus  where studenttrackerid in (623146,626973);

commit;


│ studenttrackerid │ operationalwindowid │ statuscode  │        createddate         │ createduser │
├──────────────────┼─────────────────────┼─────────────┼────────────────────────────┼─────────────┤
│           457223 │               10193 │ STCOMPLETED │ 2017-03-29 14:26:28.439+00 │          13 │
│           457482 │               10193 │ STCOMPLETED │ 2017-03-29 14:06:41.59+00  │          13 │
│           623146 │               10276 │ STCOMPLETED │ 2018-05-30 18:05:02.888+00 │          13 │
│           626973 │               10276 │ STCOMPLETED │ 2018-05-30 14:50:02.964+00 │          13 │
└──────────────────┴─────────────────────┴─────────────┴────────────────────────────┴─────────────┘