----------------------
-- activate records --
----------------------

DO
$BODY$
DECLARE
	num_updated INTEGER;

	data TEXT[][] := ARRAY[
		['7128266186', '7031']
	];
BEGIN
	FOR i IN array_lower(data, 1) .. array_upper(data, 1) LOOP
		-- reactivate records
		WITH updated_rows AS (
			update enrollment
			set activeflag = true,
			exitwithdrawaldate = null,
			exitwithdrawaltype = null,
			modifieddate = now(),
			modifieduser = (select id from aartuser where username = 'cetesysadmin'),
			notes = 'Activated enrollment as per US17812'
			where activeflag = false
			and id = (
				select e.id
				from enrollment e
				inner join student s on e.studentid = s.id
				inner join organization o on e.attendanceschoolid = o.id
				where o.id in (select id from organization_children((select id from organization where displayidentifier = 'KS')))
				and s.stateid = (select id from organization where displayidentifier = 'KS')
				and o.displayidentifier = data[i][2]
				and s.statestudentidentifier = data[i][1]
			)
			returning 1
		)
		SELECT count(*) FROM updated_rows INTO num_updated;
		RAISE NOTICE '[''%'', ''%''] - Activated % rows', data[i][1], data[i][2], num_updated;
	END LOOP;
END;
$BODY$;

------------------------
-- deactivate records --
------------------------

DO
$BODY$
DECLARE
	num_updated INTEGER;

	data TEXT[][] := ARRAY[
  ['7128266186', '7423']
];
BEGIN
	FOR i IN array_lower(data, 1) .. array_upper(data, 1) LOOP
		-- deactivate records
		WITH updated_rows AS (
			update enrollment
			set activeflag = false,
			exitwithdrawaldate = now(),
			exitwithdrawaltype = -55,
			modifieddate = now(),
			modifieduser = (select id from aartuser where username = 'cetesysadmin'),
			notes = 'Deactivated enrollment as per US17812'
			where id = (
				select e.id
				from enrollment e
				inner join student s on e.studentid = s.id
				inner join organization o on e.attendanceschoolid = o.id
				where o.id in (select id from organization_children((select id from organization where displayidentifier = 'KS')))
				and s.stateid = (select id from organization where displayidentifier = 'KS')
				and o.displayidentifier = data[i][2]
				and s.statestudentidentifier = data[i][1]
			)
			returning 1
		)
		SELECT count(*) FROM updated_rows INTO num_updated;
		RAISE NOTICE '[''%'', ''%''] - Deactivated % rows', data[i][1], data[i][2], num_updated;
	END LOOP;
END;
$BODY$;
