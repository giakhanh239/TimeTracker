import 'package:flutter/cupertino.dart';
import 'package:time_tracker_code_with_andrea/commom_widget/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton{
  SignInButton({
     @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,

}):     assert(text!=null),
        super(
      color: color,
      onPressed: onPressed,
      height: 50.0,
      child: Text(text,style: TextStyle(color: textColor,fontSize: 15.0),)
  );

}