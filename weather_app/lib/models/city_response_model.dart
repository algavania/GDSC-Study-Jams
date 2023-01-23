// To parse this JSON data, do
//
//     final cityResponseModel = cityResponseModelFromJson(jsonString);

import 'dart:convert';

List<CityResponseModel> cityResponseModelFromJson(String str) => List<CityResponseModel>.from(json.decode(str).map((x) => CityResponseModel.fromJson(x)));

String cityResponseModelToJson(List<CityResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityResponseModel {
    CityResponseModel({
        required this.key,
        required this.localizedName,
    });

    String key;
    String localizedName;
    factory CityResponseModel.fromJson(Map<String, dynamic> json) => CityResponseModel(
        key: json["Key"],
        localizedName: json["LocalizedName"],
    );

    Map<String, dynamic> toJson() => {
        "Key": key,
        "LocalizedName": localizedName
    };
}
