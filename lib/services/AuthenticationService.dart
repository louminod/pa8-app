import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
abstract class AuthenticationService {
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Stream<User> get userFirebase {
    return _firebaseAuth.authStateChanges();
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
    print("User signout !");
  }

  static Future<User> signInWithCredential(AuthCredential credential) async {
    return (await _firebaseAuth.signInWithCredential(credential)).user;
  }

  static Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final User user = await signInWithCredential(credential);
      // await DatabaseService(userUid: user.uid).createUserData(UserData.extractDataFromFirebaseUser(user));
      print("The user (from Google) is " + user.displayName);
    } catch (error) {
      print(error);
    }
  }
}