CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY,
    username varchar(50) UNIQUE NOT NULL,
    email varchar(255) UNIQUE NOT NULL,
    name varchar(150) NOT NULL,
    student_id varchar(30) UNIQUE,
    phone varchar(20),
    avatar_url text,
    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE season_staff (
    id VARCHAR(36) PRIMARY KEY,
    season_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    VARCHAR(20) VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE seasons (
    id VARCHAR(36) PRIMARY KEY,
    year int UNIQUE NOT NULL,
    slug varchar(50) UNIQUE NOT NULL,
    name varchar(150) NOT NULL,
    slogan varchar(255),
    logo_url text,
    banner_url text,
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    is_current boolean NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE season_settings (
    id VARCHAR(36) PRIMARY KEY,
    season_id VARCHAR(36) NOT NULL,
    setting_key varchar(100) NOT NULL,
    setting_value text NOT NULL,
    value_type VARCHAR(20) NOT NULL DEFAULT 'STRING',
    description text,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE season_pages (
    id VARCHAR(36) PRIMARY KEY,
    season_id VARCHAR(36) NOT NULL,
    slug varchar(100) NOT NULL,
    title varchar(200) NOT NULL,
    is_published boolean NOT NULL DEFAULT false,
    sort_order int NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE block_samples (
    id VARCHAR(36) PRIMARY KEY,
    code varchar(80) UNIQUE NOT NULL,
    name varchar(150) NOT NULL,
    description text,
    default_data TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE page_blocks (
    id VARCHAR(36) PRIMARY KEY,
    page_id VARCHAR(36) NOT NULL,
    block_sample_id VARCHAR(36) NOT NULL,
    sort_order int NOT NULL DEFAULT 0,
    is_visible boolean NOT NULL DEFAULT true,
    data TEXT NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE sponsor_tiers (
    id VARCHAR(36) PRIMARY KEY,
    season_id VARCHAR(36) NOT NULL,
    name varchar(100) NOT NULL,
    sort_order int NOT NULL DEFAULT 0
);

CREATE TABLE season_sponsors (
    id VARCHAR(36) PRIMARY KEY,
    tier_id VARCHAR(36) NOT NULL,
    name varchar(200) NOT NULL,
    logo_url text,
    website_url text,
    sort_order int NOT NULL DEFAULT 0
);

CREATE TABLE season_milestones (
    id VARCHAR(36) PRIMARY KEY,
    season_id VARCHAR(36) NOT NULL,
    title varchar(200) NOT NULL,
    description text,
    start_at TIMESTAMP NOT NULL,
    end_at TIMESTAMP,
    sort_order int NOT NULL DEFAULT 0
);

CREATE TABLE season_documents (
    id VARCHAR(36) PRIMARY KEY,
    season_id VARCHAR(36) NOT NULL,
    title varchar(200) NOT NULL,
    doc_type varchar(50) NOT NULL,
    version varchar(30),
    content TEXT,
    file_url text,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE season_faqs (
    id VARCHAR(36) PRIMARY KEY,
    season_id VARCHAR(36) NOT NULL,
    category varchar(100),
    question text NOT NULL,
    answer text NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE article_categories (
    id VARCHAR(36) PRIMARY KEY,
    name varchar(100) NOT NULL,
    slug varchar(100) UNIQUE NOT NULL
);

CREATE TABLE articles (
    id VARCHAR(36) PRIMARY KEY,
    season_id VARCHAR(36) NOT NULL,
    category_id VARCHAR(36) NOT NULL,
    author_id VARCHAR(36),
    title varchar(255) NOT NULL,
    slug varchar(255) NOT NULL,
    summary text,
    content text NOT NULL,
    thumbnail_url text,
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    published_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE teams (
    id VARCHAR(36) PRIMARY KEY,
    season_id VARCHAR(36) NOT NULL,
    name varchar(150) NOT NULL,
    invite_code varchar(32) UNIQUE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    review_note text,
    reviewed_by VARCHAR(36),
    reviewed_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE team_members (
    id VARCHAR(36) PRIMARY KEY,
    team_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'MEMBER',
    invite_status VARCHAR(20) NOT NULL DEFAULT 'INVITED',
    joined_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE rounds (
    id VARCHAR(36) PRIMARY KEY,
    season_id VARCHAR(36) NOT NULL,
    name varchar(150) NOT NULL,
    VARCHAR(20) VARCHAR(20) NOT NULL,
    sort_order int NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE matches (
    id VARCHAR(36) PRIMARY KEY,
    round_id VARCHAR(36) NOT NULL,
    match_code varchar(50) UNIQUE NOT NULL,
    scheduled_at TIMESTAMP,
    venue_room varchar(150),
    VARCHAR(20) VARCHAR(20) NOT NULL DEFAULT 'OFFICIAL',
    VARCHAR(20) VARCHAR(20) NOT NULL DEFAULT 'MANUAL',
    created_by VARCHAR(36),
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    is_published boolean NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE match_teams (
    id VARCHAR(36) PRIMARY KEY,
    match_id VARCHAR(36) NOT NULL,
    team_id VARCHAR(36) NOT NULL,
    slot_order int NOT NULL,
    team_color varchar(30)
);

CREATE TABLE match_staff (
    id VARCHAR(36) PRIMARY KEY,
    match_id VARCHAR(36) NOT NULL,
    season_staff_id VARCHAR(36) NOT NULL,
    assigned_at TIMESTAMP NOT NULL
);

CREATE TABLE live_coverages (
    id VARCHAR(36) PRIMARY KEY,
    match_id VARCHAR(36) UNIQUE NOT NULL,
    title varchar(255) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'LIVE',
    livestream_embed_url text,
    archive_video_url text,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE live_coverage_entries (
    id VARCHAR(36) PRIMARY KEY,
    live_coverage_id VARCHAR(36) NOT NULL,
    occurred_at TIMESTAMP NOT NULL,
    content_text text NOT NULL,
    image_url text,
    is_pinned boolean NOT NULL DEFAULT false,
    created_by VARCHAR(36)
);

CREATE TABLE match_stages (
    id VARCHAR(36) PRIMARY KEY,
    match_id VARCHAR(36) NOT NULL,
    stage_number int NOT NULL,
    name varchar(150) NOT NULL,
    VARCHAR(20) VARCHAR(20),
    config_json TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
);

CREATE TABLE match_stage_scores (
    id VARCHAR(36) PRIMARY KEY,
    match_id VARCHAR(36) NOT NULL,
    match_stage_id VARCHAR(36) NOT NULL,
    match_team_id VARCHAR(36) NOT NULL,
    base_score numeric(10,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE score_adjustments (
    id VARCHAR(36) PRIMARY KEY,
    match_stage_score_id VARCHAR(36) NOT NULL,
    delta_score numeric(10,
    reason text NOT NULL,
    adjusted_by_match_staff_id VARCHAR(36) NOT NULL,
    adjusted_at TIMESTAMP NOT NULL
);

CREATE TABLE question_sets (
    id VARCHAR(36) PRIMARY KEY,
    title varchar(200) NOT NULL,
    description text,
    created_by VARCHAR(36),
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE questions (
    id VARCHAR(36) PRIMARY KEY,
    VARCHAR(20) VARCHAR(20) NOT NULL,
    title varchar(255),
    content text NOT NULL,
    created_by VARCHAR(36),
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE question_set_items (
    question_set_id VARCHAR(36) NOT NULL,
    question_id VARCHAR(36) NOT NULL,
    sort_order int NOT NULL DEFAULT 0,
    PRIMARY KEY (question_set_id, question_id)
);

CREATE TABLE mcq_questions (
    question_id VARCHAR(36) PRIMARY KEY,
    VARCHAR(20) VARCHAR(20) NOT NULL DEFAULT 'MCQ',
    option_a text NOT NULL,
    option_b text NOT NULL,
    option_c text NOT NULL,
    option_d text NOT NULL,
    correct_option VARCHAR(5) NOT NULL
);

CREATE TABLE essay_questions (
    question_id VARCHAR(36) PRIMARY KEY,
    VARCHAR(20) VARCHAR(20) NOT NULL DEFAULT 'ESSAY',
    sample_answer text
);

CREATE TABLE coding_questions (
    question_id VARCHAR(36) PRIMARY KEY,
    VARCHAR(20) VARCHAR(20) NOT NULL DEFAULT 'CODING',
    starter_code text,
    time_limit_ms int NOT NULL DEFAULT 1000,
    memory_limit_mb int NOT NULL DEFAULT 256
);

CREATE TABLE coding_test_cases (
    id VARCHAR(36) PRIMARY KEY,
    question_id VARCHAR(36) NOT NULL,
    input_data text NOT NULL,
    expected_output text NOT NULL,
    is_sample boolean NOT NULL DEFAULT false,
    score_weight int NOT NULL DEFAULT 10
);

CREATE TABLE match_stage_questions (
    id VARCHAR(36) PRIMARY KEY,
    match_stage_id VARCHAR(36) NOT NULL,
    VARCHAR(20) VARCHAR(20) NOT NULL,
    question_id VARCHAR(36) NOT NULL,
    sort_order int NOT NULL DEFAULT 0
);
