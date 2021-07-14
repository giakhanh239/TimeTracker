
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/validators.dart';
import 'package:time_tracker_code_with_andrea/services/auth.dart';

import 'email_sign_in_model.dart';


class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier{
  EmailSignInChangeModel({
      @required this.auth,
      this.email='',
      this.password='',
      this.formType=EmailSignInFormType.signIn,
      this.isLoading=false,
      this.submitted=false,
  });
  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  String get primaryButtonText{
    return formType == EmailSignInFormType.signIn ?
    'Sign In' : 'Create an acoount';
  }
  String get secondaryButtonText{
    return  formType == EmailSignInFormType.signIn ?
    'Need an acoount? Register' : 'Have an account? Sign In';
  }

  bool get canSubmit{
    return emailValidator.isValid(email)&&
        emailValidator.isValid(password)&&
        !isLoading;
  }
  String get passwordErrorText{
    bool showErrorText= submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText{
    bool showErrorText =submitted && !emailValidator.isValid(email);
    return showErrorText?invalidEmailErrorText:null;
  }
  void toggleFormType(){
    final formType= this.formType  == EmailSignInFormType.signIn ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      isLoading: false,
      submitted: false,
      formType:formType,
    );
  }
  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);
  void submit() async{
    updateWith(submitted: true, isLoading: true);
    try{


      //  await Future.delayed(Duration(seconds: 3));
      if(formType == EmailSignInFormType.signIn){
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }

    } catch (e){
      updateWith(isLoading: false);
      rethrow;
    }
  }
  void updateWith({
  String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
}){

     this.email= email?? this.email;
      this.password= password?? this.password;
      this.formType= formType?? this.formType;
      this.isLoading= isLoading?? this.isLoading;
      this.submitted= submitted?? this.submitted;
      notifyListeners();
  }
}
