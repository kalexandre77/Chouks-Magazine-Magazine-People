--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.24
-- Dumped by pg_dump version 13.15 (Debian 13.15-0+deb11u1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: projet; Type: SCHEMA; Schema: -; Owner: touhami.bentounsi
--

CREATE SCHEMA projet;



SET default_tablespace = '';

--
-- Name: acteur; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.acteur (
    id_acteur integer NOT NULL,
    date_1er_role date,
    id_vip integer
);




--
-- Name: acteur_id_acteur_seq; Type: SEQUENCE; Schema: public; Owner: touhami.bentounsi
--

CREATE SEQUENCE public.acteur_id_acteur_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: acteur_id_acteur_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: touhami.bentounsi
--

ALTER SEQUENCE public.acteur_id_acteur_seq OWNED BY public.acteur.id_acteur;


--
-- Name: acting; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.acting (
    id_acteur integer NOT NULL,
    visa integer NOT NULL
);




--
-- Name: article; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.article (
    id_article integer NOT NULL,
    titre character varying(100),
    num_page_article integer,
    resume_ text,
    numero_revue integer
);




--
-- Name: present_photo; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.present_photo (
    id_photo integer NOT NULL,
    id_vip integer NOT NULL
);



--
-- Name: revue; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.revue (
    numero_revue integer NOT NULL,
    date_parution date
);




--
-- Name: utilise; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.utilise (
    id_photo integer NOT NULL,
    id_article integer NOT NULL
);




--
-- Name: vip; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.vip (
    id_vip integer NOT NULL,
    nom character varying(50) NOT NULL,
    prenom character varying(50) NOT NULL,
    sexe character varying(25),
    nationalite character varying(25) NOT NULL,
    date_naissance date NOT NULL,
    date_deces date,
    id_mariage integer
);




--
-- Name: actualisation_article; Type: VIEW; Schema: public; Owner: touhami.bentounsi
--

CREATE VIEW public.actualisation_article AS
 WITH articles_derniere_annee AS (
         SELECT article.id_article
           FROM (public.article
             JOIN public.revue ON ((article.numero_revue = revue.numero_revue)))
          WHERE (revue.date_parution >= (('now'::text)::date - '1 year'::interval))
        ), vip_paru AS (
         SELECT DISTINCT present_photo.id_vip
           FROM ((articles_derniere_annee
             JOIN public.utilise ON ((articles_derniere_annee.id_article = utilise.id_article)))
             JOIN public.present_photo ON ((utilise.id_photo = present_photo.id_photo)))
        )
 SELECT vip.id_vip,
    vip.nom,
    vip.prenom
   FROM public.vip
  WHERE (NOT (vip.id_vip IN ( SELECT vip_paru.id_vip
           FROM vip_paru)));



--
-- Name: album; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.album (
    id_album integer NOT NULL,
    titre character varying(50),
    date_rea date,
    nommaisondisque character varying(50),
    id_vip integer
);




--
-- Name: album_id_album_seq; Type: SEQUENCE; Schema: public; Owner: touhami.bentounsi
--

CREATE SEQUENCE public.album_id_album_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: album_id_album_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: touhami.bentounsi
--

ALTER SEQUENCE public.album_id_album_seq OWNED BY public.album.id_album;


--
-- Name: apparait; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.apparait (
    id_photo integer NOT NULL,
    num_revue integer NOT NULL,
    num_page_photo integer
);




--
-- Name: article_id_article_seq; Type: SEQUENCE; Schema: public; Owner: touhami.bentounsi
--

CREATE SEQUENCE public.article_id_article_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: article_id_article_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: touhami.bentounsi
--

ALTER SEQUENCE public.article_id_article_seq OWNED BY public.article.id_article;


--
-- Name: artiste; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.artiste (
    id_artiste integer NOT NULL,
    specialite character varying(25),
    id_vip integer
);




--
-- Name: artiste_id_artiste_seq; Type: SEQUENCE; Schema: public; Owner: touhami.bentounsi
--

CREATE SEQUENCE public.artiste_id_artiste_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: artiste_id_artiste_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: touhami.bentounsi
--

ALTER SEQUENCE public.artiste_id_artiste_seq OWNED BY public.artiste.id_artiste;


--
-- Name: defile; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.defile (
    id_defile integer NOT NULL,
    lieu character varying(100),
    id_vip integer,
    date date
);




--
-- Name: defile_id_defile_seq; Type: SEQUENCE; Schema: public; Owner: touhami.bentounsi
--

CREATE SEQUENCE public.defile_id_defile_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: defile_id_defile_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: touhami.bentounsi
--

ALTER SEQUENCE public.defile_id_defile_seq OWNED BY public.defile.id_defile;


--
-- Name: detail_mariage; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.detail_mariage (
    id_mariage integer NOT NULL,
    date_mariage date NOT NULL,
    lieu_mariage character varying(50),
    date_separation date,
    circonstance_separation text,
    id_vip_1 integer,
    id_vip_2 integer
);




--
-- Name: detail_mariage_id_mariage_seq; Type: SEQUENCE; Schema: public; Owner: touhami.bentounsi
--

CREATE SEQUENCE public.detail_mariage_id_mariage_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: detail_mariage_id_mariage_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: touhami.bentounsi
--

ALTER SEQUENCE public.detail_mariage_id_mariage_seq OWNED BY public.detail_mariage.id_mariage;


--
-- Name: emission_divorces; Type: VIEW; Schema: public; Owner: touhami.bentounsi
--

CREATE VIEW public.emission_divorces AS
 WITH comptedivorce AS (
         SELECT vip.id_vip,
            vip.nom,
            vip.prenom,
            vip.sexe,
            count(detail_mariage.id_mariage) AS nombre_divorces
           FROM (public.vip
             JOIN public.detail_mariage ON (((vip.id_vip = detail_mariage.id_vip_1) OR (vip.id_vip = detail_mariage.id_vip_2))))
          WHERE (detail_mariage.circonstance_separation = 'Divorce'::text)
          GROUP BY vip.id_vip, vip.nom, vip.prenom, vip.sexe
        ), topdivorceshomme AS (
         SELECT comptedivorce.id_vip,
            comptedivorce.nom,
            comptedivorce.prenom,
            comptedivorce.sexe,
            comptedivorce.nombre_divorces
           FROM comptedivorce
          WHERE ((comptedivorce.sexe)::text = 'M'::text)
          ORDER BY comptedivorce.nombre_divorces DESC
         LIMIT 5
        ), topdivorcesfemme AS (
         SELECT comptedivorce.id_vip,
            comptedivorce.nom,
            comptedivorce.prenom,
            comptedivorce.sexe,
            comptedivorce.nombre_divorces
           FROM comptedivorce
          WHERE ((comptedivorce.sexe)::text = 'F'::text)
          ORDER BY comptedivorce.nombre_divorces DESC
         LIMIT 5
        )
 SELECT topdivorceshomme.id_vip,
    topdivorceshomme.nom,
    topdivorceshomme.prenom,
    topdivorceshomme.sexe,
    topdivorceshomme.nombre_divorces
   FROM topdivorceshomme
UNION ALL
 SELECT topdivorcesfemme.id_vip,
    topdivorcesfemme.nom,
    topdivorcesfemme.prenom,
    topdivorcesfemme.sexe,
    topdivorcesfemme.nombre_divorces
   FROM topdivorcesfemme
  ORDER BY 5 DESC;




--
-- Name: film; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.film (
    visa integer NOT NULL,
    date_real date NOT NULL,
    titre character varying(100) NOT NULL,
    id_vip integer NOT NULL
);




--
-- Name: film_visa_seq; Type: SEQUENCE; Schema: public; Owner: touhami.bentounsi
--

CREATE SEQUENCE public.film_visa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: liaison; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.liaison (
    id_vip integer NOT NULL,
    id_vip_liaison integer NOT NULL,
    date_annonce date
);




--
-- Name: mannequin; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.mannequin (
    id_mannequin integer NOT NULL,
    taille integer,
    agence character varying(50),
    id_vip integer
);



--
-- Name: mannequin_id_mannequin_seq; Type: SEQUENCE; Schema: public; Owner: touhami.bentounsi
--

CREATE SEQUENCE public.mannequin_id_mannequin_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: mannequin_id_mannequin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: touhami.bentounsi
--

ALTER SEQUENCE public.mannequin_id_mannequin_seq OWNED BY public.mannequin.id_mannequin;


--
-- Name: mannequinat; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.mannequinat (
    id_mannequin integer NOT NULL,
    id_defile integer NOT NULL
);



--
-- Name: musique; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.musique (
    id_artiste integer NOT NULL,
    id_album integer NOT NULL
);




--
-- Name: photo; Type: TABLE; Schema: public; Owner: touhami.bentounsi
--

CREATE TABLE public.photo (
    id_photo integer NOT NULL,
    version_numerise bytea,
    date_photo date,
    nom_photographe character varying(50),
    agence_photo character varying(50),
    circonstance_photo text
);




--
-- Name: photo_id_photo_seq; Type: SEQUENCE; Schema: public; Owner: touhami.bentounsi
--

CREATE SEQUENCE public.photo_id_photo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: photo_id_photo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: touhami.bentounsi
--

ALTER SEQUENCE public.photo_id_photo_seq OWNED BY public.photo.id_photo;


--
-- Name: revue_numero_revue_seq; Type: SEQUENCE; Schema: public; Owner: touhami.bentounsi
--

CREATE SEQUENCE public.revue_numero_revue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: revue_numero_revue_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: touhami.bentounsi
--

ALTER SEQUENCE public.revue_numero_revue_seq OWNED BY public.revue.numero_revue;


--
-- Name: vip_id_vip_seq; Type: SEQUENCE; Schema: public; Owner: touhami.bentounsi
--

CREATE SEQUENCE public.vip_id_vip_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--
-- Name: vip_id_vip_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: touhami.bentounsi
--

ALTER SEQUENCE public.vip_id_vip_seq OWNED BY public.vip.id_vip;


--
-- Name: acteur id_acteur; Type: DEFAULT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.acteur ALTER COLUMN id_acteur SET DEFAULT nextval('public.acteur_id_acteur_seq'::regclass);


--
-- Name: album id_album; Type: DEFAULT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.album ALTER COLUMN id_album SET DEFAULT nextval('public.album_id_album_seq'::regclass);


--
-- Name: article id_article; Type: DEFAULT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.article ALTER COLUMN id_article SET DEFAULT nextval('public.article_id_article_seq'::regclass);


--
-- Name: artiste id_artiste; Type: DEFAULT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.artiste ALTER COLUMN id_artiste SET DEFAULT nextval('public.artiste_id_artiste_seq'::regclass);


--
-- Name: defile id_defile; Type: DEFAULT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.defile ALTER COLUMN id_defile SET DEFAULT nextval('public.defile_id_defile_seq'::regclass);


--
-- Name: detail_mariage id_mariage; Type: DEFAULT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.detail_mariage ALTER COLUMN id_mariage SET DEFAULT nextval('public.detail_mariage_id_mariage_seq'::regclass);


--
-- Name: mannequin id_mannequin; Type: DEFAULT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.mannequin ALTER COLUMN id_mannequin SET DEFAULT nextval('public.mannequin_id_mannequin_seq'::regclass);


--
-- Name: photo id_photo; Type: DEFAULT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.photo ALTER COLUMN id_photo SET DEFAULT nextval('public.photo_id_photo_seq'::regclass);


--
-- Name: revue numero_revue; Type: DEFAULT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.revue ALTER COLUMN numero_revue SET DEFAULT nextval('public.revue_numero_revue_seq'::regclass);


--
-- Name: vip id_vip; Type: DEFAULT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.vip ALTER COLUMN id_vip SET DEFAULT nextval('public.vip_id_vip_seq'::regclass);


--
-- Data for Name: acteur; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.acteur (id_acteur, date_1er_role, id_vip) FROM stdin;
1	1991-05-24	9
2	1995-08-14	10
\.


--
-- Data for Name: acting; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.acting (id_acteur, visa) FROM stdin;
1	1
1	2
2	3
2	4
1	5
1	6
1	3
\.


--
-- Data for Name: album; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.album (id_album, titre, date_rea, nommaisondisque, id_vip) FROM stdin;
1	1989	2014-10-27	Big Machine Records	11
2	Dangerous Woman	2016-05-20	Republic Records	12
4	Fine Line	2019-12-13	Columbia Records	14
5	24K Magic	2016-11-18	Atlantic Records	15
6	Purpose	2015-11-13	Def Jam Recordings	16
9	Blonde	2016-08-28	BOY'S DON'T CRY	46
\.


--
-- Data for Name: apparait; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.apparait (id_photo, num_revue, num_page_photo) FROM stdin;
1	1	5
2	2	7
3	3	9
4	1	5
5	2	10
6	3	15
7	4	20
8	5	25
9	6	30
4	7	5
5	8	10
6	9	15
7	10	20
8	11	25
9	12	30
\.


--
-- Data for Name: article; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.article (id_article, titre, num_page_article, resume_, numero_revue) FROM stdin;
1	Taylor Swift: L évolution de la pop	12	Analyse du dernier album de Taylor Swift	1
2	Ariana Grande: La voix qui inspire	22	Portrait d Ariana Grande et de sa carrière	2
4	Harry Styles: Le phénomène mondial	16	Retour sur la carrière solo de Harry Styles	4
5	Bruno Mars: Funk, soul et pop	30	Bruno Mars : artiste aux multiples facettes	5
6	Justin Bieber: Une icône de la pop moderne	10	La trajectoire de Justin Bieber et son évolution musicale	6
8	Angelina Jolie : L’engagement humanitaire d’une star	15	Analyse de ses projets humanitaires et sa carrière	2
9	Kanye West : Le génie controversé	20	Un portrait de Kanye West, sa musique et ses polémiques	3
10	Nicole Kidman : La star intemporelle	8	Nicole Kidman et ses rôles marquants à Hollywood	4
11	Jennifer Lopez : Entre musique et cinéma	12	Un retour sur la carrière polyvalente de JLo	5
3	Rihanna: L ascension de l icône mondiale	18	Rihanna, de chanteuse à entrepreneuse	10
7	Will Smith : De Prince de Bel-Air à acteur iconique	10	Retour sur la carrière de Will Smith	11
16	Beyoncé : JayZ PDIDDY	1	Beyoncé la reine de la pop	12
\.


--
-- Data for Name: artiste; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.artiste (id_artiste, specialite, id_vip) FROM stdin;
1	Chanteuse	11
2	Rappeur	12
3	Chanteuse	14
4	Chanteuse	15
5	Chanteuse	16
6	Chanteur	17
7	Chanteur	18
8	Chanteur	19
9	Chanteur	46
\.


--
-- Data for Name: defile; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.defile (id_defile, lieu, id_vip, date) FROM stdin;
2	Milan	53	2018-05-03
1	Paris	53	2019-02-02
\.


--
-- Data for Name: detail_mariage; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.detail_mariage (id_mariage, date_mariage, lieu_mariage, date_separation, circonstance_separation, id_vip_1, id_vip_2) FROM stdin;
2	2008-04-04	New York	\N	\N	11	12
1	2014-08-23	Paris	2016-09-15	Divorce	9	10
4	2014-05-24	Florence	2021-02-19	Divorce	28	29
5	1997-12-31	Los Angeles	2020-08-20	Divorce	20	21
6	2006-11-18	Rome	2012-08-20	Divorce	22	23
7	2014-09-27	Venise	\N	Mariés	24	25
8	2022-07-16	Las Vegas	\N	Mariés	26	27
9	2011-10-09	Beverly Hills	2013-01-19	Divorce	28	27
10	2018-07-07	New York	\N	Mariés	19	13
11	2016-09-18	Nashville	2017-05-05	Divorce	17	14
\.


--
-- Data for Name: film; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.film (visa, date_real, titre, id_vip) FROM stdin;
5	2000-05-05	Gladiator	47
4	2001-06-15	Tomb Raider	48
1	1999-10-15	Fight Club	49
2	2019-07-26	 \tOnce Upon a Time in Hollywood	50
3	2005-06-10	Mr.&Mrs. Smith	51
6	2006-12-08	Blood Diamond	52
\.


--
-- Data for Name: liaison; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.liaison (id_vip, id_vip_liaison, date_annonce) FROM stdin;
36	37	1994-01-01
\.


--
-- Data for Name: mannequin; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.mannequin (id_mannequin, taille, agence, id_vip) FROM stdin;
1	2	IMG Models	13
\.


--
-- Data for Name: mannequinat; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.mannequinat (id_mannequin, id_defile) FROM stdin;
1	1
1	2
\.


--
-- Data for Name: musique; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.musique (id_artiste, id_album) FROM stdin;
1	1
2	2
4	4
5	5
6	6
7	9
\.


--
-- Data for Name: photo; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.photo (id_photo, version_numerise, date_photo, nom_photographe, agence_photo, circonstance_photo) FROM stdin;
1	\N	2023-05-15	Annie Leibovitz	Vogue	Shooting pour couverture
2	\N	2023-06-10	Mario Sorrenti	Elle	Shooting mode
3	\N	2023-07-20	Steven Klein	GQ	Shooting publicité
4	\N	2023-05-20	Peter Lindbergh	Vogue	Shooting spécial pour couverture de magazine
5	\N	2023-06-15	Annie Leibovitz	Time	Shooting pour un article de fond
6	\N	2023-07-10	David LaChapelle	Rolling Stone	Shooting exclusif pour une interview
7	\N	2023-08-05	Mario Testino	Elle	Couverture spéciale été
8	\N	2023-09-10	Steven Klein	GQ	Shooting publicitaire
9	\N	2023-10-12	Richard Avedon	Vogue	Shooting pour une campagne promotionnelle
\.


--
-- Data for Name: present_photo; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.present_photo (id_photo, id_vip) FROM stdin;
1	11
2	12
3	13
4	20
5	10
6	28
7	23
8	27
9	11
\.


--
-- Data for Name: revue; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.revue (numero_revue, date_parution) FROM stdin;
1	2023-04-01
2	2023-05-01
3	2023-06-01
4	2023-07-01
5	2023-08-01
6	2023-09-01
7	2023-10-01
8	2023-11-01
9	2023-12-01
10	2024-01-01
11	2024-02-01
12	2024-03-01
\.


--
-- Data for Name: utilise; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.utilise (id_photo, id_article) FROM stdin;
1	1
2	2
3	3
4	7
5	8
6	9
7	10
8	11
\.


--
-- Data for Name: vip; Type: TABLE DATA; Schema: public; Owner: touhami.bentounsi
--

COPY public.vip (id_vip, nom, prenom, sexe, nationalite, date_naissance, date_deces, id_mariage) FROM stdin;
15	Grande	Ariana	F	Américaine	1993-06-26	\N	\N
16	Rihanna	Robyn	F	Barbadienne	1988-02-20	\N	\N
18	Mars	Bruno	M	Américain	1985-10-08	\N	\N
11	Knowles	Beyoncé	F	Américaine	1981-09-04	\N	2
12	Carter	Jay-Z	M	Américain	1969-12-04	\N	2
9	Pitt	Brad	M	Américaine	1963-12-18	\N	1
10	Jolie	Angelina	F	Américaine	1975-06-04	\N	1
28	West	Kanye	M	Américaine	1977-06-08	\N	4
29	Kardashian	Kim	F	Américaine	1980-10-21	\N	4
20	Smith	Will	M	Américaine	1968-09-25	\N	5
21	Pinkett	Jada	F	Américaine	1971-09-18	\N	5
22	Cruise	Tom	M	Américaine	1962-07-03	\N	6
23	Kidman	Nicole	F	Américaine	1967-06-20	\N	6
24	Clooney	George	M	Américaine	1961-05-06	\N	7
25	Bullock	Sandra	F	Américaine	1964-07-26	\N	7
26	Affleck	Ben	M	Américaine	1972-08-15	\N	8
27	Lopez	Jennifer	F	Américaine	1969-07-24	\N	8
13	Hadid	Bella	F	Américaine	1996-10-09	\N	10
19	Bieber	Justin	M	Canadien	1994-03-01	\N	10
14	Swift	Taylor	F	Américaine	1989-12-13	\N	11
17	Styles	Harry	M	Britannique	1994-02-01	\N	11
36	Depp	Johnny	M	Americaine	1963-06-09	\N	\N
37	Moss	Kate	F	Britannique	1974-01-16	\N	\N
35	Madelyn	Cline	F	Americaine	1997-12-21	\N	\N
46	Ocean	Franck	M	Americain	1987-10-28	\N	\N
47	Scott	Ridley	M	Britannique	1937-11-30	\N	\N
48	West	Simon	M	Britannique	1961-06-17	\N	\N
49	Fincher	David	M	Americain	1962-08-28	\N	\N
50	Tarantino	Quentin	M	Americain	1963-03-27	\N	\N
51	Ligman	Doug	M	Americain	1965-07-24	\N	\N
52	Zwick	Edward	M	Americain	1952-10-08	\N	\N
53	Abloh	Virgil	M	Americain	1980-09-30	2021-11-28	\N
\.


--
-- Name: acteur_id_acteur_seq; Type: SEQUENCE SET; Schema: public; Owner: touhami.bentounsi
--

SELECT pg_catalog.setval('public.acteur_id_acteur_seq', 2, true);


--
-- Name: album_id_album_seq; Type: SEQUENCE SET; Schema: public; Owner: touhami.bentounsi
--

SELECT pg_catalog.setval('public.album_id_album_seq', 9, true);


--
-- Name: article_id_article_seq; Type: SEQUENCE SET; Schema: public; Owner: touhami.bentounsi
--

SELECT pg_catalog.setval('public.article_id_article_seq', 17, true);


--
-- Name: artiste_id_artiste_seq; Type: SEQUENCE SET; Schema: public; Owner: touhami.bentounsi
--

SELECT pg_catalog.setval('public.artiste_id_artiste_seq', 8, true);


--
-- Name: defile_id_defile_seq; Type: SEQUENCE SET; Schema: public; Owner: touhami.bentounsi
--

SELECT pg_catalog.setval('public.defile_id_defile_seq', 6, true);


--
-- Name: detail_mariage_id_mariage_seq; Type: SEQUENCE SET; Schema: public; Owner: touhami.bentounsi
--

SELECT pg_catalog.setval('public.detail_mariage_id_mariage_seq', 11, true);


--
-- Name: film_visa_seq; Type: SEQUENCE SET; Schema: public; Owner: touhami.bentounsi
--

SELECT pg_catalog.setval('public.film_visa_seq', 6, false);


--
-- Name: mannequin_id_mannequin_seq; Type: SEQUENCE SET; Schema: public; Owner: touhami.bentounsi
--

SELECT pg_catalog.setval('public.mannequin_id_mannequin_seq', 1, true);


--
-- Name: photo_id_photo_seq; Type: SEQUENCE SET; Schema: public; Owner: touhami.bentounsi
--

SELECT pg_catalog.setval('public.photo_id_photo_seq', 11, true);


--
-- Name: revue_numero_revue_seq; Type: SEQUENCE SET; Schema: public; Owner: touhami.bentounsi
--

SELECT pg_catalog.setval('public.revue_numero_revue_seq', 6, true);


--
-- Name: vip_id_vip_seq; Type: SEQUENCE SET; Schema: public; Owner: touhami.bentounsi
--

SELECT pg_catalog.setval('public.vip_id_vip_seq', 53, true);


--
-- Name: acteur acteur_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.acteur
    ADD CONSTRAINT acteur_pkey PRIMARY KEY (id_acteur);


--
-- Name: acting acting_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.acting
    ADD CONSTRAINT acting_pkey PRIMARY KEY (id_acteur, visa);


--
-- Name: album album_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_pkey PRIMARY KEY (id_album);


--
-- Name: apparait apparait_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.apparait
    ADD CONSTRAINT apparait_pkey PRIMARY KEY (id_photo, num_revue);


--
-- Name: article article_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.article
    ADD CONSTRAINT article_pkey PRIMARY KEY (id_article);


--
-- Name: artiste artiste_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.artiste
    ADD CONSTRAINT artiste_pkey PRIMARY KEY (id_artiste);


--
-- Name: defile defile_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.defile
    ADD CONSTRAINT defile_pkey PRIMARY KEY (id_defile);


--
-- Name: detail_mariage detail_mariage_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.detail_mariage
    ADD CONSTRAINT detail_mariage_pkey PRIMARY KEY (id_mariage);


--
-- Name: film film_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.film
    ADD CONSTRAINT film_pkey PRIMARY KEY (visa);


--
-- Name: liaison liaison_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.liaison
    ADD CONSTRAINT liaison_pkey PRIMARY KEY (id_vip, id_vip_liaison);


--
-- Name: mannequin mannequin_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.mannequin
    ADD CONSTRAINT mannequin_pkey PRIMARY KEY (id_mannequin);


--
-- Name: mannequinat mannequinat_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.mannequinat
    ADD CONSTRAINT mannequinat_pkey PRIMARY KEY (id_mannequin, id_defile);


--
-- Name: musique musique_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.musique
    ADD CONSTRAINT musique_pkey PRIMARY KEY (id_artiste, id_album);


--
-- Name: photo photo_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.photo
    ADD CONSTRAINT photo_pkey PRIMARY KEY (id_photo);


--
-- Name: present_photo present_photo_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.present_photo
    ADD CONSTRAINT present_photo_pkey PRIMARY KEY (id_photo, id_vip);


--
-- Name: revue revue_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.revue
    ADD CONSTRAINT revue_pkey PRIMARY KEY (numero_revue);


--
-- Name: detail_mariage unicite_mariage; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.detail_mariage
    ADD CONSTRAINT unicite_mariage UNIQUE (id_vip_1, id_vip_2);


--
-- Name: vip unique_nom_prenom; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.vip
    ADD CONSTRAINT unique_nom_prenom UNIQUE (nom, prenom);


--
-- Name: film unique_titre_date; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.film
    ADD CONSTRAINT unique_titre_date UNIQUE (titre, date_real);


--
-- Name: utilise utilise_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.utilise
    ADD CONSTRAINT utilise_pkey PRIMARY KEY (id_photo, id_article);


--
-- Name: vip vip_pkey; Type: CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.vip
    ADD CONSTRAINT vip_pkey PRIMARY KEY (id_vip);


--
-- Name: acting id_acteur; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.acting
    ADD CONSTRAINT id_acteur FOREIGN KEY (id_acteur) REFERENCES public.acteur(id_acteur) ON DELETE CASCADE;


--
-- Name: musique id_album; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.musique
    ADD CONSTRAINT id_album FOREIGN KEY (id_album) REFERENCES public.album(id_album) ON DELETE CASCADE;


--
-- Name: utilise id_article; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.utilise
    ADD CONSTRAINT id_article FOREIGN KEY (id_article) REFERENCES public.article(id_article) ON DELETE CASCADE;


--
-- Name: musique id_artiste; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.musique
    ADD CONSTRAINT id_artiste FOREIGN KEY (id_artiste) REFERENCES public.artiste(id_artiste);


--
-- Name: mannequinat id_defile; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.mannequinat
    ADD CONSTRAINT id_defile FOREIGN KEY (id_defile) REFERENCES public.defile(id_defile) ON DELETE CASCADE;


--
-- Name: mannequinat id_mannequin; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.mannequinat
    ADD CONSTRAINT id_mannequin FOREIGN KEY (id_mannequin) REFERENCES public.mannequin(id_mannequin) ON DELETE CASCADE;


--
-- Name: vip id_mariage; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.vip
    ADD CONSTRAINT id_mariage FOREIGN KEY (id_mariage) REFERENCES public.detail_mariage(id_mariage) ON DELETE CASCADE;


--
-- Name: present_photo id_photo; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.present_photo
    ADD CONSTRAINT id_photo FOREIGN KEY (id_photo) REFERENCES public.photo(id_photo) ON DELETE CASCADE;


--
-- Name: utilise id_photo; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.utilise
    ADD CONSTRAINT id_photo FOREIGN KEY (id_photo) REFERENCES public.photo(id_photo) ON DELETE CASCADE;


--
-- Name: apparait id_photo; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.apparait
    ADD CONSTRAINT id_photo FOREIGN KEY (id_photo) REFERENCES public.photo(id_photo) ON DELETE CASCADE;


--
-- Name: present_photo id_vip; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.present_photo
    ADD CONSTRAINT id_vip FOREIGN KEY (id_vip) REFERENCES public.vip(id_vip) ON DELETE CASCADE;


--
-- Name: film id_vip; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.film
    ADD CONSTRAINT id_vip FOREIGN KEY (id_vip) REFERENCES public.vip(id_vip) ON DELETE CASCADE;


--
-- Name: acteur id_vip; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.acteur
    ADD CONSTRAINT id_vip FOREIGN KEY (id_vip) REFERENCES public.vip(id_vip) ON DELETE CASCADE;


--
-- Name: mannequin id_vip; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.mannequin
    ADD CONSTRAINT id_vip FOREIGN KEY (id_vip) REFERENCES public.vip(id_vip) ON DELETE CASCADE;


--
-- Name: defile id_vip; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.defile
    ADD CONSTRAINT id_vip FOREIGN KEY (id_vip) REFERENCES public.vip(id_vip) ON DELETE CASCADE;


--
-- Name: artiste id_vip; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.artiste
    ADD CONSTRAINT id_vip FOREIGN KEY (id_vip) REFERENCES public.vip(id_vip) ON DELETE CASCADE;


--
-- Name: album id_vip; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT id_vip FOREIGN KEY (id_vip) REFERENCES public.vip(id_vip) ON DELETE CASCADE;


--
-- Name: liaison id_vip; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.liaison
    ADD CONSTRAINT id_vip FOREIGN KEY (id_vip) REFERENCES public.vip(id_vip) ON DELETE CASCADE;


--
-- Name: detail_mariage id_vip_1; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.detail_mariage
    ADD CONSTRAINT id_vip_1 FOREIGN KEY (id_vip_1) REFERENCES public.vip(id_vip) ON DELETE CASCADE;


--
-- Name: detail_mariage id_vip_2; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.detail_mariage
    ADD CONSTRAINT id_vip_2 FOREIGN KEY (id_vip_2) REFERENCES public.vip(id_vip) ON DELETE CASCADE;


--
-- Name: liaison id_vip_liaison; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.liaison
    ADD CONSTRAINT id_vip_liaison FOREIGN KEY (id_vip_liaison) REFERENCES public.vip(id_vip) ON DELETE CASCADE;


--
-- Name: apparait num_revue; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.apparait
    ADD CONSTRAINT num_revue FOREIGN KEY (num_revue) REFERENCES public.revue(numero_revue);


--
-- Name: article numero_revue; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.article
    ADD CONSTRAINT numero_revue FOREIGN KEY (numero_revue) REFERENCES public.revue(numero_revue) ON DELETE CASCADE;


--
-- Name: acting visa; Type: FK CONSTRAINT; Schema: public; Owner: touhami.bentounsi
--

ALTER TABLE ONLY public.acting
    ADD CONSTRAINT visa FOREIGN KEY (visa) REFERENCES public.film(visa) ON DELETE CASCADE;




--
-- PostgreSQL database dump complete
--

