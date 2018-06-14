--CB
begin;
update cb.task t 
set scoringneeded=true 
from cb.taskvariant tv where t.taskid=tv.taskid 
and tv.taskvariantid in (12,
16,
18,
23,
24,
25,
26,
27,
30,
31,
33,
35,
39,
41,
42,
44,
45,
53,
57,
60,
62,
63,
65,
68,
69,
71,
73,
75,
78,
80,
81,
84,
86,
89,
93,
97,
100,
101,
103,
104,
107,
109,
110,
111,
113,
115,
116,
118,
120,
123,
124,
128,
129,
130,
136,
141,
142,
144,
145,
147,
149,
150,
152,
154,
155,
156,
158,
159,
160,
161,
162,
164,
165,
166,
171,
172,
173,
174,
177,
182,
183,
184,
185,
186,
199,
237,
238,
239,
241,
242,
247,
248,
249,
250,
251,
252,
253,
254,
256,
257,
258,
259,
266,
273,
274,
275,
280,
281,
282,
283,
285,
287,
297,
298,
302,
377,
475,
477,
478,
513,
521,
522,
523,
525,
526,
527,
528,
529,
531,
533,
534,
535,
538,
539,
573,
576,
581,
583,
588,
589,
590,
603,
623,
630,
632,
644,
649,
655,
656,
659,
660,
664,
668,
676,
692,
698,
703,
706,
707,
709,
714,
717,
723,
725,
731,
732,
733,
735,
737,
753,
755,
759,
761,
762,
764,
773,
775,
777,
780,
785,
787,
797,
808,
820,
821,
846,
851,
855,
870,
872,
874,
876,
878,
892,
893,
895,
896,
897,
913,
914,
915,
926,
930,
931,
938,
940,
942,
949,
952,
953,
955,
959,
962,
967,
969,
985,
988,
1160,
1161,
1162,
1166,
1218,
1321,
1437,
1441,
1456,
1472,
1502,
1504,
1506,
1507,
1512,
1513,
1520,
1521,
1527,
1529,
1534,
1539,
1547,
1550,
1556,
1561,
1566,
1576,
1586,
1591,
1596,
1615,
1624,
1629,
1634,
1637,
1646,
1651,
1662,
1671,
1678,
1691,
1695,
1696,
1706,
1707,
1709,
1710,
1724,
1727,
1741,
1742,
1745,
1748,
1753,
1760,
1771,
1775,
1778,
1780,
1796,
1812,
1825,
1826,
1927,
1943,
2027,
2032,
2044,
2102,
2143,
2911,
2914,
2921,
3055,
3099,
3266,
3268,
3269,
3270,
3277,
3279,
3285,
3286,
3288,
3291,
3292,
3297,
3298,
3299,
3300,
3308,
3309,
3310,
3311,
3315,
3318,
3324,
3326,
3334,
3337,
3341,
3358,
3362,
3363,
3388,
3393,
3413,
3519,
3522,
3524,
3529,
3776,
3777,
3779,
3780,
3809,
3873,
3877,
3882,
3884,
3885,
3892,
3899,
3904,
3906,
3912,
3918,
3925,
3929,
3930,
3931,
3937,
3941,
1168,
37,
187,
192,
193,
203,
212,
214,
216,
225,
229,
262,
350,
490)
 and scoringneeded =false;
commit;
--EP
begin;
-- List sent to tde for re-scoring
select distinct sr.taskvariantid into temp tmp_tv FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.externalid in (
12,
16,
18,
23,
24,
25,
26,
27,
30,
31,
33,
35,
39,
41,
42,
44,
45,
53,
57,
60,
62,
63,
65,
68,
69,
71,
73,
75,
78,
80,
81,
84,
86,
89,
93,
97,
100,
101,
103,
104,
107,
109,
110,
111,
113,
115,
116,
118,
120,
123,
124,
128,
129,
130,
136,
141,
142,
144,
145,
147,
149,
150,
152,
154,
155,
156,
158,
159,
160,
161,
162,
164,
165,
166,
171,
172,
173,
174,
177,
182,
183,
184,
185,
186,
199,
237,
238,
239,
241,
242,
247,
248,
249,
250,
251,
252,
253,
254,
256,
257,
258,
259,
266,
273,
274,
275,
280,
281,
282,
283,
285,
287,
297,
298,
302,
377,
475,
477,
478,
513,
521,
522,
523,
525,
526,
527,
528,
529,
531,
533,
534,
535,
538,
539,
573,
576,
581,
583,
588,
589,
590,
603,
623,
630,
632,
644,
649,
655,
656,
659,
660,
664,
668,
676,
692,
698,
703,
706,
707,
709,
714,
717,
723,
725,
731,
732,
733,
735,
737,
753,
755,
759,
761,
762,
764,
773,
775,
777,
780,
785,
787,
797,
808,
820,
821,
846,
851,
855,
870,
872,
874,
876,
878,
892,
893,
895,
896,
897,
913,
914,
915,
926,
930,
931,
938,
940,
942,
949,
952,
953,
955,
959,
962,
967,
969,
985,
988,
1160,
1161,
1162,
1166,
1218,
1321,
1437,
1441,
1456,
1472,
1502,
1504,
1506,
1507,
1512,
1513,
1520,
1521,
1527,
1529,
1534,
1539,
1547,
1550,
1556,
1561,
1566,
1576,
1586,
1591,
1596,
1615,
1624,
1629,
1634,
1637,
1646,
1651,
1662,
1671,
1678,
1691,
1695,
1696,
1706,
1707,
1709,
1710,
1724,
1727,
1741,
1742,
1745,
1748,
1753,
1760,
1771,
1775,
1778,
1780,
1796,
1812,
1825,
1826,
1927,
1943,
2027,
2032,
2044,
2102,
2143,
2911,
2914,
2921,
3055,
3099,
3266,
3268,
3269,
3270,
3277,
3279,
3285,
3286,
3288,
3291,
3292,
3297,
3298,
3299,
3300,
3308,
3309,
3310,
3311,
3315,
3318,
3324,
3326,
3334,
3337,
3341,
3358,
3362,
3363,
3388,
3393,
3413,
3519,
3522,
3524,
3529,
3776,
3777,
3779,
3780,
3809,
3873,
3877,
3882,
3884,
3885,
3892,
3899,
3904,
3906,
3912,
3918,
3925,
3929,
3930,
3931,
3937,
3941,
1168,
37,
187,
192,
193,
203,
212,
214,
216,
225,
229,
262,
350,
490)
 and scoringneeded =false;

update taskvariant  
set modifieddate=now(),scoringneeded =true
where externalid in (
12,
16,
18,
23,
24,
25,
26,
27,
30,
31,
33,
35,
39,
41,
42,
44,
45,
53,
57,
60,
62,
63,
65,
68,
69,
71,
73,
75,
78,
80,
81,
84,
86,
89,
93,
97,
100,
101,
103,
104,
107,
109,
110,
111,
113,
115,
116,
118,
120,
123,
124,
128,
129,
130,
136,
141,
142,
144,
145,
147,
149,
150,
152,
154,
155,
156,
158,
159,
160,
161,
162,
164,
165,
166,
171,
172,
173,
174,
177,
182,
183,
184,
185,
186,
199,
237,
238,
239,
241,
242,
247,
248,
249,
250,
251,
252,
253,
254,
256,
257,
258,
259,
266,
273,
274,
275,
280,
281,
282,
283,
285,
287,
297,
298,
302,
377,
475,
477,
478,
513,
521,
522,
523,
525,
526,
527,
528,
529,
531,
533,
534,
535,
538,
539,
573,
576,
581,
583,
588,
589,
590,
603,
623,
630,
632,
644,
649,
655,
656,
659,
660,
664,
668,
676,
692,
698,
703,
706,
707,
709,
714,
717,
723,
725,
731,
732,
733,
735,
737,
753,
755,
759,
761,
762,
764,
773,
775,
777,
780,
785,
787,
797,
808,
820,
821,
846,
851,
855,
870,
872,
874,
876,
878,
892,
893,
895,
896,
897,
913,
914,
915,
926,
930,
931,
938,
940,
942,
949,
952,
953,
955,
959,
962,
967,
969,
985,
988,
1160,
1161,
1162,
1166,
1218,
1321,
1437,
1441,
1456,
1472,
1502,
1504,
1506,
1507,
1512,
1513,
1520,
1521,
1527,
1529,
1534,
1539,
1547,
1550,
1556,
1561,
1566,
1576,
1586,
1591,
1596,
1615,
1624,
1629,
1634,
1637,
1646,
1651,
1662,
1671,
1678,
1691,
1695,
1696,
1706,
1707,
1709,
1710,
1724,
1727,
1741,
1742,
1745,
1748,
1753,
1760,
1771,
1775,
1778,
1780,
1796,
1812,
1825,
1826,
1927,
1943,
2027,
2032,
2044,
2102,
2143,
2911,
2914,
2921,
3055,
3099,
3266,
3268,
3269,
3270,
3277,
3279,
3285,
3286,
3288,
3291,
3292,
3297,
3298,
3299,
3300,
3308,
3309,
3310,
3311,
3315,
3318,
3324,
3326,
3334,
3337,
3341,
3358,
3362,
3363,
3388,
3393,
3413,
3519,
3522,
3524,
3529,
3776,
3777,
3779,
3780,
3809,
3873,
3877,
3882,
3884,
3885,
3892,
3899,
3904,
3906,
3912,
3918,
3925,
3929,
3930,
3931,
3937,
3941,
1168,
37,
187,
192,
193,
203,
212,
214,
216,
225,
229,
262,
350,
490)
 and scoringneeded =false;
commit;



 select taskvariantid,scoringdata from cb.taskvariant where taskvariantid in (9,
300,
303,
305,
306,
828,
899,
1402,
1403,
1426,
1446,
2186,
2915,
2939,
3301,
3306,
3350,
3515,
3820,
3825,
3905,
4734,
5017,
5265,
5458,
9336,
11811,
11875,
11908,
11938,
11944,
11946,
11949,
12424,
12441,
12451,
20676,
21047,
21614,
26205,
53747,
53754,
53756,
53758)

 select taskvariantid,scoringdata from cb.taskvariant where taskvariantid in (9,


begin;

select  replace(replace(replace(replace(scoringdata,'"score":"-0.2500"','"score":"0.0000"'),'"score":"-0.2000"','"score":"0.0000"'),'"score":"-0.5000"','"score":"0.0000"'),'"score":"-0.3333"','"score":"0.0000"') scoringdata_new,
 scoringdata from cb.taskvariant where taskvariantid =9 and  
 scoringdata ilike '%score":"-0%';

update  cb.taskvariant
set scoringdata=replace(replace(replace(replace(replace(scoringdata,'"score":"-0.2500"','"score":"0.0000"'),'"score":"-0.2000"','"score":"0.0000"'),'"score":"-0.5000"','"score":"0.0000"'),'"score":"-0.3333"','"score":"0.0000"'),'"score":"-0.1667"','"score":"0.0000"') ,
    scoringmethod='partialcredit'
where taskvariantid in (9,
300,
303,
305,
306,
828,
899,
1402,
1403,
1426,
1446,
2186,
2915,
2939,
3301,
3306,
3350,
3515,
3820,
3825,
3905,
4734,
5017,
5265,
5458,
9336,
11811,
11875,
11908,
11938,
11944,
11946,
11949,
12424,
12441,
12451,
20676,
21047,
21614,
26205,
53747,
53754,
53756,
53758) and  scoringdata ilike '%score":"-0%';

select  taskvariantid,scoringdata
 from cb.taskvariant where taskvariantid in (9,
300,
303,
305,
306,
828,
899,
1402,
1403,
1426,
1446,
2186,
2915,
2939,
3301,
3306,
3350,
3515,
3820,
3825,
3905,
4734,
5017,
5265,
5458,
9336,
11811,
11875,
11908,
11938,
11944,
11946,
11949,
12424,
12441,
12451,
20676,
21047,
21614,
26205,
53747,
53754,
53756,
53758) and  scoringdata ilike '%score":"-0%';

select * from tmp_tv; 


\copy (select * from tmp_tv) to 'tmp_pcscores.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


create temp table tmp_pcscores(id bigint, scoringdata text);
\COPY tmp_pcscores FROM 'tmp_pcscores.csv' DELIMITER ',' CSV HEADER ; 

begin;
update taskvariant  tv
set modifieddate=now(),scoringdata=tmp.scoringdata,scoringmethod='partialcredit'
from tmp_pcscores tmp where tv.externalid=tmp.id; 


select * from taskvariant 
where externalid in (9,
300,
303,
305,
306,
828,
899,
1402,
1403,
1426,
1446,
2186,
2915,
2939,
3301,
3306,
3350,
3515,
3820,
3825,
3905,
4734,
5017,
5265,
5458,
9336,
11811,
11875,
11908,
11938,
11944,
11946,
11949,
12424,
12441,
12451,
20676,
21047,
21614,
26205,
53747,
53754,
53756,
53758) and  scoringdata ilike '%score":"-0%';


begin

update taskvariant  tv
set modifieddate=now(),
scoringdata='{"correctResponse":{"responses":[{"responseoption":"Response Option 1","responseid":"45679","index":"0"},{"responseoption":"Response Option 2","responseid":"45677","index":"1"},{"responseoption":"Response Option 5","responseid":"45675","index":"4"}],"score":1},"partialResponses":[{"index":"0","responseoption":"Response Option 1","responseid":"45679","score":"0.3333","correctResponseFlag":"true","quota":"-1"},{"index":"1","responseoption":"Response Option 2","responseid":"45677","score":"0.3333","correctResponseFlag":"true","quota":"-1"},{"index":"2","responseoption":"Response Option 5","responseid":"45675","score":"0.3333","correctResponseFlag":"true","quota":"-1"}],"allFoilsSelectedScore":{"score":"0.0000"}}'
,scoringmethod='partialcredit'
 where tv.externalid=11777;


update taskvariant  tv
set modifieddate=now(),
scoringdata='{"correctResponse":{"responses":[{"responseoption":"Response Option 2","responseid":"4709","index":"0"},{"responseoption":"Response Option 3","responseid":"4708","index":"1"},{"responseoption":"Response Option 4","responseid":"4707","index":"2"},{"responseoption":"Response Option 6","responseid":"4705","index":"3"},{"responseoption":"Response Option 7","responseid":"4704","index":"4"}],"score":1},"partialResponses":[{"index":"0","responseoption":"Response Option 2","responseid":"4709","score":"0.2000","correctResponseFlag":"true","quota":"-1"},{"index":"1","responseoption":"Response Option 3","responseid":"4708","score":"0.2000","correctResponseFlag":"true","quota":"-1"},{"index":"2","responseoption":"Response Option 4","responseid":"4707","score":"0.2000","correctResponseFlag":"true","quota":"-1"},{"index":"3","responseoption":"Response Option 6","responseid":"4705","score":"0.2000","correctResponseFlag":"true","quota":"-1"},{"index":"4","responseoption":"Response Option 7","responseid":"4704","score":"0.2000","correctResponseFlag":"true","quota":"-1"}],"allFoilsSelectedScore":{"score":"0.0000"}}'
,scoringmethod='partialcredit'
 where tv.externalid=1168;


 update cb.taskvariant  tv
set 
scoringdata='{"correctResponse":{"responses":[{"responseoption":"Response Option 1","responseid":"45679","index":"0"},{"responseoption":"Response Option 2","responseid":"45677","index":"1"},{"responseoption":"Response Option 5","responseid":"45675","index":"4"}],"score":1},"partialResponses":[{"index":"0","responseoption":"Response Option 1","responseid":"45679","score":"0.3333","correctResponseFlag":"true","quota":"-1"},{"index":"1","responseoption":"Response Option 2","responseid":"45677","score":"0.3333","correctResponseFlag":"true","quota":"-1"},{"index":"2","responseoption":"Response Option 5","responseid":"45675","score":"0.3333","correctResponseFlag":"true","quota":"-1"}],"allFoilsSelectedScore":{"score":"0.0000"}}'
,scoringmethod='partialcredit'
 where taskvariantid=11777;


update cb.taskvariant  tv
set 
scoringdata='{"correctResponse":{"responses":[{"responseoption":"Response Option 2","responseid":"4709","index":"0"},{"responseoption":"Response Option 3","responseid":"4708","index":"1"},{"responseoption":"Response Option 4","responseid":"4707","index":"2"},{"responseoption":"Response Option 6","responseid":"4705","index":"3"},{"responseoption":"Response Option 7","responseid":"4704","index":"4"}],"score":1},"partialResponses":[{"index":"0","responseoption":"Response Option 2","responseid":"4709","score":"0.2000","correctResponseFlag":"true","quota":"-1"},{"index":"1","responseoption":"Response Option 3","responseid":"4708","score":"0.2000","correctResponseFlag":"true","quota":"-1"},{"index":"2","responseoption":"Response Option 4","responseid":"4707","score":"0.2000","correctResponseFlag":"true","quota":"-1"},{"index":"3","responseoption":"Response Option 6","responseid":"4705","score":"0.2000","correctResponseFlag":"true","quota":"-1"},{"index":"4","responseoption":"Response Option 7","responseid":"4704","score":"0.2000","correctResponseFlag":"true","quota":"-1"}],"allFoilsSelectedScore":{"score":"0.0000"}}'
,scoringmethod='partialcredit'
 where taskvariantid=1168;

 
insert into taskvariantrescore (taskvariantid,cbtaskvariantid,reason)
select id,externalid,'Scoring needed changed from false to true-cpass items' from taskvariant where id in (475785
,495788
,498007
,496733
,496010
,475756
,475793
,497931
,495970
,493057
,496763
,485616
,497989
,496777
,485550
,496742
,493046
,475769
,485603
,498025
,495783
,497929
,497951
,495816
,496031
,495994
,475776
,495807
,496797
,496045
,475809
,496053
,495964
,495819
,485609
,497973
,497988
,496015
,498005
,475751
,495827
,496794
,497958
,495821
,475803
,497998
,475782
,495796
,495748
,464189
,496059
,496060
,474812
,496806
,485595
,496037
,485574
,495981
,496040
,495765
,493061
,485554
,496793
,485553
,495774
,485614
,496798
,496720
,497948
,496812
,485621
,496009
,475815
,496013
,498002
,495768
,496756
,496001
,498015
,497941
,497955
,495993
,493113
,495962
,495985
,485625
,496799
,495745
,497984
,496024
,496739
,495777
,496005
,495786
,475742
,475796
,495825
,474695
,497968
,496772
,495732
,496747
,475739
,495761
,495808
,485590
,495772
,495982
,497947
,496033
,496818
,493053
,495755
,498013
,496780
,485580
,485579
,485537
,475812
,498011
,496051
,495969
,495991
,485626
,495973
,496815
,485568
,497996
,496055
,493062
,496816
,496058
,497987
,497943
,485546
,495818
,475747
,485610
,496719
,495754
,495750
,495757
,495814
,496014
,485533
,495749
,496728
,493044
,495987
,485555
,474854
,495830
,485604
,496804
,475723
,496023
,485576
,496784
,475806
,495811
,496048
,496778
,496782
,475765
,496808
,485629
,496791
,475794
,496002
,497986
,495758
,495770
,475770
,496004
,496803
,493054
,475795
,496049
,495759
,495997
,497979
,496785
,495747
,495794
,497945
,493056
,496724
,495974
,485538
,497971
,485585
,495734
,496734
,496730
,496776
,475728
,496723
,497962
,498021
,495967
,474762
,497972
,495800
,495831
,485564
,496028
,495785
,475724
,475805
,497934
,496767
,495826
,498018
,496768
,497992
,496735
,498012
,496725
,496012
,495824
,496755
,475738
,493120
,485613
,493051
,495793
,496057
,485531
,496757
,496732
,495792
,498000
,485542
,496762
,485558
,497949
,495756
,485561
,495971
,497970
,497999
,495764
,495822
,485600
,495823
,498028
,496038
,496025
,496729
,498023
,496783
,497959
,496813
,495977
,493043
,498006
,496018
,498009
,497956
,496727
,475722
,485543
,475807
,475736
,495780
,493050
,496751
,496775
,497930
,497939
,496736
,495733
,493060
,498017
,497993
,497940
,496006
,495975
,495829
,495787
,485582
,485541
,485587
,495769
,497997
,496753
,495996
,495979
,495751
,496744
,496759
,495789
,497969
,475761
,495752
,485596
,474850
,497975
,496726
,496737
,496800
,485612
,498014
,493114
,496034
,475760
,495741
,475762
,495795
,498026
,496050
,495736
,485628
,493108
,496740
,496743
,464185
,474719
,496758
,495744
,497977
,495737
,496721
,497938
,464190
,485563
,496761
,475779
,464188
,496047
,475792
,496786
,485607
,498008
,496760
,495762
,495999
,464191
,495965
,485584
,498022
,496746
,496807
,498027
,464186
,497942
,495968
,475726
,475750
,497967
,495775
,485540
,485534
,497944
,496039
,496017
,495986
,475759
,474963
,496032
,496000
,475763
,497932
,498003
,493048
,496029
,485597
,496811
,496774
,495778
,485545
,495738
,475804
,493045
,493059
,495803
,495966
,495740
,496789
,496805
,485551
,485549
,475820
,495799
,485562
,496056
,496007
,474763
,485539
,497981
,497995
,495781
,497978
,497994
,496764
,485617
,496817
,485544
,485623
,485559
,496802
,495806
,497964
,495739
,485548
,496011
,496741
,498010
,475810
,497936
,464184
,496750
,496788
,475766
,496052
,496787
,485620
,485601
,485606
,485571
,496765
,497953
,485605
,495978
,475790
,493104
,496766
,496731
,485575
,496042
,485536
,493055
,495784
,497991
,496041);

insert into taskvariantrescore (taskvariantid,cbtaskvariantid,reason)
select id,externalid,'Scoring method changed from correct only to pratialcredit-cpass items' from taskvariant where id in (496753,493085);


select distinct sr.taskvariantid into temp tmp_tv FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.externalid in (9,
300,
303,
305,
306,
828,
899,
1402,
1403,
1426,
1446,
2186,
2915,
2939,
3301,
3306,
3350,
3515,
3820,
3825,
3905,
4734,
5017,
5265,
5458,
9336,
11811,
11875,
11908,
11938,
11944,
11946,
11949,
12424,
12441,
12451,
20676,
21047,
21614,
26205,
53747,
53754,
53756,
53758
);

insert into taskvariantrescore (taskvariantid,cbtaskvariantid,reason)
select id,externalid,'Scoring method changed from subtractive model to pratialcredit-cpass items' from taskvariant where id in (select taskvariantid from tmp_tv);


select * from studentsresponses where studentid=322133 and taskvariantid=495813;
select * from studentsresponses where studentid=648903 and taskvariantid=495773;
select * from studentsresponses where studentid=648906 and taskvariantid=495773;
select * from studentsresponses where studentid=648912 and taskvariantid=495773;
select * from studentsresponses where studentid=673338 and taskvariantid=496043;
select * from studentsresponses where studentid=692355 and taskvariantid=496779;
select * from studentsresponses where studentid=742215 and taskvariantid=495813;
select * from studentsresponses where studentid=742226 and taskvariantid=496043;
select * from studentsresponses where studentid=743289 and taskvariantid=496035;
select * from studentsresponses where studentid=743374 and taskvariantid=496035;
select * from studentsresponses where studentid=743458 and taskvariantid=495813;


--cb --(issue found and re-run rescoring)
update  cb.taskvariant
set scoringdata=Replace(scoringdata,'"score":"0.1667","correctResponseFlag":"false"','"score":"0.0000","correctResponseFlag":"false"')
where taskvariantid =300;

begin;

select count(*) from studentsresponses
where taskvariantid in (select id from taskvariant where externalid=300) and originalscore is not null and score<>originalscore;

update studentsresponses
set score=originalscore,
    modifieddate=now()
where taskvariantid in (select id from taskvariant where externalid=300) and originalscore is not null and score<>originalscore;

update taskvariantrescore set processeddate=null,processerror=null where processeddate > '2017-12-01';

commit;

-- Missing item on round-1
--CB
begin;
update cb.task t 
set scoringneeded=true 
from cb.taskvariant tv where t.taskid=tv.taskid 
and tv.taskvariantid in (530)
 and scoringneeded =false;
commit;
--EP
begin;
-- List sent to tde for re-scoring
select distinct sr.taskvariantid into temp tmp_tv FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.externalid in (530)
 and scoringneeded =false;

insert into taskvariantrescore (taskvariantid,cbtaskvariantid,reason)
select id,externalid,'Scoring needed changed from false to true-cpass items' from taskvariant where id in (select taskvariantid from tmp_tv);

update taskvariant  
set modifieddate=now(),scoringneeded =true
where externalid in (530)
 and scoringneeded =false;

commit;


begin;
--CB
select  replace(replace(replace(replace(scoringdata,'"score":"-0.2500"','"score":"0.0000"'),'"score":"-0.2000"','"score":"0.0000"'),'"score":"-0.5000"','"score":"0.0000"'),'"score":"-0.3333"','"score":"0.0000"') scoringdata_new,
 scoringdata from cb.taskvariant where taskvariantid =20703 and  
 scoringdata ilike '%score":"-0%';

update  cb.taskvariant
set scoringdata=replace(replace(replace(replace(replace(scoringdata,'"score":"-0.2500"','"score":"0.0000"'),'"score":"-0.2000"','"score":"0.0000"'),'"score":"-0.5000"','"score":"0.0000"'),'"score":"-0.3333"','"score":"0.0000"'),'"score":"-0.1667"','"score":"0.0000"') ,
    scoringmethod='partialcredit'
where taskvariantid in (20703) and  scoringdata ilike '%score":"-0%';

select  taskvariantid,scoringdata into tmp_tv_data
from cb.taskvariant where taskvariantid in (20703
);

commit;

\copy (select * from tmp_tv_data) to 'tmp_tv_data.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--EP
create temp table tmp_tv_data(id bigint, scoringdata text);
\COPY tmp_tv_data FROM 'tmp_tv_data.csv' DELIMITER ',' CSV HEADER ; 

begin;
update taskvariant  tv
set modifieddate=now(),scoringdata=tmp.scoringdata,scoringmethod='partialcredit'
from tmp_tv_data tmp where tv.externalid=tmp.id; 


select * from taskvariant 
where externalid in (
20703) and  scoringdata ilike '%score":"-0%';


commit;

drop table if exists tmp_tv;
select distinct sr.taskvariantid into temp tmp_tv FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.externalid in (20703);
 
insert into taskvariantrescore (taskvariantid,cbtaskvariantid,reason)
select id,externalid,'Scoring method changed from subtractive model to pratialcredit-cpass items' from taskvariant where id in (select taskvariantid from tmp_tv);

--Rescoring item 300 and 20703 (do we need to clear the testjson)
update taskvariantrescore set processeddate=null,processerror=null where processeddate > '2017-12-01' and cbtaskvariantid=300;

--Validation
select distinct externalid FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.maxscore<sr.score and  tv.externalid in (20703,530,5995,300);

select * from studentsresponses where taskvariantid in (select id from taskvariant where externalid=885);
select * from studentsresponses where studentid=675060 and taskvariantid in (select id from taskvariant where externalid=300);
select * from studentsresponses where studentid=675077 and taskvariantid in (select id from taskvariant where externalid=300);
select * from studentsresponses where studentid=675092 and taskvariantid in (select id from taskvariant where externalid=300);
select * from studentsresponses where studentid=675094 and taskvariantid in (select id from taskvariant where externalid=5995);
select * from studentsresponses where studentid=712996 and taskvariantid in (select id from taskvariant where externalid=530);
select * from studentsresponses where studentid=181825 and taskvariantid in (select id from taskvariant where externalid=530);
select * from studentsresponses where studentid=181840 and taskvariantid in (select id from taskvariant where externalid=530);
select * from studentsresponses where studentid=576907 and taskvariantid in (select id from taskvariant where externalid=20703);
select * from studentsresponses where studentid=729572 and taskvariantid in (select id from taskvariant where externalid=20703);
select * from studentsresponses where studentid=348526 and taskvariantid in (select id from taskvariant where externalid=300);  --should be good all foils selected
select * from studentsresponses where studentid=567505 and taskvariantid in (select id from taskvariant where externalid=300);  --should be good all foils selected
select * from studentsresponses where studentid=649842 and taskvariantid in (select id from taskvariant where externalid=300);  --should be good all foils selected
select * from studentsresponses where studentid=1052832 and taskvariantid in (select id from taskvariant where externalid=300); --should be good all foils selected
select * from studentsresponses where studentid=1053060 and taskvariantid in (select id from taskvariant where externalid=300); --should be good all foils selected
select * from studentsresponses where studentid=1341965 and taskvariantid in (select id from taskvariant where externalid=300); --should be good all foils selected


----------------------------

-- Find the items which are in current optw and scoring flag set flase for None ER items
select distinct tv.id, tv.externalid,tt.code,scoringneeded 
into temp tmp_cbtv from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid and tt.code not in ('ER')
inner join testcollectionstests tct on tct.testid=t.id 
inner join operationaltestwindowstestcollections owc on owc.testcollectionid=tct.testcollectionid 
and  operationaltestwindowid =10238 and owc.activeflag is true
where scoringneeded is false or scoringneeded is null;


\copy (select distinct externalid,code,scoringneeded from tmp_cbtv) to 'items_scoringneeded_false_in_cpass_window_all_items.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


select distinct tv.externalid,tt.code,scoringneeded 
into temp tmp_cbtv_sr FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid 
inner join tmp_cbtv tmp on tmp.id=tv.id
WHERE e.currentschoolyear=2018 AND st.activeflag='t';

\copy (select * from tmp_cbtv_sr) to 'items_scoringneeded_false_in_cpass_window_have_std_response.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


-- Find the items which are in current optw and scoring method subtractivemodel
drop table if exists tmp_cbtv;
select distinct tv.id,tv.externalid,tt.code,scoringneeded 
into temp tmp_cbtv from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid and tt.code not in ('ER')
inner join testcollectionstests tct on tct.testid=t.id 
inner join operationaltestwindowstestcollections owc on owc.testcollectionid=tct.testcollectionid 
and  operationaltestwindowid =10238 and owc.activeflag is true
where tv.scoringmethod='subtractivemodel' or scoringneeded is null;


\copy (select distinct externalid,code,scoringneeded  from tmp_cbtv) to 'items_scoringmethod_subtractivemodel_in_cpass_window_all_items.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


select distinct tv.externalid,tt.code,scoringmethod 
into temp tmp_cbtv_sr FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid 
inner join tmp_cbtv tmp on tmp.id=tv.id
WHERE e.currentschoolyear=2018 AND st.activeflag='t';

\copy (select * from tmp_cbtv_sr) to 'items_scoringmethod_subtractivemodel_in_cpass_window_have_std_response.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



select distinct tv.id,tv.externalid,tv.scoringneeded,tv.scoringmethod,tv.scoringdata,sr.score,sr.response

select distinct studentstestsid,taskvariantid,studentstestsectionsid,sr.score,sr.createddate
-- into temp tmp_data
FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid 
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.externalid in (822, 1192, 3056, 3061, 3699, 3706, 50784,56951)
;

\copy (select * from tmp_data) to 'items_itp_in_cpass_window_have_std_response.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);




select distinct studentstestsid,taskvariantid,studentstestsectionsid,sr.score,sr.createddate
-- into temp tmp_data
FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid 
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.externalid in (796,
814,
842,
857,
859,
860,
862,
905);




select tv.externalid,sr.score,count(distinct sr.studentid) student_count
-- into temp tmp_data
FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid 
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.externalid in (822, 1192, 3056, 3061, 3699, 3706, 50784,56951)
group by tv.externalid,sr.score;



--cpass rescoring 12/19/2017 for mc-k scoring needed flag 
-- Note : MC_MS and MC_S item has scoring data and max score scoring responses issue 
drop table if exists tmp_cbtv;
select distinct tv.id, tv.externalid,tt.code,scoringneeded ,st.id,
tss.operationaltestwindowid,owc.activeflag
 from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid 
inner join testcollectionstests tct on tct.testid=t.id 
inner join studentstests st on st.testid=t.id
inner join studentsresponses sr on sr.studentstestsid=st.id
inner join operationaltestwindowstestcollections owc on owc.testcollectionid=tct.testcollectionid 
INNER JOIN testsession tss on tss.id = st.testsessionid and tss.operationaltestwindowid=owc.operationaltestwindowid
where 10222 =operationaltestwindowid and  tv.id in (506735,475786);
tv.externalid not in (
493,
482,
484,
485,
486,
1483,
1484,
1485,
1486,
1487,
2245,
2246,
2247,
2248,
6653,
8101,
8102,
8103,
8104,
8108,
8109,
12813,
12815,
12817,
12821,
67886,
67888,
67890,
67891,
67880,
67881,
67882,
67883,
55426,
55428,
55429,
55431,
55432);

\copy (select distinct externalid from tmp_cbtv) to 'tmp_cbtv_mck.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--EP
begin;

-- List sent to tde for re-scoring
select distinct sr.taskvariantid into temp tmp_tv FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.externalid in (select externalid from tmp_cbtv)
 and scoringneeded =false;

insert into taskvariantrescore (taskvariantid,cbtaskvariantid,reason)
select id,externalid,'Scoring needed changed from false to true-cpass items' from taskvariant where id in (select taskvariantid from tmp_tv);

update taskvariant  
set modifieddate=now(),scoringneeded =true,maxscore=1
where id in (select id from tmp_cbtv)
 and scoringneeded =false;

commit;


-- Missing item on round-1
--CB
begin;

create  temp TABLE tmp_cbtv (taskvariantid bigint);
\COPY tmp_cbtv FROM 'tmp_cbtv_mck.csv' DELIMITER ',' CSV HEADER ;

update cb.task t 
set modifieddate=now(),scoringneeded=true ,maxscore=1
from cb.taskvariant tv where t.taskid=tv.taskid 
and tv.taskvariantid in (select taskvariantid from tmp_cbtv)
 and scoringneeded =false;
commit;


begin;
-- List sent to tde for re-scoring
select distinct sr.taskvariantid into temp tmp_tv FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.externalid in (885)
 and scoringneeded =false;

insert into taskvariantrescore (taskvariantid,cbtaskvariantid,reason)
select id,externalid,'Scoring needed changed from false to true-cpass items' from taskvariant where id in (select taskvariantid from tmp_tv);

select distinct tv.id, tv.externalid,tt.code,scoringneeded 
into temp tmp_cbtv from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid --and tt.code in ('MC-K')
inner join testcollectionstests tct on tct.testid=t.id 
inner join operationaltestwindowstestcollections owc on owc.testcollectionid=tct.testcollectionid 
and  operationaltestwindowid =10238 and owc.activeflag is true
where --(scoringneeded is false or scoringneeded is null) and 
tv.externalid in (885);

update taskvariant  
set modifieddate=now(),scoringneeded =true,maxscore=1
where externalid in (885)
 and scoringneeded =false;

commit;


-- for subtractive model 
--EP
drop table if exists tmp_cbtv;
select distinct tv.id,tv.externalid,tt.code,scoringneeded , scoringmethod
into temp tmp_mcms from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid and tt.code not in ('ER')
inner join testcollectionstests tct on tct.testid=t.id 
inner join operationaltestwindowstestcollections owc on owc.testcollectionid=tct.testcollectionid 
and  operationaltestwindowid =10238 and owc.activeflag is true
where (tv.scoringmethod='subtractivemodel') and 
tv.externalid not in (
493,
482,
484,
485,
486,
1483,
1484,
1485,
1486,
1487,
2245,
2246,
2247,
2248,
6653,
8101,
8102,
8103,
8104,
8108,
8109,
12813,
12815,
12817,
12821,
67886,
67888,
67890,
67891,
67880,
67881,
67882,
67883,
55426,
55428,
55429,
55431,
55432);



\copy (select distinct externalid  from tmp_mcms) to 'tmp_mcms.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--CB

begin;

create temp table tmp_cbtv (taskvariantid bigint);
\COPY tmp_cbtv FROM 'tmp_mcms.csv' DELIMITER ',' CSV HEADER ;

select tv.scoringdata,t.maxscore,tv.taskvariantid
into temp tmp_tv_data from cb.taskvariant tv 
inner join cb.task t on t.taskid=tv.taskid
inner join tmp_cbtv tmp on tmp.taskvariantid=tv.taskvariantid;

\copy (select * from tmp_tv_data) to 'tmp_tv_data.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);




begin;
--CB
select  replace(replace(replace(replace(scoringdata,'"score":"-0.2500"','"score":"0.0000"'),'"score":"-0.2000"','"score":"0.0000"'),'"score":"-0.5000"','"score":"0.0000"'),'"score":"-0.3333"','"score":"0.0000"') scoringdata_new,
 scoringdata 
 select count(*) from cb.taskvariant where taskvariantid in (select taskvariantid from tmp_tv_data) and  
 scoringdata ilike '%score":"-0%';

update  cb.taskvariant
set scoringdata=replace(replace(replace(replace(replace(replace(scoringdata,'"score":"-0.2500"','"score":"0.0000"'),'"score":"-0.2000"','"score":"0.0000"'),'"score":"-0.5000"','"score":"0.0000"'),'"score":"-0.3333"','"score":"0.0000"'),'"score":"-0.1667"','"score":"0.0000"') ,'"score":"-0.1429"','"score":"0.0000"'),
    scoringmethod='partialcredit'
where taskvariantid in (select taskvariantid from tmp_tv_data) and  scoringdata ilike '%score":"-0%';

select  taskvariantid,scoringdata  from cb.taskvariant where taskvariantid in (select taskvariantid from tmp_tv_data)


commit;

\copy (select  taskvariantid,scoringdata  from cb.taskvariant where taskvariantid in (select taskvariantid from tmp_tv_data)) to 'tmp_tv_data_cb.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--EP
create temp table tmp_tv_data(id bigint, scoringdata text);
\COPY tmp_tv_data FROM 'tmp_tv_data.csv_new' DELIMITER ',' CSV HEADER ; 

begin;




select * from taskvariant 
where externalid in (
20703) and  scoringdata ilike '%score":"-0%';


commit;

drop table if exists tmp_tv;
select distinct sr.taskvariantid into temp tmp_tv FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.externalid in (select id from tmp_tv_data );
 
insert into taskvariantrescore (taskvariantid,cbtaskvariantid,reason)
select id,externalid,'Scoring method changed from subtractive model to pratialcredit-cpass items' from taskvariant where id in (select taskvariantid from tmp_tv);


select distinct tv.id,tv.externalid,tt.code,tmp.scoringdata,tv.scoringmethod
into temp tmp_mcms_new from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid and tt.code not in ('ER')
inner join testcollectionstests tct on tct.testid=t.id 
inner join tmp_tv_data tmp on tv.externalid=tmp.id
inner join operationaltestwindowstestcollections owc on owc.testcollectionid=tct.testcollectionid 
and  operationaltestwindowid =10238 and owc.activeflag is true
where (tv.scoringmethod='subtractivemodel' ) and 
tv.externalid not in (
493,
482,
484,
485,
486,
1483,
1484,
1485,
1486,
1487,
2245,
2246,
2247,
2248,
6653,
8101,
8102,
8103,
8104,
8108,
8109,
12813,
12815,
12817,
12821,
67886,
67888,
67890,
67891,
67880,
67881,
67882,
67883,
55426,
55428,
55429,
55431,
55432);

begin;

update taskvariant  tv
set modifieddate=now(),scoringdata=tmp.scoringdata,scoringmethod='partialcredit'
from tmp_mcms_new tmp where tv.id=tmp.id; 


select count(*) from taskvariant tv
inner join tmp_mcms_new tmp on tv.id=tmp.id
 where tv.scoringdata ilike '%score":"-0%';

 select distinct tv.externalid,tv.scoringmethod from taskvariant tv
inner join tmp_mcms_new tmp on tv.id=tmp.id
 where tv.scoringdata ilike '%score":"-0%';

commit;

select distinct tv.externalid FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t' and tv.externalid in (
226,
227,
228,
435,
437,
629,
1066,
1311,
1312,
1313,
1427,
1469,
67880,
67883,
67891);


update taskvariant
 set scoringdata =(select scoringdata from taskvariant  where id=513264 and externalid =885),modifieddate=now()
 where externalid =885 and modifieddate>'2017-12-18' and id<>513264;



 select distinct tv.id, tv.externalid,tt.code,scoringneeded,scoringmethod
into temp tmp_cbtv from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid --and tt.code in ('MC-K')
inner join testcollectionstests tct on tct.testid=t.id
inner join operationaltestwindowstestcollections owc on owc.testcollectionid=tct.testcollectionid
and  operationaltestwindowid =10238 and owc.activeflag is true
where --(scoringneeded is false or scoringneeded is null) and
tv.externalid in (885);


update taskvariant  tv
set modifieddate=now(),scoringdata=(select scoringdata from taskvariant where externalid=885 and id=513264)  ,scoringmethod='partialcredit'
from tmp_cbtv tmp where tv.id=tmp.id; 

insert into taskvariantrescore (taskvariantid,cbtaskvariantid,reason)
select id,externalid,'Scoring method changed from correctonly model to pratialcredit-cpass items' from taskvariant 
where id in (select distinct taskvariantid from studentsresponses where taskvariantid in (select id from tmp_cbtv));


--

select count(*) FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
where ts.operationaltestwindowid =10238 and sr.createddate::date>'2017-12-16'

--MC-S - max score, taskvariantfoils - responsescore, scoringneeded - true (226, 227, 228)


select tv.taskvariantid,tv.scoringdata,t.maxscore,tv.taskvariantid,tvr.correctresponse,tvr.responsescore,scoringneeded
 from cb.taskvariant tv 
inner join cb.task t on t.taskid=tv.taskid
inner join cb.taskvariantresponse tvr on tvr.taskvariantid=tv.taskvariantid
where tv.taskvariantid in (226,227,228);


select distinct tv.id, tv.externalid,tt.code,scoringneeded,scoringmethod,t.maxscore
into temp tmp_cbtv from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid 
inner join testcollectionstests tct on tct.testid=t.id
inner join operationaltestwindowstestcollections owc on owc.testcollectionid=tct.testcollectionid
and  operationaltestwindowid =10238 and owc.activeflag is true
where tv.externalid in (226,227,228);


select distinct sr.taskvariantid into temp tmp_tv FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.id in (select id from tmp_cbtv );

begin;

update taskvariant  
set modifieddate=now(),scoringneeded =true,maxscore=4
where id in (select id from tmp_cbtv);

commit;

--MC-MS - max score, scoringdata, scoringneeded - true, scoring method - partialcredit (629, 1066, 1311, 1312, 1313, 1427, 1469)

select tv.taskvariantid,tv.scoringdata
into temp tmp_tv_data
 from cb.taskvariant tv 
inner join cb.task t on t.taskid=tv.taskid
where tv.taskvariantid in (629, 1066, 1311, 1312, 1313, 1427, 1469);

\copy (select  * from tmp_tv_data) to 'tmp_tv_data.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--EP
create temp table tmp_tv_data(id bigint, scoringdata text);
\COPY tmp_tv_data FROM 'tmp_tv_data.csv' DELIMITER ',' CSV HEADER ; 

select distinct tv.id, tv.externalid,tt.code,scoringneeded,scoringmethod,t.maxscore
into temp tmp_cbtv from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid 
inner join testcollectionstests tct on tct.testid=t.id
inner join operationaltestwindowstestcollections owc on owc.testcollectionid=tct.testcollectionid
and  operationaltestwindowid =10238 and owc.activeflag is true
where tv.externalid in (629, 1066, 1311, 1312, 1313, 1427, 1469);

select distinct sr.taskvariantid into temp tmp_tv FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.id in (select id from tmp_cbtv );

insert into taskvariantrescore (taskvariantid,cbtaskvariantid,reason)
select id,externalid,'Scoring method changed from subtractive model to pratialcredit-cpass items' from taskvariant 
where id in (select  taskvariantid from tmp_tv);

update taskvariant  tv
set modifieddate=now(),scoringdata=tmp.scoringdata,scoringmethod='partialcredit',scoringneeded=true,,maxscore=1
from tmp_tv_data tmp
where tv.externalid=tmp.id and tv.id in (select id from tmp_cbtv); 

select tv.modifieddate,tv.scoringmethod,tv.scoringneeded,tv.maxscore from taskvariant tv 
inner join tmp_tv_data tmp
on tv.externalid=tmp.id 
where tv.id in (select id from tmp_cbtv);

select tv.id, tv.externalid,scoringneeded,scoringmethod,maxscore,scoringdata from taskvariant tv where externalid=226 order by tv.id desc limit 1;


select s.id studentid,s.statestudentidentifier ssid, t.externalid cbtestid,t.id eptestid ,t.createdate testcreatedate,t.modifieddate testmodifieddate,st.id studentstestid,sr.studentstestsectionsid,tv.id eptaskvariantid
,tv.externalid cbtaskvariantid,sr.score,sr.createddate responsecreatedate,sr.modifieddate responsemodifieddate
, sr.response,sr.foilid,tv.scoringmethod,tv.maxscore,tv.scoringneeded,tv.scoringdata,tv.createdate itemcreatedate,tv.modifieddate itemmodifieddate 
,tvt.code tasktypecode,tvs.createddate rescorecreateddate,tvs.modifieddate rescoremodifieddate 
,array_to_string(array_agg(distinct tvf.foilid  ), ',') correctfoilid
,array_to_string(array_agg(distinct tvf.taskvariantid ), ',') correctvariantid,operationaltestwindowid
 into temp tmp_report
FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
inner join test t on t.id=st.testid
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join student s on s.id=e.studentid
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
left outer join taskvariantsfoils tvf on correctresponse is true  and tvf.taskvariantid=tv.id
left outer join tasktype tvt on tvt.id=tv.tasktypeid
left outer join taskvariantrescore tvs on tv.id=tvs.taskvariantid and tvs.createddate>='2017-11-01 18:09:50.990173+00'
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and t.externalid in (19508,19509,20340) 
group by s.id ,s.statestudentidentifier , t.externalid ,t.id  ,st.id ,sr.studentstestsectionsid,tv.id 
,tv.externalid ,sr.score,sr.response,sr.foilid,tv.scoringmethod,tv.maxscore,tv.scoringneeded,tv.scoringdata
,t.createdate,t.modifieddate,tvs.createddate,tvs.modifieddate,sr.createddate,sr.modifieddate,tvt.code,operationaltestwindowid;

\copy (select *  from tmp_report) to 'tmp_report.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

select * from studentsresponses  limit 10;

select distinct statestudentidentifier FROM studentstests st

select count(distinct st.testid)
FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
inner join test t on t.id=st.testid
JOIN testsession ts ON st.testsessionid = ts.id 
where ts.operationaltestwindowid=10246;
JOIN studentstestsections sts ON sts.studentstestid = st.id
inner join test t on t.id=st.testid
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join student s on s.id=e.studentid
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and t.externalid in (19509) and s.statestudentidentifier in (
'100010001',
'100020002',
'100030003',
'100040004',
'100050005',
'100060006',
'100070007',
'100080008',
'100090009')

----------------------------------------------------------------

-- 02/28/2018 updating for MC-K items 

drop table if exists tmp_cbtv;
select distinct tv.id,tv.externalid,tt.code,scoringneeded,scoringmethod,tv.maxscore,scoringdata
into temp tmp_cbtv 
from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid 
inner join testcollectionstests tct on tct.testid=t.id
inner join operationaltestwindowstestcollections owc on owc.testcollectionid=tct.testcollectionid
and  operationaltestwindowid =10246 and owc.activeflag is true;


 select distinct externalid from tmp_cbtv where code='MC-MS';
 select distinct externalid from tmp_cbtv where code='MC-K';
 
 select id,externalid,code,scoringneeded,scoringmethod,maxscore from tmp_cbtv where code='MC-MS';
 select id,externalid,code,scoringneeded,scoringmethod,maxscore from tmp_cbtv where code='MC-K';
 
 select id,externalid,code,scoringneeded,scoringmethod,maxscore from tmp_cbtv where code='ITP';


-- 1.mc-k items some have true ,but score zero 
      --i.max score is blanck for 
      --ii.scoring need false for some items 
-- 2.mc-ms subtracive model need to change to partial credit 

 is this 0 or +ve "score":"-0.3333","correctResponseFlag":"false","quota":"-1"
-- 3.itp --item need verify 
3699 -- some got 1 
3061 -- non of them got correct
3056 --some got 1
-- 4. test json table need to clear or just clear by test 
-- 5. run the scoring process 

select * from taskvariantsfoils  where taskvariantid =506726;

select * from taskvariant  where id=506726


--EP
begin;

-- List sent to tde for re-scoring
drop table if exists tmp_tv;
select distinct sr.taskvariantid into temp tmp_tv FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.externalid in ( select distinct externalid from tmp_cbtv where code='MC-K')
 and (maxscore is null or scoringneeded =false);


insert into taskvariantrescore (taskvariantid,cbtaskvariantid,reason)
select id,externalid,'Scoring needed changed from false to true-cpass items' from taskvariant where id in (select taskvariantid from tmp_tv);

update taskvariant  
set modifieddate=now(),scoringneeded =true,maxscore=1
where externalid in (select distinct externalid from tmp_cbtv where code='MC-K')
 and (scoringneeded =false or maxscore is null) and createdate>'2017-08-01';

\copy (select distinct externalid from tmp_cbtv where code='MC-K') to 'tmp_cbtv_mck.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


commit;


-- Missing item on round-1
--CB
begin;

create  temp TABLE tmp_cbtv (taskvariantid bigint);
\COPY tmp_cbtv FROM 'tmp_cbtv_mck.csv' DELIMITER ',' CSV HEADER ;

update cb.task t 
set modifieddate=now(),scoringneeded=true ,maxscore=1
from cb.taskvariant tv where t.taskid=tv.taskid 
and tv.taskvariantid in (select taskvariantid from tmp_cbtv)
 and (scoringneeded =false or maxscore is null);
commit;

--CB 
select tv.taskvariantid,ts.scoringneeded,ts.maxscore,ts.taskid from cb.taskvariant tv
inner join cb.task ts on ts.taskid=tv.taskid
where tv.taskvariantid in (1456,
       1472,
       1502,
       1504,
       1506,
       1507,
       1512,
       1513,
       1520,
       1521,
       1522,
       1527,
       1529,
       1534,
       1535,
       1539,
       1547,
       1550,
       1556,
       1561,
       1566,
       1569,
       1576,
       1586,
       1591,
       1596,
       1615,
       1619,
       1622,
       1623,
       1624,
       1629,
       1631,
       1634,
       1637,
       1646,
       1651,
       1658,
       1662,
       1671,
       1678,
       1691,
       1693,
       1695,
       1696,
       1699,
       1702,
       1706,
       1707,
       1709,
       1710,
       1718,
       1724,
       1727,
       1734,
       1741,
       1742,
       1745,
       1748,
       1753,
       1760,
       1771,
       1775,
       1778,
       1780,
       1795,
       1796,
       1812,
       1825,
       1826,
       1937,
       1943,
       2027,
       2032,
       2044,
       2102,
       2143,
       2911,
       2912,
       2914,
       2916,
       2921,
       2922,
       2943,
       2950,
       3055,
       3099,
       3266,
       3267,
       3268,
       3269,
       3270,
       3277,
       3279,
       3285,
       3286,
       3288,
       3292,
       3297,
       3298,
       3299,
       3300,
       3308,
       3309,
       3310,
       3311,
       3313,
       3314,
       3315,
       3316,
       3318,
       3324,
       3326,
       3333,
       3334,
       3337,
       3341,
       3348,
       3358,
       3362,
       3363,
       3366,
       3388,
       3393,
       3413,
       3414,
       3517,
       3518,
       3519,
       3521,
       3522,
       3524,
       3529,
       3754,
       3757,
       3759,
       3761,
       3762,
       3763,
       3764,
       3766,
       3768,
       3770,
       3771,
       3773,
       3937) and (ts.scoringneeded is false or ts.maxscore is null) ;

-------------------------------------------
--MS-MS subtractive model


update  cb.taskvariant
set scoringdata=replace(replace(replace(replace(replace(scoringdata,'"score":"-0.2500"','"score":"0.0000"'),'"score":"-0.2000"','"score":"0.0000"'),'"score":"-0.5000"','"score":"0.0000"'),'"score":"-0.3333"','"score":"0.0000"'),'"score":"-0.1667"','"score":"0.0000"') ,
    scoringmethod='partialcredit'
 where   taskvariantid= 54948;

select  taskvariantid, scoringdata
into temp tmp_cb_data
 from cb.taskvariant
where taskvariantid in (
1704,
       1721,
       1733,
       1765,
       1767,
      -- 2140,
       2178,
       3060,
       3533,
       4111,
       4226,
       4233,
       4386,
       4725,
       4748,
       4757,
      54948);

\copy (select * from tmp_cb_data) to 'tmp_cb_data.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 --EP
 
create temp table tmp_tv_data(id bigint, scoringdata text);
\COPY tmp_tv_data FROM 'tmp_cb_data.csv' DELIMITER ',' CSV HEADER ; 

begin;

drop table if exists tmp_tv;
select distinct sr.taskvariantid into temp tmp_tv FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.externalid in ( select distinct externalid from tmp_cbtv where code='MC-MS' and scoringmethod='subtractivemodel');


insert into taskvariantrescore (taskvariantid,cbtaskvariantid,reason)
select id,externalid,'Scoring method changed from correct only to pratialcredit-cpass items' from taskvariant 
where id in (select taskvariantid from tmp_tv where externalid<>2140);


update taskvariant  tv
set modifieddate=now(),scoringdata=tmp.scoringdata,scoringmethod='partialcredit'
from tmp_tv_data tmp where tv.externalid=tmp.id
and createdate>'2017-08-01'
and externalid<>2140
and tv.scoringmethod='subtractivemodel';


select distinct scoringmethod from taskvariant 
where externalid in (select id from tmp_tv_data
) --and  scoringdata ilike '%score":"-0%'
and createdate>'2017-08-01' ;

commit;


commit;     


select count(distinct taskvariantid)  from taskvariantrescore where createddate::date='2018-02-28';

select count(distinct t.id) 
from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id=tv.tasktypeid 
inner join testcollectionstests tct on tct.testid=t.id
where tv.id in (select distinct taskvariantid  from taskvariantrescore where createddate::date='2018-02-28');



---03/01/2018
--MS-MS subtractive model


select scoringdata from cb.taskvariant where taskvariantid= 2140;

update  cb.taskvariant
set --scoringdata=replace(replace(replace(replace(replace(scoringdata,'"score":"-0.2500"','"score":"0.0000"'),'"score":"-0.2000"','"score":"0.0000"'),'"score":"-0.5000"','"score":"0.0000"'),'"score":"-0.3333"','"score":"0.0000"'),'"score":"-0.1667"','"score":"0.0000"') ,
    scoringmethod='partialcredit'
 where   taskvariantid= 2140;

\copy (select taskvariantid,scoringdata from cb.taskvariant where   taskvariantid= 2140) to 'tmp_cb_data.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 --EP
 
create temp table tmp_tv_data(id bigint, scoringdata text);
\COPY tmp_tv_data FROM 'tmp_cb_data.csv' DELIMITER ',' CSV HEADER ; 

begin;

drop table if exists tmp_tv;
select distinct sr.taskvariantid into temp tmp_tv FROM studentstests st
JOIN studentstestsections sts ON sts.studentstestid = st.id
JOIN testsession ts ON st.testsessionid = ts.id 
JOIN enrollment e ON st.enrollmentid = e.id
inner join studentsresponses sr on sr.studentstestsectionsid=sts.id
inner join taskvariant tv on tv.id=sr.taskvariantid
WHERE e.currentschoolyear=2018 AND st.activeflag='t'
and tv.externalid in ( select distinct externalid from tmp_cbtv where code='MC-MS' and scoringmethod='subtractivemodel');


insert into taskvariantrescore (taskvariantid,cbtaskvariantid,reason)
select id,externalid,'Scoring method changed from correct only to pratialcredit-cpass items' from taskvariant 
where id in (select taskvariantid from tmp_tv where externalid<>2140);


update taskvariant  tv
set modifieddate=now(),scoringmethod='partialcredit'
where createdate>'2017-08-01' and  externalid=2140   
and tv.scoringmethod='subtractivemodel';


insert into taskvariantrescore (taskvariantid,cbtaskvariantid,reason)
select id,externalid,'Scoring method changed from correct only to pratialcredit-cpass items' from taskvariant 
 where  createdate>'2017-08-01' and  externalid=2140;




