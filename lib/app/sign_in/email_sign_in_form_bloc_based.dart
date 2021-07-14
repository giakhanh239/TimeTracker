import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/validators.dart';
import 'package:time_tracker_code_with_andrea/commom_widget/form_submit_button.dart';
import 'package:time_tracker_code_with_andrea/commom_widget/show_alert_dialog.dart';
import 'package:time_tracker_code_with_andrea/commom_widget/show_exception_alert_dialog.dart';
import 'package:time_tracker_code_with_andrea/services/auth.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({@required this.bloc});
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context){
    final auth =Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create:(_)=> EmailSignInBloc(auth: auth) ,
      child: Consumer<EmailSignInBloc>(
        builder: (_,bloc,__)=>EmailSignInFormBlocBased(bloc:bloc),
      ),
      dispose: (_,bloc) => bloc.dispose(),
    );
  }
  @override
  _EmailSignInFormBlocBasedState createState() => _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController= TextEditingController();
  final TextEditingController _passwordController= TextEditingController();

  final FocusNode _emailFocusNode =FocusNode();
  final FocusNode _passwordFocusNode= FocusNode();


  void _submit() async{
    try{
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e){
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    }
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType(){
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model){
    return [
      _buildEmailTextField(model),
      SizedBox(height: 8.0,),
      _buildPasswordTextField(model),
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

  TextField _buildPasswordTextField(EmailSignInModel model) {
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
      onChanged: (password) => widget.bloc.updatePassword(password),
      enabled: model.isLoading==false,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel  model) {
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
      onEditingComplete:()=> _emailEditingComplete(model),
      onChanged: (email) => widget.bloc.updateEmail(email),
      enabled: model.isLoading == false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel model = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(model) ,
          ),
        );
      }
    );
  }

}
