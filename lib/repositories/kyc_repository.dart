import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KycRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> submitKyc({
    required String idType,
    required String idNumber,
    required Uint8List? idFileBytes,
    required String? idFileName,
    required String streetAddress,
    required String city,
    required String state,
    required String zipCode,
    required Uint8List? addressFileBytes,
    required String? addressFileName,
    required String accountHolderName,
    required String accountNumber,
    required String bank,
    required String payoutSchedule,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Upload ID document
    String? idFrontUrl;
    if (idFileBytes != null && idFileName != null) {
      try {
        final ext = idFileName.split('.').last.toLowerCase();
        final path = '$userId/id_front.$ext';
        await _client.storage.from('kyc-documents').uploadBinary(
              path,
              idFileBytes,
              fileOptions: FileOptions(
                contentType: ext == 'pdf' ? 'application/pdf' : 'image/jpeg',
                upsert: true,
              ),
            );
        idFrontUrl = _client.storage.from('kyc-documents').getPublicUrl(path);
      } catch (e) {
        debugPrint('ID upload error: $e');
      }
    }

    // Upload proof of address
    String? proofOfAddressUrl;
    if (addressFileBytes != null && addressFileName != null) {
      try {
        final ext = addressFileName.split('.').last.toLowerCase();
        final path = '$userId/proof_of_address.$ext';
        await _client.storage.from('kyc-documents').uploadBinary(
              path,
              addressFileBytes,
              fileOptions: FileOptions(
                contentType: ext == 'pdf' ? 'application/pdf' : 'image/jpeg',
                upsert: true,
              ),
            );
        proofOfAddressUrl =
            _client.storage.from('kyc-documents').getPublicUrl(path);
      } catch (e) {
        debugPrint('Address doc upload error: $e');
      }
    }

    // Insert into kyc_verifications
    await _client.from('kyc_verifications').upsert({
      'owner_id': userId,
      'status': 'pending',
      'id_type': idType,
      'id_number': idNumber,
      'id_front_url': idFrontUrl,
      'street_address': streetAddress,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'proof_of_address_url': proofOfAddressUrl,
      'account_holder_name': accountHolderName,
      'account_number': accountNumber,
      'bank_name': bank,
      'payout_schedule': payoutSchedule,
      'submitted_at': DateTime.now().toIso8601String(),
    }, onConflict: 'owner_id');
  }
}

final kycRepositoryProvider = Provider<KycRepository>((_) => KycRepository());
