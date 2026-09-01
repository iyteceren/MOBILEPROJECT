import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/saved_build.dart';

/// Tamamlanan kurulumları JSON listesi olarak cihazda saklar.
class SavedBuildsRepository {
  static const _key = 'saved_builds';

  Future<List<SavedBuild>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => SavedBuild.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _persist(List<SavedBuild> builds) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(builds.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }

  Future<List<SavedBuild>> add(SavedBuild build) async {
    final all = await load()..insert(0, build);
    await _persist(all);
    return all;
  }

  Future<List<SavedBuild>> removeById(String id) async {
    final all = await load()..removeWhere((b) => b.id == id);
    await _persist(all);
    return all;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
