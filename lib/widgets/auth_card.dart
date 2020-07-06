import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  bool _isLoading = false;
  GlobalKey<FormState> _form = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _submit() {
    if (!this._form.currentState.validate()) return;

    setState(() {
      this._isLoading = true;
    });

    this._form.currentState.save();

    if (this._authMode == AuthMode.Signup) {
      //Registrar
    } else {
      //Login
    }

    setState(() {
      this._isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (this._authMode == AuthMode.Login) {
      setState(() {
        this._authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        this._authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: deviceSize.width * 0.75,
        height: this._authMode == AuthMode.Signup ? 400 : 310,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: this._form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  return (value.isEmpty || !value.contains('@')) ? 'Informe um e-mail válido' : null;
                },
                onSaved: (value) => this._authData['email'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                controller: this._passwordController,
                obscureText: true,
                validator: (value) {
                  return  (value.isEmpty || value.length < 5) ? 'Informe uma senha válida' : null;
                },
                onSaved: (value) => this._authData['password'] = value,
              ),
              if (this._authMode == AuthMode.Signup)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirmar Senha'),
                  obscureText: true,
                  validator: this._authMode == AuthMode.Signup
                      ? (value) {
                          if (value != this._passwordController.text)
                            return 'As Senhas informadas são Diferentes';
                          return null;
                        }
                      : null,
                ),
              Spacer(),
              if (this._isLoading)
                CircularProgressIndicator()
              else
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).accentTextTheme.button.color,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 8.0,
                  ),
                  child: Text(this._authMode == AuthMode.Login
                      ? 'ENTRAR'
                      : 'REGISTRAR'),
                  onPressed: this._submit,
                ),
              FlatButton(
                onPressed: this._switchAuthMode,
                child: Text(
                    this._authMode == AuthMode.Login ? 'REGISTRAR' : 'LOGIN'),
                textColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
