
import 'package:lemon/common/data/models/models.dart';
import 'package:drift/drift.dart';

@DriftAccessor(tables: [Covers])
class CoversRepository extends DatabaseAccessor<AppDatabase>{
  CoversRepository(super.db);

  // 创建新封面
  Future<int> createCover(Uint8List coverData, String hash) async {
    return await into(db.covers).insert(
      CoversCompanion(
        cover: Value(coverData),
        hash: Value(hash),
      ),
    );
  }

  // 创建新封面 withId
  Future<int> createCoverWithId(int id,Uint8List coverData, String hash) async {
    return await into(db.covers).insert(
      CoversCompanion(
        id: Value(id),
        cover: Value(coverData),
        hash: Value(hash),
      ),
    );
  }

  // 根据ID读取封面
  Future<Cover?> getCoverById(int id) async {
    return await (select(db.covers)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

// 根据哈希值读取封面的 ID
  Future<int?> getCoverIdByHash(String hash) async {
    final result = await (select(db.covers)..where((tbl) => tbl.hash.equals(hash))).getSingleOrNull();
    return result?.id; // 假设 Cover 类中有一个 id 字段
  }


// 更新封面
  Future<bool> updateCover(int id, Uint8List newCoverData, String newHash) async {
    final coverToUpdate = await getCoverById(id);
    if (coverToUpdate != null) {
      final rowsAffected = await (update(db.covers)..where((tbl) => tbl.id.equals(id))).write(
        CoversCompanion(
          cover: Value(newCoverData),
          hash: Value(newHash),
        ),
      );
      return rowsAffected > 0; // 返回更新是否成功的布尔值
    }
    return false; // 封面未找到
  }

  // 删除封面
  Future<int> deleteCover(int id) async {
    return await (delete(db.covers)..where((tbl) => tbl.id.equals(id))).go();
  }

  // 获取所有封面
  Future<List<Cover>> getAllCovers() async {
    return await select(db.covers).get();
  }

  Future<int> destroyCoversDb() => db.delete(db.covers).go();
}