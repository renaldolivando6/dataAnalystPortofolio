-- case 2
WITH t1 as(
SELECT
FORMAT(created_at,'yyyy-MM') month_date,
CAST(SUM(value) as DECIMAL(10,2)) this_month_revenue,
CAST(LAG(SUM(value),1,0) over (order by FORMAT(created_at,'yyyy-MM'))as DECIMAL(10,2)) last_month_revenue
from 
sf_transactions
group by FORMAT(created_at,'yyyy-MM')
)

select 
month_date,
CAST(100*(this_month_revenue-last_month_revenue)/NULLIF(last_month_revenue,0) AS DECIMAL (10,2))
from t1
