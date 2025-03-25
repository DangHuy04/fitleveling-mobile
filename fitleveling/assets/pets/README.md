# Hướng dẫn thêm animation cho Thú cưng

Để thêm hình ảnh chuyển động cho thú cưng trong ứng dụng, bạn có thể sử dụng một trong những định dạng sau (theo thứ tự ưu tiên):

1. **Lottie JSON Animation** (khuyến nghị - ít gặp lỗi nhất)
2. **GIF Animation** (phổ biến nhưng có thể gặp lỗi giật/lag)
3. **PNG tĩnh** (dự phòng)

## Cấu trúc thư mục

```
assets/
  └── pets/
      ├── dragon/
      │   ├── evolution_1.json  (Lottie - Cấp độ 5) - ƯU TIÊN
      │   ├── evolution_1.gif   (GIF - Cấp độ 5) - DỰ PHÒNG
      │   ├── evolution_1.png   (PNG - Cấp độ 5) - DỰ PHÒNG
      │   ├── evolution_2.json  (Cấp độ 10)
      │   ├── evolution_3.json  (Cấp độ 15)
      │   ├── evolution_4.json  (Cấp độ 25)
      │   └── evolution_5.json  (Cấp độ 30)
      ├── fox/
      │   ├── evolution_1.json
      │   ├── evolution_2.json
      │   ├── evolution_3.json
      │   ├── evolution_4.json
      │   └── evolution_5.json
      └── axolotl/
          ├── evolution_1.json
          ├── evolution_2.json
          ├── evolution_3.json
          ├── evolution_4.json
          └── evolution_5.json
```

## Khuyến nghị sử dụng Lottie JSON Animation

### Ưu điểm của Lottie JSON:
- Hiệu suất cao hơn, ít gặp lỗi giật/lag
- Kích thước tệp nhỏ hơn GIF
- Có thể tùy chỉnh thời gian, màu sắc...
- Hỗ trợ animation chất lượng cao và mượt mà

### Cách tìm Lottie JSON:

1. [LottieFiles](https://lottiefiles.com/featured) - Kho tài nguyên Lottie miễn phí lớn nhất
2. [IconScout Lottie](https://iconscout.com/lottie-animations) - Nhiều animation Lottie miễn phí chất lượng cao

## Sử dụng GIF Animation (nếu không có Lottie)

### Mẹo giảm giật lag cho GIF:
- Sử dụng GIF có kích thước nhỏ (dưới 500KB)
- Giảm số lượng frame trong GIF
- Tối ưu hóa GIF bằng công cụ như [EZgif](https://ezgif.com/optimize)

### Nguồn GIF:
1. [Giphy](https://giphy.com/) - Tìm kiếm "pixel art dragon", "pixel art fox", "pixel art axolotl"...
2. [Tenor](https://tenor.com/) - Cung cấp nhiều GIF miễn phí
3. [OpenGameArt](https://opengameart.org/) - Tìm sprite animation cho game

## Cách đặt tên và đặt file

1. Đặt tên file theo quy tắc:
   - `evolution_X.json` - cho Lottie
   - `evolution_X.gif` - cho GIF
   - `evolution_X.png` - cho hình tĩnh
   
   Với X là số từ 1-5 tương ứng với cấp độ tiến hóa.

2. Đặt file vào thư mục tương ứng với loại thú cưng.

**Lưu ý**: Ứng dụng sẽ ưu tiên tìm file theo thứ tự: JSON > GIF > PNG > Icon mặc định 