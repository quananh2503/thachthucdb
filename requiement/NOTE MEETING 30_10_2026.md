### **NOTE MEETING 30/10/2026**

### **1\. Định hướng sản phẩm**

* Xây dựng một nền tảng tập trung để quản lý và vận hành cuộc thi.  
* Hiện tại, các game đang hoạt động độc lập, ban tổ chức phải nhập điểm thủ công từ từng game để tổng hợp kết quả.  
* Mục tiêu là kết nối các game vào một hệ thống thống nhất, tự động hóa việc quản lý và tính điểm.  
* Hướng đến cả thi thử và thi thật.

### **2\. Các trang chính**

* Trang thông tin cuộc thi:  
  * Giới thiệu cuộc thi.  
  * Thông tin các game.  
  * Luật thi mới nhất.  
  * Tin tức, bài viết, hướng dẫn.  
  * Lưu trữ thông tin các mùa thi.  
* Trang quản lý (Admin):  
  * Quản lý đội thi.  
  * Quản lý game.  
  * Cấu hình điểm số, luật chơi.  
  * Quản lý cuộc thi và kết quả.  
  * Quản lý nội dung website.  
* Trang thi thử (Simulation):  
  * Cho phép các đội tham gia thi thử.  
  * Một đội người thật có thể đấu với các Agent thay thế những đội còn lại.  
  * Agent có nhiều mức độ khó khác nhau.  
  * Hỗ trợ các đội giao lưu, thi đấu với nhau.  
* Trang thi thật (Live Competition):  
  * Tổ chức và quản lý các trận đấu thực tế.  
  * Tự động cập nhật điểm số.  
  * Hiển thị bảng xếp hạng.  
  * Tường thuật trực tiếp bằng text theo từng giai đoạn, có thể đính kèm hình ảnh.  
  * Lưu trữ video và liên kết đến video sau cuộc thi.

### **3\. Quản lý thông tin theo từng năm**

* Mỗi năm có một trang riêng, cấu trúc và layout tương tự nhau.  
* Admin có thể tạo trang cho mùa thi mới mà không cần lập trình lại.  
* Trước mắt tập trung xây dựng nội dung cho năm 2026 và 2025\.  
* Nội dung gồm: luật thi, game, đội thi, tin tức, bài viết, hướng dẫn và kết quả.  
* Thiết kế giao diện thú vị, có sự khác biệt giữa các mùa nhưng vẫn đồng nhất.

### **4\. Kiến trúc và tích hợp game**

* Abstract Game: Xây dựng một lớp/interface game chung để chuẩn hóa cách các game hoạt động.  
* Standardized Input/Output: Chuẩn hóa dữ liệu đầu vào và đầu ra giữa Master và các game.  
* Master: Đóng vai trò trung tâm giao tiếp giữa game và client, điều phối trận đấu và nhận kết quả.  
* Plugin Architecture: Cho phép thêm game mới thông qua plugin/configuration mà không phải sửa logic trung tâm hoặc thêm nhiều `if-else`.  
* Game Configuration: Cấu hình luật chơi, điểm số, đội thi và các thông số của từng game.  
* Containerization: Nghiên cứu đóng gói mỗi game thành một container riêng để dễ triển khai, quản lý và mở rộng.  
* Đảm bảo các game độc lập về logic nhưng thống nhất về cách giao tiếp với hệ thống.

### **5\. Các đối tượng sử dụng**

Thiết kế hệ thống dựa trên ba góc nhìn:

* Đội thi: Đăng ký, thi thử, thi thật, xem điểm, giao lưu với đội khác.  
* Khán giả: Xem thông tin, theo dõi diễn biến, bảng xếp hạng và video.  
* Ban tổ chức: Quản lý đội, game, cuộc thi, điểm số và tường thuật.

### **6\. Yêu cầu kỹ thuật**

* Authentication và Authorization.  
* Phân quyền người dùng.  
* Bảo mật API và dữ liệu cuộc thi.  
* Đảm bảo Performance khi nhiều đội và khán giả truy cập.  
* Đảm bảo Reliability khi vận hành thi thật.  
* Có cơ chế xử lý khi game hoặc hệ thống gặp sự cố.  
* Lưu trữ trạng thái và kết quả trận đấu để có thể khôi phục khi cần.

### **7\. Phạm vi ưu tiên**

* Bắt buộc: Trang thông tin cuộc thi, trang quản lý, trang thi thử.  
* Điểm cộng: Trang thi thật và tường thuật trực tiếp.  
* Ưu tiên xây dựng kiến trúc có khả năng mở rộng thay vì triển khai tất cả chức năng cùng lúc.

### **8\. Làm việc với thầy**

* Chia dự án thành từng phần và từng giai đoạn phát triển.  
* Trước mỗi buổi gặp thầy, chuẩn bị danh sách tính năng dự kiến triển khai.  
* Nghiên cứu các giải pháp kỹ thuật trước khi đề xuất.  
* Trình bày yêu cầu tài nguyên cho từng giải pháp (server, CPU, RAM, GPU...).  
* Thầy đánh giá khả năng đáp ứng tài nguyên trước khi quyết định triển khai.  
* Ưu tiên những giải pháp khả thi, có thể chứng minh được bằng demo.

