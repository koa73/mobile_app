import 'dart:async';
import 'dart:convert';
import 'dart:io';


import './auth_api.dart';
import '../model/items_model.dart';

class RestClient {

    final baseUrl = "test-front.phone4pay.ru";
    final _httpClient = new HttpClient();


    ///
    /// Returns the list of all items
    ///
    Future<ItemsList> getItemsList ({int id:0}) async {

        var uri = Uri.https(baseUrl, "mobile/goods/items", <String, String>{
            'topic_id': id.toString()
        });

        var response = await _getRequest(uri);

        ItemsList list = itemsListFromJson(response);
        return list;
    }


    Future<String> _getRequest(Uri uri) async {

        // Temp value must be removed in future
        var token = await auth.getToken(username: '6c6c1d3c-c8c8-5103-b7a2-7a2b0070d2ae',
            password: 'NWM3ZjY0NDgzYTNlMDk5NzA5');

        var request = await _httpClient.getUrl(uri);
        request.headers.add('Authorization','Bearer $token');
        request.headers.add('Accept-Language','ru-RU');

        var response = await request.close();
        return response.transform(utf8.decoder).join();
    }
}

RestClient rest = RestClient();


