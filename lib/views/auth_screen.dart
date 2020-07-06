import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/widgets/auth_card.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5),
                  Color.fromRGBO(255, 188, 117, 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 65.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepOrange.shade900,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    // .. -> Operador Cascata: O tipo do return será igual ao do método anterior
                    transform: Matrix4.rotationZ(-10 * pi / 180)
                      ..translate(-10.0),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 40,
                    ),
                    child: Text(
                      'Minha Loja',
                      style: TextStyle(
                        color:
                            Theme.of(context).accentTextTheme.headline6.color,
                        fontSize: 40,
                        fontFamily: 'Anton',
                      ),
                    ),
                  ),
                  AuthCard(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
