import 'package:consumable_app/data/rest_ds.dart';
import 'package:consumable_app/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);
  BuildContext _ctx;

  User user;

  doLogin(String username, String password) {
    api.login(username, password).then((User user) {
      _view.onLoginSuccess(user);
    }).catchError((Exception error) => _view.onLoginError(error.toString()));
  }

  doGoogleLogin() async {
    await _googleSignIn.signIn();
  }

  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      'http://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  initLogin() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) async {
      if (account != null) {
//        Navigator.of(_ctx).pushReplacementNamed("/home");
      } else {
        // user NOT logged
      }
    });
//  _googleSignIn.signInSilently().whenComplete(() => dismissLoading());
  }

//  dismissLoading() {
//
//  }

}