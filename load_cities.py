import requests
from shapely.geometry import Point

from main import db, User, City


cities = db.session.query(db.distinct(User.city))
for city, in cities:
    print city,
    resp = requests.get('http://nominatim.openstreetmap.org/search', params={
        'city': city,
        'country': 'poland',
        'format': 'json',
        'limit': 1
    })
    result = resp.json()
    if not result:
        print '?'
        continue
    city_data = result[0]
    print city_data['lon'], city_data['lat']

    coords = Point(float(city_data['lon']), float(city_data['lat']))
    city_ent = City(name=city, coords=coords.wkt)
    db.session.add(city_ent)
db.session.commit()
