-- Configure Write-Ahead Logging (WAL) for CDC (Change Data Capture)
-- This prepares the database for Apache NiFi CDC in future phases

-- Set WAL level to logical (required for logical replication/CDC)
ALTER SYSTEM SET wal_level = 'logical';

-- Set maximum number of replication slots
ALTER SYSTEM SET max_replication_slots = 10;

-- Set maximum number of WAL sender processes
ALTER SYSTEM SET max_wal_senders = 10;

-- Note: These settings require PostgreSQL restart to take effect
-- Docker Compose will handle restart automatically on container recreation

-- Log completion
DO $$
BEGIN
    RAISE NOTICE 'WAL configuration updated for CDC support';
    RAISE NOTICE 'Settings will take effect after PostgreSQL restart';
    RAISE NOTICE 'To restart: docker-compose restart postgres';
END $$;


