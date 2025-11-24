-- Create spatial indexes and other performance indexes
-- GIST indexes enable fast spatial queries (ST_Within, ST_DWithin, ST_Distance)

-- Spatial index on street_lights location
CREATE INDEX idx_lights_location ON street_lights USING GIST(location);
COMMENT ON INDEX idx_lights_location IS 'Spatial index for fast proximity and containment queries';

-- Spatial index on neighborhoods boundary
CREATE INDEX idx_neighborhoods_boundary ON neighborhoods USING GIST(boundary);
COMMENT ON INDEX idx_neighborhoods_boundary IS 'Spatial index for fast point-in-polygon queries';

-- Spatial index on suppliers location
CREATE INDEX idx_suppliers_location ON suppliers USING GIST(location);
COMMENT ON INDEX idx_suppliers_location IS 'Spatial index for nearest supplier queries';

-- Regular B-tree indexes for foreign keys and common filters
CREATE INDEX idx_lights_status ON street_lights(status);
COMMENT ON INDEX idx_lights_status IS 'Fast filtering by light status (operational, faulty, maintenance_required)';

CREATE INDEX idx_lights_neighborhood ON street_lights(neighborhood_id);
COMMENT ON INDEX idx_lights_neighborhood IS 'Fast JOIN with neighborhoods table';

CREATE INDEX idx_maintenance_light ON maintenance_requests(light_id);
COMMENT ON INDEX idx_maintenance_light IS 'Fast JOIN with street_lights table';

CREATE INDEX idx_maintenance_reported ON maintenance_requests(reported_at);
COMMENT ON INDEX idx_maintenance_reported IS 'Fast filtering by report date';

CREATE INDEX idx_weather_light ON weather_enrichment(light_id);
COMMENT ON INDEX idx_weather_light IS 'Fast JOIN for enrichment';

CREATE INDEX idx_weather_season ON weather_enrichment(season);
COMMENT ON INDEX idx_weather_season IS 'Fast filtering by season';

CREATE INDEX idx_power_grid_light ON power_grid_enrichment(light_id);
COMMENT ON INDEX idx_power_grid_light IS 'Fast JOIN for enrichment';

-- Analyze tables for query optimizer
ANALYZE neighborhoods;
ANALYZE street_lights;
ANALYZE maintenance_requests;
ANALYZE suppliers;
ANALYZE weather_enrichment;
ANALYZE demographics_enrichment;
ANALYZE power_grid_enrichment;

-- Log completion with index statistics
DO $$
DECLARE
    idx_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO idx_count 
    FROM pg_indexes 
    WHERE schemaname = 'public';
    
    RAISE NOTICE 'Indexes created successfully!';
    RAISE NOTICE 'Spatial indexes (GIST):';
    RAISE NOTICE '  - idx_lights_location';
    RAISE NOTICE '  - idx_neighborhoods_boundary';
    RAISE NOTICE '  - idx_suppliers_location';
    RAISE NOTICE 'Regular indexes (B-tree):';
    RAISE NOTICE '  - idx_lights_status';
    RAISE NOTICE '  - idx_lights_neighborhood';
    RAISE NOTICE '  - idx_maintenance_light';
    RAISE NOTICE '  - idx_maintenance_reported';
    RAISE NOTICE '  - idx_weather_light';
    RAISE NOTICE '  - idx_weather_season';
    RAISE NOTICE '  - idx_power_grid_light';
    RAISE NOTICE 'Total indexes in public schema: %', idx_count;
    RAISE NOTICE 'Tables analyzed for query optimization';
END $$;


