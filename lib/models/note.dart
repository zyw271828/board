class Note {
  String? content;
  int? colorCode;

  Note(this.content, this.colorCode);

  Note.fromJson(Map<String, dynamic> json)
      : content = json['content'],
        colorCode = json['colorCode'];

  Map<String, dynamic> toJson() => {
        'content': content,
        'colorCode': colorCode,
      };
}
