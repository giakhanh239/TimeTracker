import 'package:flutter/cupertino.dart';
import 'package:time_tracker_code_with_andrea/commom_widget/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required String assetName,
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }) :  assert(assetName !=null),
        assert(text!=null),
        super(
          color: color,
          onPressed: onPressed,
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15.0),
              ),
              Opacity(opacity: 0.0, child: Image.asset(assetName)),
            ],
          ),
        );
}
