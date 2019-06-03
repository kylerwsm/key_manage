import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<String> getDisplayName();

  Future<String> getPhotoUrl();

  Future<String> getEmail();

  Future<String> getPhoneNumber();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> resetPassword(String email);

  Future<void> updateDisplayName(String newDisplayName);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<String> getDisplayName() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.displayName;
  }

  Future<String> getPhotoUrl() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.photoUrl;
  }

  Future<String> getEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.email;
  }

  Future<String> getPhoneNumber() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.phoneNumber;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateDisplayName(String newDisplayName) async {
    var userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = newDisplayName;
    _updateUserProfile(userUpdateInfo);
  }

  Future<void> _updateUserProfile(UserUpdateInfo userUpdateInfo) async {
    var user = await getCurrentUser();
    user.updateProfile(userUpdateInfo);
  }
}
