-- migrate:up

-- install uuid
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- create user schema
CREATE SCHEMA IF NOT EXISTS "user";

-- create role table
DROP TABLE IF EXISTS "user"."role" CASCADE;
CREATE TABLE "user"."role"(
  "id"            uuid          DEFAULT uuid_generate_v4() ,
  "code"          CHAR(4)     	NOT NULL ,
  "name"          VARCHAR(50) 	NOT NULL ,
  "created_at"    TIMESTAMP   	NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  "updated_at"    TIMESTAMP   	NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY ("id")
);
CREATE INDEX "pkey_urole" ON "user"."role" ("id");

-- dumy role data 
INSERT INTO "user"."role"("id", "code", "name") VALUES ('e6d6b8d0-9b6e-4d3d-8f7f-2b7a6b5d8a2d', 'USER', 'User');
INSERT INTO "user"."role"("id", "code", "name") VALUES ('e6d6b8d0-9b6e-4d3d-8f7f-2b7a6b5d8a2e', 'ADMN', 'Admin');


-- create account table
DROP TABLE IF EXISTS "user"."account" CASCADE;
CREATE TABLE "user"."account"(
  "id"                uuid            DEFAULT uuid_generate_v4() ,
  "urole_id"          uuid     		    NOT NULL ,
  "username"          VARCHAR(100)    NOT NULL UNIQUE,
  "pwd"               TEXT        		NOT NULL ,
  "email"             VARCHAR(255) 		NOT NULL UNIQUE ,
  "google_id"         VARCHAR(255)    NULL ,
  "fullname"          VARCHAR(100)    NOT NULL ,
  "avatar"            VARCHAR(255)    NULL ,
  "is_ban"            BOOLEAN     	NOT NULL  DEFAULT FALSE ,
  "created_at"        TIMESTAMP   		NOT NULL  DEFAULT CURRENT_TIMESTAMP ,
  "updated_at"        TIMESTAMP   		NOT NULL  DEFAULT CURRENT_TIMESTAMP ,
  "deleted_at"        TIMESTAMP   		NULL ,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("urole_id") REFERENCES "user"."role"("id")  ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE INDEX "pkey_uaccount" ON "user"."account" ("id");
CREATE INDEX "fkey_uaccount_urole" ON "user"."account" ("urole_id");

-- create api_tokens table
DROP TABLE IF EXISTS "user"."api_tokens" CASCADE;
CREATE TABLE "user"."api_tokens"
(
  "id"         uuid          DEFAULT uuid_generate_v4() ,
  "user_id"    uuid          NOT NULL ,
  "name"       varchar(255)  NOT NULL ,
  "type"       varchar(255)  NOT NULL ,
  "token"      varchar(255)  NOT NULL ,
  "created_at" timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "expires_at" timestamp    ,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("user_id") REFERENCES "user"."account"("id") ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE INDEX "pkey_uapi_tokens" ON "user"."api_tokens" ("id");
CREATE INDEX "fkey_uapi_tokens_uaccount" ON "user"."api_tokens" ("user_id");


-- migrate:down
DROP TABLE IF EXISTS "user"."api_tokens" CASCADE;
DROP TABLE IF EXISTS "user"."account" CASCADE;
DROP TABLE IF EXISTS "user"."role" CASCADE;
DROP SCHEMA IF EXISTS "user" CASCADE;
