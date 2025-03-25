import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../models/pet.dart';
import '../providers/pet_provider.dart';
import 'dart:convert';

// Cache để lưu kết quả kiểm tra tồn tại của file
final Map<String, PetAnimationType> _assetTypeCache = {};
// Cache lưu trữ hình ảnh đã tải
final Map<String, Image> _imageCache = {};
// Cache lưu trữ ImageProvider để duy trì tham chiếu liên tục
final Map<String, ImageProvider> _imageProviders = {};

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Tải trước các hình ảnh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadImages(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Pre-cache lại GIF của thú cưng hiện tại mỗi khi dependencies thay đổi
    if (mounted && context.read<PetProvider>().activePet != null) {
      final pet = context.read<PetProvider>().activePet!;
      if (!_imageProviders.containsKey(pet.gifAsset)) {
        _imageProviders[pet.gifAsset] = AssetImage(pet.gifAsset);
      }
      precacheImage(_imageProviders[pet.gifAsset]!, context);
    }
  }

  // Tải trước các hình ảnh
  Future<void> _preloadImages(BuildContext context) async {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    for (var pet in petProvider.pets) {
      for (int level = 0; level <= 5; level++) {
        final assetPath =
            'assets/pets/${pet.type.name.toLowerCase()}/evolution_$level.gif';
        try {
          // Tạo và lưu trữ ImageProvider
          if (!_imageProviders.containsKey(assetPath)) {
            _imageProviders[assetPath] = AssetImage(assetPath);
          }

          // Buộc tải trước
          await precacheImage(_imageProviders[assetPath]!, context);

          // Tạo và lưu trữ Image widget cũng để dùng sau này
          final image = Image(
            image: _imageProviders[assetPath]!,
            gaplessPlayback: true,
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
            width: 200,
            height: 200,
          );

          // Lưu trữ Image widget vào cache
          _imageCache[assetPath] = image;
        } catch (e) {
          // Bỏ qua lỗi
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, child) {
        final pet = petProvider.activePet;

        if (pet == null) {
          return const Center(child: Text('Không có thú cưng nào được chọn'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Tên thú cưng và loại
              Text(
                '${pet.name} - ${pet.type.displayName}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              // Hiển thị cấp độ
              Text(
                'Cấp độ: ${pet.level} (Tiến hóa: ${pet.evolutionStage}/5)',
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 30),

              // Hiển thị thú cưng dạng animation
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Center(child: _buildPetAnimation(pet)),
                ),
              ),

              // Thanh kinh nghiệm
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kinh nghiệm: ${pet.experience}/${pet.requiredExperience}',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: pet.experiencePercentage,
                      minHeight: 20,
                      backgroundColor: Colors.blueGrey.shade800,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        pet.getEvolutionColor(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Nút thêm kinh nghiệm
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildExperienceButton(petProvider, 10, 'Tập 10 XP'),
                  _buildExperienceButton(petProvider, 50, 'Tập 50 XP'),
                  _buildExperienceButton(petProvider, 100, 'Tập 100 XP'),
                ],
              ),

              const SizedBox(height: 20),

              // Nút chọn thú cưng
              ElevatedButton.icon(
                icon: const Icon(Icons.pets),
                label: const Text('Đổi thú cưng'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  _showPetSelectionDialog(context, petProvider);
                },
              ),

              // Nút debug
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.bug_report),
                label: const Text('Debug Assets'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                ),
                onPressed: () {
                  _debugAssets(context, petProvider);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget để hiển thị animation cho thú cưng
  Widget _buildPetAnimation(Pet pet) {
    // Kiểm tra xem đã có kết quả trong cache chưa
    final cacheKey = pet.gifAsset;
    final cachedResult = _assetTypeCache[cacheKey];

    if (cachedResult != null) {
      // Nếu đã có trong cache, hiển thị ngay lập tức
      return _buildAnimationWidgetByType(pet, cachedResult);
    }

    return FutureBuilder(
      future: _checkFileExists(pet),
      builder: (context, AsyncSnapshot<PetAnimationType> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Hiển thị spinner khi đang kiểm tra các file
          return const CircularProgressIndicator();
        }

        final animationType = snapshot.data ?? PetAnimationType.none;

        // Lưu kết quả vào cache
        _assetTypeCache[cacheKey] = animationType;

        return _buildAnimationWidgetByType(pet, animationType);
      },
    );
  }

  // Hàm helper để xây dựng widget hiển thị dựa trên loại animation
  Widget _buildAnimationWidgetByType(Pet pet, PetAnimationType type) {
    switch (type) {
      case PetAnimationType.lottie:
        return _buildLottieAnimation(pet);
      case PetAnimationType.gif:
        return _buildGifAnimation(pet);
      case PetAnimationType.image:
        return _buildStaticImage(pet);
      case PetAnimationType.none:
        return _buildFallbackIcon(pet);
    }
  }

  // Hiển thị Lottie animation
  Widget _buildLottieAnimation(Pet pet) {
    return Lottie.asset(
      pet.lottieAsset,
      width: pet.getEvolutionSize() * 1.5,
      height: pet.getEvolutionSize() * 1.5,
      fit: BoxFit.contain,
      controller: _animationController,
      onLoaded: (composition) {
        _animationController
          ..duration = composition.duration
          ..repeat();
      },
    );
  }

  // Hiển thị GIF animation
  Widget _buildGifAnimation(Pet pet) {
    final gifPath = pet.gifAsset;

    // Đảm bảo luôn có ImageProvider cho file này
    if (!_imageProviders.containsKey(gifPath)) {
      _imageProviders[gifPath] = AssetImage(gifPath);
      // Cache ngay lập tức để tránh tải lại nhiều lần
      precacheImage(_imageProviders[gifPath]!, context);
    }

    // Kiểm tra xem GIF đã được cache chưa
    final cachedImage = _imageCache[gifPath];

    if (cachedImage != null) {
      // Sử dụng RepaintBoundary để tối ưu hiệu suất render
      return RepaintBoundary(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
          alignment: Alignment.center,
          color:
              Colors.transparent, // Thêm màu nền để tránh hiện tượng nhấp nháy
          child: cachedImage,
        ),
      );
    }

    // Nếu chưa có trong cache, tạo mới và hiển thị
    return RepaintBoundary(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
        alignment: Alignment.center,
        color: Colors.transparent, // Thêm màu nền để tránh hiện tượng nhấp nháy
        child: Image(
          image: _imageProviders[gifPath]!,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          isAntiAlias: true,
          filterQuality: FilterQuality.high,
          width: 200,
          height: 200,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackIcon(pet);
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            // Nếu frame là null, nghĩa là đang tải
            if (frame == null) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(opacity: 0.5, child: child),
                  const CircularProgressIndicator(),
                ],
              );
            }

            // Lưu vào cache khi đã tải xong frame đầu tiên
            if (frame > 0 && !_imageCache.containsKey(gifPath)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _imageCache[gifPath] = Image(
                  image: _imageProviders[gifPath]!,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                  isAntiAlias: true,
                  filterQuality: FilterQuality.high,
                  width: 200,
                  height: 200,
                );
              });
            }

            return AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 300),
              child: child,
            );
          },
        ),
      ),
    );
  }

  // Hiển thị hình ảnh tĩnh
  Widget _buildStaticImage(Pet pet) {
    return Image.asset(
      pet.imageAsset,
      width: pet.getEvolutionSize() * 1.5,
      height: pet.getEvolutionSize() * 1.5,
      fit: BoxFit.contain,
    );
  }

  // Hiển thị icon fallback
  Widget _buildFallbackIcon(Pet pet) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          pet.getEvolutionIcon(),
          size: pet.getEvolutionSize(),
          color: pet.getEvolutionColor(),
        ),
        const SizedBox(height: 20),
        Text(
          '${pet.type.displayName} - Tiến hóa ${pet.evolutionStage}',
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text(
          'Vui lòng kiểm tra đường dẫn file trong assets',
          style: TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Kiểm tra xem file animation nào tồn tại
  Future<PetAnimationType> _checkFileExists(Pet pet) async {
    final lottieAsset = pet.lottieAsset;
    final gifAsset = pet.gifAsset;
    final imageAsset = pet.imageAsset;
    final buildContext = context;

    // Trực tiếp ưu tiên sử dụng GIF nếu trước đó đã tìm thấy
    try {
      await DefaultAssetBundle.of(buildContext).load(gifAsset);
      return PetAnimationType.gif;
    } catch (e) {
      try {
        await DefaultAssetBundle.of(buildContext).load(imageAsset);
        return PetAnimationType.image;
      } catch (e) {
        try {
          await DefaultAssetBundle.of(buildContext).load(lottieAsset);
          return PetAnimationType.lottie;
        } catch (e) {
          return PetAnimationType.none;
        }
      }
    }
  }

  // Tạo nút thêm kinh nghiệm
  Widget _buildExperienceButton(
    PetProvider petProvider,
    int amount,
    String label,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: () {
        petProvider.addExperience(amount);
        _checkForEvolution(context, petProvider);
      },
      child: Text(label),
    );
  }

  // Hàm kiểm tra và hiển thị thông báo tiến hóa
  void _checkForEvolution(BuildContext context, PetProvider petProvider) {
    final pet = petProvider.activePet;
    if (pet == null) return;

    // Hiển thị thông báo tiến hóa nếu pet ở mức tiến hóa 1, 2, 3, 4, hoặc 5
    if (pet.evolutionStage > 0 && pet.level == 5 ||
        pet.level == 10 ||
        pet.level == 15 ||
        pet.level == 25 ||
        pet.level == 30) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Tiến hóa!'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.amber, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    '${pet.name} đã tiến hóa lên giai đoạn ${pet.evolutionStage}!',
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Tuyệt vời!'),
                ),
              ],
            ),
      );
    }
  }

  // Hiển thị dialog chọn thú cưng
  void _showPetSelectionDialog(BuildContext context, PetProvider petProvider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Chọn thú cưng'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: petProvider.pets.length,
                itemBuilder: (context, index) {
                  final pet = petProvider.pets[index];
                  return ListTile(
                    leading: Icon(
                      getPetIcon(pet.type),
                      color: getPetColor(pet.type),
                    ),
                    title: Text(pet.name),
                    subtitle: Text(
                      '${pet.type.displayName} - Cấp ${pet.level}',
                    ),
                    onTap: () {
                      petProvider.setActivePet(pet.id);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ),
    );
  }

  // Lấy icon tương ứng cho loại thú cưng
  IconData getPetIcon(PetType type) {
    switch (type) {
      case PetType.dragon:
        return Pet.getIconForDragonLevel(0);
      case PetType.fox:
        return Pet.getIconForFoxLevel(0);
      case PetType.axolotl:
        return Pet.getIconForAxolotlLevel(0);
    }
  }

  // Lấy màu tương ứng cho loại thú cưng
  Color getPetColor(PetType type) {
    switch (type) {
      case PetType.dragon:
        return Colors.red;
      case PetType.fox:
        return Colors.orange;
      case PetType.axolotl:
        return Colors.pink;
    }
  }

  // Debug hiển thị thông tin về các file assets
  void _debugAssets(BuildContext context, PetProvider petProvider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Debug Asset Paths'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin thú cưng:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Tên: ${petProvider.activePet?.name}'),
                  Text('Loại: ${petProvider.activePet?.type.displayName}'),
                  Text('Level: ${petProvider.activePet?.level}'),
                  Text(
                    'Evolution Stage: ${petProvider.activePet?.evolutionStage}',
                  ),
                  const Divider(),

                  Text(
                    'Đường dẫn Asset:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('GIF: ${petProvider.activePet?.gifAsset}'),
                  Text('Lottie: ${petProvider.activePet?.lottieAsset}'),
                  Text('PNG: ${petProvider.activePet?.imageAsset}'),
                  const Divider(),

                  Text(
                    'Cấu trúc file:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  FutureBuilder(
                    future: DefaultAssetBundle.of(
                      context,
                    ).loadString('AssetManifest.json'),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      if (!mounted) {
                        return const Text('Widget không còn được gắn kết');
                      }
                      try {
                        final Map<String, dynamic> manifestMap =
                            Map<String, dynamic>.from(
                              json.decode(snapshot.data.toString()),
                            );

                        final petAssets =
                            manifestMap.keys
                                .where((String key) => key.contains('pets'))
                                .toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tìm thấy ${petAssets.length} file:'),
                            ...petAssets.map((asset) => Text('- $asset')),
                          ],
                        );
                      } catch (e) {
                        return Text('Lỗi: $e');
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Đóng'),
              ),
            ],
          ),
    );
  }
}

// Enum cho các loại animation thú cưng
enum PetAnimationType {
  lottie, // Lottie JSON animation
  gif, // GIF animation
  image, // Hình ảnh tĩnh
  none, // Không có animation, sử dụng icon
}
