import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/widgets.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;

  const AuthUser({
    required this.id, //id to associate whit notes in firestore cloud this is given by firebase authentication internally we need it here for notes
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        /* here fromFirebase is name
  of factory constructor for AuthUser and taking User named as user from firebase 
  which is defined by firebase internally and giving them to simple constructor of AuthUser
  like id:user.uid to id ans so on */
        id: user.uid,//uid is internal from firebase auth 
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
}
