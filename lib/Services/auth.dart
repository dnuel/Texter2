import 'package:brew_crew/modals/users.dart';

import 'package:firebase_auth/firebase_auth.dart';
class AuthMethods{

final FirebaseAuth _auth =  FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user){

    return user != null ?  User(userId: user.uid): null ;
  } 

  
  
  Future signinWithEmailAndPassword(String email, String password) async {

    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user ;
      return _userFromFirebaseUser(firebaseUser);




    }catch(e){
      print(e.toString());
    }


  }

  Future SignUpWithEmailAndPassword(String email, String password) async {
    try{

      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }

  Future restPass(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async {
    try{
        return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }
}