-- AppMatch - Validation
-- 05_validation.sql
-- Consultas para validar a integridade e o funcionamento do banco e das views

-- =========================
-- 1) Perfis cadastrados
SELECT * FROM public.profiles;

-- =========================
-- 2) Interesses cadastrados
SELECT * FROM public.interests;

-- =========================
-- 3) Relacionamento de interesses por usuário
SELECT ui.user_id, p.name AS profile_name, i.name AS interest_name
FROM public.user_interests ui
JOIN public.profiles p ON p.id = ui.user_id
JOIN public.interests i ON i.id = ui.interest_id
ORDER BY profile_name, interest_name;

-- =========================
-- 4) Intenções de perfil
SELECT pi.profile_id, p.name AS profile_name, pi.intention, pi.emotional_openness, pi.interaction_rhythm
FROM public.profile_intentions pi
JOIN public.profiles p ON p.id = pi.profile_id
ORDER BY profile_name;

-- =========================
-- 5) Preferências de usuário
SELECT up.profile_id, p.name AS profile_name, min_age, max_age, prefers_gender,
       likes_beach, likes_travel, likes_sports
FROM public.user_preferences up
JOIN public.profiles p ON p.id = up.profile_id
ORDER BY profile_name;

-- =========================
-- 6) Testar matching de interesses
SELECT * FROM match_candidates;

-- =========================
-- 7) Testar score bruto
SELECT * FROM match_scores;

-- =========================
-- 8) Score legível
SELECT * FROM match_scores_readable;

-- =========================
-- 9) Matching avançado (v2)
SELECT * FROM match_candidates_v2;

-- =========================
-- 10) Top matches para conferência
SELECT p1.name AS profile_1, p2.name AS profile_2, ms.score
FROM match_scores ms
JOIN profiles p1 ON p1.id = ms.profile_1
JOIN profiles p2 ON p2.id = ms.profile_2
ORDER BY ms.score DESC
LIMIT 10;
