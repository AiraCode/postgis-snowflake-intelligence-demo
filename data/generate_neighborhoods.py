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
Generate realistic Bengaluru neighborhoods with polygon boundaries.
Output: neighborhoods.csv with WKT polygon format
"""

import csv
import random
from shapely.geometry import Polygon
from shapely import wkt

# Bengaluru coordinate bounds (approximate)
LAT_MIN, LAT_MAX = 12.8, 13.1
LON_MIN, LON_MAX = 77.5, 77.7

# Real Bengaluru neighborhood names
NEIGHBORHOOD_NAMES = [
    "Koramangala", "Indiranagar", "Whitefield", "Electronic City", "Jayanagar",
    "Malleshwaram", "Rajajinagar", "Banashankari", "BTM Layout", "HSR Layout",
    "Yelahanka", "Hebbal", "Marathahalli", "Bellandur", "Sarjapur",
    "JP Nagar", "Basavanagudi", "Richmond Town", "Frazer Town", "Shivajinagar",
    "Sadashivanagar", "RT Nagar", "Kalyan Nagar", "KR Puram", "Mahadevapura",
    "Bommanahalli", "Hoodi", "Brookefield", "Varthur", "Kadugodi",
    "Nagarbhavi", "Peenya", "Vijayanagar", "Yeshwantpur", "Mathikere",
    "Jalahalli", "Rajajinagar", "Kammanahalli", "Banaswadi", "Rammurthy Nagar",
    "CV Raman Nagar", "Domlur", "Ulsoor", "Cox Town", "Pulakeshi Nagar",
    "Bannerghatta", "Begur", "Arekere", "Hulimavu", "Uttarahalli"
]

def generate_polygon_in_bounds(center_lat, center_lon, size=0.02):
    """
    Generate a polygon centered at (center_lat, center_lon)
    with approximate size in degrees (0.02 ≈ 2km)
    """
    num_points = random.randint(5, 8)  # 5-8 sided polygons
    
    # Generate points in a roughly circular pattern
    points = []
    for i in range(num_points):
        angle = (2 * 3.14159 * i) / num_points
        # Add some randomness to make it look natural
        radius = size * random.uniform(0.7, 1.0)
        lat = center_lat + radius * random.uniform(-1, 1)
        lon = center_lon + radius * random.uniform(-1, 1)
        
        # Ensure within bounds
        lat = max(LAT_MIN, min(LAT_MAX, lat))
        lon = max(LON_MIN, min(LON_MAX, lon))
        
        points.append((lon, lat))  # Note: Shapely uses (lon, lat) order
    
    # Close the polygon
    points.append(points[0])
    
    return Polygon(points)

def generate_neighborhoods(count=50):
    """Generate neighborhood data"""
    neighborhoods = []
    
    # Create a grid to distribute neighborhoods evenly
    grid_size = int(count ** 0.5) + 1
    lat_step = (LAT_MAX - LAT_MIN) / grid_size
    lon_step = (LON_MAX - LON_MIN) / grid_size
    
    for i in range(count):
        grid_row = i // grid_size
        grid_col = i % grid_size
        
        # Center point for this grid cell
        center_lat = LAT_MIN + (grid_row + 0.5) * lat_step + random.uniform(-lat_step*0.2, lat_step*0.2)
        center_lon = LON_MIN + (grid_col + 0.5) * lon_step + random.uniform(-lon_step*0.2, lon_step*0.2)
        
        # Generate polygon
        polygon = generate_polygon_in_bounds(center_lat, center_lon, size=lat_step*0.4)
        
        # Generate data
        neighborhood_id = f"NH-{i+1:03d}"
        name = NEIGHBORHOOD_NAMES[i] if i < len(NEIGHBORHOOD_NAMES) else f"Neighborhood {i+1}"
        boundary_wkt = polygon.wkt
        population = random.randint(50000, 200000)
        
        neighborhoods.append({
            'neighborhood_id': neighborhood_id,
            'name': name,
            'boundary': boundary_wkt,
            'population': population
        })
    
    return neighborhoods

def save_to_csv(neighborhoods, filename='neighborhoods.csv'):
    """Save neighborhoods to CSV file"""
    fieldnames = ['neighborhood_id', 'name', 'boundary', 'population']
    
    with open(filename, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(neighborhoods)
    
    print(f"✓ Generated {len(neighborhoods)} neighborhoods")
    print(f"✓ Saved to {filename}")

def main():
    print("Generating Bengaluru neighborhoods...")
    neighborhoods = generate_neighborhoods(50)
    save_to_csv(neighborhoods)
    
    # Print summary
    print(f"\nSummary:")
    print(f"  Total neighborhoods: {len(neighborhoods)}")
    print(f"  Coordinate bounds: ({LAT_MIN}, {LON_MIN}) to ({LAT_MAX}, {LON_MAX})")
    print(f"  Sample neighborhood: {neighborhoods[0]['name']} ({neighborhoods[0]['neighborhood_id']})")

if __name__ == "__main__":
    main()


