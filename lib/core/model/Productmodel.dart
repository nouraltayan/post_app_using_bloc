import 'dart:convert';
import 'package:hive_flutter/adapters.dart';
import 'handling.dart';
part 'Productmodel.g.dart';

class ListOf<T> extends ResultModel {
  List<T> data;
  ListOf({
    required this.data,
  });
}

@HiveType(typeId: 1)
class ProductModel extends ResultModel {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? body;
  @HiveField(2)
  num? userId;

  ProductModel({
    this.title,
    this.body,
    this.userId,
  });

  ProductModel copyWith({
    String? name,
    String? body,
    num? userId,
  }) {
    return ProductModel(
      title: title ?? this.title,
      body: body ?? this.body,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'body': body,
      'userId': userId,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      title: map['title'] as String,
      body: map['body'] as String,
      userId: map['userId'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(title: $title, body: $body, userId: $userId,)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.body == body && other.userId == userId;
  }

  @override
  int get hashCode {
    return title.hashCode ^ body.hashCode ^ userId.hashCode;
  }
}
