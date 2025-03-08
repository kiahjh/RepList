--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6 (Homebrew)
-- Dumped by pg_dump version 16.6 (Homebrew)

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
-- Name: meta; Type: SCHEMA; Schema: -; Owner: miciah
--

CREATE SCHEMA meta;


ALTER SCHEMA meta OWNER TO miciah;

--
-- Name: familiarity_level; Type: TYPE; Schema: public; Owner: miciah
--

CREATE TYPE public.familiarity_level AS ENUM (
    'TODO',
    'LEARNING',
    'PLAYABLE',
    'GOOD',
    'MASTERED'
);


ALTER TYPE public.familiarity_level OWNER TO miciah;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: embeddings; Type: TABLE; Schema: meta; Owner: miciah
--

CREATE TABLE meta.embeddings (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    content text NOT NULL
);


ALTER TABLE meta.embeddings OWNER TO miciah;

--
-- Name: embeddings_id_seq; Type: SEQUENCE; Schema: meta; Owner: miciah
--

ALTER TABLE meta.embeddings ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME meta.embeddings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: migrations; Type: TABLE; Schema: meta; Owner: miciah
--

CREATE TABLE meta.migrations (
    version text NOT NULL,
    name text,
    applied_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE meta.migrations OWNER TO miciah;

--
-- Name: session_tokens; Type: TABLE; Schema: public; Owner: miciah
--

CREATE TABLE public.session_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '14 days'::interval) NOT NULL
);


ALTER TABLE public.session_tokens OWNER TO miciah;

--
-- Name: songs; Type: TABLE; Schema: public; Owner: miciah
--

CREATE TABLE public.songs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    composer text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.songs OWNER TO miciah;

--
-- Name: user_songs; Type: TABLE; Schema: public; Owner: miciah
--

CREATE TABLE public.user_songs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    song_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    familiarity public.familiarity_level NOT NULL
);


ALTER TABLE public.user_songs OWNER TO miciah;

--
-- Name: users; Type: TABLE; Schema: public; Owner: miciah
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    username text NOT NULL,
    hashed_password text NOT NULL
);


ALTER TABLE public.users OWNER TO miciah;

--
-- Data for Name: embeddings; Type: TABLE DATA; Schema: meta; Owner: miciah
--

COPY meta.embeddings (id, created_at, content) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: meta; Owner: miciah
--

COPY meta.migrations (version, name, applied_at) FROM stdin;
202407160001	embeddings	2024-12-24 11:50:25.954-05
\.


--
-- Data for Name: session_tokens; Type: TABLE DATA; Schema: public; Owner: miciah
--

COPY public.session_tokens (id, user_id, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: songs; Type: TABLE DATA; Schema: public; Owner: miciah
--

COPY public.songs (id, title, composer, created_at) FROM stdin;
\.


--
-- Data for Name: user_songs; Type: TABLE DATA; Schema: public; Owner: miciah
--

COPY public.user_songs (id, user_id, song_id, created_at, familiarity) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: miciah
--

COPY public.users (id, email, created_at, username, hashed_password) FROM stdin;
\.


--
-- Name: embeddings_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: miciah
--

SELECT pg_catalog.setval('meta.embeddings_id_seq', 1, false);


--
-- Name: embeddings embeddings_pkey; Type: CONSTRAINT; Schema: meta; Owner: miciah
--

ALTER TABLE ONLY meta.embeddings
    ADD CONSTRAINT embeddings_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: meta; Owner: miciah
--

ALTER TABLE ONLY meta.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: session_tokens session_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: miciah
--

ALTER TABLE ONLY public.session_tokens
    ADD CONSTRAINT session_tokens_pkey PRIMARY KEY (id);


--
-- Name: songs songs_pkey; Type: CONSTRAINT; Schema: public; Owner: miciah
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);


--
-- Name: user_songs user_songs_pkey; Type: CONSTRAINT; Schema: public; Owner: miciah
--

ALTER TABLE ONLY public.user_songs
    ADD CONSTRAINT user_songs_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: miciah
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: miciah
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: miciah
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: session_tokens session_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: miciah
--

ALTER TABLE ONLY public.session_tokens
    ADD CONSTRAINT session_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_songs user_songs_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: miciah
--

ALTER TABLE ONLY public.user_songs
    ADD CONSTRAINT user_songs_song_id_fkey FOREIGN KEY (song_id) REFERENCES public.songs(id);


--
-- Name: user_songs user_songs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: miciah
--

ALTER TABLE ONLY public.user_songs
    ADD CONSTRAINT user_songs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

