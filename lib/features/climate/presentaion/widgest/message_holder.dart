import 'package:flutter/material.dart';

class MessageHolder extends StatelessWidget {
  final String message;

  const MessageHolder({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(message),
      ),
    );
  }
}
