import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:course_player/data/models/models.dart';

class CoversRepository {
  final Box<Cover> _coverBox;

  // Constructor
  CoversRepository(this._coverBox);

  // 创建新封面
  Future<void> createCover(Uint8List coverData, String hash) async {
    final cover = Cover((b) => b
      ..cover = coverData  // 直接使用 Uint8List
      ..hash = hash);
    await _coverBox.add(cover);
  }

  // 创建新封面 withId (Hive automatically generates an ID)
  Future<void> createCoverWithId(int id, Uint8List coverData, String hash) async {
    final cover = Cover((b) => b
      ..id = id
      ..cover = coverData  // 直接使用 Uint8List
      ..hash = hash);
    await _coverBox.put(id, cover);
  }

  // 根据ID读取封面
  Future<Cover?> getCoverById(int id) async {
    return _coverBox.get(id);
  }

  // 根据哈希值读取封面的 ID
  Future<int?> getCoverIdByHash(String hash) async {
    for (var entry in _coverBox.toMap().entries) {
      if (entry.value.hash == hash) {
        return entry.key; // Hive uses keys for storing, returning the key as ID
      }
    }
    return null;
  }

  // 更新封面
  Future<bool> updateCover(int id, Uint8List newCoverData, String newHash) async {
    final coverToUpdate = await getCoverById(id);
    if (coverToUpdate != null) {
      final updatedCover = Cover((b) => b
        ..cover = newCoverData  // 直接使用 Uint8List
        ..hash = newHash);
      await _coverBox.put(id, updatedCover);
      return true; // Successfully updated
    }
    return false; // Cover not found
  }

  // 删除封面
  Future<void> deleteCover(int id) async {
    await _coverBox.delete(id);
  }

  // 获取所有封面
  Future<List<Cover>> getAllCovers() async {
    return _coverBox.values.toList();
  }

  // 销毁所有封面
  Future<void> destroyCoversDb() async {
    await _coverBox.clear();
  }
}
