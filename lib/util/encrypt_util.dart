import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class EncryptUtil {
  static final EncryptUtil _instance = EncryptUtil._internal();

  factory EncryptUtil() {
    return _instance;
  }

  EncryptUtil._internal() {
    // 生成秘钥
    final key = Key.fromUtf8('2b3<94B5->884=F0');
    _encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  }

  late final Encrypter _encrypter;
  // 初始化向量
  final iv = IV.fromUtf8('1234567890');

  /// AES 加密
  String encrypt(String data) {
    final encrypted = _encrypter.encrypt(data, iv: iv);
    return encrypted.base16;
  }

  /// AES 解密
  String decrypt(String encryptedData) {
    final encrypted = Encrypted.fromBase64(encryptedData);
    final decrypted = _encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}

class CryptoUtil {
  /// md5加密
  static String encodeMd5(String data) {
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  /// Base64 加密
  static String encodeBase64(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  /// Base64 解密
  static String decodeBase64(String data) {
    return String.fromCharCodes(base64Decode(data));
  }
}
