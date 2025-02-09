import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class IdTokenPayload {
  final String sub;
  final String name;
  final int exp;

  const IdTokenPayload({required this.sub, required this.name, required this.exp});

  Map<String, dynamic> toJson() {
    return {
      'sub': sub,
    };
  }

  factory IdTokenPayload.fromJson(Map<String, dynamic> json) {
    return IdTokenPayload(
      sub: json['sub'],
      name: json['given_name'],
      exp: json['exp'],
    );
  }

  factory IdTokenPayload.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return IdTokenPayload.fromJson(json);
  }
}

class AuthModel {
  String? idToken;
  String? refreshToken;
  String? accessToken;

  AuthModel({
    this.idToken,
    this.accessToken,
    this.refreshToken
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      idToken: json['id_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      accessToken: json['access_token'] as String?
    );
  }
}
