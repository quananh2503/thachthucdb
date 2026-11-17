-- SQL dump generated using DBML (dbml.dbdiagram.io)
-- Database: PostgreSQL
-- Generated at: 2026-11-17T16:54:59.725Z

CREATE TYPE "user_role" AS ENUM (
  'USER',
  'ADMIN'
);

CREATE TYPE "staff_type" AS ENUM (
  'MC',
  'JUDGE',
  'ORGANIZER'
);

CREATE TYPE "season_status" AS ENUM (
  'DRAFT',
  'PUBLISHED',
  'ARCHIVED'
);

CREATE TYPE "setting_value_type" AS ENUM (
  'STRING',
  'NUMBER',
  'BOOLEAN',
  'JSON'
);

CREATE TYPE "article_status" AS ENUM (
  'DRAFT',
  'PUBLISHED'
);

CREATE TYPE "team_status" AS ENUM (
  'DRAFT',
  'PENDING',
  'NEEDS_REVISION',
  'APPROVED',
  'REJECTED',
  'WITHDRAWN'
);

CREATE TYPE "team_member_role" AS ENUM (
  'CAPTAIN',
  'MEMBER'
);

CREATE TYPE "member_invite_status" AS ENUM (
  'INVITED',
  'ACCEPTED',
  'DECLINED'
);

CREATE TYPE "round_type" AS ENUM (
  'PRELIMINARY',
  'QUALIFIER',
  'SEMIFINAL',
  'FINAL',
  'PLAYOFF'
);

CREATE TYPE "match_type" AS ENUM (
  'OFFICIAL',
  'PLAYOFF'
);

CREATE TYPE "pairing_method" AS ENUM (
  'MANUAL',
  'DRAW'
);

CREATE TYPE "match_status" AS ENUM (
  'DRAFT',
  'IN_PROGRESS',
  'PROVISIONAL',
  'FINALIZED'
);

CREATE TYPE "live_status" AS ENUM (
  'LIVE',
  'ENDED'
);

CREATE TYPE "stage_status" AS ENUM (
  'PENDING',
  'RUNNING',
  'PAUSED',
  'FINISHED'
);

CREATE TYPE "question_type" AS ENUM (
  'MCQ',
  'ESSAY',
  'CODING'
);

CREATE TYPE "mcq_option" AS ENUM (
  'A',
  'B',
  'C',
  'D'
);

CREATE TABLE "users" (
  "id" uuid PRIMARY KEY,
  "username" varchar(50) UNIQUE NOT NULL,
  "email" varchar(255) UNIQUE NOT NULL,
  "name" varchar(150) NOT NULL,
  "student_id" varchar(30) UNIQUE,
  "phone" varchar(20),
  "avatar_url" text,
  "role" user_role NOT NULL DEFAULT 'USER',
  "created_at" timestamptz NOT NULL,
  "updated_at" timestamptz NOT NULL
);

CREATE TABLE "season_staff" (
  "id" uuid PRIMARY KEY,
  "season_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "staff_type" staff_type NOT NULL,
  "created_at" timestamptz NOT NULL
);

CREATE TABLE "seasons" (
  "id" uuid PRIMARY KEY,
  "year" int UNIQUE NOT NULL,
  "slug" varchar(50) UNIQUE NOT NULL,
  "name" varchar(150) NOT NULL,
  "slogan" varchar(255),
  "logo_url" text,
  "banner_url" text,
  "status" season_status NOT NULL DEFAULT 'DRAFT',
  "is_current" boolean NOT NULL DEFAULT false,
  "created_at" timestamptz NOT NULL,
  "updated_at" timestamptz NOT NULL
);

CREATE TABLE "season_settings" (
  "id" uuid PRIMARY KEY,
  "season_id" uuid NOT NULL,
  "setting_key" varchar(100) NOT NULL,
  "setting_value" text NOT NULL,
  "value_type" setting_value_type NOT NULL DEFAULT 'STRING',
  "description" text,
  "updated_at" timestamptz NOT NULL
);

CREATE TABLE "season_pages" (
  "id" uuid PRIMARY KEY,
  "season_id" uuid NOT NULL,
  "slug" varchar(100) NOT NULL,
  "title" varchar(200) NOT NULL,
  "is_published" boolean NOT NULL DEFAULT false,
  "sort_order" int NOT NULL DEFAULT 0,
  "created_at" timestamptz NOT NULL,
  "updated_at" timestamptz NOT NULL
);

CREATE TABLE "block_samples" (
  "id" uuid PRIMARY KEY,
  "code" varchar(80) UNIQUE NOT NULL,
  "name" varchar(150) NOT NULL,
  "description" text,
  "default_data" jsonb NOT NULL,
  "created_at" timestamptz NOT NULL
);

CREATE TABLE "page_blocks" (
  "id" uuid PRIMARY KEY,
  "page_id" uuid NOT NULL,
  "block_sample_id" uuid NOT NULL,
  "sort_order" int NOT NULL DEFAULT 0,
  "is_visible" boolean NOT NULL DEFAULT true,
  "data" jsonb NOT NULL,
  "updated_at" timestamptz NOT NULL
);

CREATE TABLE "sponsor_tiers" (
  "id" uuid PRIMARY KEY,
  "season_id" uuid NOT NULL,
  "name" varchar(100) NOT NULL,
  "sort_order" int NOT NULL DEFAULT 0
);

CREATE TABLE "season_sponsors" (
  "id" uuid PRIMARY KEY,
  "tier_id" uuid NOT NULL,
  "name" varchar(200) NOT NULL,
  "logo_url" text,
  "website_url" text,
  "sort_order" int NOT NULL DEFAULT 0
);

CREATE TABLE "season_milestones" (
  "id" uuid PRIMARY KEY,
  "season_id" uuid NOT NULL,
  "title" varchar(200) NOT NULL,
  "description" text,
  "start_at" timestamptz NOT NULL,
  "end_at" timestamptz,
  "sort_order" int NOT NULL DEFAULT 0
);

CREATE TABLE "season_documents" (
  "id" uuid PRIMARY KEY,
  "season_id" uuid NOT NULL,
  "title" varchar(200) NOT NULL,
  "doc_type" varchar(50) NOT NULL,
  "version" varchar(30),
  "content" jsonb,
  "file_url" text,
  "created_at" timestamptz NOT NULL
);

CREATE TABLE "season_faqs" (
  "id" uuid PRIMARY KEY,
  "season_id" uuid NOT NULL,
  "category" varchar(100),
  "question" text NOT NULL,
  "answer" text NOT NULL,
  "created_at" timestamptz NOT NULL
);

CREATE TABLE "article_categories" (
  "id" uuid PRIMARY KEY,
  "name" varchar(100) NOT NULL,
  "slug" varchar(100) UNIQUE NOT NULL
);

CREATE TABLE "articles" (
  "id" uuid PRIMARY KEY,
  "season_id" uuid NOT NULL,
  "category_id" uuid NOT NULL,
  "author_id" uuid,
  "title" varchar(255) NOT NULL,
  "slug" varchar(255) NOT NULL,
  "summary" text,
  "content" text NOT NULL,
  "thumbnail_url" text,
  "status" article_status NOT NULL DEFAULT 'DRAFT',
  "published_at" timestamptz,
  "created_at" timestamptz NOT NULL,
  "updated_at" timestamptz NOT NULL
);

CREATE TABLE "teams" (
  "id" uuid PRIMARY KEY,
  "season_id" uuid NOT NULL,
  "name" varchar(150) NOT NULL,
  "invite_code" varchar(32) UNIQUE NOT NULL,
  "status" team_status NOT NULL DEFAULT 'DRAFT',
  "review_note" text,
  "reviewed_by" uuid,
  "reviewed_at" timestamptz,
  "created_at" timestamptz NOT NULL,
  "updated_at" timestamptz NOT NULL
);

CREATE TABLE "team_members" (
  "id" uuid PRIMARY KEY,
  "team_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "role" team_member_role NOT NULL DEFAULT 'MEMBER',
  "invite_status" member_invite_status NOT NULL DEFAULT 'INVITED',
  "joined_at" timestamptz,
  "created_at" timestamptz NOT NULL
);

CREATE TABLE "rounds" (
  "id" uuid PRIMARY KEY,
  "season_id" uuid NOT NULL,
  "name" varchar(150) NOT NULL,
  "round_type" round_type NOT NULL,
  "sort_order" int NOT NULL DEFAULT 0,
  "created_at" timestamptz NOT NULL
);

CREATE TABLE "matches" (
  "id" uuid PRIMARY KEY,
  "round_id" uuid NOT NULL,
  "match_code" varchar(50) UNIQUE NOT NULL,
  "scheduled_at" timestamptz,
  "venue_room" varchar(150),
  "match_type" match_type NOT NULL DEFAULT 'OFFICIAL',
  "pairing_method" pairing_method NOT NULL DEFAULT 'MANUAL',
  "created_by" uuid,
  "status" match_status NOT NULL DEFAULT 'DRAFT',
  "is_published" boolean NOT NULL DEFAULT false,
  "created_at" timestamptz NOT NULL,
  "updated_at" timestamptz NOT NULL
);

CREATE TABLE "match_teams" (
  "id" uuid PRIMARY KEY,
  "match_id" uuid NOT NULL,
  "team_id" uuid NOT NULL,
  "slot_order" int NOT NULL,
  "team_color" varchar(30)
);

CREATE TABLE "match_staff" (
  "id" uuid PRIMARY KEY,
  "match_id" uuid NOT NULL,
  "season_staff_id" uuid NOT NULL,
  "assigned_at" timestamptz NOT NULL
);

CREATE TABLE "live_coverages" (
  "id" uuid PRIMARY KEY,
  "match_id" uuid UNIQUE NOT NULL,
  "title" varchar(255) NOT NULL,
  "status" live_status NOT NULL DEFAULT 'LIVE',
  "livestream_embed_url" text,
  "archive_video_url" text,
  "created_at" timestamptz NOT NULL
);

CREATE TABLE "live_coverage_entries" (
  "id" uuid PRIMARY KEY,
  "live_coverage_id" uuid NOT NULL,
  "occurred_at" timestamptz NOT NULL,
  "content_text" text NOT NULL,
  "image_url" text,
  "is_pinned" boolean NOT NULL DEFAULT false,
  "created_by" uuid
);

CREATE TABLE "match_stages" (
  "id" uuid PRIMARY KEY,
  "match_id" uuid NOT NULL,
  "stage_number" int NOT NULL,
  "name" varchar(150) NOT NULL,
  "question_type" question_type,
  "config_json" jsonb,
  "status" stage_status NOT NULL DEFAULT 'PENDING'
);

CREATE TABLE "match_stage_scores" (
  "id" uuid PRIMARY KEY,
  "match_id" uuid NOT NULL,
  "match_stage_id" uuid NOT NULL,
  "match_team_id" uuid NOT NULL,
  "base_score" numeric(10,2) NOT NULL DEFAULT 0,
  "created_at" timestamptz NOT NULL
);

CREATE TABLE "score_adjustments" (
  "id" uuid PRIMARY KEY,
  "match_stage_score_id" uuid NOT NULL,
  "delta_score" numeric(10,2) NOT NULL,
  "reason" text NOT NULL,
  "adjusted_by_match_staff_id" uuid NOT NULL,
  "adjusted_at" timestamptz NOT NULL
);

CREATE TABLE "question_sets" (
  "id" uuid PRIMARY KEY,
  "title" varchar(200) NOT NULL,
  "description" text,
  "created_by" uuid,
  "created_at" timestamptz NOT NULL
);

CREATE TABLE "questions" (
  "id" uuid PRIMARY KEY,
  "question_type" question_type NOT NULL,
  "title" varchar(255),
  "content" text NOT NULL,
  "created_by" uuid,
  "created_at" timestamptz NOT NULL
);

CREATE TABLE "question_set_items" (
  "question_set_id" uuid NOT NULL,
  "question_id" uuid NOT NULL,
  "sort_order" int NOT NULL DEFAULT 0,
  PRIMARY KEY ("question_set_id", "question_id")
);

CREATE TABLE "mcq_questions" (
  "question_id" uuid PRIMARY KEY,
  "question_type" question_type NOT NULL DEFAULT 'MCQ',
  "option_a" text NOT NULL,
  "option_b" text NOT NULL,
  "option_c" text NOT NULL,
  "option_d" text NOT NULL,
  "correct_option" mcq_option NOT NULL
);

CREATE TABLE "essay_questions" (
  "question_id" uuid PRIMARY KEY,
  "question_type" question_type NOT NULL DEFAULT 'ESSAY',
  "sample_answer" text
);

CREATE TABLE "coding_questions" (
  "question_id" uuid PRIMARY KEY,
  "question_type" question_type NOT NULL DEFAULT 'CODING',
  "starter_code" text,
  "time_limit_ms" int NOT NULL DEFAULT 1000,
  "memory_limit_mb" int NOT NULL DEFAULT 256
);

CREATE TABLE "coding_test_cases" (
  "id" uuid PRIMARY KEY,
  "question_id" uuid NOT NULL,
  "input_data" text NOT NULL,
  "expected_output" text NOT NULL,
  "is_sample" boolean NOT NULL DEFAULT false,
  "score_weight" int NOT NULL DEFAULT 10
);

CREATE TABLE "match_stage_questions" (
  "id" uuid PRIMARY KEY,
  "match_stage_id" uuid NOT NULL,
  "question_type" question_type NOT NULL,
  "question_id" uuid NOT NULL,
  "sort_order" int NOT NULL DEFAULT 0
);

CREATE UNIQUE INDEX ON "season_staff" ("season_id", "user_id", "staff_type");

CREATE UNIQUE INDEX ON "season_staff" ("id", "season_id");

CREATE UNIQUE INDEX ON "season_settings" ("season_id", "setting_key");

CREATE UNIQUE INDEX ON "season_pages" ("season_id", "slug");

CREATE UNIQUE INDEX ON "sponsor_tiers" ("season_id", "name");

CREATE UNIQUE INDEX ON "articles" ("season_id", "slug");

CREATE UNIQUE INDEX ON "teams" ("season_id", "name");

CREATE UNIQUE INDEX ON "teams" ("id", "season_id");

CREATE UNIQUE INDEX ON "team_members" ("team_id", "user_id");

CREATE UNIQUE INDEX ON "rounds" ("id", "season_id");

CREATE UNIQUE INDEX ON "match_teams" ("match_id", "team_id");

CREATE UNIQUE INDEX ON "match_teams" ("match_id", "slot_order");

CREATE UNIQUE INDEX ON "match_teams" ("id", "match_id");

CREATE UNIQUE INDEX ON "match_staff" ("match_id", "season_staff_id");

CREATE UNIQUE INDEX ON "match_stages" ("match_id", "stage_number");

CREATE UNIQUE INDEX ON "match_stages" ("id", "match_id");

CREATE UNIQUE INDEX ON "match_stages" ("id", "question_type");

CREATE UNIQUE INDEX ON "match_stage_scores" ("match_stage_id", "match_team_id");

CREATE UNIQUE INDEX ON "questions" ("id", "question_type");

CREATE UNIQUE INDEX ON "match_stage_questions" ("match_stage_id", "question_id");

COMMENT ON TABLE "users" IS 'Logic đăng nhập (password_hash, OAuth...) tách ở bảng auth riêng.';

COMMENT ON COLUMN "users"."student_id" IS 'MSSV, có thể null với tài khoản BTC/Giám khảo ngoài';

COMMENT ON TABLE "season_staff" IS 'Danh sách cộng tác viên (MC, Giám khảo...) đăng ký theo từng mùa.';

COMMENT ON COLUMN "season_staff"."staff_type" IS 'MC, JUDGE, ORGANIZER';

COMMENT ON TABLE "season_settings" IS 'Cấu hình key-value linh hoạt cho từng mùa (số thành viên tối đa, thời gian mở đăng ký...).';

COMMENT ON COLUMN "block_samples"."code" IS 'Khớp key trong BLOCK_REGISTRY của Frontend';

COMMENT ON COLUMN "page_blocks"."data" IS 'Copy từ block_samples.default_data và cho phép chỉnh sửa theo trang';

COMMENT ON COLUMN "sponsor_tiers"."name" IS 'Kim cương, Vàng, Bạc, Đồng... (tự định nghĩa theo mùa)';

COMMENT ON COLUMN "season_sponsors"."tier_id" IS 'Không lặp season_id vì suy ra từ tier_id (3NF)';

COMMENT ON COLUMN "season_documents"."content" IS 'Nội dung thể lệ dạng JSON có cấu trúc (hoặc đính kèm PDF)';

COMMENT ON TABLE "teams" IS 'Chỉ status = APPROVED mới là đội thi chính thức được xếp vào trận đấu.';

COMMENT ON COLUMN "match_teams"."slot_order" IS 'Số đội dynamic trong trận (1..N)';

COMMENT ON TABLE "match_staff" IS 'Nối MC và Giám khảo của mùa vào từng trận đấu cụ thể.';

COMMENT ON COLUMN "live_coverages"."match_id" IS 'Không lặp season_id vì suy ra qua match -> round -> season (3NF)';

COMMENT ON COLUMN "match_stages"."stage_number" IS '0 = Vòng 0 (cộng 20 điểm đầu trận); 1..N = các vòng chơi';

COMMENT ON COLUMN "match_stages"."question_type" IS 'Nullable ở Vòng 0; quy định loại câu hỏi cho vòng chơi 1..N';

COMMENT ON COLUMN "match_stages"."config_json" IS 'File JSON cấu hình linh hoạt cho từng game/vòng chơi';

COMMENT ON TABLE "match_stage_scores" IS 'Tổng điểm vòng = base_score + SUM(score_adjustments.delta_score). Tổng điểm trận = SUM tất cả các vòng.';

COMMENT ON COLUMN "match_stage_scores"."base_score" IS 'Điểm hệ thống/vòng 0; không lưu total_score tổng trận để tránh lệch dữ liệu';

COMMENT ON TABLE "score_adjustments" IS 'Lịch sử ban giám khảo can thiệp cộng/trừ/sửa điểm từng vòng kèm lý do.';

COMMENT ON COLUMN "questions"."content" IS 'Câu hỏi / Đề bài chung';

COMMENT ON COLUMN "mcq_questions"."question_type" IS 'CHECK (question_type = ''MCQ'')';

COMMENT ON COLUMN "essay_questions"."question_type" IS 'CHECK (question_type = ''ESSAY'')';

COMMENT ON COLUMN "essay_questions"."sample_answer" IS 'Nullable với các câu tự luận không cần đáp án mẫu';

COMMENT ON COLUMN "coding_questions"."question_type" IS 'CHECK (question_type = ''CODING'')';

COMMENT ON TABLE "match_stage_questions" IS 'FK kép đảm bảo câu hỏi bốc từ thư viện luôn khớp đúng question_type của vòng chơi.';

ALTER TABLE "season_staff" ADD FOREIGN KEY ("season_id") REFERENCES "seasons" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "season_staff" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "season_settings" ADD FOREIGN KEY ("season_id") REFERENCES "seasons" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "season_pages" ADD FOREIGN KEY ("season_id") REFERENCES "seasons" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "page_blocks" ADD FOREIGN KEY ("page_id") REFERENCES "season_pages" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "page_blocks" ADD FOREIGN KEY ("block_sample_id") REFERENCES "block_samples" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "sponsor_tiers" ADD FOREIGN KEY ("season_id") REFERENCES "seasons" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "season_sponsors" ADD FOREIGN KEY ("tier_id") REFERENCES "sponsor_tiers" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "season_milestones" ADD FOREIGN KEY ("season_id") REFERENCES "seasons" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "season_documents" ADD FOREIGN KEY ("season_id") REFERENCES "seasons" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "season_faqs" ADD FOREIGN KEY ("season_id") REFERENCES "seasons" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "articles" ADD FOREIGN KEY ("season_id") REFERENCES "seasons" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "articles" ADD FOREIGN KEY ("category_id") REFERENCES "article_categories" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "articles" ADD FOREIGN KEY ("author_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "teams" ADD FOREIGN KEY ("season_id") REFERENCES "seasons" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "teams" ADD FOREIGN KEY ("reviewed_by") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "team_members" ADD FOREIGN KEY ("team_id") REFERENCES "teams" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "team_members" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "rounds" ADD FOREIGN KEY ("season_id") REFERENCES "seasons" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "matches" ADD FOREIGN KEY ("round_id") REFERENCES "rounds" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "matches" ADD FOREIGN KEY ("created_by") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "match_teams" ADD FOREIGN KEY ("match_id") REFERENCES "matches" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "match_teams" ADD FOREIGN KEY ("team_id") REFERENCES "teams" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "match_staff" ADD FOREIGN KEY ("match_id") REFERENCES "matches" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "match_staff" ADD FOREIGN KEY ("season_staff_id") REFERENCES "season_staff" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "live_coverages" ADD FOREIGN KEY ("match_id") REFERENCES "matches" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "live_coverage_entries" ADD FOREIGN KEY ("live_coverage_id") REFERENCES "live_coverages" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "live_coverage_entries" ADD FOREIGN KEY ("created_by") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "match_stages" ADD FOREIGN KEY ("match_id") REFERENCES "matches" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "match_stage_scores" ADD FOREIGN KEY ("match_stage_id", "match_id") REFERENCES "match_stages" ("id", "match_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "match_stage_scores" ADD FOREIGN KEY ("match_team_id", "match_id") REFERENCES "match_teams" ("id", "match_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "score_adjustments" ADD FOREIGN KEY ("match_stage_score_id") REFERENCES "match_stage_scores" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "score_adjustments" ADD FOREIGN KEY ("adjusted_by_match_staff_id") REFERENCES "match_staff" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "question_sets" ADD FOREIGN KEY ("created_by") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "questions" ADD FOREIGN KEY ("created_by") REFERENCES "users" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "question_set_items" ADD FOREIGN KEY ("question_set_id") REFERENCES "question_sets" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "question_set_items" ADD FOREIGN KEY ("question_id") REFERENCES "questions" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "mcq_questions" ADD FOREIGN KEY ("question_id", "question_type") REFERENCES "questions" ("id", "question_type") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "essay_questions" ADD FOREIGN KEY ("question_id", "question_type") REFERENCES "questions" ("id", "question_type") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "coding_questions" ADD FOREIGN KEY ("question_id", "question_type") REFERENCES "questions" ("id", "question_type") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "coding_test_cases" ADD FOREIGN KEY ("question_id") REFERENCES "coding_questions" ("question_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "match_stage_questions" ADD FOREIGN KEY ("match_stage_id", "question_type") REFERENCES "match_stages" ("id", "question_type") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "match_stage_questions" ADD FOREIGN KEY ("question_id", "question_type") REFERENCES "questions" ("id", "question_type") DEFERRABLE INITIALLY IMMEDIATE;
