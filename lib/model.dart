// To parse this JSON data, do
//
//     final model = modelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Model modelFromJson(String str) => Model.fromJson(json.decode(str));

String modelToJson(Model data) => json.encode(data.toJson());

class Model {
  Model({
    required this.result,
    // required this.total,
    // required this.time,
  });

  List<Result> result;
  // int total;
  // Time time;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        // total: json["total"],
        // time: Time.fromJson(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        // "total": total,
        // "time": time.toJson(),
      };
}

class Result {
  Result({
    required this.title,
    required this.typeId,
    required this.opportunity,
    required this.taxValue,
    required this.id,
    required this.ufCrm1671547810826,
  });

  String title;
  String typeId;
  String opportunity;
  String taxValue;
  String id;
  String ufCrm1671547810826;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        title: json["TITLE"],
        typeId: json["TYPE_ID"] == null ? '' : json["TYPE_ID"],
        opportunity: json["OPPORTUNITY"] == null ? '' : json["OPPORTUNITY"],
        taxValue: json["TAX_VALUE"] == null ? '' : json["TAX_VALUE"],
        id: json["ID"],
        ufCrm1671547810826: json["UF_CRM_1671547810826"] == null
            ? ''
            : json["UF_CRM_1671547810826"],
      );

  Map<String, dynamic> toJson() => {
        "TITLE": title,
        "TYPE_ID": typeId == null ? '' : typeId,
        "OPPORTUNITY": opportunity == null ? '' : opportunity,
        "TAX_VALUE": taxValue == null ? '' : taxValue,
        "ID": id,
        "UF_CRM_1671547810826":
            ufCrm1671547810826 == null ? '' : ufCrm1671547810826,
      };
}

// class Time {
//   Time({
//     required this.start,
//     required this.finish,
//     required this.duration,
//     required this.processing,
//     required this.dateStart,
//     required this.dateFinish,
//     required this.operatingResetAt,
//     required this.operating,
//   });
//
//   double start;
//   double finish;
//   double duration;
//   double processing;
//   DateTime dateStart;
//   DateTime dateFinish;
//   int operatingResetAt;
//   int operating;
//
//   factory Time.fromJson(Map<String, dynamic> json) => Time(
//         start: json["start"].toDouble(),
//         finish: json["finish"].toDouble(),
//         duration: json["duration"].toDouble(),
//         processing: json["processing"].toDouble(),
//         dateStart: DateTime.parse(json["date_start"]),
//         dateFinish: DateTime.parse(json["date_finish"]),
//         operatingResetAt: json["operating_reset_at"],
//         operating: json["operating"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "start": start,
//         "finish": finish,
//         "duration": duration,
//         "processing": processing,
//         "date_start": dateStart.toIso8601String(),
//         "date_finish": dateFinish.toIso8601String(),
//         "operating_reset_at": operatingResetAt,
//         "operating": operating,
//       };
// }
