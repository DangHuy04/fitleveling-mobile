import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/pet.dart';

class PetProvider extends ChangeNotifier {
  Pet? _activePet;
  final List<Pet> _pets = [];

  // Cache để tránh mất thú cưng khi rebuild
  Pet? _cachedActivePet;

  // Constructor - tạo một thú cưng mặc định
  PetProvider() {
    _initializePets();
  }

  // Khởi tạo thú cưng ban đầu
  void _initializePets() {
    final uuid = Uuid();

    // Tạo 3 thú cưng mặc định, một cho mỗi loại
    final dragon = Pet(id: uuid.v4(), name: 'Dragy', type: PetType.dragon);
    final fox = Pet(id: uuid.v4(), name: 'Foxy', type: PetType.fox);
    final axolotl = Pet(id: uuid.v4(), name: 'Axo', type: PetType.axolotl);

    _pets.addAll([dragon, fox, axolotl]);

    // Đặt thú cưng mặc định
    _activePet = _pets.first;
    _cachedActivePet = _activePet;
  }

  // Getter cho thú cưng hiện tại
  Pet? get activePet {
    // Nếu _activePet bị null, sử dụng pet từ cache
    if (_activePet == null && _cachedActivePet != null) {
      _activePet = _cachedActivePet;
    }

    // Nếu vẫn null (hiếm khi xảy ra), sử dụng pet đầu tiên
    if (_activePet == null && _pets.isNotEmpty) {
      _activePet = _pets.first;
    }

    return _activePet;
  }

  // Getter cho danh sách thú cưng
  List<Pet> get pets => List.unmodifiable(_pets);

  // Thay đổi thú cưng hiện tại
  void setActivePet(String petId) {
    final pet = _pets.firstWhere(
      (pet) => pet.id == petId,
      orElse: () => _pets.first,
    );
    _activePet = pet;
    _cachedActivePet = pet; // Cập nhật cache
    notifyListeners();
  }

  // Thêm kinh nghiệm cho thú cưng hiện tại
  void addExperience(int amount) {
    if (_activePet == null) return;

    final oldEvolutionStage = _activePet!.evolutionStage;
    final updatedPet = _activePet!.addExperience(amount);

    // Cập nhật thú cưng trong danh sách
    final index = _pets.indexWhere((pet) => pet.id == updatedPet.id);
    if (index != -1) {
      _pets[index] = updatedPet;
      _activePet = updatedPet;
      _cachedActivePet = updatedPet; // Cập nhật cache

      // Kiểm tra xem thú cưng có tiến hóa hay không
      if (updatedPet.evolutionStage > oldEvolutionStage) {
        // Thú cưng đã tiến hóa
      }

      notifyListeners();
    }
  }

  // Đặt tên cho thú cưng
  void renamePet(String petId, String newName) {
    final index = _pets.indexWhere((pet) => pet.id == petId);
    if (index != -1) {
      final updatedPet = _pets[index].copyWith(name: newName);
      _pets[index] = updatedPet;

      if (_activePet?.id == petId) {
        _activePet = updatedPet;
      }

      notifyListeners();
    }
  }
}
