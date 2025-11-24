#!/usr/bin/env python3
# Copyright 2025 Kamesh Sampath
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
Generate enrichment data for street lights and neighborhoods.
Includes weather patterns, demographics, and power grid data.
"""

import csv
import random
from datetime import date, timedelta

def load_street_lights(filename='street_lights.csv'):
    """Load street lights from CSV"""
    with open(filename, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        return list(reader)

def load_neighborhoods(filename='neighborhoods.csv'):
    """Load neighborhoods from CSV"""
    with open(filename, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        return list(reader)

def generate_weather_enrichment(lights):
    """Generate weather enrichment data for all lights (3 seasons each)"""
    weather_data = []
    
    # Season configurations
    seasons = {
        'monsoon': {  # June-September
            'temp_range': (25, 30),
            'rainfall_range': (150, 250),
            'risk_range': (0.70, 0.90)
        },
        'summer': {  # March-May
            'temp_range': (32, 38),
            'rainfall_range': (15, 40),
            'risk_range': (0.50, 0.70)
        },
        'winter': {  # December-February
            'temp_range': (18, 25),
            'rainfall_range': (5, 20),
            'risk_range': (0.20, 0.40)
        }
    }
    
    for light in lights:
        light_id = light['light_id']
        light_age_days = (date.today() - date.fromisoformat(light['installation_date'])).days
        
        for season_name, config in seasons.items():
            avg_temp = round(random.uniform(*config['temp_range']), 2)
            rainfall = round(random.uniform(*config['rainfall_range']), 2)
            
            # Base risk from season
            base_risk = random.uniform(*config['risk_range'])
            
            # Adjust risk based on light age (older lights = higher risk)
            age_factor = min(0.15, light_age_days / (365 * 30))  # Up to +0.15 for very old lights
            
            # Adjust risk based on current status
            status_factor = {
                'operational': 0,
                'maintenance_required': 0.10,
                'faulty': 0  # Already faulty, no prediction needed
            }.get(light['status'], 0)
            
            final_risk = min(0.99, base_risk + age_factor + status_factor)
            final_risk = round(final_risk, 2)
            
            # Generate predicted failure date
            # Only for non-faulty lights with moderate to high risk
            predicted_failure_date = ''
            if light['status'] != 'faulty' and final_risk > 0.5:
                # Higher risk = sooner predicted failure
                days_to_failure = int(random.uniform(7, 180) * (1 - final_risk))
                predicted_failure_date = (date.today() + timedelta(days=days_to_failure)).isoformat()
            
            weather_data.append({
                'light_id': light_id,
                'season': season_name,
                'avg_temperature_c': avg_temp,
                'rainfall_mm': rainfall,
                'failure_risk_score': final_risk,
                'predicted_failure_date': predicted_failure_date
            })
    
    return weather_data

def generate_demographics_enrichment(neighborhoods):
    """Generate demographics enrichment for neighborhoods"""
    demographics_data = []
    
    for neighborhood in neighborhoods:
        nh_id = neighborhood['neighborhood_id']
        population = int(neighborhood['population'])
        
        # Estimate population density (people per sq km)
        # Assume neighborhood area is roughly 2-10 sq km
        area_sqkm = random.uniform(2, 10)
        population_density = int(population / area_sqkm)
        
        # Classify by population density
        if population_density > 15000:
            urban_classification = 'urban'
        elif population_density > 5000:
            urban_classification = 'suburban'
        else:
            urban_classification = 'rural'
        
        demographics_data.append({
            'neighborhood_id': nh_id,
            'population_density': population_density,
            'urban_classification': urban_classification
        })
    
    return demographics_data

def generate_power_grid_enrichment(lights):
    """Generate power grid enrichment for lights"""
    power_grid_data = []
    
    # Define grid zones (distribute lights across zones)
    grid_zones = ['ZONE-A', 'ZONE-B', 'ZONE-C', 'ZONE-D', 'ZONE-E']
    
    for light in lights:
        light_id = light['light_id']
        
        # Assign grid zone (consistent distribution)
        grid_zone = grid_zones[int(light_id.split('-')[1]) % len(grid_zones)]
        
        # Average grid load (some zones more loaded than others)
        zone_base_load = {
            'ZONE-A': 75,
            'ZONE-B': 82,  # Higher load
            'ZONE-C': 68,
            'ZONE-D': 78,
            'ZONE-E': 71
        }
        base_load = zone_base_load[grid_zone]
        avg_load_percent = round(base_load + random.uniform(-5, 5), 2)
        
        # Outage history (higher in overloaded zones)
        if avg_load_percent > 80:
            outage_history_count = random.randint(3, 8)
        elif avg_load_percent > 75:
            outage_history_count = random.randint(1, 4)
        else:
            outage_history_count = random.randint(0, 2)
        
        power_grid_data.append({
            'light_id': light_id,
            'grid_zone': grid_zone,
            'avg_load_percent': avg_load_percent,
            'outage_history_count': outage_history_count
        })
    
    return power_grid_data

def save_to_csv(data, filename, fieldnames):
    """Save data to CSV file"""
    with open(filename, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)
    
    print(f"✓ Generated {len(data)} records")
    print(f"✓ Saved to {filename}")

def main():
    print("Loading base data...")
    lights = load_street_lights()
    neighborhoods = load_neighborhoods()
    print(f"✓ Loaded {len(lights)} lights and {len(neighborhoods)} neighborhoods")
    
    print("\n1. Generating weather enrichment...")
    weather_data = generate_weather_enrichment(lights)
    save_to_csv(weather_data, 'weather_enrichment.csv',
                ['light_id', 'season', 'avg_temperature_c', 'rainfall_mm', 'failure_risk_score', 'predicted_failure_date'])
    
    print("\n2. Generating demographics enrichment...")
    demographics_data = generate_demographics_enrichment(neighborhoods)
    save_to_csv(demographics_data, 'demographics_enrichment.csv',
                ['neighborhood_id', 'population_density', 'urban_classification'])
    
    print("\n3. Generating power grid enrichment...")
    power_grid_data = generate_power_grid_enrichment(lights)
    save_to_csv(power_grid_data, 'power_grid_enrichment.csv',
                ['light_id', 'grid_zone', 'avg_load_percent', 'outage_history_count'])
    
    # Print summary
    print("\n=== Summary ===")
    print(f"Weather enrichment: {len(weather_data)} records (3 seasons × {len(lights)} lights)")
    
    with_predictions = sum(1 for w in weather_data if w['predicted_failure_date'])
    print(f"  Predicted failure dates: {with_predictions} ({with_predictions*100/len(weather_data):.1f}%)")
    
    urban_counts = {}
    for d in demographics_data:
        urban_counts[d['urban_classification']] = urban_counts.get(d['urban_classification'], 0) + 1
    print(f"\nDemographics: {len(demographics_data)} neighborhoods")
    for classification, count in urban_counts.items():
        print(f"  {classification}: {count}")
    
    zone_counts = {}
    for p in power_grid_data:
        zone_counts[p['grid_zone']] = zone_counts.get(p['grid_zone'], 0) + 1
    print(f"\nPower grid: {len(power_grid_data)} lights")
    for zone, count in zone_counts.items():
        print(f"  {zone}: {count} lights")

if __name__ == "__main__":
    main()


