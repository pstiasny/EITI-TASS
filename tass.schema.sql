--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cities (
    name character varying(256) NOT NULL,
    coords geometry(Point)
);


ALTER TABLE cities OWNER TO postgres;

--
-- Name: counties2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE counties2 (
    id integer NOT NULL,
    geom geometry(MultiPolygon,2180),
    iip_przest character varying(254),
    iip_identy character varying(254),
    iip_wersja character varying(254),
    jpt_sjr_ko character varying(254),
    jpt_kod_je character varying(254),
    jpt_nazwa_ character varying(254),
    jpt_nazw01 character varying(254),
    jpt_organ_ character varying(254),
    jpt_orga01 character varying(254),
    jpt_jor_id numeric,
    wazny_od date,
    wazny_do date,
    jpt_wazna_ character varying(254),
    wersja_od date,
    wersja_do date,
    jpt_powier numeric,
    jpt_kj_iip character varying(254),
    jpt_kj_i01 character varying(254),
    jpt_kj_i02 character varying(254),
    jpt_kod_01 character varying(254),
    id_bufora_ numeric,
    id_bufor01 numeric,
    id_technic numeric,
    jpt_opis character varying(254),
    jpt_sps_ko character varying(254),
    gra_ids character varying(254),
    status_obi character varying(254),
    opis_bledu character varying(254),
    typ_bledu character varying(254)
);


ALTER TABLE counties2 OWNER TO postgres;

--
-- Name: wynagrodzenia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE wynagrodzenia (
    kod character varying(10) NOT NULL,
    nazwa character varying(254),
    srednie_wynagrodzenie numeric(8,2)
);


ALTER TABLE wynagrodzenia OWNER TO postgres;

--
-- Name: counties; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW counties AS
 SELECT counties2.id,
    counties2.jpt_nazwa_ AS name,
    st_simplify(st_transform(counties2.geom, 4326), (0.01)::double precision) AS border,
    w.srednie_wynagrodzenie AS avg_salary
   FROM (counties2
     JOIN wynagrodzenia w ON ((((counties2.jpt_kod_je)::text || '000'::text) = (w.kod)::text)))
  WITH NO DATA;


ALTER TABLE counties OWNER TO postgres;

--
-- Name: counties2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE counties2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE counties2_id_seq OWNER TO postgres;

--
-- Name: counties2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE counties2_id_seq OWNED BY counties2.id;


--
-- Name: skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE skills (
    skill_id integer NOT NULL,
    skill_name text,
    description character varying(128)
);


ALTER TABLE skills OWNER TO postgres;

--
-- Name: skills_skill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE skills_skill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE skills_skill_id_seq OWNER TO postgres;

--
-- Name: skills_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE skills_skill_id_seq OWNED BY skills.skill_id;


--
-- Name: user_friends; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_friends (
    user_id integer NOT NULL,
    friend_id integer NOT NULL
);


ALTER TABLE user_friends OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    user_id integer NOT NULL,
    name character varying(128),
    city character varying(256),
    district character varying(128),
    link text
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: users_skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users_skills (
    user_id integer NOT NULL,
    skill_id integer NOT NULL
);


ALTER TABLE users_skills OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_user_id_seq OWNED BY users.user_id;


--
-- Name: counties2 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY counties2 ALTER COLUMN id SET DEFAULT nextval('counties2_id_seq'::regclass);


--
-- Name: skills skill_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY skills ALTER COLUMN skill_id SET DEFAULT nextval('skills_skill_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN user_id SET DEFAULT nextval('users_user_id_seq'::regclass);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (name);


--
-- Name: counties2 counties2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY counties2
    ADD CONSTRAINT counties2_pkey PRIMARY KEY (id);


--
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (skill_id);


--
-- Name: user_friends user_friends_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_friends
    ADD CONSTRAINT user_friends_pkey PRIMARY KEY (user_id, friend_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users_skills users_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_skills
    ADD CONSTRAINT users_skills_pkey PRIMARY KEY (user_id, skill_id);


--
-- Name: wynagrodzenia wynagrodzenia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY wynagrodzenia
    ADD CONSTRAINT wynagrodzenia_pkey PRIMARY KEY (kod);


--
-- Name: idx_cities_coords; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cities_coords ON cities USING gist (coords);


--
-- Name: user_friends user_friends_friend_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_friends
    ADD CONSTRAINT user_friends_friend_id_fkey FOREIGN KEY (friend_id) REFERENCES users(user_id);


--
-- Name: user_friends user_friends_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_friends
    ADD CONSTRAINT user_friends_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- Name: users_skills users_skills_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_skills
    ADD CONSTRAINT users_skills_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES skills(skill_id);


--
-- Name: users_skills users_skills_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_skills
    ADD CONSTRAINT users_skills_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(user_id);


--
-- PostgreSQL database dump complete
--

