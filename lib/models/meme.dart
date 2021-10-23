class Meme {

  String submissionId = '';
  String submissionUrl = '';
  String submissionTitle = '';
  String permalink = '';
  String author = '';
  String created = '';
  String timestamp = '';

  Meme({
    required this.submissionId,
    required this.submissionUrl,
    required this.submissionTitle,
    required this.permalink,
    required this.author,
    required this.created,
    required this.timestamp
  });

  Meme.fromJson(Map<String, dynamic> json) {
    submissionId = json['submission_id'];
    submissionUrl = json['submission_url'];
    submissionTitle = json['submission_title'];
    permalink = json['permalink'];
    author = json['author'];
    created = json['created'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['submission_id'] = submissionId;
    data['submission_url'] = submissionUrl;
    data['submission_title'] = submissionTitle;
    data['permalink'] = permalink;
    data['author'] = author;
    data['created'] = created;
    data['timestamp'] = timestamp;
    return data;
  }
}