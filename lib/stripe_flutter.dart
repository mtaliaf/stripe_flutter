import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class StripeFlutter {
  static const MethodChannel _channel = const MethodChannel('com.mtaliaf.stripeflutter/stripe_flutter');

  static Future<String> getCardToken({
      @required String cardNumber,
      @required int cardExpMonth,
      @required int cardExpYear,
      @required String cardCVC,
      @required String publishableKey
  }) async {
    final String token = await _channel.invokeMethod(
        'getCardToken',
        <String, String>{
          'cardNumber': cardNumber,
          'cardExpMonth': cardExpMonth.toString(),
          'cardExpYear': cardExpYear.toString(),
          'cardCVC': cardCVC,
          'publishableKey': publishableKey,
        });
    return token;
  }
}
