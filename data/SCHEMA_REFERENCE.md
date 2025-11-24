# Data Dictionary

## Complete Schema Reference for Street Lights Maintenance Demo

> **DISCLAIMER**: All sample data shown below is fictitious and created solely for demonstration purposes. Company names, contact information, and other identifiers do not represent real entities.

---

## Base Tables

### `street_lights`

**Purpose**: Operational data for all street lights in the city

| Column | Type | Constraints | Description | Example |
|--------|------|-------------|-------------|---------|
| `light_id` | TEXT | PRIMARY KEY | Unique identifier for each light | `SL-0001` |
| `location` | GEOMETRY(Point, 4326) | NOT NULL | GPS coordinates (WGS84) | `POINT(77.5946 12.9716)` |
| `status` | TEXT | NOT NULL | Current operational status | `operational`, `faulty`, `maintenance_required` |
| `wattage` | INTEGER | | Power consumption in watts | `150` |
| `installation_date` | DATE | | Date light was installed | `2018-03-15` |
| `last_maintenance` | TIMESTAMP | | Last maintenance timestamp | `2024-01-20 14:30:00` |
| `neighborhood_id` | TEXT | FOREIGN KEY | Reference to neighborhood | `NH-042` |

**Indexes**:

- `idx_lights_location GIST(location)` - Spatial index for fast proximity queries
- `idx_lights_status` (optional) - Filter by status

**Sample Data**:

```sql
INSERT INTO street_lights VALUES
('SL-0001', ST_GeomFromText('POINT(77.5946 12.9716)', 4326), 'operational', 150, '2018-03-15', '2024-01-20 14:30:00', 'NH-042'),
('SL-0002', ST_GeomFromText('POINT(77.5950 12.9720)', 4326), 'faulty', 150, '2019-07-22', '2023-12-15 09:15:00', 'NH-042'),
('SL-0003', ST_GeomFromText('POINT(77.5955 12.9725)', 4326), 'maintenance_required', 200, '2017-11-10', '2024-02-01 16:45:00', 'NH-043');
```

---

### `neighborhoods`

**Purpose**: Geographic boundaries and metadata for city neighborhoods

| Column | Type | Constraints | Description | Example |
|--------|------|-------------|-------------|---------|
| `neighborhood_id` | TEXT | PRIMARY KEY | Unique identifier | `NH-001` |
| `name` | TEXT | NOT NULL | Neighborhood name | `Koramangala` |
| `boundary` | GEOMETRY(Polygon, 4326) | NOT NULL | Geographic boundary | `POLYGON((77.60 12.93, ...))` |
| `population` | INTEGER | | Estimated population | `125000` |

**Indexes**:

- `idx_neighborhoods_boundary GIST(boundary)` - Spatial index for point-in-polygon queries

**Sample Data**:

```sql
INSERT INTO neighborhoods VALUES
('NH-001', 'Koramangala', ST_GeomFromText('POLYGON((77.60 12.93, 77.62 12.93, 77.62 12.91, 77.60 12.91, 77.60 12.93))', 4326), 125000),
('NH-002', 'Indiranagar', ST_GeomFromText('POLYGON((77.63 12.97, 77.65 12.97, 77.65 12.95, 77.63 12.95, 77.63 12.97))', 4326), 98000);
```

---

### `maintenance_requests`

**Purpose**: Historical and active maintenance requests

| Column | Type | Constraints | Description | Example |
|--------|------|-------------|-------------|---------|
| `request_id` | TEXT | PRIMARY KEY | Unique identifier | `REQ-0001` |
| `light_id` | TEXT | FOREIGN KEY (street_lights) | Light requiring maintenance | `SL-1234` |
| `reported_at` | TIMESTAMP | NOT NULL | When issue was reported | `2024-01-15 08:30:00` |
| `resolved_at` | TIMESTAMP | | When issue was resolved | `2024-01-18 14:20:00` |
| `issue_type` | TEXT | | Type of issue | `bulb_failure`, `wiring`, `pole_damage` |

**Sample Data**:

```sql
INSERT INTO maintenance_requests VALUES
('REQ-0001', 'SL-1234', '2024-01-15 08:30:00', '2024-01-18 14:20:00', 'bulb_failure'),
('REQ-0002', 'SL-2345', '2024-01-20 16:45:00', NULL, 'wiring');
```

---

### `suppliers` (NEW)

**Purpose**: Light equipment suppliers and their service coverage

| Column | Type | Constraints | Description | Example |
|--------|------|-------------|-------------|---------|
| `supplier_id` | TEXT | PRIMARY KEY | Unique identifier | `SUP-001` |
| `name` | TEXT | NOT NULL | Supplier company name (fictitious) | `Acme Lights & Co.` |
| `location` | GEOMETRY(Point, 4326) | NOT NULL | Supplier office location | `POINT(77.5800 12.9600)` |
| `contact_phone` | TEXT | | Contact phone number | `+91-80-12345678` |
| `service_radius_km` | INTEGER | | Service coverage radius | `10` |
| `avg_response_hours` | INTEGER | | Average response time | `4` |
| `specialization` | TEXT | | Equipment specialization | `LED`, `Sodium Vapor`, `All` |

**Indexes**:

- `idx_suppliers_location GIST(location)` - Spatial index for nearest supplier queries

**Sample Data** (fictitious):

```sql
INSERT INTO suppliers VALUES
('SUP-001', 'Acme Lights & Co.', ST_GeomFromText('POINT(77.5800 12.9600)', 4326), '+91-80-12345678', 10, 4, 'All'),
('SUP-002', 'BrightBeam Systems Demo', ST_GeomFromText('POINT(77.6000 12.9400)', 4326), '+91-80-23456789', 8, 6, 'LED'),
('SUP-003', 'CloudGlow Innovations', ST_GeomFromText('POINT(77.5500 12.9800)', 4326), '+91-80-34567890', 12, 3, 'Sodium Vapor');
```

---

## Enrichment Tables

### `weather_enrichment`

**Purpose**: Seasonal weather patterns affecting light failure rates

| Column | Type | Constraints | Description | Example |
|--------|------|-------------|-------------|---------|
| `light_id` | TEXT | FOREIGN KEY (street_lights) | Reference to light | `SL-0001` |
| `season` | TEXT | NOT NULL | Season identifier | `monsoon`, `summer`, `winter` |
| `avg_temperature_c` | NUMERIC(5,2) | | Average temperature | `32.50` |
| `rainfall_mm` | NUMERIC(6,2) | | Average rainfall | `185.75` |
| `failure_risk_score` | NUMERIC(3,2) | CHECK (0.0 - 1.0) | Predicted failure risk | `0.75` |
| `predicted_failure_date` | DATE | | ML-predicted failure date | `2024-06-15` |

**Season Definitions**:

- **Monsoon** (June-September): High rainfall, high failure risk (0.7-0.9)
- **Summer** (March-May): High temperature, medium risk (0.5-0.7)
- **Winter** (December-February): Moderate conditions, low risk (0.2-0.4)

**Sample Data**:

```sql
INSERT INTO weather_enrichment VALUES
('SL-0001', 'monsoon', 28.50, 185.75, 0.78, '2024-07-20'),
('SL-0001', 'summer', 35.20, 25.30, 0.62, NULL),
('SL-0001', 'winter', 22.80, 10.50, 0.35, NULL);
```

---

### `demographics_enrichment`

**Purpose**: Neighborhood characteristics affecting infrastructure needs

| Column | Type | Constraints | Description | Example |
|--------|------|-------------|-------------|---------|
| `neighborhood_id` | TEXT | FOREIGN KEY (neighborhoods) | Reference to neighborhood | `NH-001` |
| `population_density` | INTEGER | | People per sq km | `12500` |
| `urban_classification` | TEXT | | Urban development level | `urban`, `suburban`, `rural` |

**Sample Data**:

```sql
INSERT INTO demographics_enrichment VALUES
('NH-001', 12500, 'urban'),
('NH-002', 9800, 'urban'),
('NH-003', 5200, 'suburban');
```

---

### `power_grid_enrichment`

**Purpose**: Electrical grid data for each light

| Column | Type | Constraints | Description | Example |
|--------|------|-------------|-------------|---------|
| `light_id` | TEXT | FOREIGN KEY (street_lights) | Reference to light | `SL-0001` |
| `grid_zone` | TEXT | | Power grid zone identifier | `ZONE-A`, `ZONE-B` |
| `avg_load_percent` | NUMERIC(5,2) | | Average grid load | `78.50` |
| `outage_history_count` | INTEGER | | Historical outage count | `3` |

**Sample Data**:

```sql
INSERT INTO power_grid_enrichment VALUES
('SL-0001', 'ZONE-A', 78.50, 3),
('SL-0002', 'ZONE-A', 82.30, 5),
('SL-0003', 'ZONE-B', 65.40, 1);
```

---

## Enriched Views

### `street_lights_enriched`

**Purpose**: Combined view of lights with all enrichment data for CDC and analytics

```sql
CREATE VIEW street_lights_enriched AS
SELECT 
  l.light_id,
  l.location,
  ST_X(l.location) as longitude,
  ST_Y(l.location) as latitude,
  l.status,
  l.wattage,
  l.installation_date,
  l.last_maintenance,
  l.neighborhood_id,
  n.name as neighborhood_name,
  n.population,
  -- Weather enrichment
  w.season,
  w.avg_temperature_c,
  w.rainfall_mm,
  w.failure_risk_score,
  w.predicted_failure_date,
  -- Demographics enrichment
  d.population_density,
  d.urban_classification,
  -- Power grid enrichment
  p.grid_zone,
  p.avg_load_percent,
  p.outage_history_count,
  -- Calculated fields
  EXTRACT(YEAR FROM AGE(CURRENT_DATE, l.installation_date)) * 12 + 
    EXTRACT(MONTH FROM AGE(CURRENT_DATE, l.installation_date)) as age_months,
  CASE 
    WHEN w.predicted_failure_date <= CURRENT_DATE + INTERVAL '7 days' THEN 'CRITICAL'
    WHEN w.predicted_failure_date <= CURRENT_DATE + INTERVAL '30 days' THEN 'HIGH'
    WHEN w.predicted_failure_date <= CURRENT_DATE + INTERVAL '90 days' THEN 'MEDIUM'
    ELSE 'LOW'
  END as maintenance_urgency
FROM street_lights l
LEFT JOIN neighborhoods n ON l.neighborhood_id = n.neighborhood_id
LEFT JOIN weather_enrichment w ON l.light_id = w.light_id AND w.season = 
  CASE 
    WHEN EXTRACT(MONTH FROM CURRENT_DATE) BETWEEN 6 AND 9 THEN 'monsoon'
    WHEN EXTRACT(MONTH FROM CURRENT_DATE) BETWEEN 3 AND 5 THEN 'summer'
    ELSE 'winter'
  END
LEFT JOIN demographics_enrichment d ON n.neighborhood_id = d.neighborhood_id
LEFT JOIN power_grid_enrichment p ON l.light_id = p.light_id;
```

---

### `maintenance_requests_enriched`

**Purpose**: Maintenance requests with spatial and enrichment context

```sql
CREATE VIEW maintenance_requests_enriched AS
SELECT 
  m.request_id,
  m.light_id,
  m.reported_at,
  m.resolved_at,
  m.issue_type,
  l.location,
  ST_X(l.location) as longitude,
  ST_Y(l.location) as latitude,
  l.wattage,
  l.neighborhood_id,
  n.name as neighborhood_name,
  w.season,
  w.failure_risk_score,
  -- Calculated fields
  CASE 
    WHEN m.resolved_at IS NOT NULL 
    THEN EXTRACT(EPOCH FROM (m.resolved_at - m.reported_at))/3600 
    ELSE NULL 
  END as resolution_hours,
  CASE 
    WHEN m.resolved_at IS NULL THEN 'OPEN'
    ELSE 'CLOSED'
  END as status
FROM maintenance_requests m
JOIN street_lights l ON m.light_id = l.light_id
LEFT JOIN neighborhoods n ON l.neighborhood_id = n.neighborhood_id
LEFT JOIN weather_enrichment w ON l.light_id = w.light_id AND w.season = 
  CASE 
    WHEN EXTRACT(MONTH FROM m.reported_at) BETWEEN 6 AND 9 THEN 'monsoon'
    WHEN EXTRACT(MONTH FROM m.reported_at) BETWEEN 3 AND 5 THEN 'summer'
    ELSE 'winter'
  END;
```

---

## Data Volumes

| Table/View | Record Count | Notes |
|------------|--------------|-------|
| `street_lights` | 5,000 | Across 50 neighborhoods |
| `neighborhoods` | 50 | Bengaluru city coverage |
| `maintenance_requests` | 500 | Historical data |
| `suppliers` | 20-30 | Distributed coverage |
| `weather_enrichment` | 15,000 | 3 seasons × 5,000 lights |
| `demographics_enrichment` | 50 | One per neighborhood |
| `power_grid_enrichment` | 5,000 | One per light |
| `street_lights_enriched` | 5,000 | Virtual view |
| `maintenance_requests_enriched` | 500 | Virtual view |

---

## Coordinate System

**SRID**: 4326 (WGS84 - World Geodetic System 1984)

- Standard for GPS coordinates
- Latitude/Longitude format
- Compatible with web mapping libraries

**Bengaluru Bounds**:

- Latitude: 12.8° N to 13.1° N
- Longitude: 77.5° E to 77.7° E

**Geography vs Geometry**:

- Use `::geography` cast for accurate meter-based distance calculations
- GEOMETRY sufficient for display and basic spatial operations

---

## Query Patterns

### Common Spatial Queries

**Find lights within neighborhood**:

```sql
SELECT * FROM street_lights l
JOIN neighborhoods n ON ST_Within(l.location, n.boundary)
WHERE n.name = 'Koramangala';
```

**Find nearest supplier to a light**:

```sql
SELECT s.*, 
       ST_Distance(s.location::geography, l.location::geography)/1000 as distance_km
FROM suppliers s
CROSS JOIN street_lights l
WHERE l.light_id = 'SL-0001'
ORDER BY s.location <-> l.location
LIMIT 1;
```

**Find lights predicted to fail soon**:

```sql
SELECT * FROM street_lights_enriched
WHERE predicted_failure_date <= CURRENT_DATE + INTERVAL '30 days'
  AND predicted_failure_date IS NOT NULL
ORDER BY predicted_failure_date;
```

---

## Data Generation Notes

- **Realistic Distribution**: Lights generated within neighborhood boundaries
- **Seasonal Patterns**: Failure rates higher in monsoon season
- **Service Coverage**: Suppliers placed to cover most neighborhoods
- **Predicted Failures**: Calculated based on age, season, and risk score
- **Bengaluru Coordinates**: Using actual city bounds for realism

