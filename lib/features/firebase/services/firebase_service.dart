import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firebase와 관련된 데이터 처리를 담당하는 서비스 클래스입니다.
///
/// Firestore 데이터베이스를 사용하여 사용자 정보, 대화, 프로젝트 데이터를 관리하고,
/// Firebase Authentication 및 Firestore 관련 코드 템플릿을 생성하는 기능을 제공합니다.
class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 사용자 데이터를 Firestore에 저장합니다.
  ///
  /// 현재 로그인된 사용자의 UID를 문서 ID로 사용하여 `users` 컬렉션에 데이터를 저장합니다.
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set(userData);
    }
  }

  /// Firestore에서 현재 로그인된 사용자의 데이터를 가져옵니다.
  Future<Map<String, dynamic>?> getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data();
    }
    return null;
  }

  /// 대화 내용을 Firestore에 저장합니다.
  ///
  /// 현재 로그인된 사용자의 `conversations` 하위 컬렉션에 대화 데이터를 저장합니다.
  Future<void> saveConversation(Map<String, dynamic> conversationData) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('conversations')
          .doc(conversationData['id'])
          .set(conversationData);
    }
  }

  /// Firestore에서 모든 대화 목록을 가져옵니다.
  ///
  /// 업데이트된 날짜를 기준으로 내림차순으로 정렬하여 반환합니다.
  Future<List<Map<String, dynamic>>> getConversations() async {
    final user = _auth.currentUser;
    if (user != null) {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('conversations')
          .orderBy('updatedAt', descending: true)
          .get();
      
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    }
    return [];
  }

  /// 특정 대화를 Firestore에서 삭제합니다.
  Future<void> deleteConversation(String conversationId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('conversations')
          .doc(conversationId)
          .delete();
    }
  }

  /// 프로젝트 정보를 Firestore에 저장합니다.
  Future<void> saveProject(Map<String, dynamic> projectData) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('projects')
          .doc(projectData['id'])
          .set(projectData);
    }
  }

  /// Firestore에서 모든 프로젝트 목록을 가져옵니다.
  Future<List<Map<String, dynamic>>> getProjects() async {
    final user = _auth.currentUser;
    if (user != null) {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('projects')
          .orderBy('updatedAt', descending: true)
          .get();
      
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    }
    return [];
  }

  /// 특정 프로젝트를 Firestore에서 삭제합니다.
  Future<void> deleteProject(String projectId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('projects')
          .doc(projectId)
          .delete();
    }
  }

  /// Firebase Authentication을 위한 기본 코드 템플릿을 생성합니다.
  String generateFirebaseAuthCode() {
    return '''
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 현재 사용자 가져오기
  User? get currentUser => _auth.currentUser;

  // 인증 상태 변경 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 이메일/비밀번호로 회원가입
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // 이메일/비밀번호로 로그인
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
''';
  }

  /// Firestore 데이터 처리를 위한 기본 코드 템플릿을 생성합니다.
  ///
  /// [collectionName]을 기반으로 CRUD(Create, Read, Update, Delete) 기능을 포함하는
  /// 서비스 클래스 코드를 생성합니다.
  String generateFirestoreCode(String collectionName) {
    return '''
import 'package:cloud_firestore/cloud_firestore.dart';

class ${collectionName.capitalize()}Service {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = '$collectionName';

  // 문서 추가
  Future<DocumentReference> add(Map<String, dynamic> data) async {
    return await _firestore.collection(collectionName).add(data);
  }

  // 문서 가져오기
  Future<DocumentSnapshot> get(String documentId) async {
    return await _firestore.collection(collectionName).doc(documentId).get();
  }

  // 모든 문서 가져오기
  Stream<QuerySnapshot> getAll() {
    return _firestore.collection(collectionName).snapshots();
  }

  // 문서 업데이트
  Future<void> update(String documentId, Map<String, dynamic> data) async {
    await _firestore.collection(collectionName).doc(documentId).update(data);
  }

  // 문서 삭제
  Future<void> delete(String documentId) async {
    await _firestore.collection(collectionName).doc(documentId).delete();
  }
}
''';
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}