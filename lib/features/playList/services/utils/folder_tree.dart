import 'dart:io';

// 递归函数来生成文件树字符串
String folderTree(Directory dir, {int maxDepth = 2, String prefix = ''}) {
  if (!dir.existsSync()) {
    return 'Directory not found: ${dir.path}';
  }

  final buffer = StringBuffer();
  _listDir(dir, 0, maxDepth, buffer, prefix);
  return buffer.toString();
}

// 辅助递归函数
void _listDir(Directory dir, int currentDepth, int maxDepth,
    StringBuffer buffer, String prefix) {
  if (currentDepth > maxDepth) {
    return;
  }

  // 获取当前目录下的所有文件和子目录
  final List<FileSystemEntity> entities = dir.listSync()
    ..sort((a, b) => a.path.compareTo(b.path)); // 按路径排序，让结果更整洁

  for (int i = 0; i < entities.length; i++) {
    final entity = entities[i];
    final isLast = i == entities.length - 1;
    final entityName = entity.path.split(Platform.pathSeparator).last;

    if (entity is Directory) {
      buffer.writeln('$prefix${isLast ? '└─' : '├─'} $entityName');
      _listDir(entity, currentDepth + 1, maxDepth, buffer,
          '$prefix${isLast ? '  ' : '│ '}');
    } else if (entity is File) {
      buffer.writeln('$prefix${isLast ? '└─' : '├─'} $entityName');
    }
  }
}

// final treeString = folderTree(Directory.current, maxDepth: 2);
