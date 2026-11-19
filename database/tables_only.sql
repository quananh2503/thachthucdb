CREATE TABLE users (
    id uuid PRIMARY KEY,
    username varchar(50) UNIQUE NOT NULL,
    email varchar(255) UNIQUE NOT NULL,
    name varchar(150) NOT NULL,
    student_id varchar(30) UNIQUE,
    phone varchar(20),
    avatar_url text,
    role user_role NOT NULL DEFAULT 'USER',
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE season_staff (
    id uuid PRIMARY KEY,
    season_id uuid NOT NULL,
    user_id uuid NOT NULL,
    staff_type staff_type NOT NULL,
    created_at timestamptz NOT NULL
);

CREATE TABLE seasons (
    id uuid PRIMARY KEY,
    year int UNIQUE NOT NULL,
    slug varchar(50) UNIQUE NOT NULL,
    name varchar(150) NOT NULL,
    slogan varchar(255),
    logo_url text,
    banner_url text,
    status season_status NOT NULL DEFAULT 'DRAFT',
    is_current boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE season_settings (
    id uuid PRIMARY KEY,
    season_id uuid NOT NULL,
    setting_key varchar(100) NOT NULL,
    setting_value text NOT NULL,
    value_type setting_value_type NOT NULL DEFAULT 'STRING',
    description text,
    updated_at timestamptz NOT NULL
);

CREATE TABLE season_pages (
    id uuid PRIMARY KEY,
    season_id uuid NOT NULL,
    slug varchar(100) NOT NULL,
    title varchar(200) NOT NULL,
    is_published boolean NOT NULL DEFAULT false,
    sort_order int NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE block_samples (
    id uuid PRIMARY KEY,
    code varchar(80) UNIQUE NOT NULL,
    name varchar(150) NOT NULL,
    description text,
    default_data jsonb NOT NULL,
    created_at timestamptz NOT NULL
);

CREATE TABLE page_blocks (
    id uuid PRIMARY KEY,
    page_id uuid NOT NULL,
    block_sample_id uuid NOT NULL,
    sort_order int NOT NULL DEFAULT 0,
    is_visible boolean NOT NULL DEFAULT true,
    data jsonb NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sponsor_tiers (
    id uuid PRIMARY KEY,
    season_id uuid NOT NULL,
    name varchar(100) NOT NULL,
    sort_order int NOT NULL DEFAULT 0
);

CREATE TABLE season_sponsors (
    id uuid PRIMARY KEY,
    tier_id uuid NOT NULL,
    name varchar(200) NOT NULL,
    logo_url text,
    website_url text,
    sort_order int NOT NULL DEFAULT 0
);

CREATE TABLE season_milestones (
    id uuid PRIMARY KEY,
    season_id uuid NOT NULL,
    title varchar(200) NOT NULL,
    description text,
    start_at timestamptz NOT NULL,
    end_at timestamptz,
    sort_order int NOT NULL DEFAULT 0
);

CREATE TABLE season_documents (
    id uuid PRIMARY KEY,
    season_id uuid NOT NULL,
    title varchar(200) NOT NULL,
    doc_type varchar(50) NOT NULL,
    version varchar(30),
    content jsonb,
    file_url text,
    created_at timestamptz NOT NULL
);

CREATE TABLE season_faqs (
    id uuid PRIMARY KEY,
    season_id uuid NOT NULL,
    category varchar(100),
    question text NOT NULL,
    answer text NOT NULL,
    created_at timestamptz NOT NULL
);

CREATE TABLE article_categories (
    id uuid PRIMARY KEY,
    name varchar(100) NOT NULL,
    slug varchar(100) UNIQUE NOT NULL
);

CREATE TABLE articles (
    id uuid PRIMARY KEY,
    season_id uuid NOT NULL,
    category_id uuid NOT NULL,
    author_id uuid,
    title varchar(255) NOT NULL,
    slug varchar(255) NOT NULL,
    summary text,
    content text NOT NULL,
    thumbnail_url text,
    status article_status NOT NULL DEFAULT 'DRAFT',
    published_at timestamptz,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE teams (
    id uuid PRIMARY KEY,
    season_id uuid NOT NULL,
    name varchar(150) NOT NULL,
    invite_code varchar(32) UNIQUE NOT NULL,
    status team_status NOT NULL DEFAULT 'DRAFT',
    review_note text,
    reviewed_by uuid,
    reviewed_at timestamptz,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE team_members (
    id uuid PRIMARY KEY,
    team_id uuid NOT NULL,
    user_id uuid NOT NULL,
    role team_member_role NOT NULL DEFAULT 'MEMBER',
    invite_status member_invite_status NOT NULL DEFAULT 'INVITED',
    joined_at timestamptz,
    created_at timestamptz NOT NULL
);

CREATE TABLE rounds (
    id uuid PRIMARY KEY,
    season_id uuid NOT NULL,
    name varchar(150) NOT NULL,
    round_type round_type NOT NULL,
    sort_order int NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL
);

CREATE TABLE matches (
    id uuid PRIMARY KEY,
    round_id uuid NOT NULL,
    match_code varchar(50) UNIQUE NOT NULL,
    scheduled_at timestamptz,
    venue_room varchar(150),
    match_type match_type NOT NULL DEFAULT 'OFFICIAL',
    pairing_method pairing_method NOT NULL DEFAULT 'MANUAL',
    created_by uuid,
    status match_status NOT NULL DEFAULT 'DRAFT',
    is_published boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE match_teams (
    id uuid PRIMARY KEY,
    match_id uuid NOT NULL,
    team_id uuid NOT NULL,
    slot_order int NOT NULL,
    team_color varchar(30)
);

CREATE TABLE match_staff (
    id uuid PRIMARY KEY,
    match_id uuid NOT NULL,
    season_staff_id uuid NOT NULL,
    assigned_at timestamptz NOT NULL
);

CREATE TABLE live_coverages (
    id uuid PRIMARY KEY,
    match_id uuid UNIQUE NOT NULL,
    title varchar(255) NOT NULL,
    status live_status NOT NULL DEFAULT 'LIVE',
    livestream_embed_url text,
    archive_video_url text,
    created_at timestamptz NOT NULL
);

CREATE TABLE live_coverage_entries (
    id uuid PRIMARY KEY,
    live_coverage_id uuid NOT NULL,
    occurred_at timestamptz NOT NULL,
    content_text text NOT NULL,
    image_url text,
    is_pinned boolean NOT NULL DEFAULT false,
    created_by uuid
);

CREATE TABLE match_stages (
    id uuid PRIMARY KEY,
    match_id uuid NOT NULL,
    stage_number int NOT NULL,
    name varchar(150) NOT NULL,
    question_type question_type,
    config_json jsonb,
    status stage_status NOT NULL DEFAULT 'PENDING'
);

CREATE TABLE match_stage_scores (
    id uuid PRIMARY KEY,
    match_id uuid NOT NULL,
    match_stage_id uuid NOT NULL,
    match_team_id uuid NOT NULL,
    base_score numeric(10,
    created_at timestamptz NOT NULL
);

CREATE TABLE score_adjustments (
    id uuid PRIMARY KEY,
    match_stage_score_id uuid NOT NULL,
    delta_score numeric(10,
    reason text NOT NULL,
    adjusted_by_match_staff_id uuid NOT NULL,
    adjusted_at timestamptz NOT NULL
);

CREATE TABLE question_sets (
    id uuid PRIMARY KEY,
    title varchar(200) NOT NULL,
    description text,
    created_by uuid,
    created_at timestamptz NOT NULL
);

CREATE TABLE questions (
    id uuid PRIMARY KEY,
    question_type question_type NOT NULL,
    title varchar(255),
    content text NOT NULL,
    created_by uuid,
    created_at timestamptz NOT NULL
);

CREATE TABLE question_set_items (
    question_set_id uuid NOT NULL,
    question_id uuid NOT NULL,
    sort_order int NOT NULL DEFAULT 0,
    PRIMARY KEY (question_set_id, question_id)
);

CREATE TABLE mcq_questions (
    question_id uuid PRIMARY KEY,
    question_type question_type NOT NULL DEFAULT 'MCQ',
    option_a text NOT NULL,
    option_b text NOT NULL,
    option_c text NOT NULL,
    option_d text NOT NULL,
    correct_option mcq_option NOT NULL
);

CREATE TABLE essay_questions (
    question_id uuid PRIMARY KEY,
    question_type question_type NOT NULL DEFAULT 'ESSAY',
    sample_answer text
);

CREATE TABLE coding_questions (
    question_id uuid PRIMARY KEY,
    question_type question_type NOT NULL DEFAULT 'CODING',
    starter_code text,
    time_limit_ms int NOT NULL DEFAULT 1000,
    memory_limit_mb int NOT NULL DEFAULT 256
);

CREATE TABLE coding_test_cases (
    id uuid PRIMARY KEY,
    question_id uuid NOT NULL,
    input_data text NOT NULL,
    expected_output text NOT NULL,
    is_sample boolean NOT NULL DEFAULT false,
    score_weight int NOT NULL DEFAULT 10
);

CREATE TABLE match_stage_questions (
    id uuid PRIMARY KEY,
    match_stage_id uuid NOT NULL,
    question_type question_type NOT NULL,
    question_id uuid NOT NULL,
    sort_order int NOT NULL DEFAULT 0
);
