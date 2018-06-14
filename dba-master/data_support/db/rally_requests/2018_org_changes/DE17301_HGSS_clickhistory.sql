select distinct sts.id,statestudentidentifier,st.id
from studentstests st 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join student s on s.id=st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
inner join testcollection tc on tc.id=st.testcollectionid
inner join stage stg on stg.id=tc.stageid
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258,10261)  and s.statestudentidentifier in ('5372499745')
 and tc.contentareaid=443 and stg.name='Performance';


begin;

--old <p>&nbsp;&nbsp;&nbsp; There are multiple things tha
--  <p>&nbsp;&nbsp;&nbsp; There are multiple things tha
-- t courts should consider when detemining the nation&#39;s laws. They have to consider a lot beacuse there are many people in our nation and many people have
-- different views on things. Therefore, the court has to consider a lot when making the laws for the nation including, what the constitution says, the oath of
-- office, and other departments of the government.</p><p>&nbsp;&nbsp;&nbsp; The cosnstitution, oath of office, and the other departments of office should be lo
-- ok into when</p>
update studentsresponses
set response='<p>    There are multiple things that courts should consider when determining the nation&#39;s laws. They have to consider a lot because there are many people in our nation and many people have different views on things. Therefore, the court has to consider a lot when making the laws for the nation including, what the constitution says, the oath of office, and other departments of the government.</p><p>    The constitution, oath of office, and the other departments of office should be looked into when making laws for the nation. The constitution should be looked into because the constitution itself should always be &quot;first mentioned&quot; according to the article. It is a major part of our government and it needs to be considered when making national laws. The oath of office should be considered because it is imposed by legislature. This also reminds us to be fair and respectful toward everyone. Every person in our counrty matters so this needs to be set into view. The other departments in office need to be considered too in the decisions of law because it may effect them in a bad way. Therefore, this part of office needs to consider other parts in all law making decisions. </p><p>    In conclusion, when making national laws, the constitution, the oath of office, and other departments of office need to be considered. They are all important to our nation and we do not want anyone to feel left out. These other parts of office are curial into making just laws.</p><p>    </p>'
, modifieddate=now()
, modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestsectionsid  =31739866;


--4406480617--done( '<p>pp</p>' --old)

update studentsresponses
set response='<p>&nbsp;&nbsp;&nbsp; Based on my understanding of the history of civil rights there are many things that the people could have done to calm the racial tension.</p><p>&nbsp;&nbsp;&nbsp;&nbsp;One of the first things people could have done would be to limit any violence on either side of the issue. People who are promoting segregation shouldn&#39;t attack people of color with violence. One example of the use of violence agents african Amaricans was Emmett Till, a young african American teen who was captured, tortured, and killed. This made national news and angered many people and convinced many more that the african Amaricans were treated very unfairly. This caused a surge of uproar from the Black community which lead to much more violence. A very famous civil rights activist named Martin Luther King Jr. dedicated his live to preaching the gospel and fighting for black rights, but through his life he always promoted nonviolence. This is why it is so important that as a nation we go to any lengths to avoid violence at all costs, because it always leads to more violence.&nbsp;</p><p>&nbsp;&nbsp;&nbsp; another step we should have taken to reduce racial tension would be to always have peaceful protests and try to accept others point of view. This would lead to better communication between the races in turn lowering racial tension.</p><p>&nbsp;&nbsp;&nbsp; We the people need to avoid violence agents one another and always protest in a peaceful manner, these are the steps america should take to the path of lower racial tension.</p>'
, modifieddate=now()
, modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestsectionsid  =32935661;

--7747474253--done ('<p>Wh</p>'--old)
update studentsresponses
set response='<p>What factors should courts consider when determining the constituionality of the nation&#39;s laws? A&nbsp;factor the courts should consider when determining the constitutionality of the nation&#39;s laws if it will infringe on others rights. An example is&nbsp;&nbsp;the court case that involved the gay couple and the cake shop was infringing on both party&#39;s&nbsp;right. The gay couple wanted a cake to be made, but the baker didn&#39;t want to make it for them becsuse it was against his religion.</p><p>Another factor they should consider is that they need to stop changing and adding new amendments. They need to stop&nbsp;changing and adding new amendments because if they are going to keep doing that then, what is the point of the almost 16 original amendments? The first amendments that the United States had were good enough. All though there is going to be people that disagree and say that they need to make more. I think that they should just leave them how they are.</p>'
, modifieddate=now()
, modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestsectionsid  =31529440;

--8289856431--done
update studentsresponses
set response='<p>An Oligarchy and Democracy both have a community of people, but in a oligarchy only the rich and powerful are involved, which in a democracy every man 18 years or older,&nbsp;rich or poor could be involved. A democracy is more fair than a oligarchy and it will keep everyone fair and not want to try and overule a leader or leaders. Democracy also allowwed everyone to vote on laws or important decisions. Arsitotle in her book said that all citzens should be paid if they have any share in management of public affaris, either as members of the assembly and judges.Those are just a couple of reasons why it is better.</p><p>&nbsp; &nbsp; Oligarchy has advantages and disadvantages. Oligarchy you know has powerful goverment, but it doesn&#39;t speak for the people which could lead to a total riot like in Aristoles constitution writing.In a Oligarchy &nbsp;to be rich you had to have been born into to a rich family. No people could vote unless they were rich or powerful. They couldn&#39;t decide on laws or public affaris. Oligarchy has more disadvantages then advatages.</p>'
, modifieddate=now()
, modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestsectionsid  =31625263;

--2058773217--done
update studentsresponses
set response='<p>&nbsp;&nbsp;&nbsp;&nbsp;The courts should consider how the law effects all groups, races, classes of people and if the law will&nbsp;help them or not. They must also ensure that a law will give the constitution the right amount of power to the federal government and to the states and to the people. The courts need to make sure they judge a case without bias against on side. In this excerpt from <em>Marbury vs. Madison&nbsp;</em>it says &quot;<em><span>I do solemnly swear that I will administer justice without respect to persons, and do equal right to the poor and to the rich&quot;&nbsp;</span></em><span>The courts should always chose what is best for the United States and not what is best for the courts. It says in the <em>Marbury vs. Madison </em>case <em>&quot;I do solemnly swear that I will administer justice without respect to persons . . . agreeably to the constitution and laws of the United States.&quot;&nbsp;</em>The courts have to judge cases taking all things into account, not being bias and must do everything in the name of and for the United States of America.</span></p>'
, modifieddate=now()
, modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestsectionsid  =31605466;

--7009295123--done
update studentsresponses
set response='<p>There are many strengths and weaknesses to all types of government.</p><p>&nbsp; &nbsp; There are many strengths to democracy and tyranny.&nbsp;One strength of democracy is that the people get to deiced&nbsp;what choices are made. One strength of tyranny is that when choices are made it doesn&#39;t take as long to make the decsion because there&#39;s one person making the decsion. Another strength in democracy is that not one person is all powerful so that might cause less civil wars or uprisings. Another&nbsp;strength of tyranny is that since there is only one ruler regular people don&#39;t have to think about being in government or making important descions in government.</p><p>&nbsp; &nbsp; There are also many weaknesses to both a tyranny and democracy. One weakness in tyranny is that only one person is a ruler and might not make a descion that you want. One weakness in a democracy is that since there are many leaders that might not have the same mindset or descions it could go on for weeks at a time. Another weakness in tyranny is that becuase there is one ruler and the ruler might not make the descion you or other people want there could be uprisings and civil wars which could make that country weak causing them to be captured by another country. Another weakness in democracy is that some people might not be able to play a role in government so they might start and uprising causing them to be weak and being captured by another country.&nbsp;</p><p>&nbsp; &nbsp; As you can see there are many strengths and weaknesses in democracy and tyranny.</p>'
, modifieddate=now()
, modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestsectionsid  =31623572;


--9178568277--done
update studentsresponses
set response='<p>Aristotle thinks democracy is the best goverment. some like oligarcy instead. in the next parhgraphs I&#39;ll talk about how great democracy, but also so problems. I&#39;ll also talk about how bad oligarchy is.</p><p>democracy means goverment ruled by the people. We even still use democracy. democracy is great because rich people don&#39;t have anymore power than other people. I could be bad if you were rich.</p><p>Oligarcy means ruled by rich and powerful. Oligarcy isn&#39;t even really used anymore. Oligarcy is bad because if you were poor you wouldn&#39;t have any say. It&#39;s also bad because your power is mesured in worth.</p><p>Those are some resons why democracy is better than oligarcy. Would you want to be equal with other people or have power than people how have more money? I would choose oligarcy because all people are equal. That is why I would choose democracy.</p>'
, modifieddate=now()
, modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestsectionsid =31623718;

--6414369438--done
update studentsresponses
set response='<p>    The pros of a Democracy are that it is ran by the people for the people. A Treaise On Goverment: Politics, &quot;In this state also no office should be for life.&quot; Citizens that participate in any public managment should be paid from judges, magistrsiters, and member of the assembly. The rich do not have more power over the poor. The governer is choosen by the people. The pros of a Oligarchy are that The smartest minds work together. The people with the most money are at the top, so they can fund more for their community.</p><p>    The cons of a Democracy are it can losses power for not paying members of a communtiy for their attendence. The cons of a Oligarchy are that the people have no say in public events. The governer can run for as long as wanted. Only the rich, educated, men of families are in control. Slaves, poor people, and women are not heard for their needs.</p>'
, modifieddate=now()
, modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestsectionsid  =31625210;

commit

