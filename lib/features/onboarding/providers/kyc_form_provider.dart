import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KycFormState {
  // Step 1
  String? idType;
  String idNumber;
  Uint8List? idFileBytes;
  String? idFileName;

  // Step 2
  String streetAddress;
  String? city;
  String? state;
  String zipCode;
  Uint8List? addressFileBytes;
  String? addressFileName;

  // Step 3
  String accountHolderName;
  String accountNumber;
  String? bank;
  String? payoutSchedule;

  KycFormState({
    this.idType,
    this.idNumber = '',
    this.idFileBytes,
    this.idFileName,
    this.streetAddress = '',
    this.city,
    this.state,
    this.zipCode = '',
    this.addressFileBytes,
    this.addressFileName,
    this.accountHolderName = '',
    this.accountNumber = '',
    this.bank,
    this.payoutSchedule,
  });

  KycFormState copyWith({
    String? idType,
    String? idNumber,
    Uint8List? idFileBytes,
    String? idFileName,
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
    Uint8List? addressFileBytes,
    String? addressFileName,
    String? accountHolderName,
    String? accountNumber,
    String? bank,
    String? payoutSchedule,
  }) {
    return KycFormState(
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
      idFileBytes: idFileBytes ?? this.idFileBytes,
      idFileName: idFileName ?? this.idFileName,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      addressFileBytes: addressFileBytes ?? this.addressFileBytes,
      addressFileName: addressFileName ?? this.addressFileName,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNumber: accountNumber ?? this.accountNumber,
      bank: bank ?? this.bank,
      payoutSchedule: payoutSchedule ?? this.payoutSchedule,
    );
  }
}

class KycFormNotifier extends StateNotifier<KycFormState> {
  KycFormNotifier() : super(KycFormState());

  void updateIdentity({
    String? idType,
    String? idNumber,
    Uint8List? idFileBytes,
    String? idFileName,
  }) {
    state = state.copyWith(
      idType: idType,
      idNumber: idNumber,
      idFileBytes: idFileBytes,
      idFileName: idFileName,
    );
  }

  void updateLocation({
    String? streetAddress,
    String? city,
    String? state,
    String? zipCode,
    Uint8List? addressFileBytes,
    String? addressFileName,
  }) {
    this.state = this.state.copyWith(
          streetAddress: streetAddress,
          city: city,
          state: state,
          zipCode: zipCode,
          addressFileBytes: addressFileBytes,
          addressFileName: addressFileName,
        );
  }

  void updatePayment({
    String? accountHolderName,
    String? accountNumber,
    String? bank,
    String? payoutSchedule,
  }) {
    state = state.copyWith(
      accountHolderName: accountHolderName,
      accountNumber: accountNumber,
      bank: bank,
      payoutSchedule: payoutSchedule,
    );
  }
}

final kycFormProvider = StateNotifierProvider<KycFormNotifier, KycFormState>(
  (_) => KycFormNotifier(),
);
