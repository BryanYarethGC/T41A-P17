CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  data JSONB
);

CREATE TABLE productos(
  id SERIAL PRIMARY KEY,
  precio NUMERIC,
  atributos JSONB,
  atributosH HSTORE
);
