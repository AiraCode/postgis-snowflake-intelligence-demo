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
Generate street lights distributed across neighborhoods.
Ensures all points fall within neighborhood boundaries.
Output: street_lights.csv with WKT point format
"""

import csv
import random
from datetime import date, timedelta
from shapely.geometry import Point
from shapely import wkt

def load_neighborhoods(filename='neighborhoods.csv'):
    """Load neighborhoods from CSV"""
    neighborhoods = []
    with open(filename, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            row['boundary_geom'] = wkt.loads(row['boundary'])
            neighborhoods.append(row)
    return neighborhoods

def generate_random_point_in_polygon(polygon):
    """Generate a random point inside a polygon"""
    minx, miny, maxx, maxy = polygon.bounds
    
    max_attempts = 100
    for _ in range(max_attempts):
        point = Point(random.uniform(minx, maxx), random.uniform(miny, maxy))
        if polygon.contains(point):
            return point
    
    # Fallback: return centroid
    return polygon.centroid

def generate_street_lights(neighborhoods, total_count=5000):
    """Generate street lights distributed across neighborhoods"""
    lights = []
    
    # Calculate lights per neighborhood (proportional to population)
    total_population = sum(int(n['population']) for n in neighborhoods)
    lights_per_neighborhood = {
        n['neighborhood_id']: max(1, int(total_count * int(n['population']) / total_population))
        for n in neighborhoods
    }
    
    # Adjust to exactly match total_count
    current_total = sum(lights_per_neighborhood.values())
    if current_total < total_count:
        # Add remaining lights to largest neighborhoods
        sorted_neighborhoods = sorted(neighborhoods, key=lambda n: int(n['population']), reverse=True)
        for i in range(total_count - current_total):
            nh_id = sorted_neighborhoods[i % len(sorted_neighborhoods)]['neighborhood_id']
            lights_per_neighborhood[nh_id] += 1
    
    light_counter = 1
    
    # Status distribution: 85% operational, 10% maintenance_required, 5% faulty
    status_pool = ['operational'] * 850 + ['maintenance_required'] * 100 + ['faulty'] * 50
    random.shuffle(status_pool)
    
    for neighborhood in neighborhoods:
        nh_id = neighborhood['neighborhood_id']
        boundary = neighborhood['boundary_geom']
        count = lights_per_neighborhood[nh_id]
        
        for _ in range(count):
            # Generate point within neighborhood
            point = generate_random_point_in_polygon(boundary)
            
            # Generate light data
            light_id = f"SL-{light_counter:04d}"
            location_wkt = point.wkt
            status = status_pool[(light_counter - 1) % len(status_pool)]
            wattage = random.choice([100, 150, 200, 250])  # Common wattages
            
            # Installation date: 1-10 years ago
            days_ago = random.randint(365, 365*10)
            installation_date = (date.today() - timedelta(days=days_ago)).isoformat()
            
            # Last maintenance: somewhere between installation and now
            last_maintenance_days_ago = random.randint(30, days_ago)
            last_maintenance = (date.today() - timedelta(days=last_maintenance_days_ago)).isoformat() + " 12:00:00"
            
            lights.append({
                'light_id': light_id,
                'location': location_wkt,
                'status': status,
                'wattage': wattage,
                'installation_date': installation_date,
                'last_maintenance': last_maintenance,
                'neighborhood_id': nh_id
            })
            
            light_counter += 1
    
    return lights

def save_to_csv(lights, filename='street_lights.csv'):
    """Save lights to CSV file"""
    fieldnames = ['light_id', 'location', 'status', 'wattage', 'installation_date', 'last_maintenance', 'neighborhood_id']
    
    with open(filename, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(lights)
    
    print(f"✓ Generated {len(lights)} street lights")
    print(f"✓ Saved to {filename}")

def main():
    print("Loading neighborhoods...")
    neighborhoods = load_neighborhoods()
    print(f"✓ Loaded {len(neighborhoods)} neighborhoods")
    
    print("\nGenerating street lights...")
    lights = generate_street_lights(neighborhoods, total_count=5000)
    save_to_csv(lights)
    
    # Print summary
    status_counts = {}
    for light in lights:
        status_counts[light['status']] = status_counts.get(light['status'], 0) + 1
    
    print(f"\nSummary:")
    print(f"  Total lights: {len(lights)}")
    print(f"  Status distribution:")
    for status, count in status_counts.items():
        percentage = (count / len(lights)) * 100
        print(f"    {status}: {count} ({percentage:.1f}%)")

if __name__ == "__main__":
    main()


