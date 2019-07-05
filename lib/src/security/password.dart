import 'package:password/password.dart';
import 'dart:convert';


class Pwd{

  static const saltWord = '530f8afbc74536b9a963b4f1c4cb738bcea7403d4d606b6e074ec5d3baf39d18';

  String makePassword(String code){

    final algorithm = PBKDF2(iterationCount: 20);
    final hash = Password.hash(code, algorithm);

    //Save salt !
    final _salt =  hash.split('\$')[3];

    return _toBase64(hash.split('\$')[4].substring(1, 19));
  }

  String encodePasswordPassword(String code, {salt = saltWord}){

    final algorithm = PBKDF2(iterationCount: 20, salt: salt);
    final hash = Password.hash(code, algorithm);

    return _toBase64(hash.split('\$')[4].substring(1, 19));
  }

  String _toBase64(String hash){

    var bytes = utf8.encode(hash);
    return base64.encode(bytes);
  }

}

Pwd pwd = new Pwd();