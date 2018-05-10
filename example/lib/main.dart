import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stripe_flutter/stripe_flutter.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _cardToken = 'Unknown';

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String cardToken;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      cardToken = await StripeFlutter.getCardToken(
        cardNumber: '4242424242424242',
        cardExpMonth: 11,
        cardExpYear: 2020,
        cardCVC: '123',
        publishableKey: 'pk_test_9yIYOGqsG8XdzsRUlaKnqkdJ'
      );
    } on PlatformException catch(e) {
      cardToken = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted)
      return;

    setState(() {
      _cardToken = cardToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
          child: new Text('Token: $_cardToken\n'),
        ),
      ),
    );
  }
}
