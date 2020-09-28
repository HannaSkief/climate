import 'dart:convert';

import 'package:climate/core/error/exception.dart';
import 'package:climate/features/climate/data/model/climate_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

abstract class LocalDataSource {
  Future<ClimateModel> getLastClimate();

  Future<void> cacheClimate(ClimateModel climateModel);
}

const CACHED_CLIMATE = 'CACHED_CLIMATE';

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreference;

  LocalDataSourceImpl({@required this.sharedPreference});

  @override
  Future<ClimateModel> getLastClimate() {
    final jsonData = sharedPreference.get(CACHED_CLIMATE);
    if (jsonData != null) {
      return Future.value(ClimateModel.fromJson(json.decode(jsonData)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheClimate(ClimateModel climateModel) {
    return sharedPreference.setString(
        CACHED_CLIMATE, json.encode(climateModel.toJson()));
  }
}
