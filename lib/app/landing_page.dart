import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_code_with_andrea/app/home/jobs/jobs_page.dart';
import 'package:time_tracker_code_with_andrea/app/sign_in/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker_code_with_andrea/services/auth.dart';
import 'package:time_tracker_code_with_andrea/services/database.dart';
class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final auth=Provider.of<AuthBase>(context,listen: false);

    return StreamBuilder<User>(
      stream: auth.authStateChanges() ,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          final User user= snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }
          return Provider<Database>(
            create: (_)=> FirestoreDatabase(uid: user.uid),
            child: JobsPage(
            ),
          );
        }
        return Scaffold(
          body:Center(
            child: CircularProgressIndicator(),
          ) ,
        );
      },
    );

  }
}
