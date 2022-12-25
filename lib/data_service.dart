import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:core';
import './constants.dart';
import 'model.dart';

class DataService {
  Future<Model> getData() async {
    //URL запрос
    const String url =
        'https://b24-si58xp.bitrix24.kz/rest/1/xnrera3co5zzivgj/crm.deal.list.json?NEW_PARAM=&select[]=TITLE&select[]=TYPE_ID&select[]=OPPORTUNITY&select[]=TAX_VALUE&select[]=UF_*';

    //Парсинг json-a
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    Model model = modelFromJson(response.body);
    print(model.result[1].title);

    return model;
  }
}
