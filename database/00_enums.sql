-- AppMatch
-- 00_enums.sql
-- Definições de enums do core emocional e comportamental

create type intention_enum as enum (
  'casual',
  'amizade',
  'relacionamento_serio',
  'explorar'
);

create type emotional_openness_enum as enum (
  'reservado',
  'equilibrado',
  'aberto'
);

create type interaction_rhythm_enum as enum (
  'lento',
  'moderado',
  'intenso'
);
