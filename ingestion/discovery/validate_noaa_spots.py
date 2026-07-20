import requests

spots = {
    "Blacks Beach": (32.8897, -117.2564),
    "Swamis": (33.0339, -117.2953),
    "Trestles": (33.3825, -117.5936),
    "Pacific Beach": (32.7947, -117.2553),
    "Ocean Beach": (32.7494, -117.2547),
    "Sunset Cliffs": (32.7157, -117.2544),
    "Huntington Beach": (33.6595, -117.9988),
    "Malibu Surfrider": (34.0359, -118.6786),
    "Rincon": (34.3717, -119.4767),
    "Steamer Lane": (36.9519, -122.0264),
    "Mavericks": (37.4947, -122.5008),
}

headers = {"User-Agent": "surf-de-project (ethan.list4@gmail.com)"}

for name, (lat, lon) in spots.items():
    points_resp = requests.get(f"https://api.weather.gov/points/{lat},{lon}", headers=headers)
    if points_resp.status_code != 200:
        print(f"{name}: FAILED at /points ({points_resp.status_code})")
        print(f"  → {points_resp.text}")
        continue
    ...

    grid_url = points_resp.json()["properties"]["forecastGridData"]
    grid_resp = requests.get(grid_url, headers=headers)
    props = grid_resp.json().get("properties", {})

    has_wave_data = "waveHeight" in props or "primarySwellHeight" in props
    print(f"{name}: wave data {'✅ FOUND' if has_wave_data else '❌ MISSING'} | office={points_resp.json()['properties']['gridId']}")