import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/datasources/storage_service.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/rental_repository.dart';
import '../../../shared/widgets/dolda_button.dart';
import '../widgets/condition_selector.dart';
import '../widgets/photo_upload.dart';

class RegisterItemScreen extends ConsumerStatefulWidget {
  const RegisterItemScreen({super.key});

  @override
  ConsumerState<RegisterItemScreen> createState() =>
      _RegisterItemScreenState();
}

class _RegisterItemScreenState extends ConsumerState<RegisterItemScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _depositController = TextEditingController();

  String _category = 'lightstick';
  String _pickupMethod = 'direct';
  String _conditionGrade = 'A';
  final _photos = <XFile>[];
  bool _isLoading = false;

  static const categories = [
    ('lightstick', 'Lightstick'),
    ('phone', 'Phone'),
    ('camera', 'Camera'),
    ('slogan', 'Slogan'),
    ('costume', 'Costume'),
    ('etc', 'Other'),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_photos.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least 2 photos required')),
      );
      return;
    }
    final title = _titleController.text.trim();
    final priceText = _priceController.text.trim();
    final depositText = _depositController.text.trim();
    if (title.isEmpty || priceText.isEmpty || depositText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final userId = ref.read(authRepositoryProvider).currentUser?.id;
    if (userId == null) return;

    setState(() => _isLoading = true);
    try {
      // Upload photos
      final storage = ref.read(storageServiceProvider);
      final photoUrls = <String>[];
      for (final photo in _photos) {
        final url = await storage.uploadItemPhoto(userId, File(photo.path));
        photoUrls.add(url);
      }

      // Create item
      await ref.read(rentalRepositoryProvider).create({
        'lender_id': userId,
        'category': _category,
        'title': title,
        'description': _descController.text.trim(),
        'photos': photoUrls,
        'daily_price': int.parse(priceText),
        'currency': 'KRW', // TODO: Use user's currency
        'deposit': int.parse(depositText),
        'condition_grade': _conditionGrade,
        'pickup_method': _pickupMethod,
      });

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhotoUpload(
              photos: _photos,
              onAdd: () async {
                final picker = ImagePicker();
                final images = await picker.pickMultiImage();
                setState(() => _photos.addAll(images));
              },
              onRemove: (i) => setState(() => _photos.removeAt(i)),
            ),
            const SizedBox(height: 24),
            _sectionTitle('Category'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: categories.map((c) {
                final (value, label) = c;
                return ChoiceChip(
                  label: Text(label),
                  selected: _category == value,
                  onSelected: (_) => setState(() => _category = value),
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _sectionTitle('Title'),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'e.g., BTS Official Lightstick Ver.4',
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitle('Description'),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Describe the condition, accessories included...',
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitle('Condition'),
            const SizedBox(height: 8),
            ConditionSelector(
              grade: _conditionGrade,
              onChanged: (g) => setState(() => _conditionGrade = g),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Daily Price'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\u20A9 ',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Deposit'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _depositController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\u20A9 ',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _sectionTitle('Pickup Method'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ('direct', 'Direct Meetup'),
                ('delivery', 'Delivery'),
                ('both', 'Both'),
              ].map((m) {
                final (value, label) = m;
                return ChoiceChip(
                  label: Text(label),
                  selected: _pickupMethod == value,
                  onSelected: (_) => setState(() => _pickupMethod = value),
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            DoldaButton(
              label: 'Register',
              isLoading: _isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
