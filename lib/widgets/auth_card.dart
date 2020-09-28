import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/provider/auth.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  bool _isLoading = false;
  GlobalKey<FormState> _form = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    this._controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    this._opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: this._controller, curve: Curves.linear),
    );

    this._slideAnimation =
        Tween(begin: Offset(0, -1.5), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: this._controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    super.dispose();
    this._controller.dispose();
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um Erro!'),
        content: Text(msg),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!this._form.currentState.validate()) return;

    setState(() {
      this._isLoading = true;
    });

    this._form.currentState.save();

    Auth auth = Provider.of<Auth>(context, listen: false);

    if (this._authMode == AuthMode.Signup) {
      try {
        await auth.signup(this._authData['email'], this._authData['password']);
      } on AuthException catch (error) {
        _showErrorDialog(error.toString());
      } catch (error) {
        _showErrorDialog('Ocorreu um erro inesperado.');
      }
    } else {
      try {
        await auth.login(this._authData['email'], this._authData['password']);
      } on AuthException catch (error) {
        _showErrorDialog(error.toString());
      } catch (error) {
        _showErrorDialog('Ocorreu um erro inesperado.');
      }
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
      this._controller.forward();
    } else {
      setState(() {
        this._authMode = AuthMode.Login;
      });
      this._controller.reverse();
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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
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
                  return (value.isEmpty || !value.contains('@'))
                      ? 'Informe um e-mail válido'
                      : null;
                },
                onSaved: (value) => this._authData['email'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                controller: this._passwordController,
                obscureText: true,
                validator: (value) {
                  return (value.isEmpty || value.length < 6)
                      ? 'Informe uma senha válida'
                      : null;
                },
                onSaved: (value) => this._authData['password'] = value,
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                constraints: BoxConstraints(
                  minHeight: this._authMode == AuthMode.Signup ? 60 : 0,
                  maxHeight: this._authMode == AuthMode.Signup ? 120 : 0,
                ),
                child: FadeTransition(
                  opacity: this._opacityAnimation,
                  child: SlideTransition(
                    position: this._slideAnimation,
                    child: TextFormField(
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
                  ),
                ),
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
