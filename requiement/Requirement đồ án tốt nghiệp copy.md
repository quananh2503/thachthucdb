# **Requirement đồ án tốt nghiệp – Hệ thống quản lý cuộc thi Thách Thức**

*Phiên bản 0.2 – cập nhật 13/11/2026. Tổng hợp từ: bản requirement ban đầu của nhóm, Thể lệ các trò chơi Thách Thức 2025 (v2.51), luật Đấu trường AI 2026 (bản Final), Khung đề tài & MVP (24/10), Kế hoạch prototype (24/10), Dàn ý tổng quan, buổi họp với thầy 30/10, buổi họp với thầy và bạn kỹ thuật 13/11, bảng phân công và Jira.*

**Quy ước:** **\[CẦN CHỐT\]** \= nhóm cần ra quyết định; **\[CẦN BỔ SUNG\]** \= cần thành viên tìm hiểu/viết thêm. Mỗi mục có ghi người đề xuất phụ trách (theo bảng phân công v2), nhóm có thể đổi.

## **1\. Giới thiệu chung**

Hệ thống quản lý cuộc thi học thuật Thách Thức (Khoa CNTT – HCMUS, tổ chức từ 2001, mùa 2025 gần 700 thí sinh). Hệ thống cung cấp thông tin, thể lệ, tin tức cuộc thi (bao gồm lịch sử thi đấu theo dạng interactive); hệ thống thi thử và thi thật (đủ 3 đội chơi hoặc theo hướng 1 đội \+ 2 bot); có thể tích hợp các game mới dưới dạng plugin.

**Mục tiêu (target) đã chốt ở buổi họp 13/11:** 3 đội có thể chơi được, giả lập (simulate) trên web; làm practice mode trước; kiến trúc master – plugin game; nhóm xây lại từ đầu, chỉ tham khảo hệ thống cũ.

### **1.1. Bối cảnh cuộc thi (theo thể lệ hiện hành)**

* Sơ tuyển trắc nghiệm cá nhân, cộng dồn thành điểm đội, lấy Top 18 đội.  
* Thi chính thức: 6 trận Vòng loại → 6 đội nhất \+ 3 đội nhì điểm cao nhất → 3 trận Bán kết → Chung kết 3 đội.  
* Mỗi trận luôn có 3 đội; mỗi đội 5 thành viên thi đấu suốt trận; mỗi đội được tặng 20 điểm đầu trận; các game trong trận do BTC công bố trong ngày thi.  
* Bằng điểm thì đấu play-off (mỗi đội cử 1 người, hình thức do BTC quyết định).  
* Một số game có đặt cược (1 lần/trận/đội, 1 → max(1, min(60, điểm hiện có)), đặt trước khi bắt đầu game).

### **1.2. Hệ thống cũ (tham khảo, theo bạn kỹ thuật 13/11)**

* Stack cũ: React, NodeJS, MongoDB; đang là bản V2 (dùng khoảng 2–3 năm, V1 đã bị viết lại).  
* Năm ngoái host trên Azure; năm nay chạy local qua LAN/Wi-Fi, laptop làm máy chủ (internet hội trường hạn chế).  
* Mỗi lần chỉ chạy 1 game, chưa chạy nhiều instance song song.  
* Phần cực nhất khi vận hành là cài đặt máy thí sinh (Lập trình tiếp sức và Truy tìm lỗi ẩn cần môi trường khác nhau).  
* Lập trình tiếp sức chấm bằng hệ thống bên ngoài (CMS); app chỉ ghi điểm, tính giờ, rung chuông đổi lượt.  
* Màn hình ngày thi: 3 màn đội \+ màn chiếu sau sân khấu \+ màn bên hông \+ máy admin; dùng OBS chuyển cảnh. BTC/MC chỉ mở màn hình chiếu và kết quả.  
* Mã nguồn cũ thuộc Khoa – muốn xem phải xin phép thầy.

## **2\. Phạm vi**

| Hạng mục | Trong phạm vi đồ án | Ngoài phạm vi / để sau |
| :---- | :---- | :---- |
| Thông tin | Trang thông tin riêng cho từng năm (cùng cấu trúc, khác nhận diện), tin tức, thông báo, tường thuật bằng bài viết \+ nhúng livestream | Tự xây nền tảng truyền video |
| Đăng ký | Tài khoản, đội, hồ sơ theo mùa, BTC duyệt | Thanh toán lệ phí online |
| Game | Các game trong danh sách mục 8, chạy được ở chế độ thi thử và thi thật | App điện thoại |
| Thi | Thi thử (1 đội \+ 2 bot, hoặc 3 đội online), thi thật tại hội trường qua LAN | Giám sát chống gian lận bằng camera |
| Kết quả | Bảng điểm trận, kết quả theo vòng, lịch sử trận xem lại dạng interactive | – |
| Sơ tuyển trắc nghiệm | **\[CẦN CHỐT\]** Có làm hay không (requirement cũ có, bản hiện tại chưa nhắc) |  |

## **3\. Các quyết định đã chốt**

| \# | Quyết định | Nguồn |
| :---- | :---- | :---- |
| D1 | Mỗi năm có một trang mùa thi riêng theo mô hình website hội nghị thường niên; tạo mùa mới chỉ bằng dữ liệu, không sửa code | Họp thầy 30/10 |
| D2 | Kiến trúc master – plugin: master truyền đầu vào (đội, màu, cấu hình…) cho game; game trả kết quả về master; mọi game tuân theo một interface chung | Họp thầy 30/10, 13/11 |
| D3 | Thi thử trước: 3 đội chơi được, hoặc 1 đội \+ 2 bot | Họp 30/10, 13/11 |
| D4 | Có chế độ thi offline tại hội trường, thi online giao lưu giữa các đội và đấu với bot | Họp thầy 30/10 |
| D5 | Bảo mật: không cho chạy code tấn công từ xa (RCE); không lộ đề trước vòng chính thức | Requirement nhóm |
| D6 | Backend NestJS | Requirement nhóm |
| D7 | Dataset thi thử: APPS (Lập trình tiếp sức), DebugBench (Truy tìm lỗi ẩn) | Requirement nhóm |
| D8 | Nhóm xây lại từ đầu, chỉ tham khảo hệ thống V2 | Họp 13/11 |
| D9 | Mỗi trận chỉ chạy 1 game tại một thời điểm (thi thật) | Họp 13/11 |

## **4\. Các vấn đề cần nhóm chốt**

Mỗi dòng có phương án đề xuất để nhóm làm tiếp được ngay; khi chốt, chuyển dòng đó sang mục 3\.

| \# | Vấn đề | Các phương án | Đề xuất | Người chốt |
| :---- | :---- | :---- | :---- | :---- |
| Q1 | Danh sách game: bản này ghi 5 game (có **Về đích**), các tài liệu trước có 6 game gồm **Đối đầu trực tiếp** và **Ai thông minh hơn** | (a) 5 game như bản hiện tại; (b) 6 game cũ; (c) cả 7, cấu hình theo mùa | (c): kiến trúc plugin nên giữ được cả 7; ưu tiên làm theo danh sách mùa 2026–2027. Đối đầu trực tiếp đã có code trong prototype | Cả nhóm \+ thầy |
| Q2 | Luật game **Về đích** | – | **\[CẦN BỔ SUNG\]** Tìm thể lệ / hỏi thầy | Bảo |
| Q3 | Frontend: React/Vite (requirement) hay Next.js (prototype đang dùng Next.js 16\) | (a) React/Vite SPA; (b) giữ Next.js | Next.js cho trang công khai (SEO, đã có sẵn trang mùa, tin tức); có thể dùng React thuần cho màn hình game | Bảo, Anh |
| Q4 | Cơ sở dữ liệu (đang để ????) | PostgreSQL / MongoDB (hệ cũ) / Supabase | PostgreSQL: dữ liệu quan hệ rõ (mùa – đội – trận – điểm); nhánh build đã nối PostgreSQL | Anh, Huy |
| Q5 | Bộ chấm code: CMS (requirement, thể lệ 2025 dùng CMS) hay Judge0 (nhánh build đã dựng) | (a) CMS; (b) Judge0; (c) chấm qua lớp adapter, hỗ trợ cả hai | (c): game gọi một API chấm chung; thi thật dùng CMS cho giống thực tế, thi thử dùng Judge0 cho nhẹ | Huy |
| Q6 | Ngôn ngữ và trình biên dịch cho game lập trình | Thể lệ 2025: C/C++ (C++11, VS2022/CodeBlocks/DevC++); bạn kỹ thuật: C++14/C++17 | Cấu hình theo mùa; mặc định C++17, có thể bật C++11/14 | Huy |
| Q7 | Số thành viên đội | Thể lệ: 5 người thi đấu; trang đăng ký/prototype: tối đa 6 | Đăng ký tối đa 6, mỗi trận chọn 5 người thi; cả hai là tham số mùa | Phúc |
| Q8 | Cách triển khai | (a) Chạy LAN offline trên laptop; (b) cloud; (c) cả hai | (c): Docker Compose chạy được offline cho thi thật, bản cloud cho trang công khai và thi thử | Huy |
| Q9 | Đấu trường AI: tự xây trình mô phỏng hay dùng lại của BTC/nhóm khác | – | Hỏi thầy. Nếu tự xây: theo đúng luật 2026 (agent binary Linux, đọc MAP.INP, ghi ACT.OUT) | Bảo |
| Q10 | Có game cho khán giả không (năm trước Hackcode chạy trên HackerRank) | Không / mini game xem – dự đoán / Hackcode | Để sau MVP | Thầy |
| Q11 | Thi thử có chạy nhiều phòng song song không | – | Có: mỗi phòng là một instance game riêng (hệ cũ chưa làm được) | Bảo, Huy |
| Q12 | Đặt cược và bấm chuông: hệ thống ghi nhận hay vẫn làm tay (giấy \+ chuông vật lý) | – | Hệ thống ghi nhận cược và thứ tự chuông theo giờ máy chủ; vẫn cho trọng tài nhập tay khi có sự cố | Cả nhóm |
| Q13 | Sơ tuyển trắc nghiệm có trong phạm vi không | – | Có ở mức cơ bản (ngân hàng câu, ca thi, chấm tự động) nếu kịp thời gian | Thầy |
| Q14 | Hạn bảo vệ/nộp và mốc gặp thầy | Thầy: gặp khoảng 2–3 tuần/lần | **\[CẦN BỔ SUNG\]** Ghi ngày cụ thể | Bảo |
| Q15 | License dataset (APPS, DebugBench) và cách chuyển sang định dạng đề của hệ thống | – | **\[CẦN BỔ SUNG\]** Kiểm tra license, viết script chuyển đổi | Huy, Thịnh |

## **5\. Actor**

| Actor | Mô tả | Chức năng chính |
| :---- | :---- | :---- |
| Khách | Người chưa đăng nhập | Xem trang mùa, tin tức, thể lệ, kết quả, xem trận đang diễn ra và xem lại trận |
| Thí sinh | Người có tài khoản | Hồ sơ cá nhân, tham gia đội, thi thử với bot hoặc với đội khác |
| Đội trưởng | Thí sinh tạo đội | Tạo đội, mời thành viên, gửi/rút hồ sơ đăng ký mùa |
| Đội chơi | Đội đang trong một trận | Thao tác theo game: chọn câu, trả lời, nộp code, nộp agent, đặt cược |
| Ban tổ chức (BTC) | Quản lý cuộc thi | Quản lý mùa, trang mùa, tin tức/tường thuật, duyệt hồ sơ, tạo trận, chọn game, nhập đề |
| Điều hành / MC | Người chạy trận tại hội trường | Bắt đầu/tạm dừng/tiếp tục/kết thúc game, mở câu, khóa chuông, chuyển màn hình chiếu |
| Giám khảo | Người chấm và xử lý tình huống | Xác nhận đáp án nói miệng, cộng/trừ điểm có lý do, chốt kết quả trận |
| Người ra đề | Có quyền xem đề chưa công bố | Soạn, nhập, duyệt bộ đề; khóa đề cho trận |
| Quản trị viên | Quản trị hệ thống | Tài khoản, phân quyền, cấu hình hệ thống, sao lưu |
| Bot (hệ thống) | Đội máy | Lấp chỗ trống trong thi thử, dùng chung giao thức với đội người |
| Bộ chấm (hệ thống ngoài) | CMS / Judge0 / trình mô phỏng Đấu trường AI | Chạy code trong sandbox, trả kết quả |

Một người có thể có nhiều vai trò, nhưng quyền xem đề và đáp án phải tách khỏi quyền thí sinh.

## **6\. Module**

| Mã | Module | Nội dung | Đề xuất phụ trách |
| :---- | :---- | :---- | :---- |
| M1 | Cổng thông tin theo năm | Trang chủ, trang mùa (giới thiệu, chủ đề, thể lệ, lịch trình, hướng dẫn đăng ký, thông báo, đơn vị đồng hành, FAQ, kết quả), nhận diện theo năm, lưu trữ các năm | Anh, Duy |
| M2 | Tin tức & tường thuật | CMS bài viết, thông báo, bài tường thuật trực tiếp có mốc giờ, nhúng livestream, tự cập nhật | Thịnh |
| M3 | Tài khoản & đội | Đăng ký/đăng nhập, phân quyền, đội, hồ sơ theo mùa, BTC duyệt, xuất danh sách | Phúc |
| M4 | Quản lý mùa & trận | Mùa, vòng (sơ tuyển, loại, bán kết, chung kết), trận 3 đội, chọn game cho trận, lịch, chuyển vòng, play-off | Bảo, Phúc |
| M5 | Game master (khung plugin) | Interface game, vòng đời, đồng hồ máy chủ, phòng realtime, các màn hình (đội, điều khiển, chiếu, giám khảo), log sự kiện | Bảo |
| M6 | Các game | Plugin cho từng game (mục 8\) | Theo game |
| M7 | Chấm code & sandbox | Adapter tới CMS/Judge0, chạy agent Đấu trường AI cách ly, hàng đợi, giới hạn tài nguyên | Huy |
| M8 | Quản trị đề | Ngân hàng câu hỏi/đề theo game, nhập Excel/zip, duyệt, khóa đề, phân quyền xem | Bảo, Thịnh |
| M9 | Thi thử | Phòng luyện 1 đội \+ 2 bot, phòng giao lưu 3 đội online, dữ liệu tách khỏi thi thật | Bảo, Huy |
| M10 | Kết quả & lịch sử | Bảng điểm trận, kết quả vòng, trang đội, xem lại trận theo từng lượt (interactive) | Thịnh |
| M11 | Vận hành | Triển khai LAN/cloud, sao lưu, nhật ký, giám sát, hướng dẫn cài máy thí sinh | Huy |

## **7\. Yêu cầu chức năng**

Mức ưu tiên: **Must** \= bắt buộc cho bản demo; **Should** \= nên có; **Could** \= làm nếu còn thời gian.

### **M1 – Cổng thông tin theo năm**

| Mã | Yêu cầu | Ưu tiên |
| :---- | :---- | :---- |
| FR-1.1 | Trang chủ: mùa hiện tại, mốc sắp tới, tin mới, lối vào trang mùa và khu vực game | Must |
| FR-1.2 | Trang mùa /{năm} với bộ mục cố định: giới thiệu, chủ đề, thể lệ (kèm PDF), lịch trình (đánh dấu mốc hiện tại), hướng dẫn đăng ký, thông báo, tin tức, kết quả, đơn vị đồng hành, FAQ | Must |
| FR-1.3 | Mỗi mùa có nhận diện riêng (logo, banner, màu, slogan); đổi năm thì toàn trang đổi | Must |
| FR-1.4 | BTC tạo mùa mới, bật/tắt mục, sửa nội dung, xem trước rồi xuất bản – không sửa code | Must |
| FR-1.5 | Trang lưu trữ các mùa đã tổ chức | Should |

### **M2 – Tin tức & tường thuật**

| Mã | Yêu cầu | Ưu tiên |
| :---- | :---- | :---- |
| FR-2.1 | BTC tạo/sửa/xóa bài, nháp – xuất bản, gắn mùa và chuyên mục | Must |
| FR-2.2 | Danh sách tin lọc theo mùa, chuyên mục, tìm theo tiêu đề | Must |
| FR-2.3 | Bài tường thuật trực tiếp: cập nhật có mốc giờ, ghim, trạng thái đang diễn ra/đã kết thúc, nhúng YouTube/Facebook Live | Must |
| FR-2.4 | Người xem nhận cập nhật mới không cần tải lại trang (≤ 5 giây) | Should |

### **M3 – Tài khoản & đội**

| Mã | Yêu cầu | Ưu tiên |
| :---- | :---- | :---- |
| FR-3.1 | Đăng ký/đăng nhập email – mật khẩu; phân quyền theo vai trò ở cả giao diện và API (sai quyền trả 403\) | Must |
| FR-3.2 | Đội trưởng tạo đội, mời thành viên bằng mã/link; một người không ở 2 đội trong cùng mùa | Must |
| FR-3.3 | Gửi hồ sơ trong thời gian mở đăng ký; trạng thái Nháp → Chờ duyệt → Cần bổ sung → Đã duyệt / Từ chối / Đã rút | Must |
| FR-3.4 | BTC duyệt/từ chối có lý do, xuất Excel danh sách đội và thí sinh | Must |
| FR-3.5 | Hồ sơ cá nhân, lịch sử thi thử | Should |
| FR-3.6 | Đăng nhập bằng tài khoản trường/Google **\[CẦN CHỐT\]** | Could |

### **M4 – Quản lý mùa & trận**

| Mã | Yêu cầu | Ưu tiên |
| :---- | :---- | :---- |
| FR-4.1 | Cấu hình mùa: số thành viên đội, số người thi mỗi trận, điểm tặng đầu trận, danh sách game được dùng, phiên bản luật | Must |
| FR-4.2 | Tạo trận 3 đội, ghép đội thủ công hoặc bốc thăm; lưu người thực hiện | Must |
| FR-4.3 | Chọn chuỗi game cho từng trận (BTC công bố trong ngày thi); bảng điểm trận cộng dồn qua các game | Must |
| FR-4.4 | Chuyển vòng theo kết quả đã chốt (đội nhất \+ đội nhì cao điểm nhất); đánh dấu cần play-off khi bằng điểm | Should |
| FR-4.5 | Lịch thi, phòng/địa điểm, trạng thái trận | Should |

### **M5 – Game master (khung plugin)**

| Mã | Yêu cầu | Ưu tiên |
| :---- | :---- | :---- |
| FR-5.1 | Mọi game cài đặt cùng một interface (mục 9); thêm game mới không sửa master | Must |
| FR-5.2 | Vòng đời chung: chuẩn bị → sẵn sàng → đang chơi ⇄ tạm dừng → kết thúc; đồng hồ do máy chủ quyết định | Must |
| FR-5.3 | Phòng realtime với các màn hình: đội chơi (mỗi đội 1), điều khiển (BTC/MC), chiếu khán giả, giám khảo; mỗi màn hình chỉ nhận dữ liệu được phép thấy | Must |
| FR-5.4 | Ghi chuông/nộp bài theo thời điểm máy chủ, chống tính trùng khi gửi lặp | Must |
| FR-5.5 | Mất kết nối: hiển thị trạng thái, kết nối lại nhận đúng trạng thái, không được thêm giờ | Must |
| FR-5.6 | Giám khảo cộng/trừ/sửa điểm phải có lý do và lưu lịch sử | Must |
| FR-5.7 | Màn hình chiếu dùng được với OBS (độ phân giải cố định, nền tách được) | Should |
| FR-5.8 | Ghi đặt cược (1 lần/trận/đội) và tự tính điểm cược theo luật | Should |

### **M7 – Chấm code & sandbox**

| Mã | Yêu cầu | Ưu tiên |
| :---- | :---- | :---- |
| FR-7.1 | API chấm chung cho các game lập trình: gửi bài, nhận verdict chuẩn hóa (đúng/sai/quá giờ/lỗi biên dịch/lỗi chạy) theo từng test | Must |
| FR-7.2 | Code thí sinh chỉ chạy trong sandbox: không mạng, giới hạn CPU/RAM/thời gian, không chạy trong tiến trình web | Must |
| FR-7.3 | Chạy agent Đấu trường AI: binary Linux, 1,5 giây/lượt, RAM 4GB, không mạng, chỉ đọc/ghi trong thư mục agent, agent ≤ 200MB | Must nếu làm Q9 |
| FR-7.4 | Hàng đợi, giới hạn số lần nộp, lưu mọi lần nộp (người nộp, thời điểm, kết quả) | Should |

### **M8 – Quản trị đề**

| Mã | Yêu cầu | Ưu tiên |
| :---- | :---- | :---- |
| FR-8.1 | Nhập đề trắc nghiệm/câu hỏi bằng file Excel theo mẫu, báo đúng dòng lỗi | Must |
| FR-8.2 | Nhập đề lập trình bằng file zip gồm đề, test và checker | Must |
| FR-8.3 | BTC sửa đề sau khi nhập; đề có trạng thái nháp/đã duyệt/đã khóa cho trận | Must |
| FR-8.4 | Chỉ người ra đề xem được đề chưa công bố; nội dung câu chỉ gửi xuống trình duyệt khi câu được mở; test ẩn không bao giờ gửi xuống | Must |
| FR-8.5 | Kho đề thi thử (dataset công khai) tách riêng kho đề thi thật | Must |

### **M9 – Thi thử**

| Mã | Yêu cầu | Ưu tiên |
| :---- | :---- | :---- |
| FR-9.1 | Phòng luyện: 1 đội người \+ 2 bot, chọn game và độ khó | Must |
| FR-9.2 | Phòng giao lưu: 3 đội online cùng vào một phòng bằng mã | Should |
| FR-9.3 | Nhiều phòng chạy song song, mỗi phòng một instance game | Should |
| FR-9.4 | Điểm thi thử không ảnh hưởng xếp hạng thi thật; có bảng xếp hạng luyện tập | Should |
| FR-9.5 | Tự tạo giải giao lưu nhiều trận giữa các đội | Could |

### **M10 – Kết quả & lịch sử**

| Mã | Yêu cầu | Ưu tiên |
| :---- | :---- | :---- |
| FR-10.1 | Kết quả từng trận theo game, phân biệt tạm thời và đã chốt; đội đi tiếp được tô nổi bật | Must |
| FR-10.2 | Trang đội: các trận đã tham gia và điểm | Should |
| FR-10.3 | Xem lại trận dạng interactive từ log sự kiện: tua theo lượt/câu, xem bảng điểm tại từng thời điểm (ví dụ xem lại chung kết năm trước) | Should |
| FR-10.4 | Xuất kết quả ra Excel | Could |

## **8\. Đặc tả các game**

Luật tóm tắt theo Thể lệ 2025 (v2.51) và Đấu trường AI 2026\. Mọi con số để trong file cấu hình theo mùa, không viết cứng trong code. **\[CẦN CHỐT\]** Q1 quyết định game nào nằm trong phạm vi.

| Game | Luật tóm tắt | Yêu cầu hệ thống | Còn mở |
| :---- | :---- | :---- | :---- |
| **Khởi động** | 5 người, chia nhóm mô tả và nhóm đoán. Mỗi đội 120 giây đoán 10 cụm từ tiếng Anh CNTT. Được bỏ qua (không quay lại). Đúng \+10, sai không trừ. Không cược. Thứ tự đội bốc thăm. | Màn hình người mô tả thấy từ khóa, màn hình đoán và màn chiếu không thấy; nút Đúng/Bỏ qua cho giám khảo; đồng hồ 120 giây máy chủ | Thi thử 1 người chơi thì ai mô tả? **\[CẦN CHỐT\]** |
| **Lập trình tiếp sức** | 5 người. Đọc đề 30 giây–2 phút; mỗi người code 1–3 phút, tổng 5–15 phút;  thứ tự do đội chọn, thời gian do BTC đặt. Nộp qua CMS nhiều lần, hoặc bấm chuông (không nộp hệ thống) để xét Điểm thưởng Tự tin 40đ (sai bị −20). 100 điểm chia đều cho các test. Có cược. | Trình soạn code, đồng hồ chia lượt \+ chuông báo đổi người, khóa người trước, nộp bài qua API chấm, ghi thứ tự chuông, tính điểm tự tin/cược | Chạy trên máy BTC (IDE quen) hay trình soạn trên web? **\[CẦN CHỐT\]**; ngôn ngữ Q6 |
| **Truy tìm lỗi ẩn** | 5 người, chia nhóm truyền tin (trên sân khấu, xem code, giơ bảng 0/1 và Ctrl/Alt) và nhóm nhận tin (bàn phím, không chuột). 3–5 file C++, mỗi file 1 hoặc nhiều lỗi. 6–10 phút. Mỗi lần nộp sai −10% điểm file (sai 10 lần còn 0). First solve \+20% điểm file. Giải hết \+20. Có cược (tối đa 60). Tối đa 200đ. | Màn hình code chỉ nhóm truyền tin thấy; nộp qua lệnh terminal hoặc web; chấm tự động; tính penalty, first solve, điểm full, cược; ghi thứ tự giải xong toàn bộ | Thi thử trên web mô phỏng việc truyền tin thế nào? **\[CẦN CHỐT\]** |
| **Đấu trường AI** | 3 đội nộp agent (binary Linux). Bản đồ lục giác bán kính 8–15, tọa độ cube, 300 vàng, 3 khiên, vật cản, đối xứng xoay 120°. K \= 50–150 lượt, các thuyền hành động đồng thời: di chuyển 1 ô \+ bắn tối đa 2 tên lửa (6 tên lửa/trận). Va chạm/đổi chỗ thì đắm. Kho báu ở (0,0,0) xuất hiện giữa 0,5K–0,6K. Bị bắn mất khiên và mất vàng (vàng rơi ra ô lân cận). 5 hiệp, hạng 1: 20đ (hiệp 5: 40), hạng 2: 10đ (20). Tối đa 5 agent/đội. | Trình mô phỏng đúng luật, chạy agent trong sandbox (FR-7.3), màn chiếu bản đồ \+ animation, chọn map theo hiệp, log từng lượt để xem lại, bot mẫu cho thi thử, chế độ điều khiển tay cho thi thử | Q9; prototype hiện dùng luật rút gọn (bán kính 4, 30 lượt) cần cập nhật theo luật 2026 |
| **Về đích** | **Là phần đối đầu trực tiếp(QA chỉnh)** | – | Q2 |
| **Đối đầu trực tiếp** | 5 người. Bản đồ lục giác 6 thành phố \+ 1 thủ đô; mỗi đội bắt đầu với 1 thành phố (bốc thăm). 3 vòng, mỗi vòng mỗi đội 1 lượt tấn công (thứ tự xoay vòng). Chọn 1/9 câu, 15 giây đọc, 5 giây chọn thành phố liền kề, 30 giây trả lời. Chiếm mới: đúng \+10 vàng; tấn công đội khác: chỉ chiếm khi đội tấn công đúng và đội thủ sai; sai −5 (thủ đô −10). Lãi sau mỗi vòng 10 vàng/thành phố (15 nếu có thủ đô). Không cược. | Bản đồ và quyền sở hữu, kiểm tra liền kề, tự chọn khi hết 5 giây, đồng hồ, tính vàng và lãi | Có trong phạm vi không (Q1) |
| **Ai thông minh hơn** | 5 người. 12 mảnh ghép 3×4 che 1 ảnh, mỗi mảnh 1 câu hỏi. Đội luân phiên chọn mảnh; đội nộp đầu tiên sai thì 2 đội còn lại được bổ sung 1 lần trong 5 giây và đội sai mất quyền nộp ở câu kế. Đúng \+10. Đoán từ khóa chủ đề bất cứ lúc nào (xét sau khi đủ 6 câu): đúng được tổng điểm mảnh chưa lật, sai −1/2 và bị loại. Có cược. | Nhập đáp án trên hệ thống, thứ tự nộp theo máy chủ, cửa sổ bổ sung 5 giây, lật mảnh/gợi ý, hàng chờ xét từ khóa, xử lý sự cố lộ từ khóa | Có trong phạm vi không (Q1) |

## **9\. Interface plugin game (hợp đồng master – game)**

* **Đầu vào master gửi cho game:** mã trận, chế độ (thi thử / thi thật / giao lưu), danh sách đội {id, tên, màu, là bot hay người, danh sách người chơi}, cấu hình game theo mùa (có phiên bản), bộ đề đã khóa, seed.  
* **Lệnh master điều khiển:** start, pause, resume, next (câu/lượt), abort, adjustScore(đội, điểm, lý do).  
* **Game phát ra:** trạng thái công khai (cho màn chiếu), trạng thái riêng theo vai trò (đội, giám khảo), sự kiện điểm, sự kiện kết thúc.  
* **Đầu ra khi kết thúc:** điểm từng đội theo định dạng chung, chi tiết điểm (thưởng, phạt, cược), log sự kiện đầy đủ để xem lại.  
* **Giao thức bot:** nhận trạng thái (JSON) → trả hành động; đội người, bot và (nếu có) agent dùng chung hợp đồng này.  
* **Màn hình mỗi game phải cung cấp:** màn đội, màn điều khiển, màn chiếu, màn giám khảo.  
* **\[CẦN BỔ SUNG\]** Bảo viết interface cụ thể (TypeScript) và ví dụ cài đặt cho 1 game.

## **10\. User flow**

### **UF1 – Khách xem thông tin**

Trang chủ → chọn năm → xem giới thiệu, thể lệ, lịch trình → xem tin tức/tường thuật → xem kết quả và xem lại trận.

### **UF2 – Đăng ký dự thi**

Đăng ký tài khoản → đội trưởng tạo đội → mời thành viên → thành viên xác nhận → gửi hồ sơ vào mùa đang mở → BTC duyệt / yêu cầu bổ sung → đội thấy trạng thái Đã duyệt.

### **UF3 – Thi thử với bot**

Đăng nhập → Khu vực game → chọn game → chọn "Đấu với bot" và độ khó → hệ thống tạo phòng (1 đội \+ 2 bot) → chơi → xem kết quả, xem lại ván.

### **UF4 – Giao lưu 3 đội online**

Đội A tạo phòng → gửi mã cho đội B, C → đủ 3 đội, chủ phòng bắt đầu → chơi chuỗi game đã chọn → bảng điểm tổng.

### **UF5 – Tổ chức trận thi thật tại hội trường**

BTC tạo trận, chọn 3 đội và chuỗi game, khóa bộ đề → mở các màn hình (3 máy đội, màn chiếu, máy điều khiển, máy giám khảo) trên LAN → đội đặt cược (nếu có) → MC bắt đầu game → đội thao tác, giám khảo xác nhận → kết thúc game, điểm cộng vào bảng trận → hết các game: giám khảo chốt, nếu bằng điểm thì play-off → kết quả lên trang mùa.

### **UF6 – Nhập đề**

Người ra đề tải file Excel/zip theo mẫu → hệ thống kiểm tra, báo lỗi theo dòng → sửa → duyệt → khóa cho trận.

## **11\. Use case specifications**

### **UC-01 – Tạo và xuất bản trang mùa thi**

| Mục | Nội dung |
| :---- | :---- |
| Actor | BTC |
| Tiền điều kiện | Đăng nhập vai trò BTC |
| Luồng chính | 1\. Tạo mùa (năm, tên, slogan, màu, logo, banner). 2\. Bật các mục cần dùng. 3\. Nhập nội dung từng mục. 4\. Xem trước. 5\. Xuất bản. |
| Luồng phụ / ngoại lệ | Thiếu ảnh/màu bắt buộc: báo lỗi, không cho xuất bản. Năm đã tồn tại: báo trùng. |
| Hậu điều kiện | Trang /{năm} hiển thị công khai với nhận diện riêng |

### **UC-02 – Đăng ký đội theo mùa**

| Mục | Nội dung |
| :---- | :---- |
| Actor | Đội trưởng, Thí sinh |
| Tiền điều kiện | Mùa đang mở đăng ký; đã đăng nhập |
| Luồng chính | 1\. Tạo đội. 2\. Mời thành viên bằng mã/link. 3\. Thành viên xác nhận. 4\. Đội trưởng gửi hồ sơ. 5\. Theo dõi trạng thái. |
| Luồng phụ / ngoại lệ | Quá hạn đăng ký: không gửi được. Thành viên đã ở đội khác trong mùa: từ chối. Thiếu người: báo số người còn thiếu. |
| Hậu điều kiện | Hồ sơ ở trạng thái Chờ duyệt |

### **UC-03 – Duyệt hồ sơ**

| Mục | Nội dung |
| :---- | :---- |
| Actor | BTC |
| Tiền điều kiện | Có hồ sơ Chờ duyệt |
| Luồng chính | 1\. Lọc hồ sơ. 2\. Xem chi tiết. 3\. Duyệt hoặc từ chối/yêu cầu bổ sung kèm lý do. |
| Luồng phụ / ngoại lệ | Hồ sơ đã bị đội rút: không duyệt được. |
| Hậu điều kiện | Đội thấy trạng thái mới; đội đã duyệt được xếp vào trận |

### **UC-04 – Tạo trận và chọn game**

| Mục | Nội dung |
| :---- | :---- |
| Actor | BTC |
| Tiền điều kiện | Có ít nhất 3 đội đủ điều kiện |
| Luồng chính | 1\. Chọn vòng. 2\. Chọn 3 đội (tay hoặc bốc thăm). 3\. Chọn chuỗi game. 4\. Gắn bộ đề đã duyệt cho từng game. 5\. Khóa trận. |
| Luồng phụ / ngoại lệ | Bộ đề chưa duyệt: không khóa được. Đội trùng lịch: cảnh báo. |
| Hậu điều kiện | Trận sẵn sàng, đề bị khóa không sửa |

### **UC-05 – Điều khiển một game trong trận**

| Mục | Nội dung |
| :---- | :---- |
| Actor | Điều hành/MC, Giám khảo |
| Tiền điều kiện | Trận đã khóa; các màn hình đã kết nối |
| Luồng chính | 1\. Kiểm tra 3 đội đã kết nối. 2\. Nhận đặt cược (nếu game có). 3\. Bắt đầu game. 4\. Mở câu/lượt. 5\. Giám khảo xác nhận đáp án. 6\. Kết thúc game, điểm vào bảng trận. |
| Luồng phụ / ngoại lệ | Đội mất kết nối: tạm dừng, chờ vào lại. Sự cố đề (lộ từ khóa, câu lỗi): thay câu theo luật. Sửa điểm: bắt buộc nhập lý do. |
| Hậu điều kiện | Điểm game được lưu kèm log |

### **UC-06 – Nộp code và nhận kết quả chấm**

| Mục | Nội dung |
| :---- | :---- |
| Actor | Đội chơi |
| Tiền điều kiện | Game lập trình đang chạy, đến lượt đội |
| Luồng chính | 1\. Viết/sửa code. 2\. Nộp. 3\. Hệ thống gửi bộ chấm. 4\. Nhận verdict từng test. 5\. Điểm cập nhật. |
| Luồng phụ / ngoại lệ | Lỗi biên dịch/quá giờ: trả verdict tương ứng. Bộ chấm không phản hồi: báo lỗi, cho nộp lại, ghi log để giám khảo xử lý. |
| Hậu điều kiện | Lần nộp được lưu (người nộp, thời điểm, kết quả) |

### **UC-07 – Thi thử với bot**

| Mục | Nội dung |
| :---- | :---- |
| Actor | Thí sinh |
| Tiền điều kiện | Đăng nhập |
| Luồng chính | 1\. Chọn game. 2\. Chọn đấu với bot và độ khó. 3\. Chơi. 4\. Xem kết quả và xem lại. |
| Luồng phụ / ngoại lệ | Bỏ giữa chừng: ván bị hủy, không lưu điểm. |
| Hậu điều kiện | Lịch sử luyện tập được lưu riêng |

### **UC-08 – Xem lại trận**

| Mục | Nội dung |
| :---- | :---- |
| Actor | Khách |
| Tiền điều kiện | Trận đã kết thúc và được công bố |
| Luồng chính | 1\. Mở trận từ trang kết quả. 2\. Tua theo lượt/câu. 3\. Xem bảng điểm tại thời điểm đó. |
| Luồng phụ / ngoại lệ | Trận chưa công bố: không xem được. |
| Hậu điều kiện | – |

### **UC-09 – Nhập bộ đề**

| Mục | Nội dung |
| :---- | :---- |
| Actor | Người ra đề |
| Tiền điều kiện | Có quyền người ra đề |
| Luồng chính | 1\. Tải file mẫu. 2\. Điền đề. 3\. Tải lên. 4\. Sửa lỗi theo báo cáo. 5\. Duyệt. |
| Luồng phụ / ngoại lệ | Sai định dạng: báo đúng dòng/cột. |
| Hậu điều kiện | Bộ đề ở trạng thái Đã duyệt |

**\[CẦN BỔ SUNG\]** Use case cho Đấu trường AI (nộp agent, chọn map, chạy hiệp), Về đích, sơ tuyển trắc nghiệm, giao lưu online – người phụ trách game tự viết theo mẫu trên.

## **12\. Yêu cầu phi chức năng**

| Nhóm | Yêu cầu | Ghi chú |
| :---- | :---- | :---- |
| Bảo mật – RCE | Không bao giờ chạy code/agent của thí sinh trong tiến trình web; sandbox không mạng, giới hạn CPU/RAM/thời gian, không truy cập file ngoài thư mục được cấp | Đã chốt (D5) |
| Bảo mật – lộ đề | Phân quyền xem đề; đề chỉ gửi xuống trình duyệt khi câu được mở; test ẩn không gửi xuống; màn chiếu lọc dữ liệu ở máy chủ; ghi log ai xem/sửa đề | Đã chốt (D5) |
| Phân quyền | Kiểm tra quyền ở API, không chỉ ẩn nút; giới hạn tần suất đăng nhập và nộp bài | Must |
| Thời gian thực | Độ trễ cập nhật giữa các màn hình trong LAN dưới 500 ms **\[CẦN CHỐT\]** | Đề xuất |
| Công bằng | Mọi mốc thời gian (chuông, nộp bài, hết giờ) lấy theo đồng hồ máy chủ; lưu lịch sử chuông để đối chiếu khi khiếu nại | Must |
| Tin cậy | Kết nối lại giữ trạng thái; có nút để trọng tài nhập điểm tay khi hệ thống lỗi; sao lưu dữ liệu sau mỗi trận | Must |
| Triển khai | Chạy được hoàn toàn offline trên LAN bằng Docker Compose (Q8) | Must |
| Mở rộng | Thêm game mới chỉ cần thêm plugin; thêm mùa chỉ cần dữ liệu | Must |
| Hiệu năng | Trang công khai chịu khoảng 100 người xem cùng lúc; 20 lượt nộp code đồng thời **\[CẦN CHỐT\]** | Đề xuất |
| Hiển thị | Màn chiếu tối ưu 1920×1080; trang công khai dùng được trên điện thoại; Chrome, Edge, Firefox | Should |

## **13\. Stack & kiến trúc**

| Thành phần | Requirement nhóm | Prototype hiện tại | Ghi chú |
| :---- | :---- | :---- | :---- |
| Frontend | React/Vite | Next.js 16 \+ Tailwind | **\[CẦN CHỐT\]** Q3 |
| Backend | NestJS | NestJS 12 | Đã thống nhất |
| Cơ sở dữ liệu | ???? | JSON mẫu; nhánh build đã nối PostgreSQL | **\[CẦN CHỐT\]** Q4 – đề xuất PostgreSQL |
| Realtime | – | Chưa có | Đề xuất Socket.IO qua NestJS Gateway **\[CẦN CHỐT\]** |
| Chấm code | CMS | Judge0 (Docker) ở nhánh build | **\[CẦN CHỐT\]** Q5 |
| Triển khai | – | Chưa có | Docker Compose, chạy LAN \+ cloud (Q8) |

Repo: github.com/hetoke/thachthuc\_poc. **\[CẦN BỔ SUNG\]** Bảo vẽ sơ đồ kiến trúc (web công khai, API, game server realtime, bộ chấm, DB) và sơ đồ ERD (Anh).

## **14\. Dataset thi thử**

| Game | Dataset | Việc cần làm |
| :---- | :---- | :---- |
| Lập trình tiếp sức | https\://huggingface.co/datasets/codeparrot/apps | Lọc bài phù hợp thời lượng 5–15 phút; chuyển input/output sang định dạng test của bộ chấm; lời giải mẫu chủ yếu Python, cần kiểm tra khi giới hạn C++ **\[CẦN BỔ SUNG\]** |
| Truy tìm lỗi ẩn | https\://huggingface.co/datasets/Rtian/DebugBench | Lọc phần C++; mỗi file 1 lỗi; kèm test **\[CẦN BỔ SUNG\]** |
| Khởi động / Ai thông minh hơn / Đối đầu / Về đích | Tự soạn | Nhóm tự soạn bộ câu hỏi mẫu, không dùng đề thật của BTC |

**\[CẦN CHỐT\]** Q15 – kiểm tra license trước khi dùng.

## **15\. Kế hoạch và theo dõi**

* Công việc theo dõi trên Jira (project Thách Thức): Prototype nhanh 3 ngày (đã đóng, 28/10–01/11), Giai đoạn 1 (13–19/11), Giai đoạn 2 (20–26/11), Giai đoạn 3 (27/11–03/12), Giai đoạn 4 (04–10/12).  
* Các issue D01–D34 trên Jira lập theo kế hoạch prototype cũ. Sau khi chốt requirement này, cần tách lại issue theo module M1–M11 và mã FR. **\[CẦN CHỐT\]**  
* Gặp thầy khoảng 2–3 tuần/lần; mỗi lần có bản demo chạy được.

## **16\. Tài liệu tham khảo**

* Thể lệ các trò chơi Thách Thức 2025 (Luật-Thách-Thức-2.51.pdf)  
* Đấu trường AI – Thách Thức 2026 (bản Final)  
* Khung đề tài website Thách Thức và MVP (24/10/2026)  
* Kế hoạch Prototype – Hệ thống Quản lý Cuộc thi Thách Thức (24/10/2026)  
* Dàn ý tổng quan hệ thống; tài liệu phương án hệ thống (thachthuc.docx)  
* Ghi âm/ghi chú họp với thầy 30/10/2026 và 13/11/2026  
* Website chính thức: thachthuc.vn; CMS: cms-dev.github.io

