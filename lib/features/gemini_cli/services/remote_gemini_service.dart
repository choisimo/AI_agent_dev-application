import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';

/// 원격 서버에 설치된 gemini-cli를 SSH를 통해 호출하여
/// 코드베이스 전체 분석과 같은 Software Engineering (SWE) 작업을 수행하는 서비스.
class RemoteGeminiService {
  // 경고: 실제 프로덕션 환경에서는 SSH 접속 정보를 코드에 하드코딩하지 마세요.
  // 안전한 설정 관리자(예: 환경 변수, 암호화된 설정 파일)를 통해 관리해야 합니다.
  final String _host = 'YOUR_REMOTE_SERVER_IP';
  final int _port = 22;
  final String _username = 'YOUR_USERNAME';
  // 비밀번호 또는 개인 키 중 하나를 사용합니다.
  final String? _password = 'YOUR_PASSWORD'; // 비밀번호를 사용하는 경우
  final String? _privateKey = null; // 개인 키를 사용하는 경우 (예: '-----BEGIN RSA PRIVATE KEY-----\n...')

  /// 원격 서버에 SSH로 접속하여 gemini-cli 명령어를 실행하고 결과를 반환합니다.
  ///
  /// [remoteProjectPath]는 분석할 프로젝트가 위치한 원격 서버의 절대 경로입니다.
  Future<String> analyzeCodebase(String remoteProjectPath) async {
    SSHClient? client;
    try {
      client = SSHClient(
        await SSHSocket.connect(_host, _port),
        username: _username,
        // 비밀번호 또는 개인 키 인증 선택
        onPasswordRequest: () => _password,
        // privateKey: _privateKey,
      );

      // 예시: gemini-cli를 사용하여 코드베이스 분석 명령어 실행
      // 실제 gemini-cli 명령어에 맞게 수정해야 합니다.
      final command = 'gemini-cli swe analyze --path $remoteProjectPath';
      final result = await client.run(command);

      final output = String.fromCharCodes(result);
      debugPrint('Remote command output: $output');

      return output;

    } catch (e) {
      debugPrint('SSH command execution failed: $e');
      throw Exception('Failed to execute remote command: $e');
    } finally {
      client?.close();
    }
  }
}
