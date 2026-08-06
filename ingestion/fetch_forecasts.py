import requests


headers = {"User-Agent": "surf-de-project (ethan.list4@gmail.com)"}

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


lat,lon = spots["Blacks Beach"]
points_resp = requests.get(f"https://api.weather.gov/points/{lat},{lon}", headers=headers)
grid_url = points_resp.json()["properties"]["forecastGridData"]
grid_resp = requests.get(grid_url,headers=headers)
props = grid_resp.json()["properties"]

print(props.keys()) 

