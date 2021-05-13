import 'package:flutter/material.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/email_sign_in_form.dart';
import 'package:time_tracker_code_with_andrea/services/auth.dart';
class EmailSignInPage extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              child: EmailSignInForm()
          ),
        ),
      )
      ,
      backgroundColor: Colors.grey[200],
    );
  }


}
