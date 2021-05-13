import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:time_tracker_code_with_andrea/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});
  
  final AuthBase auth;

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose(){
    _isLoadingController.close();
  }
  void _setIsLoading (bool isLoading) => _isLoadingController.add(isLoading);
  Future<User> _signIn(Future<User> signInMethod) async{
    try{
      _setIsLoading(true);
      return await signInMethod;
    }catch(e){
      _setIsLoading(false);
      rethrow;
    }
  }
  Future<User> signInAnonymously() async => await _signIn(auth.signInAnonymously());
  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle());
  Future<User> signInWithFacebook() async => await _signIn(auth.signInWithFacebook());
  Future<User> signInWithEmailAndPassword(String email, String password) async => await _signIn(auth.signInWithEmailAndPassword(email, password));
}