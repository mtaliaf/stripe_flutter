package com.mtaliaf.stripeflutter;

import com.stripe.android.Stripe;
import com.stripe.android.TokenCallback;
import com.stripe.android.model.Card;
import com.stripe.android.model.Token;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** StripeFlutterPlugin */
public class StripeFlutterPlugin implements MethodCallHandler {
  private final PluginRegistry.Registrar registrar;

  StripeFlutterPlugin(PluginRegistry.Registrar registrar) {
    this.registrar = registrar;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.mtaliaf.stripeflutter/stripe_flutter");
    channel.setMethodCallHandler(new StripeFlutterPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "getCardToken":
        handleGetCardToken(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void handleGetCardToken(MethodCall call, final Result result) {
    @SuppressWarnings("unchecked")
    Map<String, String> arguments = (Map<String, String>) call.arguments;

    String cardNumber = arguments.get("cardNumber");
    int cardExpMonth = Integer.valueOf(arguments.get("cardExpMonth"));
    int cardExpYear = Integer.valueOf(arguments.get("cardExpYear"));
    String cardCVC = arguments.get("cardCVC");
    String publishableKey = arguments.get("publishableKey");

    Card card = new Card(cardNumber, cardExpMonth, cardExpYear, cardCVC);

    if (!card.validateCard()) {
      result.error(ErrorCode.INVALID_CARD.toString(), null, null);
      return;
    }

    Stripe stripe = new Stripe(registrar.context());
    stripe.createToken(
        card,
        publishableKey,
        new TokenCallback() {
          @Override
          public void onSuccess(Token token) {
            result.success(token.getId());
          }

          @Override
          public void onError(Exception error) {
            result.error(ErrorCode.TOKEN_REQUEST_FAILED.toString(), null, null);
          }
        });
  }

  private enum ErrorCode {
    NONE,
    INVALID_CARD,
    TOKEN_REQUEST_FAILED,
    UNKNOWN
  }

  private static class StripeException extends Exception {
    private final ErrorCode errorCode;

    StripeException(ErrorCode errorCode) {
      this.errorCode = errorCode;
    }

    StripeException(ErrorCode errorCode, String message) {
      super(message);
      this.errorCode = errorCode;
    }

    ErrorCode getErrorCode() {
      return errorCode;
    }
  }
}
