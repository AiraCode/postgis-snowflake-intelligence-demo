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
Generate light equipment suppliers distributed across Bengaluru.
Output: suppliers.csv

DISCLAIMER: All supplier names are fictitious and created solely for 
demonstration and testing purposes. Any resemblance to real companies, 
trademarks, or business names is purely coincidental.
"""

import csv
import random
from shapely.geometry import Point

# Bengaluru coordinate bounds
LAT_MIN, LAT_MAX = 12.8, 13.1
LON_MIN, LON_MAX = 77.5, 77.7

# Fictitious supplier names (for demo/testing purposes only)
SUPPLIER_NAMES = [
    "Acme Lights & Co.",
    "BrightBeam Systems Demo",
    "CloudGlow Innovations",
    "DeltaLux Technologies",
    "EchoLight Solutions Demo",
    "FusionBright Industries",
    "GammaWatt Distributors",
    "HorizonLED Technologies",
    "InfinityLight Demo Corp",
    "JetStream Illumination",
    "KryptoLux Systems",
    "LumiFlex Technologies Demo",
    "MegaBeam Industries",
    "NovaSpark Lighting Co.",
    "OmegaBright Solutions",
    "PixelGlow Technologies",
    "QuantumLight Demo Inc",
    "RadiantEdge Systems",
    "StellarBeam Technologies",
    "TitanLux Industries Demo",
    "UltraGlow Solutions",
    "VortexLight Systems",
    "WarpSpeed Illumination",
    "XenonBright Technologies",
    "ZenithLight Demo Corp",
    "AlphaLux Enterprises",
    "BetaBeam Industries",
    "CrystalGlow Solutions Demo",
    "DynamicLight Systems",
    "EliteBeam Technologies Demo"
]

def generate_suppliers(count=25):
    """Generate supplier data"""
    suppliers = []
    
    specializations = ['LED', 'Sodium Vapor', 'All']
    spec_weights = [4, 2, 4]  # More LED and All specialists
    
    for i in range(count):
        supplier_id = f"SUP-{i+1:03d}"
        name = SUPPLIER_NAMES[i] if i < len(SUPPLIER_NAMES) else f"Supplier {i+1}"
        
        # Distribute suppliers across city
        # Add some clustering near center for realism
        if random.random() < 0.4:
            # 40% clustered near city center (12.9716, 77.5946)
            latitude = 12.9716 + random.gauss(0, 0.05)
            longitude = 77.5946 + random.gauss(0, 0.05)
        else:
            # 60% distributed across city
            latitude = random.uniform(LAT_MIN, LAT_MAX)
            longitude = random.uniform(LON_MIN, LON_MAX)
        
        # Ensure within bounds
        latitude = max(LAT_MIN, min(LAT_MAX, latitude))
        longitude = max(LON_MIN, min(LON_MAX, longitude))
        
        location = Point(longitude, latitude)
        location_wkt = location.wkt
        
        # Contact phone (Indian format)
        contact_phone = f"+91-80-{random.randint(20000000, 99999999)}"
        
        # Service radius: 5-15 km
        service_radius_km = random.choice([5, 8, 10, 12, 15])
        
        # Average response time: 2-8 hours
        avg_response_hours = random.choice([2, 3, 4, 5, 6, 8])
        
        # Specialization
        specialization = random.choices(specializations, weights=spec_weights)[0]
        
        suppliers.append({
            'supplier_id': supplier_id,
            'name': name,
            'location': location_wkt,
            'contact_phone': contact_phone,
            'service_radius_km': service_radius_km,
            'avg_response_hours': avg_response_hours,
            'specialization': specialization
        })
    
    return suppliers

def save_to_csv(suppliers, filename='suppliers.csv'):
    """Save suppliers to CSV file"""
    fieldnames = ['supplier_id', 'name', 'location', 'contact_phone', 'service_radius_km', 'avg_response_hours', 'specialization']
    
    with open(filename, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(suppliers)
    
    print(f"✓ Generated {len(suppliers)} suppliers")
    print(f"✓ Saved to {filename}")

def main():
    print("Generating suppliers...")
    suppliers = generate_suppliers(25)
    save_to_csv(suppliers)
    
    # Print summary
    spec_counts = {}
    for supplier in suppliers:
        spec = supplier['specialization']
        spec_counts[spec] = spec_counts.get(spec, 0) + 1
    
    print(f"\nSummary:")
    print(f"  Total suppliers: {len(suppliers)}")
    print(f"  Specializations:")
    for spec, count in spec_counts.items():
        percentage = (count / len(suppliers)) * 100
        print(f"    {spec}: {count} ({percentage:.1f}%)")
    print(f"  Service radius range: 5-15 km")
    print(f"  Response time range: 2-8 hours")

if __name__ == "__main__":
    main()


