import 'agency.dart';

class Feed {
  String feedId;
  List<Agency> agencies;

  Feed({
    this.feedId,
    this.agencies,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        feedId: json['feedId'] as String,
        agencies: json['agencies'] != null
            ? List<Agency>.from((json["agencies"] as List<dynamic>).map(
                (x) => Agency.fromJson(x as Map<String, dynamic>),
              ))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'feedId': feedId,
        'agencies': List<dynamic>.from(agencies.map((x) => x.toJson())),
      };
}
