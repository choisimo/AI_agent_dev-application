import 'dart:io';
import 'package:path/path.dart' as path;

class FileUtils {
  static Future<bool> createDirectory(String dirPath) async {
    try {
      final directory = Directory(dirPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> writeFile(String filePath, String content) async {
    try {
      final file = File(filePath);
      await file.writeAsString(content);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> readFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<String>> listFiles(String dirPath, {String? extension}) async {
    try {
      final directory = Directory(dirPath);
      if (!await directory.exists()) {
        return [];
      }

      final files = <String>[];
      await for (final entity in directory.list(recursive: true)) {
        if (entity is File) {
          if (extension == null || path.extension(entity.path) == extension) {
            files.add(entity.path);
          }
        }
      }
      return files;
    } catch (e) {
      return [];
    }
  }

  static String getFileName(String filePath) {
    return path.basename(filePath);
  }

  static String getFileExtension(String filePath) {
    return path.extension(filePath);
  }

  static String getDirectoryPath(String filePath) {
    return path.dirname(filePath);
  }

  static String joinPath(String part1, String part2) {
    return path.join(part1, part2);
  }

  static Future<bool> copyFile(String sourcePath, String destinationPath) async {
    try {
      final sourceFile = File(sourcePath);
      final destinationFile = File(destinationPath);
      
      if (await sourceFile.exists()) {
        await sourceFile.copy(destinationPath);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  static Future<DateTime?> getLastModified(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.lastModified();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
