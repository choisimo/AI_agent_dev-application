import 'dart:io';

/// Git 명령어 실행을 통해 로컬 Git 저장소를 관리하는 서비스 클래스입니다.
///
/// Git 저장소 확인, 초기화, 파일 추가, 커밋, 푸시, 풀, 상태 확인 등의 기능을 제공합니다.
/// 또한, 변경된 파일 목록을 기반으로 간단한 커밋 메시지를 생성할 수 있습니다.
class GitService {
  /// 지정된 [path]가 Git 저장소인지 확인합니다.
  Future<bool> isGitRepository(String path) async {
    try {
      final result = await Process.run(
        'git',
        ['rev-parse', '--git-dir'],
        workingDirectory: path,
      );
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  /// 지정된 [path]에 새로운 Git 저장소를 초기화합니다.
  Future<String> initRepository(String path) async {
    try {
      final result = await Process.run(
        'git',
        ['init'],
        workingDirectory: path,
      );
      
      if (result.exitCode == 0) {
        return 'Git 저장소가 초기화되었습니다.';
      } else {
        throw Exception('Git 초기화 실패: ${result.stderr}');
      }
    } catch (e) {
      throw Exception('Git 초기화 중 오류 발생: $e');
    }
  }

  /// 지정된 [files]를 Git 스테이징 영역에 추가합니다.
  Future<String> addFiles(String path, List<String> files) async {
    try {
      final result = await Process.run(
        'git',
        ['add', ...files],
        workingDirectory: path,
      );
      
      if (result.exitCode == 0) {
        return '파일이 스테이징되었습니다.';
      } else {
        throw Exception('파일 추가 실패: ${result.stderr}');
      }
    } catch (e) {
      throw Exception('파일 추가 중 오류 발생: $e');
    }
  }

  /// 스테이징된 변경사항을 [message]와 함께 커밋합니다.
  Future<String> commit(String path, String message) async {
    try {
      final result = await Process.run(
        'git',
        ['commit', '-m', message],
        workingDirectory: path,
      );
      
      if (result.exitCode == 0) {
        return '커밋이 완료되었습니다.';
      } else {
        throw Exception('커밋 실패: ${result.stderr}');
      }
    } catch (e) {
      throw Exception('커밋 중 오류 발생: $e');
    }
  }

  /// 로컬 변경사항을 원격 저장소로 푸시합니다.
  ///
  /// [remote]와 [branch]를 지정할 수 있습니다.
  Future<String> push(String path, {String? remote, String? branch}) async {
    try {
      final args = ['push'];
      if (remote != null) args.add(remote);
      if (branch != null) args.add(branch);
      
      final result = await Process.run(
        'git',
        args,
        workingDirectory: path,
      );
      
      if (result.exitCode == 0) {
        return '푸시가 완료되었습니다.';
      } else {
        throw Exception('푸시 실패: ${result.stderr}');
      }
    } catch (e) {
      throw Exception('푸시 중 오류 발생: $e');
    }
  }

  /// 원격 저장소의 변경사항을 로컬로 가져옵니다.
  ///
  /// [remote]와 [branch]를 지정할 수 있습니다.
  Future<String> pull(String path, {String? remote, String? branch}) async {
    try {
      final args = ['pull'];
      if (remote != null) args.add(remote);
      if (branch != null) args.add(branch);
      
      final result = await Process.run(
        'git',
        args,
        workingDirectory: path,
      );
      
      if (result.exitCode == 0) {
        return '풀이 완료되었습니다.';
      } else {
        throw Exception('풀 실패: ${result.stderr}');
      }
    } catch (e) {
      throw Exception('풀 중 오류 발생: $e');
    }
  }

  /// Git 저장소의 현재 상태를 반환합니다.
  ///
  /// 변경된 파일 목록을 문자열 리스트로 반환합니다.
  Future<List<String>> getStatus(String path) async {
    try {
      final result = await Process.run(
        'git',
        ['status', '--porcelain'],
        workingDirectory: path,
      );
      
      if (result.exitCode == 0) {
        return (result.stdout as String)
            .split('\n')
            .where((line) => line.isNotEmpty)
            .toList();
      } else {
        throw Exception('상태 확인 실패: ${result.stderr}');
      }
    } catch (e) {
      throw Exception('상태 확인 중 오류 발생: $e');
    }
  }

  /// 변경된 파일 목록([changes])을 기반으로 커밋 메시지를 생성합니다.
  ///
  /// 추가, 수정, 삭제된 파일 수를 요약하여 메시지를 생성합니다.
  Future<String> generateCommitMessage(List<String> changes) async {
    // AI를 사용하여 변경사항을 분석하고 의미있는 커밋 메시지 생성
    // 여기서는 간단한 로직으로 구현
    
    if (changes.isEmpty) {
      return 'Empty commit';
    }
    
    final addedFiles = changes.where((change) => change.startsWith('A')).length;
    final modifiedFiles = changes.where((change) => change.startsWith('M')).length;
    final deletedFiles = changes.where((change) => change.startsWith('D')).length;
    
    final parts = <String>[];
    
    if (addedFiles > 0) {
      parts.add('Add $addedFiles file${addedFiles > 1 ? 's' : ''}');
    }
    
    if (modifiedFiles > 0) {
      parts.add('Update $modifiedFiles file${modifiedFiles > 1 ? 's' : ''}');
    }
    
    if (deletedFiles > 0) {
      parts.add('Delete $deletedFiles file${deletedFiles > 1 ? 's' : ''}');
    }
    
    return parts.join(', ');
  }
}