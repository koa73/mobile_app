import 'package:flutter/material.dart';
import 'package:mobile_app/src/bloc/event.dart';

abstract class ShowAlertDialog{

  void showAlert(BuildContext context, String errMsg, _bloc) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Login error"),
              content: Text(errMsg),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    _bloc.dispatch(ClearError());
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
    );
  }
}