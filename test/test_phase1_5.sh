#!/bin/bash
# Phase 1-5 Validation Script
# Validates that all Phase 1-5 components are working correctly

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TESTS_PASSED=0
TESTS_FAILED=0

# Function to print test result
test_result() {
    local test_name=$1
    local result=$2
    
    if [ "$result" = "PASS" ]; then
        echo -e "${GREEN}✓ PASS${NC}: $test_name"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC}: $test_name"
        ((TESTS_FAILED++))
    fi
}

echo "========================================"
echo "Phase 1-5 Validation"
echo "========================================"
echo ""

# Test 1: Docker containers running
echo -e "${BLUE}Testing Docker infrastructure...${NC}"

if docker ps | grep -q "streetlights-postgres"; then
    test_result "PostgreSQL container running" "PASS"
else
    test_result "PostgreSQL container running" "FAIL"
fi

if docker ps | grep -q "streetlights-streamlit"; then
    test_result "Streamlit container running" "PASS"
else
    test_result "Streamlit container running" "FAIL"
fi

echo ""

# Test 2: PostgreSQL health check
echo -e "${BLUE}Testing PostgreSQL connection...${NC}"

if docker exec streetlights-postgres pg_isready -U postgres -d streetlights > /dev/null 2>&1; then
    test_result "PostgreSQL is ready" "PASS"
else
    test_result "PostgreSQL is ready" "FAIL"
fi

echo ""

# Test 3: PostGIS extension enabled
echo -e "${BLUE}Testing PostGIS installation...${NC}"

POSTGIS_VERSION=$(docker exec streetlights-postgres psql -U postgres -d streetlights -t -c "SELECT PostGIS_Version();" 2>/dev/null | tr -d ' ')

if [ ! -z "$POSTGIS_VERSION" ]; then
    test_result "PostGIS extension enabled ($POSTGIS_VERSION)" "PASS"
else
    test_result "PostGIS extension enabled" "FAIL"
fi

echo ""

# Test 4: Base tables exist
echo -e "${BLUE}Testing base tables...${NC}"

for table in "neighborhoods" "street_lights" "maintenance_requests" "suppliers"; do
    COUNT=$(docker exec streetlights-postgres psql -U postgres -d streetlights -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public' AND table_name='$table';" 2>/dev/null | tr -d ' ')
    
    if [ "$COUNT" = "1" ]; then
        test_result "Table exists: $table" "PASS"
    else
        test_result "Table exists: $table" "FAIL"
    fi
done

echo ""

# Test 5: Enrichment tables exist
echo -e "${BLUE}Testing enrichment tables...${NC}"

for table in "weather_enrichment" "demographics_enrichment" "power_grid_enrichment"; do
    COUNT=$(docker exec streetlights-postgres psql -U postgres -d streetlights -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public' AND table_name='$table';" 2>/dev/null | tr -d ' ')
    
    if [ "$COUNT" = "1" ]; then
        test_result "Enrichment table exists: $table" "PASS"
    else
        test_result "Enrichment table exists: $table" "FAIL"
    fi
done

echo ""

# Test 6: Enriched views exist
echo -e "${BLUE}Testing enriched views...${NC}"

for view in "street_lights_enriched" "maintenance_requests_enriched"; do
    COUNT=$(docker exec streetlights-postgres psql -U postgres -d streetlights -t -c "SELECT COUNT(*) FROM information_schema.views WHERE table_schema='public' AND table_name='$view';" 2>/dev/null | tr -d ' ')
    
    if [ "$COUNT" = "1" ]; then
        test_result "View exists: $view" "PASS"
    else
        test_result "View exists: $view" "FAIL"
    fi
done

echo ""

# Test 7: Spatial indexes exist
echo -e "${BLUE}Testing spatial indexes...${NC}"

for index in "idx_lights_location" "idx_neighborhoods_boundary" "idx_suppliers_location"; do
    COUNT=$(docker exec streetlights-postgres psql -U postgres -d streetlights -t -c "SELECT COUNT(*) FROM pg_indexes WHERE schemaname='public' AND indexname='$index';" 2>/dev/null | tr -d ' ')
    
    if [ "$COUNT" = "1" ]; then
        test_result "Spatial index exists: $index" "PASS"
    else
        test_result "Spatial index exists: $index" "FAIL"
    fi
done

echo ""

# Test 8: Data loaded
echo -e "${BLUE}Testing data loaded...${NC}"

LIGHTS_COUNT=$(docker exec streetlights-postgres psql -U postgres -d streetlights -t -c "SELECT COUNT(*) FROM street_lights;" 2>/dev/null | tr -d ' ')
NEIGHBORHOODS_COUNT=$(docker exec streetlights-postgres psql -U postgres -d streetlights -t -c "SELECT COUNT(*) FROM neighborhoods;" 2>/dev/null | tr -d ' ')
SUPPLIERS_COUNT=$(docker exec streetlights-postgres psql -U postgres -d streetlights -t -c "SELECT COUNT(*) FROM suppliers;" 2>/dev/null | tr -d ' ')
WEATHER_COUNT=$(docker exec streetlights-postgres psql -U postgres -d streetlights -t -c "SELECT COUNT(*) FROM weather_enrichment;" 2>/dev/null | tr -d ' ')

if [ "$LIGHTS_COUNT" -ge "4000" ]; then
    test_result "Street lights data loaded ($LIGHTS_COUNT rows)" "PASS"
else
    test_result "Street lights data loaded ($LIGHTS_COUNT rows, expected ~5000)" "FAIL"
fi

if [ "$NEIGHBORHOODS_COUNT" -ge "40" ]; then
    test_result "Neighborhoods data loaded ($NEIGHBORHOODS_COUNT rows)" "PASS"
else
    test_result "Neighborhoods data loaded ($NEIGHBORHOODS_COUNT rows, expected ~50)" "FAIL"
fi

if [ "$SUPPLIERS_COUNT" -ge "20" ]; then
    test_result "Suppliers data loaded ($SUPPLIERS_COUNT rows)" "PASS"
else
    test_result "Suppliers data loaded ($SUPPLIERS_COUNT rows, expected ~25)" "FAIL"
fi

if [ "$WEATHER_COUNT" -ge "10000" ]; then
    test_result "Weather enrichment data loaded ($WEATHER_COUNT rows)" "PASS"
else
    test_result "Weather enrichment data loaded ($WEATHER_COUNT rows, expected ~15000)" "FAIL"
fi

echo ""

# Test 9: Spatial queries work
echo -e "${BLUE}Testing spatial queries...${NC}"

# Test ST_Within
WITHIN_COUNT=$(docker exec streetlights-postgres psql -U postgres -d streetlights -t -c "SELECT COUNT(*) FROM street_lights l JOIN neighborhoods n ON ST_Within(l.location, n.boundary);" 2>/dev/null | tr -d ' ')

if [ "$WITHIN_COUNT" -ge "4000" ]; then
    test_result "ST_Within query works ($WITHIN_COUNT lights in neighborhoods)" "PASS"
else
    test_result "ST_Within query works" "FAIL"
fi

# Test enriched view
ENRICHED_COUNT=$(docker exec streetlights-postgres psql -U postgres -d streetlights -t -c "SELECT COUNT(*) FROM street_lights_enriched WHERE season IS NOT NULL;" 2>/dev/null | tr -d ' ')

if [ "$ENRICHED_COUNT" -ge "4000" ]; then
    test_result "Enriched view works ($ENRICHED_COUNT rows with season)" "PASS"
else
    test_result "Enriched view works" "FAIL"
fi

echo ""

# Test 10: Streamlit accessibility
echo -e "${BLUE}Testing Streamlit dashboard...${NC}"

if curl -s http://localhost:8501 > /dev/null 2>&1; then
    test_result "Streamlit dashboard accessible (http://localhost:8501)" "PASS"
else
    test_result "Streamlit dashboard accessible (http://localhost:8501)" "FAIL"
    echo -e "${YELLOW}Note: Streamlit may need dashboard/app.py to be created${NC}"
fi

echo ""

# Test 11: Generated files exist
echo -e "${BLUE}Testing generated files...${NC}"

for file in "neighborhoods.csv" "street_lights.csv" "maintenance_requests.csv" "suppliers.csv" "weather_enrichment.csv"; do
    if [ -f "data/$file" ]; then
        test_result "Generated file exists: data/$file" "PASS"
    else
        test_result "Generated file exists: data/$file" "FAIL"
    fi
done

echo ""

# Test 12: Documentation files exist
echo -e "${BLUE}Testing documentation...${NC}"

for doc in "architecture_diagram.md" "enrichment_strategy.md" "demo_script.md" "implementation_plan.md"; do
    if [ -f "work/$doc" ]; then
        test_result "Documentation exists: work/$doc" "PASS"
    else
        test_result "Documentation exists: work/$doc" "FAIL"
    fi
done

# Check schema reference in data folder
if [ -f "data/SCHEMA_REFERENCE.md" ]; then
    test_result "Schema reference exists: data/SCHEMA_REFERENCE.md" "PASS"
else
    test_result "Schema reference exists: data/SCHEMA_REFERENCE.md" "FAIL"
fi

echo ""

# Final summary
echo "========================================"
echo "Phase 1-5 Validation Complete"
echo "========================================"
echo ""
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
echo ""

if [ "$TESTS_FAILED" -eq 0 ]; then
    echo -e "${GREEN}✓ ALL TESTS PASSED!${NC}"
    echo ""
    echo "Phase 1-5 is complete and working correctly."
    echo ""
    echo "Next steps:"
    echo "  1. Access Streamlit dashboard: http://localhost:8501"
    echo "  2. Run PostGIS queries: cd queries/postgis && ./run_queries.sh"
    echo "  3. Review demo script: cat work/demo_script.md"
    echo "  4. Ready for Phase 6+ (NiFi CDC and Snowflake ML)"
    echo ""
    exit 0
else
    echo -e "${RED}✗ SOME TESTS FAILED${NC}"
    echo ""
    echo "Please fix the failed tests before proceeding."
    echo ""
    echo "Common issues:"
    echo "  - Data not loaded: Run cd data && ./generate_all_data.sh"
    echo "  - Containers not running: Run docker-compose up -d"
    echo "  - Streamlit not working: Ensure dashboard/app.py exists"
    echo ""
    exit 1
fi


