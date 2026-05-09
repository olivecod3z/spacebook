// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KycVerification _$KycVerificationFromJson(Map<String, dynamic> json) =>
    _KycVerification(
      id: json['id'] as String?,
      ownerId: json['ownerId'] as String?,
      status:
          $enumDecodeNullable(_$KycStatusEnumMap, json['status']) ??
          KycStatus.notStarted,
      idType: $enumDecodeNullable(_$IdTypeEnumMap, json['idType']),
      idNumber: json['idNumber'] as String?,
      idFrontUrl: json['idFrontUrl'] as String?,
      idBackUrl: json['idBackUrl'] as String?,
      selfieUrl: json['selfieUrl'] as String?,
      streetAddress: json['streetAddress'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      proofOfAddressUrl: json['proofOfAddressUrl'] as String?,
      accountHolderName: json['accountHolderName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      bankName: json['bankName'] as String?,
      payoutSchedule: json['payoutSchedule'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$KycVerificationToJson(_KycVerification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'status': _$KycStatusEnumMap[instance.status]!,
      'idType': _$IdTypeEnumMap[instance.idType],
      'idNumber': instance.idNumber,
      'idFrontUrl': instance.idFrontUrl,
      'idBackUrl': instance.idBackUrl,
      'selfieUrl': instance.selfieUrl,
      'streetAddress': instance.streetAddress,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'proofOfAddressUrl': instance.proofOfAddressUrl,
      'accountHolderName': instance.accountHolderName,
      'accountNumber': instance.accountNumber,
      'bankName': instance.bankName,
      'payoutSchedule': instance.payoutSchedule,
      'rejectionReason': instance.rejectionReason,
      'submittedAt': instance.submittedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$KycStatusEnumMap = {
  KycStatus.notStarted: 'notStarted',
  KycStatus.pending: 'pending',
  KycStatus.submitted: 'submitted',
  KycStatus.approved: 'approved',
  KycStatus.rejected: 'rejected',
};

const _$IdTypeEnumMap = {
  IdType.driversLicense: 'drivers_license',
  IdType.nin: 'nin',
  IdType.passport: 'passport',
  IdType.votersCard: 'voters_card',
};
