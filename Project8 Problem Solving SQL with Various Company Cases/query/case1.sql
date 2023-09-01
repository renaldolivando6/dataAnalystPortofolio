-- Find and select the most popular client_id 
-- based on a count of the number of users who have at least 50% of their events from the following list:  
-- video call received,video call sent, call received,voice call sent

with user_criteria_percentage as (
select 
	user_id,
	100 * sum (CASE WHEN event_type = 'video call received'
				or event_type ='video call sent' 
				or event_type ='voice call received' 
				or event_type ='voice call sent' 
		THEN 1
		ELSE 0
	END	)/count(*) as criteria_percentage
from fact_events
group by user_id)

select client_id,
		count(client_id)
from fact_events
where user_id in (select user_id from user_criteria_percentage
					where criteria_percentage >= 50)
group by client_id