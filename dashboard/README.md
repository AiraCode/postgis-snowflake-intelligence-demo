# Street Lights Maintenance Dashboard

A real-time interactive dashboard built with Streamlit for visualizing and managing street light maintenance data powered by PostGIS spatial queries.

## 📋 Table of Contents

- [Overview](#overview)
- [Dashboard Pages](#dashboard-pages)
- [Configuration](#configuration)
- [File Structure](#file-structure)
- [Running the Dashboard](#running-the-dashboard)
- [Features](#features)
- [Technologies](#technologies)

## 🎯 Overview

This dashboard provides a comprehensive view of street light infrastructure, including:
- Real-time status monitoring of street lights
- Spatial analysis using PostGIS
- Predictive maintenance capabilities
- Supplier coverage analysis
- Interactive maps with Folium
- Live demo controls for presentations

## 📊 Dashboard Pages

### 1. 🏘️ Neighborhood Overview

**Purpose:** High-level view of all street lights, neighborhoods, and suppliers across the city.

**Features:**
- Interactive map with multiple layers (Neighborhoods, Lights, Suppliers)
- Real-time metrics: Total lights, operational count, faulty count, maintenance required
- Filter by neighborhood
- Toggle map layers on/off
- Color-coded light status (green=operational, orange=maintenance, red=faulty)
- Neighborhood statistics table with fault percentage

**Use Cases:**
- Quick status check of entire infrastructure
- Identify problem areas at a glance
- Filter specific neighborhoods for detailed inspection

---

### 2. 🔴 Faulty Lights Analysis

**Purpose:** Detailed analysis of currently faulty lights with their nearest service suppliers.

**Features:**
- List of all faulty lights with nearest supplier information
- Distance calculation from faulty light to nearest supplier
- Filter by neighborhood and maximum distance
- Interactive map showing faulty lights
- Bar chart of faulty lights per neighborhood
- Supplier contact information and response times

**Use Cases:**
- Dispatch maintenance teams efficiently
- Identify supplier coverage gaps
- Prioritize repairs based on distance
- Contact suppliers for specific areas

**Key Data:**
- Light ID and location
- Nearest supplier and specialization
- Distance to supplier (km)
- Average response time (hours)
- Contact phone

---

### 3. 🔮 Predictive Maintenance

**Purpose:** Forecast which lights are likely to fail in the near future based on enrichment data.

**Features:**
- Prediction window slider (7-90 days)
- Urgency-based filtering (CRITICAL, HIGH, MEDIUM, LOW)
- Color-coded urgency levels:
  - CRITICAL (0-7 days): Dark red
  - HIGH (7-30 days): Orange
  - MEDIUM (30-60 days): Yellow
  - LOW (60+ days): Gray
- Timeline chart showing predicted failures over time
- Seasonal pattern analysis
- Risk score visualization

**Use Cases:**
- Plan preventive maintenance schedules
- Budget for upcoming repairs
- Understand seasonal failure patterns
- Prioritize maintenance based on urgency

**Predictions Based On:**
- Light age (months)
- Days since last maintenance
- Historical maintenance patterns
- Weather/seasonal data
- Power grid load
- Neighborhood demographics

---

### 4. 🏭 Supplier Coverage

**Purpose:** Analyze supplier locations, service areas, and coverage effectiveness.

**Features:**
- Interactive map with supplier locations and service radius circles
- Neighborhood-to-supplier connection lines with distance labels
- Toggle connections on/off
- Coverage statistics:
  - Lights within 5km of supplier
  - Lights within 10-15km
  - Lights beyond 10km
- Distance analysis charts:
  - Lights by distance range (color-coded)
  - Neighborhood-to-supplier bar chart
- Detailed coverage table with color gradient
- Supplier details table (specialization, service radius, response time)
- Distribution charts:
  - Supplier specialization pie chart
  - Service radius histogram

**Use Cases:**
- Identify coverage gaps
- Plan new supplier locations
- Evaluate supplier distribution
- Optimize service areas
- Understand neighborhood access to services

**Interactive Elements:**
- Click lines to see connection details
- Hover over bars for detailed info
- Toggle connection lines for clearer view

---

### 5. 🎮 Live Demo Controls

**Purpose:** Interactive controls for demonstrating real-time updates and system capabilities.

**Features:**
- Current system status metrics
- **Simulate Random Failure:** Set a random operational light to faulty
- **Trigger Scheduled Maintenance:** Set multiple lights to maintenance_required status
- **Refresh Dashboard:** Clear cache and reload all data
- **Auto-refresh Toggle:** Enable 30-second automatic refresh
- Demo script hints and presenter notes
- Quick validation checklist

**Use Cases:**
- Live demonstrations and presentations
- Testing data refresh mechanisms
- Simulating real-world scenarios
- Training sessions
- System testing

**⚠️ Warning:** These actions modify the database. Use for demo purposes only!

---

## ⚙️ Configuration

### config.py

Configuration file for dashboard settings and database connection.

#### Database Connection

The dashboard tries to load connection details in this order:
1. **Streamlit Secrets** (`.streamlit/secrets.toml`)
2. **Environment Variables**
3. **Default Values**

```python
# Connection parameters
POSTGIS_CONFIG = {
    "host": "localhost",        # or POSTGRES_HOST env var
    "port": 5432,               # or POSTGRES_PORT env var
    "database": "streetlights", # or POSTGRES_DATABASE env var
    "user": "postgres",         # or POSTGRES_USER env var
    "password": "password"      # or POSTGRES_PASSWORD env var
}
```

#### Map Configuration

```python
MAP_CONFIG = {
    "center": [12.9716, 77.5946],  # Bengaluru center [lat, lon]
    "zoom": 11,                     # Initial zoom level
    "tiles": "OpenStreetMap"        # Map tile provider
}
```

#### Color Schemes

**Light Status Colors:**
```python
STATUS_COLORS = {
    "operational": "#2ecc71",           # Green
    "maintenance_required": "#f39c12",  # Orange
    "faulty": "#e74c3c"                 # Red
}
```

**Urgency Colors:**
```python
URGENCY_COLORS = {
    "CRITICAL": "#c0392b",  # Dark red
    "HIGH": "#e67e22",      # Orange
    "MEDIUM": "#f39c12",    # Yellow
    "LOW": "#95a5a6"        # Gray
}
```

#### Other Settings

```python
AUTO_REFRESH_INTERVAL = 30  # seconds
MAX_RESULTS = 1000          # query result limit
```

---

## 📁 File Structure

```
dashboard/
├── README.md              # This file
├── app.py                 # Main Streamlit application
├── config.py              # Configuration settings
├── db_utils.py            # Database connection and query functions
├── map_utils.py           # Folium map creation utilities
├── run.py                 # Entry point script
└── requirements.txt       # Python dependencies
```

### File Descriptions

#### app.py
Main Streamlit application with all dashboard pages. Contains:
- Page routing and navigation
- UI components and layouts
- Chart generation with Plotly
- Map integration with Folium
- Real-time metrics display

#### db_utils.py
Database operations and queries:
- `get_connection()` - PostgreSQL connection (psycopg2)
- `get_sqlalchemy_engine()` - SQLAlchemy engine for pandas
- `execute_query()` - Execute SQL and return DataFrame
- `get_all_lights()` - Fetch all street lights with enrichment
- `get_neighborhoods()` - Get neighborhoods with boundaries
- `get_suppliers()` - Get supplier locations
- `get_faulty_lights_with_supplier()` - Faulty lights with nearest supplier
- `get_predicted_failures()` - Lights predicted to fail
- `get_neighborhood_stats()` - Aggregated neighborhood statistics
- `get_seasonal_patterns()` - Maintenance patterns by season
- `get_supplier_coverage()` - Supplier coverage analysis
- `get_neighborhood_supplier_distance()` - Distance from neighborhoods to suppliers
- `simulate_light_failure()` - Demo function to create a failure
- `trigger_scheduled_maintenance()` - Demo function for maintenance

**Caching:**
- `@st.cache_resource` for database connections (persistent)
- `@st.cache_data(ttl=X)` for query results (time-limited)

#### map_utils.py
Map creation and layer management:
- `create_base_map()` - Initialize Folium map
- `add_neighborhoods_layer()` - Add neighborhood polygons
- `add_lights_layer()` - Add street light markers (clustered)
- `add_suppliers_layer()` - Add supplier markers with service radius
- `add_predicted_failures_layer()` - Add predicted failure markers
- `add_neighborhood_supplier_lines()` - Draw connection lines with distances
- `create_legend_html()` - Generate custom map legend
- `add_fullscreen_control()` - Add fullscreen button

#### run.py
Entry point for running the dashboard:
```python
def main():
    """Run the Streamlit dashboard"""
    import streamlit.web.cli as stcli
    # Launches Streamlit with app.py
```

---

## 🚀 Running the Dashboard

### Prerequisites

```bash
# Install dependencies
uv sync
# OR
pip install -r requirements.txt
```

### Start the Dashboard

**Using project script:**
```bash
uv run dashboard
```

**Using Streamlit directly:**
```bash
streamlit run dashboard/app.py
```

**Using Python module:**
```bash
python -m dashboard.run
```

### Environment Setup

Create `.env` file in project root:
```bash
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DATABASE=streetlights
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password
```

OR create `.streamlit/secrets.toml`:
```toml
[postgres]
host = "localhost"
port = 5432
database = "streetlights"
user = "postgres"
password = "password"
```

### Browser Access

The dashboard will be available at:
- **Local:** http://localhost:8501
- **Network:** http://YOUR_IP:8501

---

## ✨ Features

### Real-Time Updates
- Live database queries (cached for performance)
- Auto-refresh capability
- Manual refresh controls

### Spatial Analysis
- PostGIS spatial queries (ST_Within, ST_Distance, ST_Centroid)
- Distance calculations in kilometers
- Nearest neighbor analysis
- Coverage area analysis

### Interactive Visualizations
- Folium maps with multiple layers
- Plotly charts (bar, pie, line, histogram)
- Marker clustering for performance
- Hover tooltips and popups
- Color gradients based on metrics

### Data Enrichment
- Weather/seasonal patterns
- Power grid load data
- Demographic information
- Historical maintenance records

### Export & Analysis
- DataFrame displays for easy copying
- Styled tables with color gradients
- Formatted percentages and distances

---

## 🛠️ Technologies

### Core Framework
- **Streamlit 1.28+** - Dashboard framework
- **Python 3.12+** - Programming language

### Database
- **PostgreSQL with PostGIS** - Spatial database
- **psycopg2** - Database driver
- **SQLAlchemy 2.0+** - Database toolkit (for pandas integration)

### Data Processing
- **Pandas 2.0+** - Data manipulation
- **NumPy** - Numerical computations

### Visualization
- **Folium** - Interactive maps
- **Plotly 5.17+** - Interactive charts
- **Matplotlib 3.7+** - Color gradients (pandas styling)
- **streamlit-folium** - Folium-Streamlit integration

### Geospatial
- **Shapely 2.0+** - Geometric operations
- **PostGIS** - Spatial SQL functions

---

## 📈 Performance Considerations

### Caching Strategy
- **Resource Caching:** Database connections (persistent across runs)
- **Data Caching:** Query results with TTL (Time To Live)
  - 30s: High-frequency updates (faulty lights)
  - 60s: Medium frequency (lights, suppliers)
  - 120s: Low frequency (statistics, patterns)

### Query Optimization
- Indexed spatial columns
- Parameterized queries
- LIMIT clauses where appropriate
- Aggregated queries for statistics

### Map Performance
- Marker clustering for large datasets
- Sample data (500 lights) on coverage page
- Layer toggling to reduce load
- Fixed random seed to prevent flicker

---

## 🔧 Customization

### Adding New Pages

Add a new page by:
1. Add page option to sidebar radio in `app.py`
2. Add elif block with page logic
3. Create necessary query functions in `db_utils.py`
4. Add map layers in `map_utils.py` if needed

### Changing Map Center

Update `MAP_CONFIG` in `config.py`:
```python
MAP_CONFIG = {
    "center": [YOUR_LAT, YOUR_LON],
    "zoom": YOUR_ZOOM_LEVEL
}
```

### Adding New Metrics

1. Create query function in `db_utils.py`
2. Call function in `app.py` page
3. Display using `st.metric()`, `st.dataframe()`, or charts

---

## 🐛 Troubleshooting

### No data showing
- Verify PostgreSQL container is running
- Check database connection settings
- Ensure `load_data.sql` was executed
- Check `.envrc` or `.streamlit/secrets.toml`

### Maps not loading
- Check Folium installation
- Verify coordinate format (lat, lon)
- Check GeoJSON validity

### Slow performance
- Reduce query TTL in `db_utils.py`
- Add database indexes
- Reduce sample size on maps
- Check network latency to database

### Connection errors
- Verify database credentials
- Check PostgreSQL is accepting connections
- Test connection with `psql` command
- Check firewall settings

---

## 📝 License

Copyright 2025 Kamesh Sampath

Licensed under the Apache License, Version 2.0
See LICENSE file for details.

---

## 🤝 Contributing

When contributing to the dashboard:
1. Follow existing code style
2. Add docstrings to new functions
3. Update this README if adding pages
4. Test with sample data
5. Check for linter errors

---

## 📞 Support

For issues or questions:
- Check the main project README
- Review SQL schema in `init/` folder
- Check data generation scripts in `data/` folder
- Review test scripts in `test/` folder

