#import "StripeFlutterPlugin.h"
#import "Stripe/Stripe.h"

@implementation StripeFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.mtaliaf.stripeflutter/stripe_flutter"
            binaryMessenger:[registrar messenger]];
  StripeFlutterPlugin* instance = [[StripeFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getCardToken" isEqualToString:call.method]) {
    [self handleGetCardToken:call result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)handleGetCardToken:(FlutterMethodCall*)call result:(FlutterResult)result {  
  STPCardParams *cardParams = [[STPCardParams alloc] init];
  cardParams.number = call.arguments[@"cardNumber"];
  cardParams.expMonth = [call.arguments[@"cardExpMonth"] intValue];
  cardParams.expYear = [call.arguments[@"cardExpYear"] intValue];
  cardParams.cvc = call.arguments[@"cardCVC"];

  [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:call.arguments[@"publishableKey"]];
  [[STPAPIClient sharedClient] createTokenWithCard:cardParams completion:^(STPToken *token, NSError *error) {
      if (token == nil || error != nil) {
          result([FlutterError errorWithCode:@"TOKEN_REQUEST_FAILED"
                                      message:nil
                                      details:nil]);
          return;
      }

      result(token.tokenId);
  }];
}

@end
