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
-- Name: content; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA content;


--
-- Name: user; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA "user";


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: article; Type: TABLE; Schema: content; Owner: -
--

CREATE TABLE content.article (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: article_categories; Type: TABLE; Schema: content; Owner: -
--

CREATE TABLE content.article_categories (
    article_id uuid NOT NULL,
    category_id uuid NOT NULL
);


--
-- Name: category; Type: TABLE; Schema: content; Owner: -
--

CREATE TABLE content.category (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: comment; Type: TABLE; Schema: content; Owner: -
--

CREATE TABLE content.comment (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    article_id uuid NOT NULL,
    content text NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(128) NOT NULL
);


--
-- Name: account; Type: TABLE; Schema: user; Owner: -
--

CREATE TABLE "user".account (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    urole_id uuid NOT NULL,
    username character varying(100) NOT NULL,
    pwd text NOT NULL,
    email character varying(255) NOT NULL,
    google_id character varying(255),
    fullname character varying(100) NOT NULL,
    avatar character varying(255),
    is_ban boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: api_tokens; Type: TABLE; Schema: user; Owner: -
--

CREATE TABLE "user".api_tokens (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expires_at timestamp without time zone
);


--
-- Name: role; Type: TABLE; Schema: user; Owner: -
--

CREATE TABLE "user".role (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    code character(4) NOT NULL,
    name character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: article_categories article_categories_pkey; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.article_categories
    ADD CONSTRAINT article_categories_pkey PRIMARY KEY (article_id, category_id);


--
-- Name: article article_pkey; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.article
    ADD CONSTRAINT article_pkey PRIMARY KEY (id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: account account_email_key; Type: CONSTRAINT; Schema: user; Owner: -
--

ALTER TABLE ONLY "user".account
    ADD CONSTRAINT account_email_key UNIQUE (email);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: user; Owner: -
--

ALTER TABLE ONLY "user".account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: account account_username_key; Type: CONSTRAINT; Schema: user; Owner: -
--

ALTER TABLE ONLY "user".account
    ADD CONSTRAINT account_username_key UNIQUE (username);


--
-- Name: api_tokens api_tokens_pkey; Type: CONSTRAINT; Schema: user; Owner: -
--

ALTER TABLE ONLY "user".api_tokens
    ADD CONSTRAINT api_tokens_pkey PRIMARY KEY (id);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: user; Owner: -
--

ALTER TABLE ONLY "user".role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: fkey_carticle_caccount; Type: INDEX; Schema: content; Owner: -
--

CREATE INDEX fkey_carticle_caccount ON content.article USING btree (user_id);


--
-- Name: fkey_carticle_categories_carticle; Type: INDEX; Schema: content; Owner: -
--

CREATE INDEX fkey_carticle_categories_carticle ON content.article_categories USING btree (article_id);


--
-- Name: fkey_carticle_categories_ccategory; Type: INDEX; Schema: content; Owner: -
--

CREATE INDEX fkey_carticle_categories_ccategory ON content.article_categories USING btree (category_id);


--
-- Name: fkey_ccomment_caccount; Type: INDEX; Schema: content; Owner: -
--

CREATE INDEX fkey_ccomment_caccount ON content.comment USING btree (user_id);


--
-- Name: fkey_ccomment_carticle; Type: INDEX; Schema: content; Owner: -
--

CREATE INDEX fkey_ccomment_carticle ON content.comment USING btree (article_id);


--
-- Name: pkey_carticle; Type: INDEX; Schema: content; Owner: -
--

CREATE INDEX pkey_carticle ON content.article USING btree (id);


--
-- Name: pkey_ccategory; Type: INDEX; Schema: content; Owner: -
--

CREATE INDEX pkey_ccategory ON content.category USING btree (id);


--
-- Name: fkey_uaccount_urole; Type: INDEX; Schema: user; Owner: -
--

CREATE INDEX fkey_uaccount_urole ON "user".account USING btree (urole_id);


--
-- Name: fkey_uapi_tokens_uaccount; Type: INDEX; Schema: user; Owner: -
--

CREATE INDEX fkey_uapi_tokens_uaccount ON "user".api_tokens USING btree (user_id);


--
-- Name: pkey_uaccount; Type: INDEX; Schema: user; Owner: -
--

CREATE INDEX pkey_uaccount ON "user".account USING btree (id);


--
-- Name: pkey_uapi_tokens; Type: INDEX; Schema: user; Owner: -
--

CREATE INDEX pkey_uapi_tokens ON "user".api_tokens USING btree (id);


--
-- Name: pkey_urole; Type: INDEX; Schema: user; Owner: -
--

CREATE INDEX pkey_urole ON "user".role USING btree (id);


--
-- Name: article_categories article_categories_article_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.article_categories
    ADD CONSTRAINT article_categories_article_id_fkey FOREIGN KEY (article_id) REFERENCES content.article(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: article_categories article_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.article_categories
    ADD CONSTRAINT article_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES content.category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: article article_user_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.article
    ADD CONSTRAINT article_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user".account(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comment comment_article_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.comment
    ADD CONSTRAINT comment_article_id_fkey FOREIGN KEY (article_id) REFERENCES content.article(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comment comment_user_id_fkey; Type: FK CONSTRAINT; Schema: content; Owner: -
--

ALTER TABLE ONLY content.comment
    ADD CONSTRAINT comment_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user".account(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: account account_urole_id_fkey; Type: FK CONSTRAINT; Schema: user; Owner: -
--

ALTER TABLE ONLY "user".account
    ADD CONSTRAINT account_urole_id_fkey FOREIGN KEY (urole_id) REFERENCES "user".role(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: api_tokens api_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: user; Owner: -
--

ALTER TABLE ONLY "user".api_tokens
    ADD CONSTRAINT api_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES "user".account(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


--
-- Dbmate schema migrations
--

INSERT INTO public.schema_migrations (version) VALUES
    ('20240913024515'),
    ('20240913025653');
