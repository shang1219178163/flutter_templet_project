import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// 苹果登录 mixin
mixin AppleSiginMixin {
  /// 苹果登录
  Future<Map<String, dynamic>> appleSigin() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // ignore: avoid_print
    print("$this credential: $credential");
    final authorizationCode = credential.authorizationCode;
    final identityToken = credential.identityToken;
    final userIdentifier = credential.userIdentifier;

    // final queryParameters = <String, String>{
    //   'code': credential.authorizationCode,
    //   if (credential.givenName != null)
    //     'firstName': credential.givenName!,
    //   if (credential.familyName != null)
    //     'lastName': credential.familyName!,
    //   if (credential.state != null) 'state': credential.state!,
    // };

    // This is the endpoint that will convert an authorization code obtained
    // via Sign in with Apple into a session in your system
    // final signInWithAppleEndpoint = Uri(
    //   scheme: 'https',
    //   host: 'flutter-sign-in-with-apple-example.glitch.me',
    //   path: '/sign_in_with_apple',
    //   queryParameters: queryParameters,
    // );
    //
    // final session = await Dio().requestUri(
    //   signInWithAppleEndpoint,
    // );
    //
    // print("$this session: $session");

    return credential.toJson();
  }
}

extension on AuthorizationCredentialAppleID {
  static AuthorizationCredentialAppleID? fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return AuthorizationCredentialAppleID(
      userIdentifier: map["userIdentifier"],
      givenName: map["givenName"],
      familyName: map["familyName"],
      authorizationCode: map["authorizationCode"],
      email: map["email"],
      identityToken: map["identityToken"],
      state: map["state"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userIdentifier": userIdentifier,
      "givenName": givenName,
      "familyName": familyName,
      "authorizationCode": authorizationCode,
      "email": email,
      "identityToken": identityToken,
      "state": state,
    };
  }
}
