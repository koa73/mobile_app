import 'dart:async';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../globals.dart' as global;
import '../security/password.dart';


class AuthClient {

  final baseUrl = "test-front.phone4pay.ru";
  final basicKey = "YWNtZTphY21lc2VjcmV0";

  // PreRegistration authentication request
  Future<String> getCredential() async  {
    return await _getNewToken(grantType: "client_credentials");
  }


  // Request current token, required authentication before
  Future<String> getToken({String username, String password}) async {

    final current = new DateTime.now().millisecondsSinceEpoch;

    if (password != null){
      password = pwd.encodePasswordPassword(password);
    }

    if (global.expire == null) {

      return await _getNewToken(grantType: "password", username: username,
          password: password);
      
    } else {
      
      if (global.expire > current) {

        return global.token;

      } else {

        return await _getNewToken(
            grantType: "refresh_token", token: global.refresh);
      }
    }
  }

  // OAuth server request
  Future<String> _getNewToken({String grantType, String username,

    String password, String token}) async {

    if (username == null){
      username = _getCurrentUserName();
    }

    var uri = Uri.https(
        baseUrl,
        '/uaa/oauth/token',
        <String, String>{
          'grant_type': grantType,
          'username' : username,
          'password' : password,
          'refresh_token' : token
        }
    );

    try{

      final response = await http.post(uri,
      headers: {HttpHeaders.authorizationHeader: "Basic $basicKey"},);

      if (response.statusCode == 200) {

        var jsonResponse = convert.jsonDecode(response.body);
        _saveToken(jsonResponse);
        return jsonResponse['access_token'];

      } else {

        throw ("${convert.jsonDecode(response.body)['error']}");
      }

    } on SocketException{
      throw ("Internet access error. Please check your connection.");
    }

  }

  // Save current token data in memory variable for reusing
  void _saveToken(jsonResponse) async {

    final current = new DateTime.now().millisecondsSinceEpoch;
    global.token = jsonResponse['access_token'];
    // calculate expire time in epoch format minus 10 sec
    global.expire = jsonResponse['expires_in']*1000 - 10000 + current;
    global.refresh = jsonResponse['refresh_token'];
  }

  String _getCurrentUserName(){
    return "6c6c1d3c-c8c8-5103-b7a2-7a2b0070d2ae";
  }

}

AuthClient auth = AuthClient();