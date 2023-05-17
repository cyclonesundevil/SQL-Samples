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
