import 'package:memes_app/models/meme.dart';

class ResponseApi {
  int total = 0;
  int count = 0;
  List<Meme> data = [];

  ResponseApi({
    required this.total,
    required this.count,
    required this.data
  });

  ResponseApi.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    count = json['count'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((meme) {
        data.add(Meme.fromJson(meme));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = total;
    data['count'] = count;
    data['data'] = this.data.map((meme) => meme.toJson()).toList();
    return data;
  }
}