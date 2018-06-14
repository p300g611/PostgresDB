--ssid:7456743970

begin;

delete from studenttrackerblueprintstatus  where studenttrackerid in (744997,745298);

commit;


 studenttrackerid  │ operationalwindowid │ statuscode  │        createddate         │ createduser │
├──────────────────┼─────────────────────┼─────────────┼────────────────────────────┼─────────────┤
│           744997 │               10274 │ STCOMPLETED │ 2018-05-15 17:05:03.733+00 │          13 │
│           745298 │               10274 │ STCOMPLETED │ 2018-05-14 17:05:02.567+00 │          13 │