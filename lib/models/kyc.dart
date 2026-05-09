import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc.freezed.dart';
part 'kyc.g.dart';

enum KycStatus { notStarted, pending, submitted, approved, rejected }

enum IdType {
  @JsonValue('drivers_license')
  driversLicense,
  @JsonValue('nin')
  nin,
  @JsonValue('passport')
  passport,
  @JsonValue('voters_card')
  votersCard,
}

extension IdTypeLabel on IdType {
  String get label {
    switch (this) {
      case IdType.driversLicense:
        return "Driver's License";
      case IdType.nin:
        return 'National ID (NIN)';
      case IdType.passport:
        return 'International Passport';
      case IdType.votersCard:
        return "Voter's Card";
    }
  }
}

@Freezed()
abstract class KycVerification with _$KycVerification {
  const factory KycVerification({
    String? id,
    String? ownerId,
    @Default(KycStatus.notStarted) KycStatus status,
    IdType? idType,
    String? idNumber,
    String? idFrontUrl,
    String? idBackUrl,
    String? selfieUrl,
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
    String? proofOfAddressUrl,
    String? accountHolderName,
    String? accountNumber,
    String? bankName,
    String? payoutSchedule,
    String? rejectionReason,
    DateTime? submittedAt,
    DateTime? createdAt,
  }) = _KycVerification;

  factory KycVerification.fromJson(Map<String, dynamic> json) =>
      _$KycVerificationFromJson(json);
}
