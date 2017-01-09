from flask import Flask, jsonify, render_template
from flask_sqlalchemy import SQLAlchemy
from geoalchemy2 import Geometry
from shapely import wkb


app = Flask('tass')
app.config.from_pyfile('settings.py')
db = SQLAlchemy(app)


class Skill(db.Model):
    __tablename__ = 'skills'
    id = db.Column(db.Integer(), primary_key=True)
    name = db.Column(db.String(120))


class County(db.Model):
    __tablename__ = 'counties'
    id = db.Column(db.Integer(), primary_key=True)
    name = db.Column(db.String(120))
    border = db.Column(Geometry('MULTIPOLYGON'))


@app.route('/')
def entry_point():
    return render_template(
        'index.html.j2',
        API_KEY=app.config['GOOGLE_MAPS_API_KEY'])


@app.route('/regions/')
def list_regions():
    polys = []
    for county in County.query.all():
        region_shape = wkb.loads(bytes(county.border.data))
        for geom in region_shape.geoms:
            polys.append([
                {'lat': lat, 'lng': lng}
                for lng, lat in geom.exterior.coords
            ])
    return jsonify(polys)


if __name__ == '__main__':
    app.run(debug=True)