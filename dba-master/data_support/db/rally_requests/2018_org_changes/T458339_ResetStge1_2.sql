--reset stage1 in progress and stage2 is inactive 

--SSID:3419481616,SID:873285  ELA

select kap_testreset_inprogress(2018,873285,3,'For ticket#458339');

--SSID:2713467381  ,SID:1234185 Math

select kap_testreset_inprogress(2018,1234185,440,'For ticket#458339');

commit;
