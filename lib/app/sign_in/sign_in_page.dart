import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/sign_in_bloc.dart';
import 'file:///D:/Android/time_tracker_code_with_andrea/lib/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_code_with_andrea/commom_widget/custom_raised_button.dart';
import 'package:time_tracker_code_with_andrea/commom_widget/show_exception_alert_dialog.dart';
import 'package:time_tracker_code_with_andrea/services/auth.dart';
class SignInPage extends StatelessWidget{
  final SignInBloc bloc;

  const SignInPage({Key key, this.bloc}) : super(key: key);

  static Widget create(BuildContext context){
   final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignInBloc>(
        create: (_)=> SignInBloc(auth: auth),
        dispose: (_,bloc)=>bloc.dispose(),
        child: Consumer<SignInBloc>(
            builder: (_,bloc,__)=> SignInPage(bloc: bloc,),
        ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception){
    showExceptionAlertDialog(context,
        title: 'Sign in failed',
        exception: exception);
  }

  Future<void> _signInAnonymously(BuildContext context) async{
    try {
      await bloc.signInAnonymously();
    }on Exception catch(e){
      _showSignInError(context, e);
    }
  }
  Future<void> _signInWithGoogle(BuildContext context) async{

    try {
      await bloc.signInWithGoogle();
    }catch(e){
      _showSignInError(context, e);
    }
  }
  Future<void> _signInWithFacebook(BuildContext context) async{

    try {
      await bloc.signInWithFacebook();
    }catch(e){
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context){
    //TODO: Show EmailSignIn
    final auth=Provider.of<AuthBase>(context,listen: false);

    Navigator.of(context).push(
      MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context)=> EmailSignInPage())
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: StreamBuilder<bool>(
        stream: bloc.isLoadingStream,
        initialData: false,
        builder: (context, snapshot) {
          return _buildContent(context,snapshot.data);
        }
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Container(
      padding: EdgeInsets.all(16.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isLoading==false ?
            Text(
              'Sign in',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w600,
              ),
            )
          : Center(child: CircularProgressIndicator()),



          SizedBox(height: 48.0,),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign with Google',
            color: Colors.white,
            onPressed:()=>_signInWithGoogle(context),

          ),
          SizedBox(height: 8.0,),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign with Facebook',
            color: Color(0xFF334D92),
            textColor: Colors.white,
            onPressed:!isLoading? ()=>_signInWithFacebook(context):null,
          ),
          SizedBox(height: 8.0,),
          SignInButton(
            text: 'Sign with email',
            color: Colors.teal[700],
            textColor: Colors.white,
            onPressed: !isLoading?()=>_signInWithEmail(context):null,
          ),
          SizedBox(height: 8.0,),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0,color: Colors.black87) ,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0,),
          SignInButton(
            text: 'Go anonymous',
            color: Colors.lime[300],
            textColor: Colors.black,
            onPressed:!isLoading? ()=> _signInAnonymously(context):null,
          ),

        ],
      ),
    );
  }
}
