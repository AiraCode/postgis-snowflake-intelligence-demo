# 🚀 Quick Start Guide

Get the demo running in 5 minutes!

## Step 1: Start Docker

```bash
# Start PostgreSQL + Streamlit
docker-compose up -d

# Wait ~30 seconds for PostgreSQL to initialize
docker logs -f streetlights-postgres
# Press Ctrl+C when you see "database system is ready to accept connections"
```

## Step 2: Load Sample Data

```bash
# Load pre-generated sample data (10 lights, 5 neighborhoods)
docker exec -it streetlights-postgres psql -U postgres -d streetlights -f /data/load_sample_data.sql
```

## Step 3: Open Dashboard

```bash
# Open in browser
open http://localhost:8501

# Or manually visit: http://localhost:8501
```

## Step 4: Explore

### Try the Dashboard Pages

1. **🏘️ Neighborhood Overview**
   - See the interactive map
   - Click on markers for details
   - Toggle layers on/off

2. **🎮 Live Demo Controls**
   - Click "Simulate Random Failure"
   - Go back to Neighborhood Overview
   - See the new red marker appear!

3. **🔴 Faulty Lights Analysis**
   - View table with nearest suppliers
   - Filter by neighborhood

4. **🔮 Predictive Maintenance**
   - See predicted failures timeline
   - Adjust time window slider

5. **🏭 Supplier Coverage**
   - View service areas on map
   - Check coverage statistics

---

## What's Next?

### Generate Full Dataset

For the complete demo with 5,000 lights:

```bash
# Install dependencies
uv pip install -e .
# or: pip install -e .

# Generate data
cd data && ./generate_all_data.sh

# Load into database
docker exec -it streetlights-postgres psql -U postgres -d streetlights -f /data/load_data.sql
```

### Run PostGIS Queries

```bash
# Interactive query runner
cd queries/postgis && ./run_queries.sh

# Or manually
docker exec -it streetlights-postgres psql -U postgres -d streetlights
```

### Connect from Local Machine

For easier database access without Docker exec:

```bash
# Copy and configure .env
cp .env.example .env

# Load environment variables
source .env

# Connect with psql (uses PG* variables)
psql

# Or run queries directly
psql -c "SELECT COUNT(*) FROM street_lights;"
psql -f queries/postgis/q01_lights_in_neighborhood.sql
```

**Tip**: Use [direnv](https://direnv.net/) for automatic environment loading:

```bash
echo "dotenv" > .envrc
direnv allow
# Now PG* variables load automatically when you cd into the project
```

### Test Everything

```bash
# Run validation tests
./test/test_phase1_5.sh
```

---

## Troubleshooting

### Dashboard shows "Connection Error"

```bash
# Check if PostgreSQL is ready
docker exec streetlights-postgres pg_isready

# If not ready, wait a bit longer
# The init scripts take ~30 seconds on first run
```

### "No data found" in dashboard

```bash
# Make sure you loaded the sample data
docker exec -it streetlights-postgres psql -U postgres -d streetlights -c "SELECT COUNT(*) FROM street_lights;"

# Should show at least 10 if sample data is loaded
```

### Can't access <http://localhost:8501>

```bash
# Check if Streamlit is running
docker logs streetlights-streamlit

# Restart if needed
docker-compose restart streamlit
```

---

## Demo Script (30 seconds)

**For a quick demo:**

1. Show the **Neighborhood Overview** map
2. Go to **Live Demo Controls**
3. Click **"Simulate Random Failure"**
4. Return to **Faulty Lights Analysis**
5. Show the new faulty light with nearest supplier!

**"This demonstrates real-time PostGIS queries with spatial enrichment!"**

---

## Key URLs

- Dashboard: <http://localhost:8501>
- PostgreSQL: localhost:5432
- Database: `streetlights`
- Username: `postgres`
- Password: `password`

---

## Need Help?

- Check `README.md` for full documentation
- See `work/demo_script.md` for 30-minute presentation
- Read `PHASE5.5_COMPLETE.md` for dashboard details

**Ready to present!** 🎉
