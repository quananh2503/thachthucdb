# Đặc tả Nghiệp vụ Tổng hợp phục vụ Thiết kế Cơ sở Dữ liệu SQL (3NF)

> **Mục đích tài liệu:** Gom toàn bộ nghiệp vụ từ 4 tài liệu gốc trong `requiement/` và phần phân tích kiến trúc Web động, sắp xếp lại theo **6 Cụm Bảng (Database Clusters)** kèm danh sách thực thể dự kiến, quan hệ, ràng buộc toàn vẹn (Constraints) và điểm nối giữa các cụm để kỹ sư Backend chia bảng và dựng DBML/SQL chuẩn 3NF.

**Nguồn đối chiếu:**
- `requiement/Requirement đồ án tốt nghiệp.md` (v0.2 – 13/11/2026)
- `requiement/Note meeting đồ án tốt nghiệp - 13_11_2026.docx.md`
- `requiement/Note meeting đồ án tốt nghiệp - 13_11_2026 (bổ sung).docx.md`
- `requiement/NOTE MEETING 30_10_2026.md`

---

## Tổng quan Kiến trúc & Thứ tự Chia Cụm DB

Hệ thống gồm **6 cụm dữ liệu**, thiết kế theo hướng phụ thuộc 1 chiều từ gốc ra ngọn để tránh vòng lặp khóa ngoại (FK cycles):

```text
[1. Identity & RBAC]
        │
        ▼
[2. Season, Web Portal & Dynamic Blocks] ──► (Mùa thi là trục trung tâm của mọi dữ liệu)
        │
        ├──► [3. Teams, Registration & Official Matches]
        │           │
        ├──► [4. Question Bank & Game Definitions]
        │           │
        └───────────┴──► [5. Game Runtime, Practice, Scoring & Replay]
                                    │
                                    ▼
                         [6. Code Judging & AI Arena Sandbox]
```

**Nguyên tắc cốt lõi bắt buộc từ Requirement:**
1. **D1 (Data-driven Seasons):** Tạo mùa mới chỉ bằng dữ liệu (không sửa code); giữ lưu trữ toàn bộ các mùa cũ (`/2025`, `/2026`...).
2. **D2 & Sec 8 (Master – Plugin Game + Config Versioning):** Mọi con số luật game không hard-code; cấu hình game theo mùa **có phiên bản**.
3. **FR-8.5 & FR-9.4 (Tách Thi thật vs Thi thử):** Kho đề thi thử tách riêng kho đề thi thật; điểm/xếp hạng thi thử hoàn toàn tách khỏi thi thật.
4. **D9 vs Q11 (Độ đồng thời):** Thi thật mỗi trận chỉ chạy **1 game tại một thời điểm** (nhưng trận gồm chuỗi nhiều game tuần tự); thi thử có thể chạy **nhiều phòng song song**.

---

## CỤM 1: Identity, Auth & RBAC (Người dùng, Vai trò & Bảo mật)

### 1.1. Nghiệp vụ & Thực thể cốt lõi
- **Tài khoản (`users`):**
  - Đăng ký / đăng nhập bằng `email` + `mật khẩu` (`FR-3.1`).
  - Có thể mở rộng OAuth (Google / tài khoản trường – `FR-3.6` `[CẦN CHỐT]`).
  - Thông tin hồ sơ cá nhân phục vụ thí sinh & BTC (`FR-3.5`).
- **Vai trò (`roles`) & Phân quyền (`user_roles`):**
  - Các vai trò nghiệp vụ (`Sec 5`):
    1. `CONTESTANT` (Thí sinh – tham gia đội, thi thử). *(Lưu ý: `Đội trưởng` là vai trò theo ngữ cảnh thành viên trong đội, không nhất thiết là role toàn cục).*
    2. `ORGANIZER` / `BTC` (quản lý mùa, web, tin tức, duyệt hồ sơ, tạo trận, sửa/duyệt đề).
    3. `MC` / `OPERATOR` (điều hành game tại hội trường: start/pause/resume/next/abort, mở câu, khóa chuông, chuyển màn chiếu).
    4. `JUDGE` (Giám khảo: xác nhận đáp án nói miệng, cộng/trừ/sửa điểm có lý do, chốt kết quả trận).
    5. `PROBLEM_SETTER` (Người ra đề: soạn, nhập, duyệt bộ đề, khóa đề cho trận, xem đề chưa công bố).
    6. `ADMIN` (Quản trị hệ thống: tài khoản, phân quyền, cấu hình hệ thống, sao lưu).
  - *(Tác nhân không phải tài khoản người dùng: `Khách` = public chưa đăng nhập; `Bot` = đội máy thi thử; `Bộ chấm ngoài` = CMS/Judge0/AI Simulator).*
- **Nhật ký bảo mật (`audit_logs` / `question_access_logs`):**
  - Ghi log **ai xem / sửa đề thi** và thời điểm thực hiện (`Sec 12`).

### 1.2. Ràng buộc & Quy tắc DB
- **Đa vai trò (`Sec 5`):** 1 `User` có thể có nhiều `Role` (`N–N`).
- **Xung đột quyền bắt buộc (`Sec 5` – dòng 94):** **"Quyền xem đề và đáp án phải tách khỏi quyền thí sinh."**
  - *Điểm cần chốt khi tạo bảng:* Quy tắc cấm trùng vai trò (`PROBLEM_SETTER` vs `CONTESTANT`) áp dụng **toàn hệ thống (theo User)** hay **theo từng Mùa (theo `(user_id, season_id)`)**?

### 1.3. Điểm nối ra ngoài
- `users.id` được tham chiếu bởi: thành viên đội (Cụm 3), người tạo/duyệt/khóa trận & đề (Cụm 3, 4), người nộp code (Cụm 6), người sửa điểm/tạo phòng thi thử (Cụm 5), tác giả bài viết/tường thuật (Cụm 2).

---

## CỤM 2: Season, Web Portal, News & Dynamic Layout (Mùa thi & Trang thông tin)

*(Cụm đầu tiên bạn dự định thiết kế SQL)*

### 2.1. Nghiệp vụ Mùa thi & Cấu hình Chung (`M1`, `FR-1.x`, `FR-4.1`, `Q6`, `Q7`)
- **Mùa thi (`seasons`):**
  - `year` là duy nhất (`UNIQUE`, dùng làm route `/{year}`, VD: `2025`, `2026`). Trùng năm phải báo lỗi (`UC-01`).
  - Nhận diện riêng (`FR-1.3`, `UC-01`): `name`, `slogan`, `logo_url`, `banner_url`, `primary_color`, `secondary_color`... (Thiếu ảnh/màu bắt buộc → không cho xuất bản).
  - Trạng thái cổng mùa: `DRAFT` (nháp / xem trước) → `PUBLISHED` (công khai) → `ARCHIVED` (lưu trữ) (`FR-1.4`, `FR-1.5`).
  - Có mốc thời gian mở / đóng đăng ký hồ sơ đội (`UC-02`).
- **Tham số thi đấu cấp Mùa (`season_settings` hoặc thuộc `seasons` – `FR-4.1`, `Q6`, `Q7`):**
  - `max_team_members` (đề xuất: 6) và `min_team_members`.
  - `match_lineup_size` (thể lệ: 5 người thi đấu mỗi trận).
  - `initial_match_score` (điểm tặng đầu trận: 20 điểm).
  - `allowed_compilers` (ngôn ngữ lập trình cho mùa: mặc định `C++17`, có thể bật `C++11`/`C++14` – `Q6`).
- **Menu điều hướng theo mùa (`season_nav_items`):**
  - Mỗi mùa có thanh menu riêng (như ảnh mẫu `thachthuc.vn`: *Trang chủ, Hackcode, Fanpage, Youtube, Liên hệ*...). Cho phép thêm/bớt/sắp xếp link nội bộ hoặc link ngoài theo từng mùa.

### 2.2. Dữ liệu Nghiệp vụ Trang Web (Chuẩn 3NF – Single Source of Truth)
Không nhét các dữ liệu sau vào JSON/HTML để tránh trùng lặp và mất toàn vẹn tham chiếu:
- **Nhà tài trợ / Đơn vị đồng hành (3 bảng `3NF`):**
  - `organizations`: thực thể công ty/đơn vị dùng chung qua các năm (`name`, `default_logo_url`, `website_url`).
  - `season_sponsor_tiers`: hạng tài trợ định nghĩa riêng theo từng mùa (`season_id`, `name` [*Vàng / Bạc / Đồng / Kim Cương...*], `sort_order`, `display_style`).
  - `season_sponsors` (placement): gán `organization_id` vào `tier_id` của mùa đó (`sort_order`, `custom_logo_url` nếu có).
- **Lịch trình mùa (`season_milestones` – `FR-1.1`, `FR-1.2`):**
  - Danh sách các mốc thời gian của mùa (`title`, `description`, `start_at`, `end_at`, `sort_order`). Hệ thống tự xác định mốc hiện tại / sắp tới.
- **Thể lệ & Tài liệu (`season_documents` – `FR-1.2`):**
  - Mỗi mùa có thể có nhiều văn bản/file PDF (Thể lệ chung, Luật Đấu trường AI, Hướng dẫn đăng ký...): `title`, `doc_type`, `version`, `content_markdown`, `pdf_url`, `sort_order`.
- **Hỏi đáp (`season_faqs` – `FR-1.2`):**
  - `season_id`, `category`, `question`, `answer`, `sort_order`.

### 2.3. Tin tức & Tường thuật trực tiếp (`M2`, `FR-2.x`, `Note 30/10`)
- **Chuyên mục (`article_categories`):** phân loại tin tức / thông báo.
- **Bài viết (`articles` – `FR-2.1`, `FR-2.2`):**
  - Gắn với `season_id` và `category_id`.
  - Trạng thái: `DRAFT` / `PUBLISHED`; lọc theo mùa, chuyên mục, tìm theo tiêu đề.
- **Tường thuật trực tiếp (`live_coverages` & `live_coverage_entries` – `FR-2.3`, `Note 30/10`):**
  - Header tường thuật: tiêu đề, trạng thái (`LIVE` / `ENDED`), `livestream_embed_url` (YouTube/Facebook Live), `archive_video_url` (lưu sau cuộc thi).
  - Các dòng cập nhật diễn biến (`entries`): `timestamp`, `content_text`, `image_url`, `is_pinned`.
  - *Điểm cần chốt:* Bài tường thuật chỉ gắn với `season_id` hay có `match_id` (gắn 1-1 hoặc 1-N với trận đấu ở Cụm 3)?

### 2.4. Bố cục Trang Động – Giải bài toán không cứng layout giữa các năm (`D1`, `FR-1.4`)
Tách riêng khỏi dữ liệu 3NF ở mục 2.2:
- **Danh mục loại Block (`block_types`):** các component UI Frontend đã đăng ký sẵn (nhóm *gắn dữ liệu 3NF*: `SPONSOR_SHOWCASE`, `TIMELINE`, `RULES_LIST`, `NEWS_FEED`, `FAQ_ACCORDION`, `RESULTS_BOARD`; nhóm *tự do*: `HERO_BANNER`, `RICH_TEXT`, `CARD_GRID`, `VIDEO_EMBED`, `SPLIT_MEDIA`...).
- **Trang theo mùa (`season_pages`):** 1 mùa có 1 hoặc nhiều trang (`slug`, `title`, `is_published`).
- **Các khối trên trang (`page_blocks`):** thuộc riêng về `page_id` (`1 Season -> N Pages -> N Blocks`), có `block_type_code`, `sort_order`, `variant`, `is_visible`.
  - **Nếu là Block gắn dữ liệu 3NF:** KHÔNG chứa bản sao dữ liệu; Backend tự query từ các bảng ở mục 2.2 theo `season_id` khi trả API.
  - **Nếu là Block tự do:** Chọn 1 trong 2 phương án thiết kế DB:
    - *Phương án A:* Lưu payload nội dung vào cột `content_json JSONB` trên `page_blocks` (validate schema tại NestJS).
    - *Phương án B:* Tạo các bảng Subtype `1–1` / `1–N` thuần quan hệ (`block_heroes`, `block_rich_texts`, `block_card_grids` + `block_card_items`...) nối bằng FK kép `(block_id, block_type_code)` + `CHECK`.

---

## CỤM 3: Teams, Registration & Official Tournament (Đội thi, Hồ sơ & Giải đấu Chính thức)

### 3.1. Đội thi & Hồ sơ Đăng ký Mùa (`M3`, `FR-3.2`–`FR-3.4`, `UC-02`, `UC-03`, `Q7`)
- **Đội thi (`teams`) & Thành viên (`team_members`):**
  - Đội trưởng tạo đội, sinh mã/link mời (`invite_code`); thí sinh xác nhận lời mời tham gia (`PENDING` → `ACCEPTED`).
  - **Ràng buộc cứng (`FR-3.2`):** **1 người không được ở 2 đội trong cùng 1 mùa.**
  - *Điểm cần chốt:* `teams` gắn cứng với `season_id` (mỗi mùa tạo record đội mới) HAY `teams` xuyên suốt nhiều năm rồi đăng ký qua bảng `season_registrations`? *(Nếu chọn xuyên mùa, `team_members` vẫn bắt buộc phải có phạm vi theo mùa để giữ đúng ràng buộc FR-3.2).*
- **Hồ sơ đăng ký mùa (thuộc `teams` hoặc `season_registrations`):**
  - **State machine trạng thái (`FR-3.3`):**
    `DRAFT` (Nháp) → `PENDING` (Chờ duyệt) → `NEEDS_REVISION` (Cần bổ sung) → `APPROVED` (Đã duyệt) / `REJECTED` (Từ chối) / `WITHDRAWN` (Đã rút).
  - **Ràng buộc chuyển trạng thái (`UC-02`, `UC-03`):**
    - Chỉ gửi được trong thời hạn mở đăng ký của mùa và khi đủ số lượng thành viên tối thiểu (tối đa theo `max_team_members`, VD 6).
    - BTC duyệt / từ chối / yêu cầu bổ sung phải lưu **lý do** (`review_note`) + `reviewed_by` + `reviewed_at`.
    - Hồ sơ đã `WITHDRAWN` (đội tự rút) thì **không thể duyệt**.
    - Chỉ đội có trạng thái `APPROVED` mới được đưa vào danh sách bốc thăm / xếp trận chính thức.

### 3.2. Vòng thi & Trận đấu Chính thức (`M4`, `Sec 1.1`, `FR-4.2`–`FR-4.5`, `UC-04`, `FR-10.1`)
- **Vòng thi (`rounds`):**
  - Thuộc `season_id`. Theo thể lệ (`Sec 1.1`):
    1. `PRELIMINARY` (Sơ tuyển trắc nghiệm – `[CẦN CHỐT Q13]`: thi cá nhân theo ca → cộng dồn điểm sang điểm đội → lấy Top 18).
    2. `QUALIFIER` (Vòng loại: 6 trận × 3 đội = 18 đội → lấy 6 nhất + 3 nhì cao điểm nhất = 9 đội).
    3. `SEMIFINAL` (Bán kết: 3 trận × 3 đội = 9 đội → lấy 3 đội).
    4. `FINAL` (Chung kết: 1 trận × 3 đội).
    5. `PLAYOFF` (Trận phụ khi bằng điểm lúc xét chuyển vòng – `FR-4.4`).
- **Trận đấu chính thức (`matches`):**
  - Thuộc `round_id`.
  - Thông tin lịch & vận hành (`FR-4.2`, `FR-4.5`): `match_code`, `scheduled_at`, `venue_room` (phòng/địa điểm), `match_type` (`OFFICIAL` / `PLAYOFF`), `pairing_method` (`MANUAL` / `DRAW`), `created_by` (lưu người thực hiện ghép đội), `status` (`DRAFT` → `LOCKED` → `IN_PROGRESS` → `PROVISIONAL` → `FINALIZED`), `is_published` (chưa công bố thì khách chưa xem lại được – `UC-08`).
  - **Cảnh báo nghiệp vụ (`UC-04`):** Kiểm tra đội trùng lịch thi đấu khi xếp trận.
- **Đội tham gia trận (`match_teams`):**
  - Mỗi trận chính thức có **đúng 3 đội** (`slot_order` 1, 2, 3; mỗi đội gán màu đại diện).
  - Điểm khởi đầu trận (`initial_score` theo cấu hình mùa, mặc định 20đ), tổng điểm cuối trận (`final_score`), thứ hạng (`rank`), cờ đi tiếp (`is_qualified` – `FR-10.1`).
- **Đội hình ra sân của trận (`match_lineups` – `Sec 1.1`, `Q7`):**
  - Hồ sơ mùa cho phép tối đa 6 thành viên, nhưng mỗi trận chỉ chọn **5 thành viên thi đấu suốt trận** (và **1 thành viên** nếu là trận `PLAYOFF`).
  - *Ràng buộc:* Thành viên trong `match_lineups` bắt buộc phải là thành viên hợp lệ (`ACCEPTED`) của đúng `team_id` trong mùa đó.
- **Chuỗi Game được chọn cho trận (`match_games` – `FR-4.3`, `UC-04`, `D9`):**
  - 1 Trận gồm chuỗi `N` Game chơi theo thứ tự (`sequence_order` = 1, 2, 3...).
  - Mỗi slot `match_games` gắn với: 1 loại Game (`game_id`), 1 phiên bản cấu hình luật (`game_config_id`), và 1 bộ đề đã duyệt (`question_set_id`).
  - **Ràng buộc khóa (`UC-04`):** Không thể chuyển trận sang `LOCKED` nếu có `match_games` chưa gắn bộ đề ở trạng thái `APPROVED`. Khi đã khóa trận, đề thi gắn với trận bị khóa không được sửa.

---

## CỤM 4: Question Bank & Game Definitions (Danh mục Game & Ngân hàng Đề)

### 4.1. Danh mục Game & Cấu hình Luật theo Mùa (`M6`, `Q1`, `Sec 8`, `Sec 9`)
- **Danh mục Game (`games`):**
  - Toàn hệ thống đăng ký plugin cho 7 game (`Q1` đề xuất giữ cả 7 dưới dạng plugin):
    1. `KHOI_DONG` (Khởi động)
    2. `LAP_TRINH_TIEP_SUC` (Lập trình tiếp sức)
    3. `TRUY_TIM_LOI_AN` (Truy tìm lỗi ẩn)
    4. `DAU_TRUONG_AI` (Đấu trường AI)
    5. `VE_DICH` (Về đích – *lưu ý cần chốt với nhóm xem gộp hay tách khỏi Đối đầu trực tiếp theo dòng 217 vs Q2*)
    6. `DOI_DAU_TRUC_TIEP` (Đối đầu trực tiếp)
    7. `AI_THONG_MINH_HON` (Ai thông minh hơn)
- **Kích hoạt & Phiên bản Cấu hình Game theo Mùa (`season_game_configs` – `FR-4.1`, `Sec 8`, `Sec 9`):**
  - Xác định mùa `season_id` sử dụng những game nào (`is_enabled`).
  - Lưu **phiên bản cấu hình (`version`)** chứa các tham số luật (thời gian lượt, điểm cộng/trừ, mức cược tối đa, có cho cược hay không, ngôn ngữ C++...) để trận đã đấu cũ luôn đối chiếu đúng phiên bản luật lúc thi.

### 4.2. Quản trị Bộ đề & Bảo mật (`M8`, `FR-8.1`–`FR-8.5`, `UC-09`, `Sec 12`)
- **Kho đề tách biệt môi trường (`FR-8.5`):**
  - Mọi bộ đề (`question_sets`) bắt buộc phân loại môi trường: `OFFICIAL` (thi thật – bảo mật nghiêm ngặt) vs `PRACTICE` (thi thử công khai: dataset APPS, DebugBench, tự soạn – `Sec 14`).
- **Bộ đề (`question_sets`):**
  - Thuộc `game_id` (và tùy chọn `season_id`).
  - Trạng thái (`FR-8.3`): `DRAFT` (Nháp) → `APPROVED` (Đã duyệt) → `LOCKED` (Đã khóa cho trận).
  - Lưu người tạo, người duyệt, thời điểm, nguồn nhập (`EXCEL`, `ZIP`, `MANUAL`, `DATASET`).
  - **Cơ chế thay câu dự phòng (`UC-05`):** Bộ đề hoặc ngân hàng câu cần phân biệt câu chính thức và câu dự phòng (`is_backup`) để MC/Giám khảo thay khi lộ từ khóa hoặc câu lỗi.
  - **Bảo mật (`FR-8.4`, `Sec 12`):** Chỉ `PROBLEM_SETTER` (hoặc role được cấp) xem được đề chưa công bố; **test ẩn không bao giờ trả xuống API trình duyệt**; ghi log mỗi lần xem/sửa.

### 4.3. Cấu trúc Dữ liệu Đề đặc thù từng Game (`Sec 8`, `Note 13/11`)
*(Phần này cần cân nhắc tách bảng chi tiết theo nhóm loại đề để giữ chuẩn 3NF thay vì nhồi hết vào 1 bảng):*

1. **Khởi động (`KHOI_DONG`):**
   - Mỗi lượt đội là bộ **10 cụm từ tiếng Anh CNTT** (`keyword`, `description_hint`, `forbidden_words` nếu có, `order_index`).
2. **Lập trình tiếp sức (`LAP_TRINH_TIEP_SUC`):**
   - **1 bài lập trình** (vòng Chung kết: **2 bài** – `Note 13/11`).
   - Gồm: đề bài (`statement_markdown`), giới hạn thời gian/bộ nhớ (`time_limit_ms`, `memory_limit_mb`), file checker (nếu có), và danh sách **Test cases** (`input`, `expected_output`, `is_sample` / `is_hidden`, `score_weight` — tổng 100đ chia đều các test).
3. **Truy tìm lỗi ẩn (`TRUY_TIM_LOI_AN`):**
   - Mỗi bộ gồm **3–5 file C++ lỗi**: `file_name`, `buggy_source_code`, `max_score`, `sort_order`, kèm danh sách **Test cases** riêng cho từng file đó (`input`, `expected_output`, `is_hidden`).
4. **Đấu trường AI (`DAU_TRUONG_AI`):**
   - **Bản đồ lục giác (tọa độ cube `(q, r, s)`):** bán kính `8–15`, đối xứng xoay `120°`, tổng `300 vàng`, `3 khiên`, tọa độ vật cản, tọa độ spawn 3 thuyền, tham số lượt `K = 50–150` và khoảng xuất hiện kho báu tại `(0,0,0)` (`0.5K–0.6K`). Một trận gồm **5 hiệp**, mỗi hiệp chọn 1 map.
5. **Đối đầu trực tiếp (`DOI_DAU_TRUC_TIEP`):**
   - Bản đồ cố định/cấu hình gồm **6 thành phố + 1 thủ đô** và đồ thị cạnh liền kề giữa các ô.
   - Bộ **9 câu hỏi** (`question_text`, `answer_text`, `order_index` 1..9).
6. **Ai thông minh hơn (`AI_THONG_MINH_HON`):**
   - 1 đối tượng chủ đề: `cover_image_url`, `main_keyword` (từ khóa chủ đề), danh sách đáp án chấp nhận.
   - Lưới `3×4` gồm **12 mảnh ghép (`puzzle_pieces`):** `row` (1..3), `col` (1..4), gắn với **1 câu hỏi + đáp án**.
7. **Sơ tuyển trắc nghiệm (`PRELIMINARY` – `[CẦN CHỐT Q13]`):**
   - Ngân hàng câu hỏi trắc nghiệm (nội dung, 4 đáp án lựa chọn, đáp án đúng), **Ca thi (`exam_shifts`)**, bài làm cá nhân của thí sinh (`attempt_answers`) → chấm tự động và cộng dồn thành điểm đội.

---

## CỤM 5: Game Runtime, Practice Rooms, Betting & Replay (Vận hành, Thi thử, Đặt cược & Lịch sử)

### 5.1. Hai ngữ cảnh tạo Phiên chơi Game (`D2`, `M5`, `M9`, `FR-9.1`–`FR-9.5`, `UC-07`)
Mọi game đều chạy thông qua **Master Interface (`Sec 9`)**, nhưng xuất phát từ 2 ngữ cảnh tách biệt:
1. **Thi thật (`OFFICIAL`):** gắn vào 1 slot `match_games` thuộc `matches` (Cụm 3).
2. **Thi thử (`PRACTICE` / `SCRIMMAGE`):** tạo bởi người dùng trong **Phòng thi thử (`practice_rooms`)** – không thuộc `rounds`/`matches` chính thức:
   - *Phòng luyện với Bot (`FR-9.1`, `UC-07`):* 1 người chơi (hoặc 1 đội) + **2 Bot** (lưu `bot_difficulty`: Dễ / Trung bình / Khó). Nếu bỏ ngang giữa chừng → hủy ván, không lưu điểm (`UC-07`).
   - *Phòng giao lưu 3 đội online (`FR-9.2`, `UF4`):* Chủ phòng tạo mã mời (`room_code`), 3 đội tham gia, chọn chuỗi game.
   - *(Could `FR-9.5`):* Tự tạo giải giao lưu nhiều trận.
   - Chạy nhiều phòng song song độc lập (`FR-9.3`, `Q11`).
   - *Điểm cần chốt cho thiết kế DB:* Giữa bảng `match_games` (thi thật) và `practice_room_games` (thi thử), bạn muốn dùng chung 1 bảng `game_sessions` có phân nhánh rõ ràng, hay tách hẳn luồng bảng `Official` và `Practice` để tránh FK nullable / đa hình?

### 5.2. Phiên Game, Vòng đời & Kết quả (`FR-5.2`, `FR-5.5`, `Sec 9`)
- **Phiên Game (`game_sessions`):**
  - `seed` ngẫu nhiên, tham chiếu `question_set_id` & `game_config_id`.
  - **Vòng đời (`FR-5.2`):** `PREPARING` → `READY` → `RUNNING` ⇄ `PAUSED` → `FINISHED` / `ABORTED`.
  - Thời điểm bắt đầu, thời điểm tạm dừng/tiếp tục, đồng hồ đếm ngược máy chủ (`server_clock` – mất kết nối không được cộng giờ).
- **Bảng điểm chi tiết theo đội trong từng Game (`game_session_scores`):**
  - Điểm gốc đạt được (`base_score`), điểm thưởng (`bonus_score`), điểm phạt (`penalty_score`), điểm cược (`bet_delta`), tổng điểm game (`total_game_score`).

### 5.3. Đặt cược (`Sec 1.1`, `FR-5.8`, `Q12`)
- **Thực thể Đặt cược (`match_bets`):**
  - Áp dụng cho các game có luật cược (*Lập trình tiếp sức*, *Truy tìm lỗi ẩn*, *Ai thông minh hơn*).
  - **Ràng buộc cứng 1 (`Sec 1.1`):** **Tối đa 1 lần / trận / đội** → `UNIQUE (match_id, team_id)` (hoặc `UNIQUE (match_team_id)`).
  - **Ràng buộc cứng 2:** Chỉ được đặt cho 1 `match_game_id` thuộc đúng `match_id` đó và game đó phải cho phép cược; thời điểm đặt **trước khi game chuyển sang `RUNNING`**.
  - **Ràng buộc giá trị (`Sec 1.1`):** `1 <= bet_amount <= max(1, min(60, current_match_score))`.
  - Lưu nguồn ghi nhận: đội tự đặt trên hệ thống hoặc trọng tài nhập tay (`entered_by_judge_id` – `Q12`).

### 5.4. Điều chỉnh Điểm, Chuông & Nhật ký Sự kiện để Replay (`FR-5.4`, `FR-5.6`, `FR-10.3`, `UC-08`)
- **Lịch sử Giám khảo sửa điểm (`score_adjustments` – `FR-5.6`):**
  - Khi Giám khảo cộng/trừ/sửa điểm phải ghi: `game_session_id`, `team_id`, `delta_score`, **`reason` (bắt buộc NOT NULL)**, `adjusted_by` (Judge), `adjusted_at`.
- **Log sự kiện & Chuông (`game_event_logs` – `FR-5.4`, `FR-10.3`, `Sec 9`, `Sec 12`):**
  - Lưu tuần tự theo `sequence_no` + `server_timestamp_ms` (để xử lý tranh chấp thứ tự bấm chuông / nộp bài, chống gửi lặp `idempotency_key`).
  - Chứa `event_type` (mở câu, bấm chuông, trả lời đúng/sai, đặt cược, chiếm thành phố, lật mảnh, sửa điểm...) và `payload` trạng thái bảng điểm tại thời điểm đó để phục vụ **Xem lại trận dạng interactive (`FR-10.3`, `UC-08`)** – tua theo từng câu/lượt.

---

## CỤM 6: Code Judging, Sandbox & AI Arena Execution (Chấm Code & Đấu trường AI)

### 6.1. Chấm bài Lập trình (`M7`, `FR-7.1`–`FR-7.4`, `UC-06`, `Q5`, `Q6`)
*(Phục vụ Lập trình tiếp sức và Truy tìm lỗi ẩn)*
- **Lần nộp bài (`code_submissions`):**
  - Gắn với: `game_session_id`, `team_id` (hoặc slot đội), **`submitted_by_user_id`** (thành viên cụ thể – bắt buộc thuộc `match_lineups` nếu là thi thật), `problem_id` hoặc `buggy_file_id` (tùy game).
  - Thông tin nộp: `source_code`, `language_compiler` (C++14/17...), `submitted_at` (server time), `judge_provider` (`CMS` / `JUDGE0` – `Q5`), `queue_status` (`QUEUED` / `JUDGING` / `DONE` / `ERROR`).
  - Kết quả tổng: `verdict` (`AC`, `WA`, `TLE`, `CE`, `RE`, `SYSTEM_ERROR`), `score`, `execution_time_ms`, `memory_kb`.
  - **Nghiệp vụ riêng *Lập trình tiếp sức* (`Sec 8`, `Note 13/11`):**
    - Có theo dõi thứ tự lượt lên code của 5 thành viên (`turn_order`, mỗi người ít nhất 1 lần).
    - Hỗ trợ thao tác **bấm chuông chốt bài (không nộp qua hệ thống)** để Giám khảo xét *Điểm thưởng Tự tin* (`+40đ` / `-20đ`).
  - **Nghiệp vụ riêng *Truy tìm lỗi ẩn* (`Sec 8`):**
    - Theo cặp `(session, team, file)`: đếm số lần nộp sai để tính `-10%` mỗi lần (10 lần về `0`), đánh dấu `is_first_solve` (`+20%`), và đánh dấu đội giải xong toàn bộ tất cả file (`+20đ`).
- **Kết quả từng Test Case (`submission_test_results` – `FR-7.1`):**
  - `1 code_submission` → `N test_results` (ứng với từng test case của bài): `test_case_id`, `verdict`, `time_ms`, `memory_kb`. *(Test ẩn chỉ lưu verdict/điểm, tuyệt đối không trả input/output ẩn xuống client thí sinh – `FR-8.4`).*

### 6.2. Đấu trường AI (`Sec 8`, `FR-7.3`, `Q9`)
- **Quản lý Agent (`ai_agents`):**
  - Thuộc `team_id` (và `season_id` hoặc `practice`).
  - **Ràng buộc (`Sec 8`):** Tối đa **5 agent / đội**, file binary Linux `≤ 200MB` (`file_path`, `file_size_bytes`, `checksum`, `uploaded_by`, `uploaded_at`).
- **Hiệp đấu & Log từng lượt (`ai_arena_rounds` & `ai_arena_turn_logs` – `Sec 8`):**
  - 1 phiên Đấu trường AI gồm **5 hiệp** (mỗi hiệp chọn 1 map + chọn agent đại diện của mỗi đội).
  - Kết quả từng hiệp: hạng 1 (`+20đ`, hiệp 5 `+40đ`), hạng 2 (`+10đ`, hiệp 5 `+20đ`).
  - Mỗi hiệp chạy `K = 50–150` lượt: lưu log trạng thái từng lượt (tọa độ thuyền, vàng, khiên, tên lửa bắn/trúng, va chạm, kho báu) để hiển thị animation trực tiếp và xem lại.

---

## Bảng Tổng hợp các Quyết định Cần Chốt Trước khi Vẽ Sơ đồ Chi tiết

| # | Điểm cần chốt | Ảnh hưởng trực tiếp tới Thiết kế SQL / FK |
| :--- | :--- | :--- |
| **1** | **Block tự do của Web (Cụm 2):** Chọn `JSONB` trên `page_blocks` hay tách bảng Subtype `1–1`? | Quyết định số lượng bảng của phần CMS Web (gọn 3–4 bảng vs ~10 bảng Subtype). |
| **2** | **Tường thuật trực tiếp (Cụm 2):** Gắn theo `Season` hay gắn trực tiếp với `Match`? | Thêm hoặc bỏ FK `live_coverages.match_id -> matches.id`. |
| **3** | **Phạm vi tách quyền `Người ra đề` vs `Thí sinh` (Cụm 1):** Toàn hệ thống hay theo Mùa? | Kiểm tra xung đột trên bảng `user_roles` toàn cục hay bảng `season_user_roles`. |
| **4** | **Vòng đời `Team` (Cụm 3):** Tạo mới theo từng `Season` hay tồn tại xuyên mùa? | Quyết định `teams.season_id` có `NOT NULL` hay phải qua bảng `season_registrations`. |
| **5** | **Thi thử với Bot (Cụm 5):** Người chơi đơn lẻ (`User`) được chơi luôn hay phải tạo `Team` 1 người? | Quyết định cấu trúc bảng thành viên tham gia `practice_rooms` (trỏ tới `User` hay `Team`). |
| **6** | **Tách/Gộp `Official` và `Practice` ở bảng `game_sessions` (Cụm 5):** | Quyết định dùng 1 bảng `game_sessions` chung interface Master–Plugin hay 2 luồng tách biệt hoàn toàn (tránh polymorphic FK). |
| **7** | **`Về đích` vs `Đối đầu trực tiếp` (Cụm 4):** Là 1 game hay 2 game riêng? | Quyết định danh sách bản ghi cấu hình & schema đề trong `games`. |
| **8** | **Phạm vi `Sơ tuyển trắc nghiệm` (Cụm 3 & 4 – `Q13`):** Có làm trong schema đợt này luôn không? | Thêm hay chưa thêm cụm bảng `exam_shifts`, `mcq_questions`, `preliminary_attempts`. |

---

## Tham số Mặc định cần Lưu thành Cấu hình Mùa (Không Hard-code)

- Số thành viên tối đa đăng ký đội: `6` (`Q7`); số người thi chính thức mỗi trận: `5` (`Sec 1.1`).
- Điểm tặng đầu trận: `20` (`Sec 1.1`).
- Giới hạn đặt cược: `1` đến `max(1, min(60, điểm hiện có))`, tối đa `1 lần / trận / đội` (`Sec 1.1`).
- Trình biên dịch mặc định: `C++17` (có thể bật `C++11`/`C++14` – `Q6`).
- Giới hạn Sandbox Đấu trường AI: binary `≤ 200MB`, `RAM 4GB`, `1.5s/lượt`, tối đa `5 agent/đội`, `6 tên lửa/trận`, `300 vàng`, `3 khiên`, `K = 50–150` lượt, `5 hiệp` (`FR-7.3`, `Sec 8`).
