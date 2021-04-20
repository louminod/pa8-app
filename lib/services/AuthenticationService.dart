import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/services/DatabaseService.dart';

abstract class AuthenticationService {
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Stream<User> get userFirebase {
    return _firebaseAuth.authStateChanges();
  }

  static Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }

  static Future<User> signInWithCredential(AuthCredential credential) async {
    return (await _firebaseAuth.signInWithCredential(credential)).user;
  }

  static Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        User user = userCredential.user;
        UserData userData = UserData.extractDataFromFirebaseUser(user);
        await DatabaseService(userUid: userData.uid).createUserData(userData);
        //await DatabaseService(userUid: user.uid).syncDatabases();
      } catch (error) {
        print("ERROR -> signInWithGoogle -> " + error.toString());
      }
    }

    return null;
  }
}
