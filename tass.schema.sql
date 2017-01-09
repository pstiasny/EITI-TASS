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
-- Name: counties2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE counties2 (
    id integer NOT NULL,
    geom geometry(MultiPolygon,4326),
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
-- Name: counties; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW counties AS
 SELECT counties2.id,
    counties2.jpt_nazwa_ AS name,
    st_simplify(counties2.geom, (0.01)::double precision) AS border
   FROM counties2;


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
    id integer NOT NULL,
    name character varying(120)
);


ALTER TABLE skills OWNER TO postgres;

--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE skills_id_seq OWNER TO postgres;

--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE skills_id_seq OWNED BY skills.id;


--
-- Name: counties2 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY counties2 ALTER COLUMN id SET DEFAULT nextval('counties2_id_seq'::regclass);


--
-- Name: skills id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY skills ALTER COLUMN id SET DEFAULT nextval('skills_id_seq'::regclass);


--
-- Name: counties2 counties2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY counties2
    ADD CONSTRAINT counties2_pkey PRIMARY KEY (id);


--
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

