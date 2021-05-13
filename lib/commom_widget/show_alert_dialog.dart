import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showAlertDialog(
  BuildContext context,{
    @required String title,
    @required String content,
    @required String defaultActionText,
      String cancelActionText,
}
) {
  return showDialog(context: context,
      builder:(context){
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions:<Widget> [
            if(cancelActionText!=null)
              FlatButton(onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelActionText),
              ),
            FlatButton(onPressed: () => Navigator.of(context).pop(true),
                child: Text(defaultActionText)
            )
          ],
        );
      }
  );
}