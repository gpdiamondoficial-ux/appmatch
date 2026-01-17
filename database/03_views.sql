-- AppMatch - Views
-- 03_views.sql
-- Views de matching logic (Fase 2)

-- =========================================
-- 1) match_candidates
-- Conta interesses em comum e calcula diferença de idade entre pares de perfis
-- =========================================
CREATE OR REPLACE VIEW match_candidates AS
SELECT 
    p1.id AS profile_1,
    p2.id AS profile_2,
    COUNT(DISTINCT ui1.interest_id) AS common_interests,
    ABS(EXTRACT(year FROM age(p1.birth_date)) - EXTRACT(year FROM age(p2.birth_date))) AS age_diff
FROM profiles p1
JOIN profiles p2 ON p1.id < p2.id
JOIN user_interests ui1 ON ui1.user_id = p1.id
JOIN user_interests ui2 ON ui2.user_id = p2.id AND ui2.interest_id = ui1.interest_id
GROUP BY p1.id, p2.id, p1.birth_date, p2.birth_date;

-- =========================================
-- 2) match_scores
-- Calcula o score baseando-se em common_interests e diferença de idade
-- =========================================
CREATE OR REPLACE VIEW match_scores AS
SELECT 
    profile_1,
    profile_2,
    (LEAST(common_interests * 10, 70) +
        CASE
            WHEN age_diff <= 2 THEN 30
            WHEN age_diff <= 5 THEN 20
            WHEN age_diff <= 10 THEN 10
            ELSE 0
        END) AS score
FROM match_candidates;

-- =========================================
-- 3) match_scores_readable
-- Traz o nome dos perfis junto com o score para fácil leitura
-- =========================================
CREATE OR REPLACE VIEW match_scores_readable AS
SELECT 
    p1.name AS profile_1_name,
    p2.name AS profile_2_name,
    ms.score
FROM match_scores ms
JOIN profiles p1 ON p1.id = ms.profile_1
JOIN profiles p2 ON p2.id = ms.profile_2
ORDER BY ms.score DESC;

-- =========================================
-- 4) match_candidates_v2
-- Matching avançado considerando intenções, abertura emocional e ritmo de interação
-- =========================================
CREATE OR REPLACE VIEW match_candidates_v2 AS
WITH base AS (
    SELECT 
        p1.id AS profile_1,
        p2.id AS profile_2,
        pi1.intention AS intention_1,
        pi2.intention AS intention_2,
        pi1.emotional_openness AS openness_1,
        pi2.emotional_openness AS openness_2,
        pi1.interaction_rhythm AS rhythm_1,
        pi2.interaction_rhythm AS rhythm_2
    FROM profiles p1
    JOIN profiles p2 ON p1.id < p2.id
    JOIN profile_intentions pi1 ON pi1.profile_id = p1.id
    JOIN profile_intentions pi2 ON pi2.profile_id = p2.id
)
SELECT
    profile_1,
    profile_2,
    CASE
        WHEN intention_1 = intention_2 THEN
            CASE WHEN intention_1 = 'explorar'::intention_enum THEN 15 ELSE 30 END
        WHEN intention_1 = 'explorar'::intention_enum OR intention_2 = 'explorar'::intention_enum THEN 10
        ELSE 0
    END AS intention_score,
    CASE
        WHEN openness_1 = openness_2 THEN 15
        WHEN openness_1 = 'depende'::emotional_openness_enum OR openness_2 = 'depende'::emotional_openness_enum THEN 8
        ELSE 0
    END AS openness_score,
    CASE
        WHEN rhythm_1 = rhythm_2 THEN 10
        WHEN rhythm_1 = 'equilibrado'::interaction_rhythm_enum OR rhythm_2 = 'equilibrado'::interaction_rhythm_enum THEN 5
        ELSE 0
    END AS rhythm_score,
    (
        CASE
            WHEN intention_1 = intention_2 THEN
                CASE WHEN intention_1 = 'explorar'::intention_enum THEN 15 ELSE 30 END
            WHEN intention_1 = 'explorar'::intention_enum OR intention_2 = 'explorar'::intention_enum THEN 10
            ELSE 0
        END
        +
        CASE
            WHEN openness_1 = openness_2 THEN 15
            WHEN openness_1 = 'depende'::emotional_openness_enum OR openness_2 = 'depende'::emotional_openness_enum THEN 8
            ELSE 0
        END
        +
        CASE
            WHEN rhythm_1 = rhythm_2 THEN 10
            WHEN rhythm_1 = 'equilibrado'::interaction_rhythm_enum OR rhythm_2 = 'equilibrado'::interaction_rhythm_enum THEN 5
            ELSE 0
        END
    ) AS match_score
FROM base;

