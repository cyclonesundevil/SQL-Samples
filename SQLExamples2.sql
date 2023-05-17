SELECT aticket_production.apps.name, 
		aticket_production.apps.updated_at,
        aticket_production.apps.obsoleted_on, 
        aticket_production.users.login,
        aticket_production.users.last_login
FROM aticket_production.apps, aticket_production.users
where 
	aticket_production.users.ID = aticket_production.apps.ID 
and
	aticket_production.apps.obsoleted_on is NULL;
	
SELECT DISTINCT u.lower_user_name, u.user_name, u.active, lrg.license_role_name, a.attribute_value

FROM   ((cwd_user u
       JOIN cwd_membership m
         ON u.id = m.child_id
            AND u.directory_id = m.directory_id
       JOIN licenserolesgroup lrg
         ON Lower(m.parent_name) = Lower(lrg.group_id)
       JOIN cwd_directory d
         ON m.directory_id = d.id))
WHERE  d.active = '1'
       AND u.active = '1'
	AND license_role_name = 'jira-software';
	
    
select cwd_group.group_name, cwd_user.user_name, cwd_user.display_name, cwd_user.email_address
from cwd_membership left join cwd_user on cwd_user.id = cwd_membership.child_id 
left join cwd_group on cwd_membership.parent_id = cwd_group.id 
order by user_name asc;


select cwd_group.group_name, cwd_user.user_name, cwd_user.display_name, cwd_user.email_address, 
(select attribute_value from cwd_user_attributes 
where cwd_user_attributes.user_id = cwd_user.id and 
cwd_user_attributes.attribute_name = 'login.lastLoginMillis') as lastAuthenticated  
from cwd_membership left join cwd_user on cwd_user.id = cwd_membership.child_id 
left join cwd_group on cwd_membership.parent_id = cwd_group.id 
order by user_name asc;

select * from cwd_user_attributes;

    u.id,
    u.user_name,
    u.first_name,
    u.last_name,
    u.external_id,
    u.active,
    cm.parent_name,
    cm.id   AS id1,
    cm.child_id,
    lrg.license_role_name,
    TO_DATE('19700101','yyyymmdd') +((attribute_value/1000)/24/60/60) as last_login_date
FROM
    cwd_user u,
    cwd_user_attribute a,
    cwd_membership cm,
    LICENSEROLESGROUP lrg
WHERE
    u.id = a.user_id
    AND u.id = cm.id
    AND lrg.GROUP_ID = cm.parent_name
    and u.active ='0'
    and lrg.LICENSE_ROLE_NAME = 'jira-software'
    and cm.parent_name = 'jira-users'
    AND attribute_name = 'login.lastLoginMillis'
ORDER BY
   last_login_date asc;


select *from cwd_membership;
select * from licenserolesgroup;
select  * from cwd_user;-- cu where cu.user_name = 'jahamme';
select * from cwd_user_attributes;-- where attribute_value = '';


select  cwd_user.id,cwd_user.directory_id,cwd_user.user_name, cwd_membership.parent_id, cwd_membership.membership_type
from 
    cwd_user
FULL OUTER JOIN cwd_membership ON cwd_user.id=cwd_membership.parent_id;

select 
        cu.user_name, 
        cu.id, 
        cu.updated_date, 
        cu.active,
        cu.external_id,
        cm.parent_name,
        cm.child_id,
        cm.parent_id
from cwd_user cu,
     cwd_membership cm
where 
    cu.active = 1
    AND cu.id = cm.id
    and cm.parent_name = 'confluence-users'
ORDER BY
        cu.updated_date ASC;
        
        

select 
    cu.id,
    cu.user_name, 
    lrg.license_role_name,
    cua.id,
    cua.attribute_value
    TO_DATE('19700101','yyyymmdd') +((attribute_value/1000)/24/60/60) as last_login_date
from 
    cwd_user cu,
    licenserolesgroup lrg,
    cwd_user_attributes cua
    
where 
    --cu.active=1
    --AND 
    cu.id = cua.id; -- AND
    cu.user_id = 'jahamme'; --and 
    --lrg.LICENSE_ROLE_NAME = 'jira-software' AND
    --cua.attribute_name = 'login.lastLoginMillis';-- AND
    --cu.id = cua.id;
ORDER BY
    last_login_date asc;
;
    

select distinct parent_name from cwd_membership;


delete from cwd_membership
where parent_name = 'jira-users'
and child_id in (
13742
);


select * from cwd_membership
where parent_name = 'confluence-users'
and child_id in (
40159,
39968,
20949,
12222,
40092,
32329,
21555,
15549,
39712,
13310
);

select * from cwd_user_attributes;
select * from cwd_user;


SELECT d.directory_name,
    u.user_name,u.email_address,
        TO_DATE('19700101','yyyymmdd') + ((attribute_value/1000)/24/60/60) as last_login_date
FROM cwd_user u
JOIN (
    SELECT DISTINCT child_name
    FROM cwd_membership m
    JOIN licenserolesgroup gp ON m.parent_name = gp.GROUP_ID
    ) m ON m.child_name = u.user_name
JOIN (
    SELECT *
    FROM cwd_user_attributes ca
    WHERE attribute_name = 'login.lastLoginMillis'
    ) a ON a.user_id = u.ID
JOIN cwd_directory d ON u.directory_id = d.ID
order by last_login_date desc;

select user_name, id, directory_id, active
from cwd_user where user_name not in 
(SELECT 
    cwd_user.user_name
FROM cwd_user, cwd_user_attributes, cwd_membership
WHERE cwd_user_attributes.user_id = cwd_user.id
--AND cwd_membership.parent_name='confluence-users'
AND cwd_user_attributes.attribute_name = 'lastAuthenticated');
AND cwd_user_attributes.attribute_name = 'login.count');

select user_name, id, directory_id, active
from cwd_user where user_name not in 
(SELECT cwd_user.user_name
FROM cwd_user, cwd_user_attributes
WHERE cwd_user_attributes.user_id = cwd_user.id
AND cwd_user_attributes.attribute_name = 'login.count');

AND cwd_membership.parent_name='confluence-users


SELECT DISTINCT
    cwd_user.user_name,
    cwd_membership.parent_name,
    cwd_user.id,
    cwd_user.active,
    cwd_user_attributes.attribute_value,
    cwd_membership.child_id,
    TO_DATE('19700101','yyyymmdd') +((attribute_value/1000)/24/60/60) as last_login_date
FROM cwd_user, cwd_user_attributes, cwd_membership 
WHERE 
--cwd_user_attributes.user_id = cwd_user.id
--AND 
cwd_membership.parent_name='confluence-users'
AND 
cwd_user.id=cwd_membership.id
--AND cwd_user.active = '0'
AND attribute_name = 'login.lastLoginMillis'
AND cwd_user_attributes.attribute_name = 'lastAuthenticated';
AND cwd_user_attributes.attribute_name = 'login.count';
ORDER BY
   last_login_date asc;


SELECT DISTINCT
    u.id,
    u.user_name,
    u.first_name,
    u.last_name,
    u.external_id,
    u.active,
    cm.parent_name,
    cm.id   AS id1,
    cm.child_id,
    lrg.license_role_name,
    TO_DATE('19700101','yyyymmdd') +((attribute_value/1000)/24/60/60) as last_login_date
FROM
    cwd_user u,
    cwd_user_attributes a,
    cwd_membership cm,
    licenserolesgroup lrg
WHERE
    u.id = a.user_id
    AND u.id = cm.id
    AND lrg.GROUP_ID = cm.parent_name
    and u.active ='1'
    and lrg.LICENSE_ROLE_NAME = 'jira-software'
    and cm.parent_name = 'jira-users'
    AND attribute_name = 'login.lastLoginMillis'
ORDER BY
   last_login_date asc;

SELECT
    u.id,
    u.user_name,
    u.first_name,
    u.last_name,
    d.group_name,
    u.external_id,
    TO_DATE('19700101','yyyymmdd') +((attribute_value/1000)/24/60/60) as last_login_date,
    cm.parent_name,
    cm.id   AS id1,
    cm.child_id
FROM
    cwd_user u,
    cwd_user_attributes a,
    cwd_group d,
    cwd_membership cm
WHERE
    u.id = a.user_id
    AND u.id = d.id
    AND u.id = cm.id
    AND u.active = 1
    AND a.attribute_name = 'login.lastLoginMillis'
ORDER BY
    ( a.attribute_value )desc;


select user_name, id, directory_id, active
from cwd_user where user_name not in 
(SELECT cwd_user.user_name
FROM cwd_user, cwd_user_attributes
WHERE cwd_user_attributes.user_id = cwd_user.id
AND cwd_user_attributes.attribute_name = 'login.count');


select * from AO_60DB71_RAPIDVIEW where OWNER_USER_NAME='u612884'
