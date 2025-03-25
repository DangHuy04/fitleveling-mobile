import 'package:flutter/material.dart';

class Pet {
  final String id;
  final String name;
  final PetType type;
  final int level;
  final int experience;
  final int requiredExperience;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    this.level = 1,
    this.experience = 0,
    this.requiredExperience = 100,
  });

  Pet copyWith({
    String? id,
    String? name,
    PetType? type,
    int? level,
    int? experience,
    int? requiredExperience,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      requiredExperience: requiredExperience ?? this.requiredExperience,
    );
  }

  Pet addExperience(int amount) {
    int newExperience = experience + amount;
    int newLevel = level;
    int newRequiredExperience = requiredExperience;

    while (newExperience >= newRequiredExperience) {
      newExperience -= newRequiredExperience;
      newLevel++;
      // Mỗi cấp độ sẽ cần thêm kinh nghiệm hơn
      newRequiredExperience = (newRequiredExperience * 1.5).round();
    }

    return copyWith(
      experience: newExperience,
      level: newLevel,
      requiredExperience: newRequiredExperience,
    );
  }

  // Trả về cấp độ tiến hóa của thú cưng (từ 0-5)
  int get evolutionStage {
    int stage = 0;
    if (level >= 30)
      stage = 5;
    else if (level >= 25)
      stage = 4;
    else if (level >= 15)
      stage = 3;
    else if (level >= 10)
      stage = 2;
    else if (level >= 5)
      stage = 1;
    else
      stage = 0;

    print('DEBUG - Pet ${name}: Level ${level} -> Evolution Stage ${stage}');
    return stage;
  }

  // Lấy đường dẫn GIF dựa trên loại và cấp độ tiến hóa
  String get gifAsset {
    return 'assets/pets/${type.name.toLowerCase()}/evolution_${evolutionStage}.gif';
  }

  // Lấy đường dẫn Lottie JSON dựa trên loại và cấp độ tiến hóa
  String get lottieAsset {
    return 'assets/pets/${type.name.toLowerCase()}/evolution_${evolutionStage}.json';
  }

  // Lấy đường dẫn hình ảnh tĩnh dự phòng
  String get imageAsset {
    return 'assets/pets/${type.name.toLowerCase()}/evolution_${evolutionStage}.png';
  }

  // Hàm fallback để lấy icon trong trường hợp GIF không tồn tại
  IconData getEvolutionIcon() {
    switch (type) {
      case PetType.dragon:
        return getIconForDragonLevel(evolutionStage);
      case PetType.fox:
        return getIconForFoxLevel(evolutionStage);
      case PetType.axolotl:
        return getIconForAxolotlLevel(evolutionStage);
    }
  }

  // Lấy màu cho thú cưng dựa trên giai đoạn tiến hóa
  Color getEvolutionColor() {
    switch (type) {
      case PetType.dragon:
        // Màu từ đỏ nhạt đến đỏ đậm
        switch (evolutionStage) {
          case 0:
            return Colors.red.shade300;
          case 1:
            return Colors.red.shade400;
          case 2:
            return Colors.red.shade500;
          case 3:
            return Colors.red.shade600;
          case 4:
            return Colors.red.shade700;
          case 5:
            return Colors.red.shade800;
          default:
            return Colors.red;
        }
      case PetType.fox:
        // Màu từ cam nhạt đến cam đậm
        switch (evolutionStage) {
          case 0:
            return Colors.orange.shade300;
          case 1:
            return Colors.orange.shade400;
          case 2:
            return Colors.orange.shade500;
          case 3:
            return Colors.orange.shade600;
          case 4:
            return Colors.orange.shade700;
          case 5:
            return Colors.orange.shade800;
          default:
            return Colors.orange;
        }
      case PetType.axolotl:
        // Màu từ hồng nhạt đến hồng đậm
        switch (evolutionStage) {
          case 0:
            return Colors.pink.shade300;
          case 1:
            return Colors.pink.shade400;
          case 2:
            return Colors.pink.shade500;
          case 3:
            return Colors.pink.shade600;
          case 4:
            return Colors.pink.shade700;
          case 5:
            return Colors.pink.shade800;
          default:
            return Colors.pink;
        }
    }
  }

  // Lấy kích thước biểu tượng dựa trên giai đoạn tiến hóa
  double getEvolutionSize() {
    switch (evolutionStage) {
      case 0:
        return 80;
      case 1:
        return 100;
      case 2:
        return 120;
      case 3:
        return 140;
      case 4:
        return 160;
      case 5:
        return 180;
      default:
        return 100;
    }
  }

  // Các hàm helper để lấy icon cho từng loại thú cưng dựa trên cấp độ
  static IconData getIconForDragonLevel(int stage) {
    switch (stage) {
      case 0:
        return Icons.egg_alt;
      case 1:
        return Icons.pest_control;
      case 2:
        return Icons.pets;
      case 3:
        return Icons.architecture;
      case 4:
        return Icons.auto_fix_high;
      case 5:
        return Icons.local_fire_department;
      default:
        return Icons.egg_alt;
    }
  }

  static IconData getIconForFoxLevel(int stage) {
    switch (stage) {
      case 0:
        return Icons.egg_alt;
      case 1:
        return Icons.cruelty_free;
      case 2:
        return Icons.pets;
      case 3:
        return Icons.emoji_nature;
      case 4:
        return Icons.sunny;
      case 5:
        return Icons.smart_toy;
      default:
        return Icons.egg_alt;
    }
  }

  static IconData getIconForAxolotlLevel(int stage) {
    switch (stage) {
      case 0:
        return Icons.egg_alt;
      case 1:
        return Icons.water_drop;
      case 2:
        return Icons.waves;
      case 3:
        return Icons.water;
      case 4:
        return Icons.tsunami;
      case 5:
        return Icons.sailing;
      default:
        return Icons.egg_alt;
    }
  }

  // Tính phần trăm kinh nghiệm hiện tại
  double get experiencePercentage {
    return experience / requiredExperience;
  }
}

enum PetType { dragon, fox, axolotl }

// Mở rộng PetType để có thêm các thuộc tính hữu ích
extension PetTypeExtension on PetType {
  String get displayName {
    switch (this) {
      case PetType.dragon:
        return 'Rồng';
      case PetType.fox:
        return 'Cáo';
      case PetType.axolotl:
        return 'Axolotl';
    }
  }

  String get description {
    switch (this) {
      case PetType.dragon:
        return 'Một sinh vật mạnh mẽ, có thể bay lượn và phun lửa.';
      case PetType.fox:
        return 'Nhanh nhẹn và thông minh, cáo là người bạn đồng hành tuyệt vời.';
      case PetType.axolotl:
        return 'Sinh vật dễ thương có khả năng tái tạo và sống dưới nước.';
    }
  }
}
