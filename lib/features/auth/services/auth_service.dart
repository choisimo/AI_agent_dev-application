import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Authentication을 사용하여 사용자 인증 관련 기능을 제공하는 서비스 클래스입니다.
///
/// 이메일/비밀번호를 사용한 회원가입, 로그인, 로그아웃, 비밀번호 재설정 기능을 포함합니다.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 사용자의 인증 상태 변경을 감지하는 Stream을 반환합니다.
  ///
  /// 로그인 또는 로그아웃 시 User 객체 또는 null을 반환합니다.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// 현재 로그인된 사용자를 반환합니다.
  ///
  /// 로그인되어 있지 않으면 null을 반환합니다.
  User? get currentUser => _auth.currentUser;

  /// 이메일과 비밀번호로 로그인을 시도합니다.
  ///
  /// 성공 시 [UserCredential]을 반환하고, 실패 시 예외를 발생시킵니다.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// 이메일과 비밀번호로 새로운 사용자를 생성합니다.
  ///
  /// 성공 시 [UserCredential]을 반환하고, 실패 시 예외를 발생시킵니다.
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// 현재 사용자를 로그아웃합니다.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// 비밀번호 재설정 이메일을 발송합니다.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// [FirebaseAuthException]을 처리하여 사용자에게 친숙한 오류 메시지를 반환합니다.
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return '등록되지 않은 이메일입니다.';
      case 'wrong-password':
        return '비밀번호가 올바르지 않습니다.';
      case 'email-already-in-use':
        return '이미 사용 중인 이메일입니다.';
      case 'weak-password':
        return '비밀번호가 너무 약합니다.';
      case 'invalid-email':
        return '유효하지 않은 이메일 형식입니다.';
      default:
        return '인증 오류가 발생했습니다: ${e.message}';
    }
  }
}