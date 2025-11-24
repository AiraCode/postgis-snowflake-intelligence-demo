-- Load sample data for quick testing
-- Use this for immediate testing without running Python generators
-- For full dataset (5,000 lights), run generate_all_data.sh instead

\timing on

\echo ''
\echo '============================================'
\echo 'Loading SAMPLE data (10 lights, 5 neighborhoods)'
\echo 'For full dataset, use generate_all_data.sh'
\echo '============================================'

-- Load sample neighborhoods
\echo ''
\echo '1. Loading sample neighborhoods...'
\copy neighborhoods(neighborhood_id, name, boundary, population) FROM '/data/sample_neighborhoods.csv' WITH (FORMAT csv, HEADER true);
SELECT COUNT(*) AS neighborhoods_loaded FROM neighborhoods;

-- Load sample street lights
\echo ''
\echo '2. Loading sample street lights...'
\copy street_lights(light_id, location, status, wattage, installation_date, last_maintenance, neighborhood_id) FROM '/data/sample_street_lights.csv' WITH (FORMAT csv, HEADER true);
SELECT COUNT(*) AS lights_loaded FROM street_lights;

-- Load sample maintenance requests
\echo ''
\echo '3. Loading sample maintenance requests...'
\copy maintenance_requests(request_id, light_id, reported_at, resolved_at, issue_type) FROM '/data/sample_maintenance_requests.csv' WITH (FORMAT csv, HEADER true, NULL '');
SELECT COUNT(*) AS requests_loaded FROM maintenance_requests;

-- Load sample suppliers
\echo ''
\echo '4. Loading sample suppliers...'
\copy suppliers(supplier_id, name, location, contact_phone, service_radius_km, avg_response_hours, specialization) FROM '/data/sample_suppliers.csv' WITH (FORMAT csv, HEADER true);
SELECT COUNT(*) AS suppliers_loaded FROM suppliers;

-- Load sample weather enrichment
\echo ''
\echo '5. Loading sample weather enrichment...'
\copy weather_enrichment(light_id, season, avg_temperature_c, rainfall_mm, failure_risk_score, predicted_failure_date) FROM '/data/sample_weather_enrichment.csv' WITH (FORMAT csv, HEADER true, NULL '');
SELECT COUNT(*) AS weather_records_loaded FROM weather_enrichment;

-- Load sample demographics enrichment
\echo ''
\echo '6. Loading sample demographics enrichment...'
\copy demographics_enrichment(neighborhood_id, population_density, urban_classification) FROM '/data/sample_demographics_enrichment.csv' WITH (FORMAT csv, HEADER true);
SELECT COUNT(*) AS demographics_records_loaded FROM demographics_enrichment;

-- Load sample power grid enrichment
\echo ''
\echo '7. Loading sample power grid enrichment...'
\copy power_grid_enrichment(light_id, grid_zone, avg_load_percent, outage_history_count) FROM '/data/sample_power_grid_enrichment.csv' WITH (FORMAT csv, HEADER true);
SELECT COUNT(*) AS power_grid_records_loaded FROM power_grid_enrichment;

-- Quick validation
\echo ''
\echo '============================================'
\echo 'Sample Data Loaded Successfully!'
\echo '============================================'

\echo ''
\echo 'Verify enriched view:'
SELECT light_id, status, neighborhood_name, season, failure_risk_score
FROM street_lights_enriched
LIMIT 5;

\echo ''
\echo '============================================'
\echo 'Next Steps:'
\echo '  1. Access Streamlit: http://localhost:8501'
\echo '  2. Test spatial queries: cd queries/postgis'
\echo '  3. For full dataset: cd data && ./generate_all_data.sh'
\echo '============================================'


