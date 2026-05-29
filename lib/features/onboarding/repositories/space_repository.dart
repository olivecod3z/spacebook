import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SpaceRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String> createSpace({
    required String title,
    required String spaceType,
    required String description,
    required String capacity,
    required String streetAddress,
    required String city,
    required String state,
    required String zipCode,
    required double hourlyRate,
    required int minimumHours,
    required List<String> availableDays,
    required String availableFrom,
    required String availableUntil,
    required List<String> amenities,
    required String rules,
    String status = 'draft',
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final spaceId = const Uuid().v4();
    final capacityNum = _parseCapacity(capacity);

    await _client.from('spaces').insert({
      'id': spaceId,
      'owner_id': userId,
      'title': title,
      'description': description,
      'space_type': spaceType,
      'street_address': streetAddress,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'capacity': capacityNum,
      'hourly_rate': hourlyRate,
      'minimum_hours': minimumHours,
      'available_days': availableDays,
      'available_from': availableFrom,
      'available_until': availableUntil,
      'amenities': amenities,
      'rules': rules,
      'photos': [],
      'status': status,
    });

    return spaceId;
  }

  Future<List<Map<String, dynamic>>> getMySpaces() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client
        .from('spaces')
        .select()
        .eq('owner_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateSpace({
    required String spaceId,
    required Map<String, dynamic> updates,
  }) async {
    await _client.from('spaces').update(updates).eq('id', spaceId);
  }

  Future<void> deleteSpace(String spaceId) async {
    await _client.from('spaces').delete().eq('id', spaceId);
  }

  Future<void> updateSpaceStatus({
    required String spaceId,
    required String status,
  }) async {
    await _client
        .from('spaces')
        .update({'status': status}).eq('id', spaceId);
  }

  int _parseCapacity(String capacity) {
    final numbers = RegExp(r'\d+').allMatches(capacity);
    if (numbers.isEmpty) return 0;
    final all = numbers.map((m) => int.parse(m.group(0)!)).toList();
    return all.last;
  }
}

final spaceRepositoryInstance = SpaceRepository();