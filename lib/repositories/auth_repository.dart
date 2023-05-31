import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:moa_app/utils/api.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class IAuthRepository {
  Future<void> googleLogin();
  Future<void> kakaoLogin();
  Future<void> naverLogin();
  Future<void> appleLogin();
}

class AuthRepository implements IAuthRepository {
  const AuthRepository._();
  static AuthRepository instance = const AuthRepository._();

  @override
  Future<void> googleLogin() async {
    late GoogleSignInAccount? user;
    var googleSignIn = GoogleSignIn();

    if (kIsWeb) {
      user = await googleSignIn.signInSilently();
    } else {
      user = await googleSignIn.signIn();
    }

    if (user != null) {
      var token = await user.authentication;
      var res = await dio.post(
        '/api/v1/user/oauth',
        data: {
          'platform': 'google',
          'id': user.id,
          'email': user.email,
        },
        options: Options(
          headers: {'oauth-token': token.idToken},
        ),
      );

      if (res.data['access_token'].isNotEmpty) {
        await TokenRepository.instance
            .setToken(token: res.data['access_token']);
      }
    }
  }

  @override
  Future<void> kakaoLogin() async {
    late OAuthToken token;
    if (kIsWeb) {
      token = await UserApi.instance.loginWithKakaoAccount();
    } else {
      var isInstalled = await isKakaoTalkInstalled();

      token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();
    }
    Dio kakaoDio = Dio();

    var response = await kakaoDio.get(
      'https://kapi.kakao.com/v2/user/me',
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      ),
    );

    if (response.data.isNotEmpty) {
      var res = await dio.post(
        '/api/v1/user/oauth',
        data: {
          'platform': 'kakao',
          'id': response.data['id'],
          'email': response.data['kakao_account']['email'],
        },
        options: Options(
          headers: {
            'oauth-token': token.accessToken,
          },
        ),
      );

      if (res.data['access_token'].isNotEmpty) {
        await TokenRepository.instance
            .setToken(token: res.data['access_token']);
      }
    }
  }

  @override
  Future<void> naverLogin() async {
    late NaverAccessToken token;
    late NaverLoginResult user;
    if (kIsWeb) {
      Dio naverDio = Dio();
      // todo front에서 요청시 cors 에러 back에서 처리하고 응답 받아야할듯
      await naverDio.get(
        'https://nid.naver.com/oauth2.0/authorize?client_id=K10uUCEMBAnAY0ZtJMeo&redirect_uri=http://localhost:8080&response_type=code&state=test',
      );
    } else {
      user = await FlutterNaverLogin.logIn();
      token = await FlutterNaverLogin.currentAccessToken;
      if (user.status != NaverLoginStatus.loggedIn) {
        return;
      }
    }

    if (token.accessToken.isNotEmpty) {
      var res = await dio.post(
        '/api/v1/user/oauth',
        data: {
          'platform': 'naver',
          'id': user.account.id,
          'email': user.account.email,
        },
        options: Options(
          headers: {'oauth-token': token.accessToken},
        ),
      );

      if (res.data['access_token'].isNotEmpty) {
        await TokenRepository.instance
            .setToken(token: res.data['access_token']);
      }
    }
  }

  @override
  Future<void> appleLogin() async {
    var credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (credential.identityToken != null && credential.userIdentifier != null) {
      var res = await dio.post(
        '/api/v1/user/oauth',
        data: {
          'platform': 'apple',
          'id': credential.userIdentifier,
          'email': credential.email,
        },
        options: Options(
          headers: {'oauth-token': credential.identityToken},
        ),
      );

      if (res.data['access_token'].isNotEmpty) {
        await TokenRepository.instance
            .setToken(token: res.data['access_token']);
      }
    }
  }
}
