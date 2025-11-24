#!/bin/bash
# Execute PostGIS queries for demo presentation
# This script runs all queries and displays results

set -e  # Exit on error

# PostgreSQL connection settings (use environment variables or defaults)
PGHOST="${POSTGRES_HOST:-localhost}"
PGPORT="${POSTGRES_PORT:-5432}"
PGDATABASE="${POSTGRES_DB:-streetlights}"
PGUSER="${POSTGRES_USER:-postgres}"

export PGHOST PGPORT PGDATABASE PGUSER

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================"
echo "PostGIS Query Library - Demo Runner"
echo "========================================"
echo ""
echo "Database: $PGDATABASE on $PGHOST:$PGPORT"
echo "User: $PGUSER"
echo ""

# Check if psql is available
if ! command -v psql &> /dev/null; then
    echo "Error: psql is required but not found"
    echo "Tip: Use docker exec instead:"
    echo "  docker exec -it streetlights-postgres psql -U postgres -d streetlights -f /path/to/query.sql"
    exit 1
fi

# Test connection
echo "Testing connection..."
if ! psql -c "SELECT PostGIS_Version();" &> /dev/null; then
    echo "Error: Cannot connect to PostgreSQL"
    echo "Check your connection settings or use PGPASSWORD environment variable"
    exit 1
fi
echo -e "${GREEN}✓ Connected successfully${NC}"
echo ""

# Function to run a query and show results
run_query() {
    local query_file=$1
    local query_name=$2
    
    echo "========================================" 
    echo -e "${BLUE}$query_name${NC}"
    echo "File: $query_file"
    echo "========================================" 
    echo ""
    
    # Run query with timing
    psql -f "$query_file"
    
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
}

# Query 1
run_query "q01_lights_in_neighborhood.sql" "Query 1: Lights in Neighborhood (ST_Within)"

# Query 2
run_query "q02_faulty_lights_radius.sql" "Query 2: Faulty Lights Within Radius (ST_DWithin)"

# Query 3
run_query "q03_lights_per_neighborhood.sql" "Query 3: Lights Per Neighborhood (Spatial Aggregation)"

# Query 4
run_query "q04_maintenance_dispatch.sql" "Query 4: Nearest Faulty Lights (KNN Search)"

# Query 5
run_query "q05_enriched_data_query.sql" "Query 5: Enriched View Query (With Context)"

# Query 6
run_query "q06_nearest_supplier.sql" "Query 6: Nearest Supplier (Supplier Allocation)"

echo "========================================"
echo -e "${GREEN}All queries completed!${NC}"
echo "========================================"
echo ""
echo "Query files are in: $(pwd)"
echo "You can run individual queries with:"
echo "  psql -U postgres -d streetlights -f q01_lights_in_neighborhood.sql"
echo ""
echo "Or from Docker:"
echo "  docker exec -it streetlights-postgres psql -U postgres -d streetlights -f /path/to/query.sql"
echo ""


