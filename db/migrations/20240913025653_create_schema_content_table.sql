-- migrate:up
CREATE SCHEMA IF NOT EXISTS "content";

-- create category table
DROP TABLE IF EXISTS "content"."category" CASCADE;
CREATE TABLE "content"."category"(
  "id"            uuid          DEFAULT uuid_generate_v4() ,
  "name"          VARCHAR(100) 	NOT NULL ,
  "description"   TEXT         	NULL ,
  "created_at"    TIMESTAMP   	NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  "updated_at"    TIMESTAMP   	NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY ("id")
);

CREATE INDEX "pkey_ccategory" ON "content"."category" ("id");

-- create article table
DROP TABLE IF EXISTS "content"."article" CASCADE;
CREATE TABLE "content"."article"(
  "id"            uuid          DEFAULT uuid_generate_v4() ,
  "title"         VARCHAR(255) 	NOT NULL ,
  "content"       TEXT         	NOT NULL ,
  "author"        VARCHAR(100) 	NOT NULL ,
  "created_at"    TIMESTAMP   	NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  "updated_at"    TIMESTAMP   	NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY ("id"),
);

CREATE INDEX "pkey_carticle" ON "content"."article" ("id");

-- create article_category table
DROP TABLE IF EXISTS "content"."article_categories" CASCADE;
CREATE TABLE "content"."article_categories"(
  "article_id"    uuid          NOT NULL ,
  "category_id"   uuid          NOT NULL ,
  PRIMARY KEY ("article_id", "category_id"),
  FOREIGN KEY ("article_id") REFERENCES "content"."article"("id") ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY ("category_id") REFERENCES "content"."category"("id") ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX "fkey_carticle_categories_carticle" ON "content"."article_categories" ("article_id");
CREATE INDEX "fkey_carticle_categories_ccategory" ON "content"."article_categories" ("category_id");

-- create comment table
DROP TABLE IF EXISTS "content"."comment" CASCADE;
CREATE TABLE "content"."comment"(
  "id"            uuid          DEFAULT uuid_generate_v4() ,
  "article_id"    uuid          NOT NULL ,
  "content"       TEXT         	NOT NULL ,
  "user_id"       uuid       	NOT NULL ,
  "created_at"    TIMESTAMP   	NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  "updated_at"    TIMESTAMP   	NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("article_id") REFERENCES "content"."article"("id") ON UPDATE CASCADE ON DELETE CASCADE
  FOREIGN KEY ("user_id") REFERENCES "user"."account"("id") ON UPDATE CASCADE ON DELETE CASCADE
);


-- migrate:down
DROP TABLE IF EXISTS "content"."comment" CASCADE;
DROP TABLE IF EXISTS "content"."article_categories" CASCADE;
DROP TABLE IF EXISTS "content"."article" CASCADE;
DROP TABLE IF EXISTS "content"."category" CASCADE;
DROP SCHEMA IF EXISTS "content" CASCADE;

