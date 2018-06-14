--ssid:2456590

begin;

delete from studenttrackerblueprintstatus  where studenttrackerid in (740327,741004);

commit;


 studenttrackerid │ operationalwindowid │ statuscode  │        createddate         │ createduser │
├──────────────────┼─────────────────────┼─────────────┼────────────────────────────┼─────────────┤
│           740327 │               10282 │ STCOMPLETED │ 2018-05-03 16:20:05.639+00 │          13 │
│           741004 │               10282 │ STCOMPLETED │ 2018-05-03 16:05:05.043+00 │          13 │
