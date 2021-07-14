import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/validators.dart';
import 'package:time_tracker_code_with_andrea/commom_widget/form_submit_button.dart';
import 'package:time_tracker_code_with_andrea/commom_widget/show_alert_dialog.dart';
import 'package:time_tracker_code_with_andrea/commom_widget/show_exception_alert_dialog.dart';
import 'package:time_tracker_code_with_andrea/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({@required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context){
    final auth =Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create:(_)=> EmailSignInChangeModel(auth: auth) ,
      child: Consumer<EmailSignInChangeModel>(
        builder: (_,model,__)=>EmailSignInFormChangeNotifier(model:model),
      ),
    );
  }
  @override
  _EmailSignInFormChangeNotifierState createState() => _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController= TextEditingController();
  final TextEditingController _passwordController= TextEditingController();

  final FocusNode _emailFocusNode =FocusNode();
  final FocusNode _passwordFocusNode= FocusNode();

  EmailSignInChangeModel get model=> widget.model;

  void _submit() async{
    try{
      await model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e){
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType(){
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(){
    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0,),
      _buildPasswordTextField(),
      SizedBox(height: 8.0,),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(height: 8.0,),
      FlatButton(
          onPressed: !model.isLoading ? ()=>_toggleFormType : null,
          child: Text(model.secondaryButtonText)
      )
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (password) => model.updatePassword(password),
      enabled: model.isLoading==false,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'abc@xyz.com',
        errorText: model.emailErrorText
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete:()=> _emailEditingComplete(),
      onChanged: (email) => model.updateEmail(email),
      enabled: model.isLoading == false,
    );
  }
  @override
  Widget build(BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren() ,
          ),
        );
  }

}
