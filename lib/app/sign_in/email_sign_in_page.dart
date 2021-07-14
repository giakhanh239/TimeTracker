import 'package:flutter/material.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/email_sign_in_form_change_notifier.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/email_sign_in_form_stateful.dart';
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
              child: EmailSignInFormChangeNotifier.create(context),
          ),
        ),
      )
      ,
      backgroundColor: Colors.grey[200],
    );
  }


}
