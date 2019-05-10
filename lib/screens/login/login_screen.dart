import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:consumable_app/auth.dart';
import 'package:consumable_app/data/database_helper.dart';
import 'package:consumable_app/models/user.dart';
import 'package:consumable_app/screens/login/login_screen_presenter.dart';
import 'package:consumable_app/widgets/google_sign_in_btn.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, _password;

  LoginScreenPresenter _presenter;

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_username, _password);
    }
  }

  void _submitGoogle() {
    _presenter.doGoogleLogin();
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  onAuthStateChanged(AuthState state) {

    if(state == AuthState.LOGGED_IN)
      Navigator.of(_ctx).pushReplacementNamed("/home");
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = new Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 5.0, top: 10.0),
        child: GestureDetector(
          onTap: () => _submit(),
          child: new Container(
              alignment: Alignment.center,
              height: 60.0,
              decoration: new BoxDecoration(
                  color: Colors.green,
                  borderRadius: new BorderRadius.circular(9.0)),
              child: new Text("Sign in",
                  style: new TextStyle(
                      fontSize: 20.0, color: Colors.white))),
        ),
      ),
    );



    var loginGoogleBtn = new GoogleSignInButton(
      onPressed: _submitGoogle,
    );


    var loginForm = new Column(
      children: <Widget>[
        new Text(
          "My Crib Login",
          textScaleFactor: 2.0,
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  validator: (val) {
                    return val.length < 10
                        ? "Username must have atleast 10 chars"
                        : null;
                  },
                  decoration: new InputDecoration(labelText: "Username"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              ),
            ],
          ),
        ),
        _isLoading ? new CircularProgressIndicator() : loginBtn,

        Text(
          'Or Sign in with',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        loginGoogleBtn

      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.green, //or set color with: Color(0xFF0000FF)
    ));

    return new Scaffold(
//      appBar: null,
      appBar: new AppBar(
          backgroundColor:Colors.transparent,
          elevation: 0.0,
          iconTheme: new IconThemeData(color: Color(0xFF18D191))),
      key: scaffoldKey,
      body: new Container(
//        decoration: new BoxDecoration(
//          image: new DecorationImage(
//              image: new AssetImage("assets/images/login_background.jpg"),
//              fit: BoxFit.cover),
//        ),
        width: double.infinity,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/icon/icon.png',
            ),
//            new StakedIcons(),

            new Form(
              key: formKey,
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new TextFormField(
                      onSaved: (val) => _username = val,
                      validator: (val) {
                        return val.length < 10
                            ? "Username must have atleast 10 chars"
                            : null;
                      },
                      decoration: new InputDecoration(labelText: "Username"),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new TextFormField(
                      onSaved: (val) => _password = val,
                      decoration: new InputDecoration(labelText: "Password"),
                    ),
                  ),
                ],
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _isLoading ? new CircularProgressIndicator() : loginBtn,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 20.0, top: 10.0),
                    child: new Container(
                        alignment: Alignment.center,
                        height: 60.0,
                        child: new Text("Forgot Password?",
                            style: new TextStyle(
                                fontSize: 17.0, color: Colors.green))),
                  ),
                )
              ],
            ),

            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Or',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

              ],
            ),

            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                loginGoogleBtn,

              ],
            ),




            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom:18.0),
                    child: new Text("Create A New Account ",style: new TextStyle(
                        fontSize: 17.0, color: Colors.green,fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar(user.toString());
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.saveUser(user);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }
}