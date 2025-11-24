-- Create replication slot for Snowflake Openflow CDC (Change Data Capture)
-- This prepares the database for streaming changes to Snowflake via Openflow

-- Note: Replication slots require wal_level = 'logical' (configured in 02_enable_wal.sql)
-- The settings take effect after PostgreSQL restart

-- Check if WAL level is set correctly
DO $$
DECLARE
    current_wal_level TEXT;
BEGIN
    SELECT setting INTO current_wal_level FROM pg_settings WHERE name = 'wal_level';
    
    IF current_wal_level != 'logical' THEN
        RAISE NOTICE 'WAL level is currently: %', current_wal_level;
        RAISE NOTICE 'Replication slot creation skipped - requires wal_level = logical';
        RAISE NOTICE 'PostgreSQL needs to be restarted for WAL settings to take effect';
        RAISE NOTICE 'Run: docker-compose restart postgres';
    ELSE
        -- Create replication slot for Snowflake Openflow CDC
        PERFORM pg_create_logical_replication_slot('snowflake_cdc_slot', 'pgoutput');
        RAISE NOTICE 'Replication slot created successfully: snowflake_cdc_slot';
        RAISE NOTICE 'This slot will be used by Snowflake Openflow for Change Data Capture';
    END IF;
EXCEPTION
    WHEN duplicate_object THEN
        RAISE NOTICE 'Replication slot snowflake_cdc_slot already exists';
    WHEN OTHERS THEN
        RAISE NOTICE 'Could not create replication slot: %', SQLERRM;
        RAISE NOTICE 'This is expected on first container start (before restart)';
        RAISE NOTICE 'Replication slot will be created after restart with logical WAL level';
END $$;

-- Show all replication slots
DO $$
DECLARE
    slot_record RECORD;
    slot_count INTEGER := 0;
BEGIN
    RAISE NOTICE 'Current replication slots:';
    FOR slot_record IN 
        SELECT slot_name, plugin, slot_type, active 
        FROM pg_replication_slots
    LOOP
        slot_count := slot_count + 1;
        RAISE NOTICE '  - % (plugin: %, type: %, active: %)', 
            slot_record.slot_name, 
            slot_record.plugin, 
            slot_record.slot_type, 
            slot_record.active;
    END LOOP;
    
    IF slot_count = 0 THEN
        RAISE NOTICE '  (none - will be created after PostgreSQL restart with logical WAL)';
    END IF;
END $$;

-- Log completion
DO $$
BEGIN
    RAISE NOTICE '';
    RAISE NOTICE '=================================================';
    RAISE NOTICE 'Database initialization complete!';
    RAISE NOTICE '=================================================';
    RAISE NOTICE 'PostGIS version: %', PostGIS_Version();
    RAISE NOTICE '';
    RAISE NOTICE 'Next steps:';
    RAISE NOTICE '1. Generate sample data: cd data && ./generate_all_data.sh';
    RAISE NOTICE '2. Load data: psql -U postgres -d streetlights -f data/load_data.sql';
    RAISE NOTICE '3. Start Streamlit dashboard: http://localhost:8501';
    RAISE NOTICE '';
    RAISE NOTICE 'For CDC with Snowflake Openflow:';
    RAISE NOTICE '1. Restart PostgreSQL: docker-compose restart postgres';
    RAISE NOTICE '2. Configure Snowflake Openflow to use replication slot: snowflake_cdc_slot';
    RAISE NOTICE '=================================================';
END $$;


