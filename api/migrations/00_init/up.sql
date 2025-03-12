DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS session_tokens CASCADE;
DROP TABLE IF EXISTS songs CASCADE;
DROP TYPE IF EXISTS familiarity_level CASCADE;
DROP TABLE IF EXISTS user_songs CASCADE;

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL UNIQUE,
  username TEXT NOT NULL UNIQUE,
  hashed_password TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE TABLE session_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  expires_at TIMESTAMPTZ DEFAULT now() + interval '14 days' NOT NULL
);

CREATE TABLE songs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  composer TEXT,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE TYPE familiarity_level AS ENUM (
  'TODO',
  'LEARNING',
  'PLAYABLE',
  'GOOD',
  'MASTERED'
);

CREATE TABLE user_songs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  song_id UUID NOT NULL REFERENCES songs(id),
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
  familiarity familiarity_level NOT NULL DEFAULT 'LEARNING'
);

CREATE TABLE waitlist (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

