import 'package:flutter/material.dart';

import 'base_auth.dart';

class LoginPage extends StatefulWidget {

  LoginPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{

  bool _obscureText = true;

  bool _isLoading = false;

  String _password = "";

  String _email = "";

  String _errorMessage = "";

  final _formKey = new GlobalKey<FormState>();

  void _toggleSecureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Form(
        key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Image.asset("assets/logo.png"),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder()
                        ),
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        validator: (value) => value.isEmpty ?'Email can\'t be empty' : null,
                        onSaved: (value) => _email = value.trim(),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                              onPressed: _toggleSecureText,
                            ),
                            border: OutlineInputBorder()
                        ),
                        obscureText: _obscureText,
                        validator: (value) => value.isEmpty ?'Password can\'t be empty' : null,
                        onSaved: (value) => _password = value.trim(),
                      ),
                      SizedBox(height: 15,),
                      showCircularProgress(),
                      RaisedButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red),
                        ),
                        onPressed: () {validateAndSubmit();},
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Text("LOGIN".toUpperCase(),
                            style: TextStyle(fontSize: 14)),
                      ),
                      FlatButton(
                        child: Text('Create an account',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.red),
                        ),
                        onPressed: () {},
                      ),
                      showErrorMessage(),
                    ],
                  ),
                )
            ),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');

        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }
}

