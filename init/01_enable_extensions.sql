-- Enable PostGIS extension explicitly (educational: show users how to install)
-- This script runs automatically when the PostgreSQL container starts

-- Enable PostGIS core extension
CREATE EXTENSION IF NOT EXISTS postgis;

-- Enable PostGIS topology (optional but useful for advanced spatial operations)
CREATE EXTENSION IF NOT EXISTS postgis_topology;

-- Verify installation and show version
SELECT PostGIS_Version() as postgis_version;

-- Show available spatial reference systems
SELECT count(*) as available_srids FROM spatial_ref_sys;

-- Log completion
DO $$
BEGIN
    RAISE NOTICE 'PostGIS extensions enabled successfully!';
    RAISE NOTICE 'PostGIS Version: %', PostGIS_Version();
END $$;


