import 'package:equatable/equatable.dart';

class ContactInfo extends Equatable {
  final String? phoneNumber;
  final String? infoUrl;
  final String? bookingUrl;

  const ContactInfo({
    this.phoneNumber,
    this.infoUrl,
    this.bookingUrl,
  });

  factory ContactInfo.fromMap(Map<String, dynamic> map) => ContactInfo(
        phoneNumber: map['phoneNumber'] as String?,
        infoUrl: map['infoUrl'] as String?,
        bookingUrl: map['bookingUrl'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'phoneNumber': phoneNumber,
        'infoUrl': infoUrl,
        'bookingUrl': bookingUrl,
      };

  @override
  List<Object?> get props => [
        phoneNumber,
        infoUrl,
        bookingUrl,
      ];
}
