/// Donation information model
class DonationInfoModel {
  final String url;
  final String? cardNumber;

  const DonationInfoModel({required this.url, this.cardNumber});

  factory DonationInfoModel.fromJson(Map<String, dynamic> json) {
    return DonationInfoModel(
      url: json['jar_url'] as String? ?? '',
      cardNumber: json['card_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'jar_url': url, 'card_number': cardNumber};
  }
}
