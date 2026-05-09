// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kyc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KycVerification {

 String? get id; String? get ownerId; KycStatus get status; IdType? get idType; String? get idNumber; String? get idFrontUrl; String? get idBackUrl; String? get selfieUrl; String? get streetAddress; String? get city; String? get state; String? get zipCode; String? get proofOfAddressUrl; String? get accountHolderName; String? get accountNumber; String? get bankName; String? get payoutSchedule; String? get rejectionReason; DateTime? get submittedAt; DateTime? get createdAt;
/// Create a copy of KycVerification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KycVerificationCopyWith<KycVerification> get copyWith => _$KycVerificationCopyWithImpl<KycVerification>(this as KycVerification, _$identity);

  /// Serializes this KycVerification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KycVerification&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.idType, idType) || other.idType == idType)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber)&&(identical(other.idFrontUrl, idFrontUrl) || other.idFrontUrl == idFrontUrl)&&(identical(other.idBackUrl, idBackUrl) || other.idBackUrl == idBackUrl)&&(identical(other.selfieUrl, selfieUrl) || other.selfieUrl == selfieUrl)&&(identical(other.streetAddress, streetAddress) || other.streetAddress == streetAddress)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.proofOfAddressUrl, proofOfAddressUrl) || other.proofOfAddressUrl == proofOfAddressUrl)&&(identical(other.accountHolderName, accountHolderName) || other.accountHolderName == accountHolderName)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.payoutSchedule, payoutSchedule) || other.payoutSchedule == payoutSchedule)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,ownerId,status,idType,idNumber,idFrontUrl,idBackUrl,selfieUrl,streetAddress,city,state,zipCode,proofOfAddressUrl,accountHolderName,accountNumber,bankName,payoutSchedule,rejectionReason,submittedAt,createdAt]);

@override
String toString() {
  return 'KycVerification(id: $id, ownerId: $ownerId, status: $status, idType: $idType, idNumber: $idNumber, idFrontUrl: $idFrontUrl, idBackUrl: $idBackUrl, selfieUrl: $selfieUrl, streetAddress: $streetAddress, city: $city, state: $state, zipCode: $zipCode, proofOfAddressUrl: $proofOfAddressUrl, accountHolderName: $accountHolderName, accountNumber: $accountNumber, bankName: $bankName, payoutSchedule: $payoutSchedule, rejectionReason: $rejectionReason, submittedAt: $submittedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $KycVerificationCopyWith<$Res>  {
  factory $KycVerificationCopyWith(KycVerification value, $Res Function(KycVerification) _then) = _$KycVerificationCopyWithImpl;
@useResult
$Res call({
 String? id, String? ownerId, KycStatus status, IdType? idType, String? idNumber, String? idFrontUrl, String? idBackUrl, String? selfieUrl, String? streetAddress, String? city, String? state, String? zipCode, String? proofOfAddressUrl, String? accountHolderName, String? accountNumber, String? bankName, String? payoutSchedule, String? rejectionReason, DateTime? submittedAt, DateTime? createdAt
});




}
/// @nodoc
class _$KycVerificationCopyWithImpl<$Res>
    implements $KycVerificationCopyWith<$Res> {
  _$KycVerificationCopyWithImpl(this._self, this._then);

  final KycVerification _self;
  final $Res Function(KycVerification) _then;

/// Create a copy of KycVerification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? ownerId = freezed,Object? status = null,Object? idType = freezed,Object? idNumber = freezed,Object? idFrontUrl = freezed,Object? idBackUrl = freezed,Object? selfieUrl = freezed,Object? streetAddress = freezed,Object? city = freezed,Object? state = freezed,Object? zipCode = freezed,Object? proofOfAddressUrl = freezed,Object? accountHolderName = freezed,Object? accountNumber = freezed,Object? bankName = freezed,Object? payoutSchedule = freezed,Object? rejectionReason = freezed,Object? submittedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as KycStatus,idType: freezed == idType ? _self.idType : idType // ignore: cast_nullable_to_non_nullable
as IdType?,idNumber: freezed == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String?,idFrontUrl: freezed == idFrontUrl ? _self.idFrontUrl : idFrontUrl // ignore: cast_nullable_to_non_nullable
as String?,idBackUrl: freezed == idBackUrl ? _self.idBackUrl : idBackUrl // ignore: cast_nullable_to_non_nullable
as String?,selfieUrl: freezed == selfieUrl ? _self.selfieUrl : selfieUrl // ignore: cast_nullable_to_non_nullable
as String?,streetAddress: freezed == streetAddress ? _self.streetAddress : streetAddress // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,zipCode: freezed == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String?,proofOfAddressUrl: freezed == proofOfAddressUrl ? _self.proofOfAddressUrl : proofOfAddressUrl // ignore: cast_nullable_to_non_nullable
as String?,accountHolderName: freezed == accountHolderName ? _self.accountHolderName : accountHolderName // ignore: cast_nullable_to_non_nullable
as String?,accountNumber: freezed == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String?,bankName: freezed == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String?,payoutSchedule: freezed == payoutSchedule ? _self.payoutSchedule : payoutSchedule // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [KycVerification].
extension KycVerificationPatterns on KycVerification {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KycVerification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KycVerification() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KycVerification value)  $default,){
final _that = this;
switch (_that) {
case _KycVerification():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KycVerification value)?  $default,){
final _that = this;
switch (_that) {
case _KycVerification() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? ownerId,  KycStatus status,  IdType? idType,  String? idNumber,  String? idFrontUrl,  String? idBackUrl,  String? selfieUrl,  String? streetAddress,  String? city,  String? state,  String? zipCode,  String? proofOfAddressUrl,  String? accountHolderName,  String? accountNumber,  String? bankName,  String? payoutSchedule,  String? rejectionReason,  DateTime? submittedAt,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KycVerification() when $default != null:
return $default(_that.id,_that.ownerId,_that.status,_that.idType,_that.idNumber,_that.idFrontUrl,_that.idBackUrl,_that.selfieUrl,_that.streetAddress,_that.city,_that.state,_that.zipCode,_that.proofOfAddressUrl,_that.accountHolderName,_that.accountNumber,_that.bankName,_that.payoutSchedule,_that.rejectionReason,_that.submittedAt,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? ownerId,  KycStatus status,  IdType? idType,  String? idNumber,  String? idFrontUrl,  String? idBackUrl,  String? selfieUrl,  String? streetAddress,  String? city,  String? state,  String? zipCode,  String? proofOfAddressUrl,  String? accountHolderName,  String? accountNumber,  String? bankName,  String? payoutSchedule,  String? rejectionReason,  DateTime? submittedAt,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _KycVerification():
return $default(_that.id,_that.ownerId,_that.status,_that.idType,_that.idNumber,_that.idFrontUrl,_that.idBackUrl,_that.selfieUrl,_that.streetAddress,_that.city,_that.state,_that.zipCode,_that.proofOfAddressUrl,_that.accountHolderName,_that.accountNumber,_that.bankName,_that.payoutSchedule,_that.rejectionReason,_that.submittedAt,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? ownerId,  KycStatus status,  IdType? idType,  String? idNumber,  String? idFrontUrl,  String? idBackUrl,  String? selfieUrl,  String? streetAddress,  String? city,  String? state,  String? zipCode,  String? proofOfAddressUrl,  String? accountHolderName,  String? accountNumber,  String? bankName,  String? payoutSchedule,  String? rejectionReason,  DateTime? submittedAt,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _KycVerification() when $default != null:
return $default(_that.id,_that.ownerId,_that.status,_that.idType,_that.idNumber,_that.idFrontUrl,_that.idBackUrl,_that.selfieUrl,_that.streetAddress,_that.city,_that.state,_that.zipCode,_that.proofOfAddressUrl,_that.accountHolderName,_that.accountNumber,_that.bankName,_that.payoutSchedule,_that.rejectionReason,_that.submittedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KycVerification implements KycVerification {
  const _KycVerification({this.id, this.ownerId, this.status = KycStatus.notStarted, this.idType, this.idNumber, this.idFrontUrl, this.idBackUrl, this.selfieUrl, this.streetAddress, this.city, this.state, this.zipCode, this.proofOfAddressUrl, this.accountHolderName, this.accountNumber, this.bankName, this.payoutSchedule, this.rejectionReason, this.submittedAt, this.createdAt});
  factory _KycVerification.fromJson(Map<String, dynamic> json) => _$KycVerificationFromJson(json);

@override final  String? id;
@override final  String? ownerId;
@override@JsonKey() final  KycStatus status;
@override final  IdType? idType;
@override final  String? idNumber;
@override final  String? idFrontUrl;
@override final  String? idBackUrl;
@override final  String? selfieUrl;
@override final  String? streetAddress;
@override final  String? city;
@override final  String? state;
@override final  String? zipCode;
@override final  String? proofOfAddressUrl;
@override final  String? accountHolderName;
@override final  String? accountNumber;
@override final  String? bankName;
@override final  String? payoutSchedule;
@override final  String? rejectionReason;
@override final  DateTime? submittedAt;
@override final  DateTime? createdAt;

/// Create a copy of KycVerification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KycVerificationCopyWith<_KycVerification> get copyWith => __$KycVerificationCopyWithImpl<_KycVerification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KycVerificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KycVerification&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.status, status) || other.status == status)&&(identical(other.idType, idType) || other.idType == idType)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber)&&(identical(other.idFrontUrl, idFrontUrl) || other.idFrontUrl == idFrontUrl)&&(identical(other.idBackUrl, idBackUrl) || other.idBackUrl == idBackUrl)&&(identical(other.selfieUrl, selfieUrl) || other.selfieUrl == selfieUrl)&&(identical(other.streetAddress, streetAddress) || other.streetAddress == streetAddress)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.proofOfAddressUrl, proofOfAddressUrl) || other.proofOfAddressUrl == proofOfAddressUrl)&&(identical(other.accountHolderName, accountHolderName) || other.accountHolderName == accountHolderName)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.payoutSchedule, payoutSchedule) || other.payoutSchedule == payoutSchedule)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,ownerId,status,idType,idNumber,idFrontUrl,idBackUrl,selfieUrl,streetAddress,city,state,zipCode,proofOfAddressUrl,accountHolderName,accountNumber,bankName,payoutSchedule,rejectionReason,submittedAt,createdAt]);

@override
String toString() {
  return 'KycVerification(id: $id, ownerId: $ownerId, status: $status, idType: $idType, idNumber: $idNumber, idFrontUrl: $idFrontUrl, idBackUrl: $idBackUrl, selfieUrl: $selfieUrl, streetAddress: $streetAddress, city: $city, state: $state, zipCode: $zipCode, proofOfAddressUrl: $proofOfAddressUrl, accountHolderName: $accountHolderName, accountNumber: $accountNumber, bankName: $bankName, payoutSchedule: $payoutSchedule, rejectionReason: $rejectionReason, submittedAt: $submittedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$KycVerificationCopyWith<$Res> implements $KycVerificationCopyWith<$Res> {
  factory _$KycVerificationCopyWith(_KycVerification value, $Res Function(_KycVerification) _then) = __$KycVerificationCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? ownerId, KycStatus status, IdType? idType, String? idNumber, String? idFrontUrl, String? idBackUrl, String? selfieUrl, String? streetAddress, String? city, String? state, String? zipCode, String? proofOfAddressUrl, String? accountHolderName, String? accountNumber, String? bankName, String? payoutSchedule, String? rejectionReason, DateTime? submittedAt, DateTime? createdAt
});




}
/// @nodoc
class __$KycVerificationCopyWithImpl<$Res>
    implements _$KycVerificationCopyWith<$Res> {
  __$KycVerificationCopyWithImpl(this._self, this._then);

  final _KycVerification _self;
  final $Res Function(_KycVerification) _then;

/// Create a copy of KycVerification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? ownerId = freezed,Object? status = null,Object? idType = freezed,Object? idNumber = freezed,Object? idFrontUrl = freezed,Object? idBackUrl = freezed,Object? selfieUrl = freezed,Object? streetAddress = freezed,Object? city = freezed,Object? state = freezed,Object? zipCode = freezed,Object? proofOfAddressUrl = freezed,Object? accountHolderName = freezed,Object? accountNumber = freezed,Object? bankName = freezed,Object? payoutSchedule = freezed,Object? rejectionReason = freezed,Object? submittedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_KycVerification(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as KycStatus,idType: freezed == idType ? _self.idType : idType // ignore: cast_nullable_to_non_nullable
as IdType?,idNumber: freezed == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String?,idFrontUrl: freezed == idFrontUrl ? _self.idFrontUrl : idFrontUrl // ignore: cast_nullable_to_non_nullable
as String?,idBackUrl: freezed == idBackUrl ? _self.idBackUrl : idBackUrl // ignore: cast_nullable_to_non_nullable
as String?,selfieUrl: freezed == selfieUrl ? _self.selfieUrl : selfieUrl // ignore: cast_nullable_to_non_nullable
as String?,streetAddress: freezed == streetAddress ? _self.streetAddress : streetAddress // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,zipCode: freezed == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String?,proofOfAddressUrl: freezed == proofOfAddressUrl ? _self.proofOfAddressUrl : proofOfAddressUrl // ignore: cast_nullable_to_non_nullable
as String?,accountHolderName: freezed == accountHolderName ? _self.accountHolderName : accountHolderName // ignore: cast_nullable_to_non_nullable
as String?,accountNumber: freezed == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String?,bankName: freezed == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String?,payoutSchedule: freezed == payoutSchedule ? _self.payoutSchedule : payoutSchedule // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
