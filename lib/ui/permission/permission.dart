import 'package:flutter/material.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  //TODO: improve permission screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: SafeArea(
        child: Center(
          child: Text(
            'Mussic app need to access to storage',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
    );
  }
}
