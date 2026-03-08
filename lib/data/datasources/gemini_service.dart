import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../core/constants/env.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/result.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService(Env.geminiApiKey);
});

class GeminiService {
  GeminiService(String apiKey)
      : _model = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: apiKey,
        );

  final GenerativeModel _model;

  /// Analyzes a rental item photo and returns auto-generated tags.
  /// Returns a VLM tag string like "BTS Official Lightstick Ver.4, Black, Good Condition"
  Future<Result<String>> analyzeItemPhoto(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final mimeType = _getMimeType(imageFile.path);

      final response = await _model.generateContent([
        Content.multi([
          TextPart(
            'You are analyzing a K-pop concert rental item photo. '
            'Identify the item and generate a concise tag string. '
            'Include: item type (lightstick/phone/camera/slogan/costume), '
            'brand/artist if identifiable, model/version if known, '
            'color, and visible condition. '
            'Return ONLY the tag string, no explanation. '
            'Example: "BTS Official Lightstick Ver.4, Purple, Like New" '
            'Example: "iPhone 15 Pro, Natural Titanium, Minor Scratches"',
          ),
          DataPart(mimeType, bytes),
        ]),
      ]);

      final tag = response.text?.trim();
      if (tag == null || tag.isEmpty) {
        return const Fail(ServerFailure('No tag generated'));
      }
      return Success(tag);
    } catch (e) {
      return Fail(mapException(e));
    }
  }

  /// Suggests a category based on the item photo.
  Future<Result<String>> suggestCategory(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final mimeType = _getMimeType(imageFile.path);

      final response = await _model.generateContent([
        Content.multi([
          TextPart(
            'Look at this K-pop concert rental item photo. '
            'Classify it into exactly ONE of these categories: '
            'lightstick, phone, camera, slogan, costume, etc. '
            'Return ONLY the category name, nothing else.',
          ),
          DataPart(mimeType, bytes),
        ]),
      ]);

      final category = response.text?.trim().toLowerCase();
      if (category == null) return const Success('etc');

      const valid = {
        'lightstick',
        'phone',
        'camera',
        'slogan',
        'costume',
        'etc',
      };
      return Success(valid.contains(category) ? category : 'etc');
    } catch (e) {
      return Fail(mapException(e));
    }
  }

  String _getMimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    return switch (ext) {
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
  }
}
