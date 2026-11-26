import 'package:bloom/features/onboarding/data/models/onboarding_data.dart';
import 'package:bloom/features/onboarding/data/repository/onboarding_repository.dart';

typedef Progress = ({OnboardingData data, int currentStep});

/// In-memory stand-in for [OnboardingRepository]. Records every call so tests
/// can assert what was saved, and can be told to delay or fail completion.
class FakeOnboardingRepository implements OnboardingRepository {
  FakeOnboardingRepository({this.progress});

  /// What loadProgress() returns. Null = a first-time user.
  Progress? progress;

  final List<Progress> saved = [];
  int completeCalls = 0;
  int clearCalls = 0;

  Duration completeDelay = Duration.zero;
  Object? completeError;

  @override
  Future<void> saveProgress({
    required OnboardingData data,
    required int currentStep,
  }) async {
    saved.add((data: data, currentStep: currentStep));
  }

  @override
  Future<Progress?> loadProgress() async => progress;

  @override
  Future<void> completeOnboarding() async {
    completeCalls++;
    if (completeDelay > Duration.zero) {
      await Future<void>.delayed(completeDelay);
    }
    final error = completeError;
    if (error != null) throw error;
  }

  @override
  Future<void> clearProgress() async {
    clearCalls++;
  }
}
