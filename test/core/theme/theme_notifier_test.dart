import 'package:bloom/core/theme/data/theme_repository.dart';
import 'package:bloom/core/theme/theme_provider.dart';
import 'package:bloom/core/theme/theme_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeThemeRepository implements ThemeRepository {
  _FakeThemeRepository([this.stored = const ThemeState()]);

  ThemeState stored;
  final List<ThemeState> saved = [];

  @override
  Future<ThemeState> load() async => stored;

  @override
  Future<void> save(ThemeState state) async {
    saved.add(state);
    stored = state;
  }
}

void main() {
  ProviderContainer makeContainer(_FakeThemeRepository repo) {
    final container = ProviderContainer(
      overrides: [themeRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('loads the stored theme on build', () async {
    final repo = _FakeThemeRepository(
      const ThemeState(mode: AppThemeMode.dark),
    );
    final container = makeContainer(repo);

    final state = await container.read(themeProvider.future);

    expect(state.mode, AppThemeMode.dark);
  });

  test('setMode updates state and saves it', () async {
    final repo = _FakeThemeRepository();
    final container = makeContainer(repo);
    await container.read(themeProvider.future);

    await container.read(themeProvider.notifier).setMode(AppThemeMode.dark);

    expect(container.read(themeProvider).requireValue.mode, AppThemeMode.dark);
    expect(repo.saved.single.mode, AppThemeMode.dark);
  });

  test('setMode keeps the current text scale', () async {
    final repo = _FakeThemeRepository();
    final container = makeContainer(repo);
    await container.read(themeProvider.future);
    final notifier = container.read(themeProvider.notifier);

    await notifier.setTextScale(1.2);
    await notifier.setMode(AppThemeMode.light);

    final state = container.read(themeProvider).requireValue;
    expect(state.mode, AppThemeMode.light);
    expect(state.textScale, 1.2);
  });

  test('setTextScale clamps to 0.9 - 1.4', () async {
    final repo = _FakeThemeRepository();
    final container = makeContainer(repo);
    await container.read(themeProvider.future);
    final notifier = container.read(themeProvider.notifier);

    await notifier.setTextScale(5);
    expect(container.read(themeProvider).requireValue.textScale, 1.4);

    await notifier.setTextScale(0.1);
    expect(container.read(themeProvider).requireValue.textScale, 0.9);

    await notifier.setTextScale(1.1);
    expect(container.read(themeProvider).requireValue.textScale, 1.1);
  });
}
