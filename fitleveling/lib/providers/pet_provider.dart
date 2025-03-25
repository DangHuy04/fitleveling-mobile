import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../services/pet_service.dart';

class PetProvider extends ChangeNotifier {
  Pet? _activePet;
  final List<Pet> _pets = [];
  final PetService _petService = PetService();
  bool _isLoading = false;
  String? _error;

  // Cache để tránh mất thú cưng khi rebuild
  Pet? _cachedActivePet;

  // Constructor
  PetProvider() {
    // Không khởi tạo dữ liệu tĩnh nữa
  }

  // Getter cho trạng thái loading
  bool get isLoading => _isLoading;

  // Getter cho lỗi
  String? get error => _error;

  // Getter cho thú cưng hiện tại
  Pet? get activePet {
    if (_activePet == null && _cachedActivePet != null) {
      _activePet = _cachedActivePet;
    }
    if (_activePet == null && _pets.isNotEmpty) {
      _activePet = _pets.first;
    }
    return _activePet;
  }

  // Getter cho danh sách thú cưng
  List<Pet> get pets => List.unmodifiable(_pets);

  // Tải dữ liệu pet từ server
  Future<void> loadPets(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Lấy danh sách pet
      final pets = await _petService.getUserPets(userId);
      _pets.clear();
      _pets.addAll(pets);

      // Lấy pet hiện tại
      final currentPet = await _petService.getCurrentPet(userId);
      if (currentPet != null) {
        _activePet = currentPet;
        _cachedActivePet = currentPet;
      } else if (_pets.isNotEmpty) {
        _activePet = _pets.first;
        _cachedActivePet = _pets.first;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thay đổi thú cưng hiện tại
  Future<void> setActivePet(String userId, String petId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _petService.setCurrentPet(userId, petId);
      
      final pet = _pets.firstWhere(
        (pet) => pet.id == petId,
        orElse: () => _pets.first,
      );
      _activePet = pet;
      _cachedActivePet = pet;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm kinh nghiệm cho thú cưng hiện tại
  Future<void> addExperience(String userId, int amount) async {
    if (_activePet == null) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedPet = await _petService.addExperience(_activePet!.id, amount);

      // Cập nhật thú cưng trong danh sách
      final index = _pets.indexWhere((pet) => pet.id == updatedPet.id);
      if (index != -1) {
        _pets[index] = updatedPet;
        _activePet = updatedPet;
        _cachedActivePet = updatedPet;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Đặt tên cho thú cưng
  Future<void> renamePet(String userId, String petId, String newName) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedPet = await _petService.renamePet(petId, newName);

      // Cập nhật thú cưng trong danh sách
      final index = _pets.indexWhere((pet) => pet.id == updatedPet.id);
      if (index != -1) {
        _pets[index] = updatedPet;
      }

      if (_activePet?.id == petId) {
        _activePet = updatedPet;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
