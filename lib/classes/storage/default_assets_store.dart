import 'dart:convert';

import 'package:flutter/services.dart';

import '../object_location.dart';

Future<List<dynamic>> loadJSONAssetObjectList(String file) async {
  var jsonStr = await rootBundle.loadString('assets/$file');
  var assets = json.decode(jsonStr);
  var ret = [];
  for(var asset in assets) {
    if(asset is Map) {
      asset['location'] = ObjectLocation(
        type: ObjectLocationType.assets,
        collectionUri: file,
      ).toJson();
      ret.add(asset);
    }
  }
  return ret;
}