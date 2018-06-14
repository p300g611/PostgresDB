--SSID:9610828056

BEGIN;

delete from studenttrackerblueprintstatus 
where  studenttrackerid in (642235,639150);

commit;

│ studenttrackerid │ operationalwindowid │ statuscode  │        createddate         │ createduser │
├──────────────────┼─────────────────────┼─────────────┼────────────────────────────┼─────────────┤
│           639150 │               10276 │ STCOMPLETED │ 2018-04-18 13:35:14.621+00 │          13 │
│           642235 │               10276 │ STCOMPLETED │ 2018-04-30 14:50:17.078+00 │          13 │
└──────────────────┴─────────────────────┴─────────────┴────────────────────────────┴─────────────┘

