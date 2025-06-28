import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 1)
enum MessageType {
  @HiveField(0)
  user,
  @HiveField(1)
  assistant,
  @HiveField(2)
  system,
  @HiveField(3)
  code,
  @HiveField(4)
  error,
}

@HiveType(typeId: 2)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String content;
  
  @HiveField(2)
  final MessageType type;
  
  @HiveField(3)
  final DateTime timestamp;
  
  @HiveField(4)
  final String? codeLanguage;
  
  @HiveField(5)
  final Map<String, dynamic>? metadata;

  MessageModel({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.codeLanguage,
    this.metadata,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      content: json['content'],
      type: MessageType.values[json['type']],
      timestamp: DateTime.parse(json['timestamp']),
      codeLanguage: json['codeLanguage'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.index,
      'timestamp': timestamp.toIso8601String(),
      'codeLanguage': codeLanguage,
      'metadata': metadata,
    };
  }
}
