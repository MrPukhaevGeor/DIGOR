// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_page_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchWordHash() => r'bbdbcf2f45e7e85b2fab52472e894b4f5b54a6b8';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [fetchWord].
@ProviderFor(fetchWord)
const fetchWordProvider = FetchWordFamily();

/// See also [fetchWord].
class FetchWordFamily extends Family<AsyncValue<WordModel>> {
  /// See also [fetchWord].
  const FetchWordFamily();

  /// See also [fetchWord].
  FetchWordProvider call({
    required int id,
  }) {
    return FetchWordProvider(
      id: id,
    );
  }

  @override
  FetchWordProvider getProviderOverride(
    covariant FetchWordProvider provider,
  ) {
    return call(
      id: provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchWordProvider';
}

/// See also [fetchWord].
class FetchWordProvider extends AutoDisposeFutureProvider<WordModel> {
  /// See also [fetchWord].
  FetchWordProvider({
    required int id,
  }) : this._internal(
          (ref) => fetchWord(
            ref as FetchWordRef,
            id: id,
          ),
          from: fetchWordProvider,
          name: r'fetchWordProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchWordHash,
          dependencies: FetchWordFamily._dependencies,
          allTransitiveDependencies: FetchWordFamily._allTransitiveDependencies,
          id: id,
        );

  FetchWordProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<WordModel> Function(FetchWordRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchWordProvider._internal(
        (ref) => create(ref as FetchWordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WordModel> createElement() {
    return _FetchWordProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchWordProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchWordRef on AutoDisposeFutureProviderRef<WordModel> {
  /// The parameter `id` of this provider.
  int get id;
}

class _FetchWordProviderElement
    extends AutoDisposeFutureProviderElement<WordModel> with FetchWordRef {
  _FetchWordProviderElement(super.provider);

  @override
  int get id => (origin as FetchWordProvider).id;
}

String _$articleZoomHash() => r'3a877299dbc44f86ace4b92e9599e897f4d912d4';

/// See also [ArticleZoom].
@ProviderFor(ArticleZoom)
final articleZoomProvider = NotifierProvider<ArticleZoom, double>.internal(
  ArticleZoom.new,
  name: r'articleZoomProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$articleZoomHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ArticleZoom = Notifier<double>;
String _$exampleModeHash() => r'52ed9eb39af51371b68b5c63e0fe23c5fd18b56d';

/// See also [ExampleMode].
@ProviderFor(ExampleMode)
final exampleModeProvider =
    AutoDisposeNotifierProvider<ExampleMode, ExampleModeEnum>.internal(
  ExampleMode.new,
  name: r'exampleModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$exampleModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExampleMode = AutoDisposeNotifier<ExampleModeEnum>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
