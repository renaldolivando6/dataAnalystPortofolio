WITH users_union AS
  (SELECT user1,
          user2
   FROM facebook_friends
   UNION 
   SELECT user2 AS user1,
                user1 AS user2
   FROM facebook_friends)

SELECT user1,
       CAST(count(*) AS FLOAT) /
  (SELECT CAST(count(DISTINCT user1) AS FLOAT)
   FROM users_union)*100 AS popularity_percent
FROM users_union
GROUP BY user1
ORDER BY user1