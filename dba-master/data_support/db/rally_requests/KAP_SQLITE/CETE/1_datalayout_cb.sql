-- Find possible score, number of possible scores, ittem key-current version
--drop table if exists tmp_pcscores;
select taskvariantid,scoringdata  into temp tmp_pcscores from cb.taskvariant tv where scoringmethod ='partialcredit' or scoringmethod ='subtractivemodel';
\copy (select * from tmp_pcscores) to '/srv/extracts/CETE/tmp_pcscores.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);