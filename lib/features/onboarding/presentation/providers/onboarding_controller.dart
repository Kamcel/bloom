import 'dart:async';

import 'package:bloom/core/models/dating_method.dart';
import 'package:bloom/core/models/dating_result.dart';
import 'package:bloom/core/utils/edd_calculator.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_data.dart';
import 'package:bloom/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

typedef OnboardingState = ({
  OnboardingData data,
  int currentStep,
  bool isSaving,
  bool isSubmitting,
});

@riverpod
class OnboardingController extends _$OnboardingController {
  static const int totalSteps = 3;

  Timer? _debounceTimer;
  Future<void>? _saveOperation;

  @override
  Future<OnboardingState> build() async {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });

    final repository = ref.watch(onboardingRepositoryProvider);
    final progress = await repository.loadProgress();

    if (progress != null) {
      return (
        data: progress.data,
        currentStep: progress.currentStep.clamp(0, totalSteps - 1).toInt(),
        isSaving: false,
        isSubmitting: false,
      );
    }

    return (
      data: const OnboardingData(),
      currentStep: 0,
      isSaving: false,
      isSubmitting: false,
    );
  }

  // ---------------------------------------------------------------------------
  // Personal information
  // ---------------------------------------------------------------------------

  String? validatePersonalInformation(OnboardingData data) {
    if (data.name == null || data.name!.trim().isEmpty) {
      return 'Please enter your name.';
    }

    if (data.dateOfBirth == null) {
      return 'Please select your date of birth.';
    }

    if (data.dateOfBirth!.isAfter(DateTime.now())) {
      return 'Date of birth cannot be in the future.';
    }

    if (data.country == null || data.country!.trim().isEmpty) {
      return 'Please select your country.';
    }

    if (data.state == null || data.state!.trim().isEmpty) {
      return 'Please select your state.';
    }

    if (data.city == null || data.city!.trim().isEmpty) {
      return 'Please select your city.';
    }

    return null;
  }

  void updateName(String? name) {
    _updateData((data) => data.copyWith(name: name));
  }

  void updateDOB(DateTime? dob) {
    _updateData((data) => data.copyWith(dateOfBirth: dob));
  }

  void updateCountry(String? country) {
    _updateData(
      (data) => data.copyWith(country: country, state: null, city: null),
    );
  }

  void updateState(String? stateProvince) {
    _updateData((data) => data.copyWith(state: stateProvince, city: null));
  }

  void updateCity(String? city) {
    _updateData((data) => data.copyWith(city: city));
  }

  // ---------------------------------------------------------------------------
  // Pregnancy dating method
  // ---------------------------------------------------------------------------

  void updateDatingMethod(DatingMethod? method) {
    _updateData((data) => data.copyWith(datingMethod: method));
  }

  // Last menstrual period

  void updateLastMenstrualPeriod(DateTime? date) {
    _updateData((data) => data.copyWith(lastMenstrualPeriod: date));
  }

  void updateCycleRegularity(bool? isRegular) {
    _updateData((data) => data.copyWith(cyclesRegular: isRegular));
  }

  void updateCycleLength(int? days) {
    _updateData((data) => data.copyWith(cycleLengthDays: days));
  }

  // Conception

  void updateConceptionDate(DateTime? date) {
    _updateData((data) => data.copyWith(conceptionDate: date));
  }

  // IVF

  void updateIVFTransferDate(DateTime? date) {
    _updateData((data) => data.copyWith(ivfTransferDate: date));
  }

  void updateIVFEmbryoAge(int? days) {
    _updateData((data) => data.copyWith(ivfEmbryoAgeDays: days));
  }

  // Ultrasound

  void updateUltrasoundDate(DateTime? date) {
    _updateData((data) => data.copyWith(ultrasoundDate: date));
  }

  void updateUltrasoundGestationalWeeks(int? weeks) {
    _updateData((data) => data.copyWith(ultrasoundGestationalWeeks: weeks));
  }

  void updateUltrasoundGestationalDays(int? days) {
    _updateData((data) => data.copyWith(ultrasoundGestationalDays: days));
  }

  // Due dates

  void updateKnownDueDate(DateTime? date) {
    _updateData((data) => data.copyWith(knownDueDate: date));
  }

  void updateProviderConfirmedDueDate(DateTime? date) {
    _updateData((data) => data.copyWith(providerConfirmedDueDate: date));
  }

  // Pregnancy history

  void updateFirstPregnancy(bool? isFirstPregnancy) {
    _updateData((data) => data.copyWith(isFirstPregnancy: isFirstPregnancy));
  }

  // ---------------------------------------------------------------------------
  // Pregnancy validation
  // ---------------------------------------------------------------------------

  String? validatePregnancyInformation(OnboardingData data) {
    final method = data.datingMethod;

    if (method == null) {
      return 'Please select how your pregnancy is dated.';
    }

    if (method == DatingMethod.unknown) {
      return null;
    }

    if (method == DatingMethod.lastMenstrualPeriod) {
      if (data.lastMenstrualPeriod == null) {
        return 'Please enter the first day of your last menstrual period.';
      }

      if (data.cyclesRegular == null) {
        return 'Please tell us whether your menstrual cycles are regular.';
      }

      if (data.cyclesRegular == true &&
          data.cycleLengthDays != null &&
          (data.cycleLengthDays! < 21 || data.cycleLengthDays! > 35)) {
        return 'Please enter a cycle length between 21 and 35 days.';
      }
    } else if (method == DatingMethod.conceptionDate) {
      if (data.conceptionDate == null) {
        return 'Please enter your conception date.';
      }
    } else if (method == DatingMethod.ivfTransfer) {
      if (data.ivfTransferDate == null) {
        return 'Please enter your embryo transfer date.';
      }

      if (![3, 5, 6].contains(data.ivfEmbryoAgeDays)) {
        return 'Embryo age must be 3, 5 or 6 days.';
      }
    } else if (method == DatingMethod.ultrasound) {
      if (data.ultrasoundDate == null) {
        return 'Please enter your ultrasound date.';
      }

      if (data.ultrasoundGestationalWeeks == null) {
        return 'Please enter the gestational weeks from your scan.';
      }

      final days = data.ultrasoundGestationalDays ?? 0;

      if (days < 0 || days > 6) {
        return 'Gestational days must be between 0 and 6.';
      }
    } else if (method == DatingMethod.knownDueDate) {
      if (data.knownDueDate == null) {
        return 'Please enter your estimated due date.';
      }
    } else if (method == DatingMethod.providerConfirmed) {
      if (data.providerConfirmedDueDate == null) {
        return 'Please enter the due date confirmed by your healthcare professional.';
      }
    }

    try {
      final result = calculateDatingResult(data);

      if (result == null) {
        return 'We could not calculate your estimated due date. Please check your information.';
      }

      return null;
    } on ArgumentError {
      return 'Please check your pregnancy dating information.';
    }
  }

  // ---------------------------------------------------------------------------
  // Estimated due date calculation
  // ---------------------------------------------------------------------------

  DatingResult? calculateDatingResult(OnboardingData data) {
    switch (data.datingMethod) {
      case DatingMethod.lastMenstrualPeriod:
        final date = data.lastMenstrualPeriod;
        if (date == null || data.cyclesRegular == null) return null;

        return eddFromLastPeriod(
          lastPeriod: date,
          cyclesRegular: data.cyclesRegular!,
          cycleLengthDays: data.cycleLengthDays,
        );

      case DatingMethod.conceptionDate:
        final date = data.conceptionDate;
        if (date == null) return null;

        return eddFromConception(date);

      case DatingMethod.ivfTransfer:
        final date = data.ivfTransferDate;
        final embryoAge = data.ivfEmbryoAgeDays;

        if (date == null || embryoAge == null) return null;

        return eddFromIvfTransfer(transferDate: date, embryoAgeDays: embryoAge);

      case DatingMethod.ultrasound:
        final date = data.ultrasoundDate;
        final weeks = data.ultrasoundGestationalWeeks;

        if (date == null || weeks == null) return null;

        return eddFromUltrasound(
          scanDate: date,
          gestationalWeeks: weeks,
          gestationalDays: data.ultrasoundGestationalDays ?? 0,
        );

      case DatingMethod.knownDueDate:
        final date = data.knownDueDate;
        if (date == null) return null;

        return DatingResult(
          edd: dateOnly(date),
          method: DatingMethod.knownDueDate,
          confidence: DatingConfidence.low,
          note: 'This date was provided by you and has not been confirmed by a healthcare professional.',
        );

      case DatingMethod.providerConfirmed:
        final date = data.providerConfirmedDueDate;
        if (date == null) return null;

        return providerConfirmedEdd(date);

      case DatingMethod.unknown:
      case null:
        return null;
    }
  }

  DatingResult? get datingResult {
    final current = state.asData?.value;
    if (current == null) return null;

    return calculateDatingResult(current.data);
  }

  // ---------------------------------------------------------------------------
  // Data updates and autosave
  // ---------------------------------------------------------------------------

  void _updateData(OnboardingData Function(OnboardingData data) update) {
    final current = state.asData?.value;
    if (current == null) return;

    updateData(update(current.data));
  }

  void updateData(OnboardingData data) {
    final current = state.asData?.value;
    if (current == null) return;

    DateTime? calculatedEdd;

    try {
      calculatedEdd = calculateDatingResult(data)?.edd;
    } on ArgumentError {
      calculatedEdd = null;
    }

    final updatedData = data.copyWith(estimatedDueDate: calculatedEdd);

    state = AsyncData((
      data: updatedData,
      currentStep: current.currentStep,
      isSaving: current.isSaving,
      isSubmitting: current.isSubmitting,
    ));

    _scheduleAutosave();
  }

  void _scheduleAutosave() {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      unawaited(
        saveProgress().catchError((Object error) {
          // A later save can still proceed if this save fails.
        }),
      );
    });
  }

  Future<void> saveProgress() {
    final previousSave = _saveOperation ?? Future<void>.value();

    final newSave = previousSave
        .catchError((Object error) {
          // Allow the next queued save to proceed.
        })
        .then((_) async {
          final current = state.asData?.value;
          if (current == null) return;

          state = AsyncData((
            data: current.data,
            currentStep: current.currentStep,
            isSaving: true,
            isSubmitting: current.isSubmitting,
          ));

          try {
            final repository = ref.read(onboardingRepositoryProvider);

            await repository.saveProgress(
              data: current.data,
              currentStep: current.currentStep,
            );
          } finally {
            final latest = state.asData?.value;

            if (latest != null) {
              state = AsyncData((
                data: latest.data,
                currentStep: latest.currentStep,
                isSaving: false,
                isSubmitting: latest.isSubmitting,
              ));
            }
          }
        });

    _saveOperation = newSave;

    return newSave;
  }

  // ---------------------------------------------------------------------------
  // Step navigation
  // ---------------------------------------------------------------------------

  Future<void> nextStep() async {
    final current = state.asData?.value;
    if (current == null) return;

    if (current.currentStep >= totalSteps - 1) return;

    if (current.currentStep == 0 &&
        validatePersonalInformation(current.data) != null) {
      return;
    }

    if (current.currentStep == 1 &&
        validatePregnancyInformation(current.data) != null) {
      return;
    }

    _debounceTimer?.cancel();

    state = AsyncData((
      data: current.data,
      currentStep: current.currentStep + 1,
      isSaving: current.isSaving,
      isSubmitting: current.isSubmitting,
    ));

    await saveProgress();
  }

  Future<void> previousStep() async {
    final current = state.asData?.value;
    if (current == null || current.currentStep == 0) return;

    _debounceTimer?.cancel();

    state = AsyncData((
      data: current.data,
      currentStep: current.currentStep - 1,
      isSaving: current.isSaving,
      isSubmitting: current.isSubmitting,
    ));

    await saveProgress();
  }

  // ---------------------------------------------------------------------------
  // Onboarding completion
  // ---------------------------------------------------------------------------

  Future<void> completeOnboarding() async {
    final current = state.asData?.value;

    if (current == null || current.isSubmitting) return;

    if (current.currentStep != totalSteps - 1) return;

    if (validatePersonalInformation(current.data) != null) return;

    if (validatePregnancyInformation(current.data) != null) return;

    _debounceTimer?.cancel();

    state = AsyncData((
      data: current.data,
      currentStep: current.currentStep,
      isSaving: current.isSaving,
      isSubmitting: true,
    ));

    try {
      await saveProgress();

      final repository = ref.read(onboardingRepositoryProvider);
      await repository.completeOnboarding();
    } finally {
      final latest = state.asData?.value;

      if (latest != null) {
        state = AsyncData((
          data: latest.data,
          currentStep: latest.currentStep,
          isSaving: latest.isSaving,
          isSubmitting: false,
        ));
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Clear onboarding progress
  // ---------------------------------------------------------------------------

  Future<void> clearProgress() async {
    _debounceTimer?.cancel();

    try {
      await _saveOperation;
    } catch (_) {
      // Continue clearing even if a previous save failed.
    }

    final repository = ref.read(onboardingRepositoryProvider);

    await repository.clearProgress();

    state = AsyncData((
      data: const OnboardingData(),
      currentStep: 0,
      isSaving: false,
      isSubmitting: false,
    ));
  }
}
