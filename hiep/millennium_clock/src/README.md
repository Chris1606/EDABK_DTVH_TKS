Tên_Dự_án/
|
|-- src/  (Thư mục chứa toàn bộ mã nguồn)
|   |
|   |-- 01_utilities/
|   |   |-- clk_divider.v
|   |   |-- debounce.v
|   |   `-- edge_detector.v
|   |
|   |-- 02_counters/
|   |   |-- counter_generic.v
|   |   `-- date_counter.v
|   |
|   |-- 03_conversion/
|   |   |-- binary_to_bcd2.v
|   |   |-- binary_to_bcd4.v
|   |   `-- bcd_to_7seg.v
|   |
|   |-- 04_display/
|   |   `-- sevenseg_driver.v
|   |
|   `-- top.v  (File chính, kết nối tất cả)
|
|-- sim/  (Thư mục chứa các file mô phỏng - Testbench)
|   `-- tb_top.v
|
|-- constraints/ (Thư mục chứa file ràng buộc chân)
|   `-- board_pins.xdc
|
`-- millennium_clock.xpr (File project của Vivado/Quartus)