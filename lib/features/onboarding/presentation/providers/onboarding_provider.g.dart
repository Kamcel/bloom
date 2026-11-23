// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(onboardingStorage)
final onboardingStorageProvider = OnboardingStorageProvider._();

final class OnboardingStorageProvider
    extends
        $FunctionalProvider<
          OnboardingStorage,
          OnboardingStorage,
          OnboardingStorage
        >
    with $Provider<OnboardingStorage> {
  OnboardingStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingStorageHash();

  @$internal
  @override
  $ProviderElement<OnboardingStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OnboardingStorage create(Ref ref) {
    return onboardingStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingStorage>(value),
    );
  }
}

String _$onboardingStorageHash() => r'ac3d4a8996eea31b1e5a7fbb6885f5e302984486';

@ProviderFor(onboardingRepository)
final onboardingRepositoryProvider = OnboardingRepositoryProvider._();

final class OnboardingRepositoryProvider
    extends
        $FunctionalProvider<
          OnboardingRepository,
          OnboardingRepository,
          OnboardingRepository
        >
    with $Provider<OnboardingRepository> {
  OnboardingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingRepositoryHash();

  @$internal
  @override
  $ProviderElement<OnboardingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OnboardingRepository create(Ref ref) {
    return onboardingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingRepository>(value),
    );
  }
}

String _$onboardingRepositoryHash() =>
    r'4d3a68118d39eb511e32d056d38723aae2ea1acb';
