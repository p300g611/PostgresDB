
   select * into temp duprole from userassessmentprogram where id in (397172,467109);

   \copy (select * from duprole) to 'T560061_duprole.csv'(FORMAT CSV,HEADER TRUE,FORCE_QUOTE *);
   
   begin;
   delete from userassessmentprogram where id = 397172;
   commit;
   