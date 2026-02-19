# E-Bike-Rental-Dataset-Analysis-with-SQL

# Executive Insights Report - UrbanRoll
<br>
<br>
1. Operational "Pulse": The Double-Hump Trend
<br>
Our analysis of 15,000+ rides confirms that **UrbanRoll is primarily a commuting tool.
<br>
- Peak Demand: Usage spikes at 7.00AM and 3.00PM
<br>
- Recommendation: Ensure "rebalancing" crews(the trucks that move bikes) are active between 10:00 AM and 2:00 PM to prepare for the evening rush.
<br>
<br>
2. The Subscriber vs Casual Split
<br>
The data revealed two distinct "User Personas":
<br>
- The Commuter(Subscriber): SHort, predictable trips(avg=15 minutes). They are the backbone of our daily volume. 
<br>
- The Explorer(Casual): Longer, erratic trips(avg=35 minutes). They represent lower volume but higher "bike time" usage. 
<br>
- Recommendation: Launch a "Weekend Explorer" pass targeted at Casual users to increase their frequency during off-peak hours.
<br>
<br>
3. The Rebalancing Crisis(Advanced Insight)
<br>
Using our Net Flow CTE, we identified that certain stations are "Sinks"(they end up with too many bikes) while others are "Sources"(they run out of bikes).
<br>
- Recommendation: Implement "Dynamic Incentives" - offer users a small discount if they end their ride at a "Source" station.
<br>
<br>
4. Growth & Retention
<br>
Our Month-over-Month(MoM) analysis shows a steady growth rate, but we identified a small group of "Power Users"(Top 1%) who account for a disproportionate amount of our Revenue.
