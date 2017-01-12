from flask import Flask, jsonify, render_template
from flask_sqlalchemy import SQLAlchemy
from geoalchemy2 import Geometry
from shapely import wkb


app = Flask('tass')
app.config.from_pyfile('settings.py')
db = SQLAlchemy(app)


users_skills_table = db.Table('users_skills', db.Model.metadata,
    db.Column('user_id', db.Integer, db.ForeignKey('users.user_id')),
    db.Column('skill_id', db.Integer, db.ForeignKey('skills.skill_id'))
)


class Skill(db.Model):
    __tablename__ = 'skills'
    id = db.Column('skill_id', db.Integer(), primary_key=True)
    name = db.Column('skill_name', db.String(128))
    description = db.Column(db.Text())
    users = db.relationship('User', secondary=users_skills_table)


class User(db.Model):
    __tablename__ = 'users'
    id = db.Column('user_id', db.Integer(), primary_key=True)
    name = db.Column(db.String(128))
    city  = db.Column(db.String(256))
    district = db.Column(db.String(128))
    link = db.Column(db.Text())


class County(db.Model):
    __tablename__ = 'counties'
    id = db.Column(db.Integer(), primary_key=True)
    name = db.Column(db.String(120))
    border = db.Column(Geometry('MULTIPOLYGON'))
    avg_salary = db.Column(db.Numeric(8, 2))


class City(db.Model):
    __tablename__ = 'cities'
    name = db.Column(db.String(256), primary_key=True)
    coords = db.Column(Geometry('POINT'))


@app.route('/')
def entry_point():
    return render_template(
        'index.html.j2',
        API_KEY=app.config['GOOGLE_MAPS_API_KEY'])


@app.route('/skills/')
def list_skills():
    return jsonify([
        {'name': skill.name}
        for skill in Skill.query.all()
    ])


@app.route('/skills/<skill_name>')
def describe_skill(skill_name):
    skill = Skill.query.filter_by(name=skill_name).first_or_404()
    city_counts = db.session.query(
            City.name,
            db.func.count(User.id),
            City.coords) \
        .join(User, City.name == User.city) \
        .join(users_skills_table) \
        .join(Skill) \
        .filter(Skill.id == skill.id) \
        .group_by(City.name)

    def _wkb_to_json(wkb_):
        point = wkb.loads(bytes(wkb_))
        return {'lng': point.x,
                'lat': point.y}

    return jsonify({
        'name': skill.name,
        'city_counts': [
            {'city': cname, 'count': ccount,
             'coords': _wkb_to_json(coords.data)}
            for cname, ccount, coords in city_counts
        ],
    })


@app.route('/regions/')
def list_regions():
    regions = []
    for county in County.query.all():
        region_shape = wkb.loads(bytes(county.border.data))
        for geom in region_shape.geoms:
            poly = [
                {'lat': lat, 'lng': lng}
                for lng, lat in geom.exterior.coords
            ]
            regions.append({
                'name': county.name,
                'avg_salary': float(county.avg_salary),
                'poly': poly,
            })
    return jsonify(regions)


if __name__ == '__main__':
    app.run(debug=True)
