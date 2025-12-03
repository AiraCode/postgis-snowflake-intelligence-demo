# Snowflake Intelligence Questions

Sample questions for use with Snowflake Intelligence after wiring **both** Cortex Search and Cortex Analyst.

This demo showcases the complementary power of:
- **🔍 Cortex Search** → Semantic similarity queries ("Find X like Y")
- **📊 Cortex Analyst** → Structured SQL analytics ("How many?", "Average of?")

Copy and paste these natural language questions directly into the Snowflake Intelligence chat interface.

---

## Quick Reference: Which Capability Handles What?

| Question Type | Best Capability | Example |
|--------------|-----------------|---------|
| Find similar items | 🔍 Search | "Find issues like bulb burnout" |
| Count/aggregate | 📊 Analyst | "How many lights are faulty?" |
| Semantic matching | 🔍 Search | "Show me storm damage" |
| Averages/sums | 📊 Analyst | "Average resolution time?" |
| Text-based discovery | 🔍 Search | "Flickering lights near MG Road" |
| Comparisons | 📊 Analyst | "Which neighborhood has most issues?" |

---

## Category 1: Finding Issues 🔍

*Best handled by Cortex Search*

- "Show me all street lights that are not working"
- "Which lights have bulb failures?"
- "Find maintenance requests for flickering lights"
- "What lights have electrical or wiring problems?"
- "Show me broken lights in Koramangala"

---

## Category 2: Troubleshooting & Diagnostics 🔍📊

*Mixed: Search for finding similar, Analyst for counts*

- "What are the most common issues reported?" 📊
- "Show me lights with recurring problems" 🔍
- "Find similar issues to this flickering LED problem" 🔍
- "Which lights have had multiple maintenance requests?" 📊
- "What issues happen during monsoon season?" 📊

---

## Category 3: Location-Based Queries 🔍📊

*Search for finding, Analyst for aggregations*

- "Show me faulty lights near MG Road" 🔍
- "Which neighborhoods have the most maintenance issues?" 📊
- "Find all open requests in the downtown area" 🔍
- "What lights need repair in high-population areas?" 🔍
- "Show me maintenance issues near the city center" 🔍

---

## Category 4: Urgency & Priority

- "What are the most urgent repairs needed?"
- "Show me critical maintenance requests"
- "Which lights have been waiting longest for repair?"
- "Find emergency lighting issues"
- "What open requests are overdue?"

---

## Category 5: Equipment & Technical

- "Show me all LED bulb failures"
- "Find lights with pole damage"
- "Which lights have sensor problems?"
- "Show me electrical connection issues"
- "Find lights with timer or controller problems"

---

## Category 6: Weather & Environmental

- "Show me storm damage to street lights"
- "Find water damage or flooding issues"
- "Which lights were damaged by weather?"
- "Show me corrosion or rust problems"
- "Find lightning strike damage"

---

## Category 7: Supplier & Dispatch

- "Which supplier should handle this repair?"
- "Find the nearest technician for this issue"
- "Show me issues that need specialized equipment"
- "Which repairs require an electrician?"
- "What parts are needed for pending repairs?"

---

## Category 8: Analytics & Reporting 📊

*Best handled by Cortex Analyst*

- "What's the average time to fix a bulb failure?"
- "How many lights are currently not working?"
- "Show me maintenance trends over time"
- "Which types of issues take longest to resolve?"
- "What percentage of lights need maintenance?"

---

## Top 10 Demo Questions

Best questions for live demo:

1. "Show me all street lights that stopped working"
2. "Find flickering or blinking light issues"
3. "Which neighborhoods have the most problems?"
4. "What urgent repairs are still open?"
5. "Show me electrical wiring issues"
6. "Find similar issues to bulb burnout"
7. "Which lights need immediate attention?"
8. "Show me storm or weather damage"
9. "What are the most common failure types?"
10. "Find lights with repeated maintenance history"

---

## Tips for Follow-up Questions

After getting initial results, try these follow-up questions:

- "Show me more details about the first one"
- "Which supplier is closest to that location?"
- "How long did similar issues take to fix?"
- "What's the resolution status?"
- "Show me the history for this light"

---

## Combined Queries (Advanced)

These questions combine multiple data sources:

- "Show me high-risk lights with their nearest supplier"
- "Find urgent issues in neighborhoods with high population"
- "Which faulty lights have the longest wait time?"
- "Show me weather damage in areas with frequent outages"
- "Find repeated failures and their common causes"

---

## Cortex Analyst Specific Questions 📊

These analytical questions work best with the semantic model:

### Infrastructure Metrics
- "How many street lights do we have by status?"
- "What is the total power consumption by neighborhood?"
- "Show me lights per neighborhood ranked by count"
- "What's the average wattage across all lights?"

### Resolution Analytics
- "What is the average resolution time for each issue type?"
- "Which issue types take longest to resolve?"
- "How many requests are resolved vs still open?"
- "What's the median resolution time this month?"

### Weather & Risk
- "What is the average failure risk by season?"
- "How many lights have risk scores above 0.7?"
- "Which season has the highest average rainfall?"
- "Show me predicted failures for next 30 days"

### Power Grid Analytics
- "Which power grid zones have the most outages?"
- "What's the average grid load by zone?"
- "Correlate outage count with failure risk"

### Supplier Performance
- "What are the average response times by supplier?"
- "How many suppliers by specialization?"
- "Which suppliers cover the largest radius?"

### Demographics
- "How are lights distributed across urban vs rural areas?"
- "What's the population per street light by neighborhood?"
- "Show population density vs maintenance request count"

### CDC Monitoring
- "Show me records modified today via CDC"
- "Which tables have the most recent changes?"
- "How many records synced in the last hour?"

---

## Demo Flow: Search + Analyst Together

For the best demo experience, show how both capabilities complement each other:

### Scenario: Monsoon Preparation

1. **📊 Analyst**: "What is the average failure risk by season?"
   → See monsoon has highest risk (0.7-0.9)

2. **🔍 Search**: "Find lights with water damage or flooding issues"
   → Get specific maintenance records with rich descriptions

3. **📊 Analyst**: "Which neighborhoods have the most maintenance issues?"
   → Identify priority areas

4. **🔍 Search**: "Show me similar issues to electrical wiring problems"
   → Find related records for pattern analysis

5. **📊 Analyst**: "What suppliers specialize in LED and have fastest response?"
   → Identify best contractors for repairs

### Scenario: Executive Dashboard

1. **📊 Analyst**: "How many lights are operational vs faulty vs maintenance required?"
   → Get status breakdown

2. **📊 Analyst**: "What's the total power consumption by neighborhood?"
   → Energy cost analysis

3. **🔍 Search**: "Show me urgent repairs needed"
   → Specific actionable items

4. **📊 Analyst**: "Average resolution time trend by month"
   → Performance tracking
