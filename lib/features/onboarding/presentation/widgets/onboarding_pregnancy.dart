import 'package:bloom/core/models/dating_method.dart';
import 'package:bloom/core/models/dating_result.dart';
import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/core/utils/date_util.dart';
import 'package:bloom/core/utils/edd_calculator.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_data.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_questions_page.dart';
import 'package:bloom/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension DatingMethodLabel on DatingMethod {
  String get label => switch (this) {
    DatingMethod.lastMenstrualPeriod => 'Last menstrual period',
    DatingMethod.conceptionDate => 'Conception date',
    DatingMethod.ivfTransfer => 'IVF transfer',
    DatingMethod.ultrasound => 'Ultrasound',
    DatingMethod.knownDueDate => 'I know my due date',
    DatingMethod.unknown => "I don't know",
    DatingMethod.providerConfirmed => 'Confirmed by my healthcare provider',
  };
}

class OnboardingPregnancy extends ConsumerStatefulWidget {
  final OnboardingQuestionsPage questionsPage;

  const OnboardingPregnancy({super.key, required this.questionsPage});

  @override
  ConsumerState<OnboardingPregnancy> createState() =>
      _OnboardingPregnancyState();
}

class _OnboardingPregnancyState extends ConsumerState<OnboardingPregnancy>
    with AutomaticKeepAliveClientMixin {
  static const List<int> _cycleLengths = [
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
  ];

  final TextEditingController _dateController = TextEditingController();

  DatingMethod _selectedMethod = DatingMethod.lastMenstrualPeriod;

  DateTime? _selectedDate;

  bool _cyclesRegular = true;
  int _cycleLengthDays = 28;

  int _gestationalWeeks = 8;
  int _gestationalDays = 0;

  int _embryoAgeDays = 5;

  // Keeps the page alive when the user moves to another step and back, so the
  // dropdowns are not rebuilt from scratch every time.
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // Pages are only built after the controller has loaded, so the saved
    // answers are available here. Reading once means this page does not
    // rebuild every time any answer on any page changes.
    final data = ref.read(onboardingControllerProvider).value?.data;
    if (data == null) return;

    _restoreFromData(data);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initializeController();
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Restore saved onboarding information
  // ---------------------------------------------------------------------------

  void _restoreFromData(OnboardingData data) {
    _selectedMethod = data.datingMethod ?? DatingMethod.lastMenstrualPeriod;

    _cyclesRegular = data.cyclesRegular ?? true;
    _cycleLengthDays = data.cycleLengthDays ?? 28;

    _gestationalWeeks = data.ultrasoundGestationalWeeks ?? 8;
    _gestationalDays = data.ultrasoundGestationalDays ?? 0;

    _embryoAgeDays = data.ivfEmbryoAgeDays ?? 5;

    _selectedDate = switch (_selectedMethod) {
      DatingMethod.lastMenstrualPeriod => data.lastMenstrualPeriod,
      DatingMethod.conceptionDate => data.conceptionDate,
      DatingMethod.ivfTransfer => data.ivfTransferDate,
      DatingMethod.ultrasound => data.ultrasoundDate,
      DatingMethod.knownDueDate => data.knownDueDate,
      DatingMethod.providerConfirmed => data.providerConfirmedDueDate,
      DatingMethod.unknown => null,
    };

    _dateController.text = _selectedDate?.dateFormat() ?? '';
  }

  /// Writes the defaults shown on screen into the controller in ONE update
  /// (it used to be up to six, each one rebuilding listeners and restarting
  /// the autosave timer).
  void _initializeController() {
    final controller = ref.read(onboardingControllerProvider.notifier);
    final data = ref.read(onboardingControllerProvider).value?.data;
    if (data == null) return;

    final updated = data.copyWith(
      datingMethod: data.datingMethod ?? _selectedMethod,
      cyclesRegular: data.cyclesRegular ?? _cyclesRegular,
      cycleLengthDays: data.cycleLengthDays ?? _cycleLengthDays,
      ultrasoundGestationalWeeks: data.datingMethod == DatingMethod.ultrasound
          ? _gestationalWeeks
          : data.ultrasoundGestationalWeeks,
      ultrasoundGestationalDays: data.datingMethod == DatingMethod.ultrasound
          ? _gestationalDays
          : data.ultrasoundGestationalDays,
      ivfEmbryoAgeDays: data.datingMethod == DatingMethod.ivfTransfer
          ? _embryoAgeDays
          : data.ivfEmbryoAgeDays,
    );

    if (updated != data) controller.updateData(updated);
  }

  // ---------------------------------------------------------------------------
  // Date field configuration
  // ---------------------------------------------------------------------------

  bool get _requiresDate => _selectedMethod != DatingMethod.unknown;

  bool get _isDueDateMethod =>
      _selectedMethod == DatingMethod.knownDueDate ||
      _selectedMethod == DatingMethod.providerConfirmed;

  String get _dateFieldLabel => switch (_selectedMethod) {
    DatingMethod.lastMenstrualPeriod => 'First day of last menstrual period',
    DatingMethod.conceptionDate => 'Conception date',
    DatingMethod.ivfTransfer => 'Transfer date',
    DatingMethod.ultrasound => 'Scan date',
    DatingMethod.knownDueDate => 'Estimated due date',
    DatingMethod.providerConfirmed => 'Provider-confirmed due date',
    DatingMethod.unknown => '',
  };

  DateTime get _firstDate => _isDueDateMethod
      ? DateUtils.dateOnly(DateTime.now())
      : DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 300)));

  DateTime get _lastDate => _isDueDateMethod
      ? DateUtils.dateOnly(DateTime.now().add(const Duration(days: 300)))
      : DateUtils.dateOnly(DateTime.now());

  // ---------------------------------------------------------------------------
  // Menstrual cycle guidance
  // ---------------------------------------------------------------------------

  bool get _cycleLengthOutsideTypicalRange =>
      _cycleLengthDays < 21 || _cycleLengthDays > 35;

  String? get _cycleGuidance {
    if (!_cyclesRegular) {
      return 'Because your cycles are irregular, an LMP-based due date may be less reliable. An early ultrasound or dating confirmed by your healthcare provider is recommended.';
    }

    if (_cycleLengthOutsideTypicalRange) {
      return 'Your cycle length is outside the typical 21–35-day range. Bloom can use the length you provided, but please confirm your pregnancy dating with your healthcare provider.';
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Dating calculation
  // ---------------------------------------------------------------------------

  ({DatingResult? result, String? error}) _computeDating() {
    if (!_requiresDate) {
      return (result: null, error: null);
    }

    final date = _selectedDate;

    if (date == null) {
      return (result: null, error: null);
    }

    try {
      final result = switch (_selectedMethod) {
        DatingMethod.lastMenstrualPeriod => eddFromLastPeriod(
          lastPeriod: date,
          cyclesRegular: _cyclesRegular,
          cycleLengthDays: _cycleLengthDays,
        ),
        DatingMethod.conceptionDate => eddFromConception(date),
        DatingMethod.ivfTransfer => eddFromIvfTransfer(
          transferDate: date,
          embryoAgeDays: _embryoAgeDays,
        ),
        DatingMethod.ultrasound => eddFromUltrasound(
          scanDate: date,
          gestationalWeeks: _gestationalWeeks,
          gestationalDays: _gestationalDays,
        ),
        DatingMethod.knownDueDate => DatingResult(
          edd: dateOnly(date),
          method: DatingMethod.knownDueDate,
          confidence: DatingConfidence.good,
          note: 'Based on the due date you provided; not independently confirmed.',
        ),
        DatingMethod.providerConfirmed => providerConfirmedEdd(date),
        DatingMethod.unknown => null,
      };

      return (result: result, error: null);
    } on ArgumentError catch (e) {
      return (result: null, error: e.message.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Dating method selection
  // ---------------------------------------------------------------------------

  void _selectMethod(DatingMethod? value) {
    if (value == null) return;

    final data = ref.read(onboardingControllerProvider).asData?.value.data;

    setState(() {
      _selectedMethod = value;

      // Restore the saved date for the selected method.
      _selectedDate = switch (value) {
        DatingMethod.lastMenstrualPeriod => data?.lastMenstrualPeriod,
        DatingMethod.conceptionDate => data?.conceptionDate,
        DatingMethod.ivfTransfer => data?.ivfTransferDate,
        DatingMethod.ultrasound => data?.ultrasoundDate,
        DatingMethod.knownDueDate => data?.knownDueDate,
        DatingMethod.providerConfirmed => data?.providerConfirmedDueDate,
        DatingMethod.unknown => null,
      };

      _dateController.text = _selectedDate?.dateFormat() ?? '';

      _cyclesRegular = data?.cyclesRegular ?? _cyclesRegular;
      _cycleLengthDays = data?.cycleLengthDays ?? _cycleLengthDays;

      _gestationalWeeks = data?.ultrasoundGestationalWeeks ?? 8;
      _gestationalDays = data?.ultrasoundGestationalDays ?? 0;

      _embryoAgeDays = data?.ivfEmbryoAgeDays ?? 5;
    });

    if (data == null) return;

    // One update for everything that changes with the method.
    ref
        .read(onboardingControllerProvider.notifier)
        .updateData(
          data.copyWith(
            datingMethod: value,
            // Keep the user's menstrual-cycle answers when changing methods.
            cyclesRegular: value == DatingMethod.lastMenstrualPeriod
                ? _cyclesRegular
                : data.cyclesRegular,
            cycleLengthDays: value == DatingMethod.lastMenstrualPeriod
                ? _cycleLengthDays
                : data.cycleLengthDays,
            ultrasoundGestationalWeeks: value == DatingMethod.ultrasound
                ? _gestationalWeeks
                : data.ultrasoundGestationalWeeks,
            ultrasoundGestationalDays: value == DatingMethod.ultrasound
                ? _gestationalDays
                : data.ultrasoundGestationalDays,
            ivfEmbryoAgeDays: value == DatingMethod.ivfTransfer
                ? _embryoAgeDays
                : data.ivfEmbryoAgeDays,
          ),
        );
  }

  // ---------------------------------------------------------------------------
  // Date picker
  // ---------------------------------------------------------------------------

  Future<void> _pickDate() async {
    final fallback = _isDueDateMethod ? _firstDate : _lastDate;
    final rawInitial = _selectedDate ?? fallback;

    final initial = rawInitial.isBefore(_firstDate)
        ? _firstDate
        : rawInitial.isAfter(_lastDate)
        ? _lastDate
        : rawInitial;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _firstDate,
      lastDate: _lastDate,
    );

    if (!mounted || picked == null) return;

    setState(() {
      _selectedDate = picked;
      _dateController.text = picked.dateFormat();
    });

    final controller = ref.read(onboardingControllerProvider.notifier);

    switch (_selectedMethod) {
      case DatingMethod.lastMenstrualPeriod:
        controller.updateLastMenstrualPeriod(picked);
        break;
      case DatingMethod.conceptionDate:
        controller.updateConceptionDate(picked);
        break;
      case DatingMethod.ivfTransfer:
        controller.updateIVFTransferDate(picked);
        break;
      case DatingMethod.ultrasound:
        controller.updateUltrasoundDate(picked);
        break;
      case DatingMethod.knownDueDate:
        controller.updateKnownDueDate(picked);
        break;
      case DatingMethod.providerConfirmed:
        controller.updateProviderConfirmedDueDate(picked);
        break;
      case DatingMethod.unknown:
        break;
    }
  }

  // ---------------------------------------------------------------------------
  // Cycle controls
  // ---------------------------------------------------------------------------

  void _updateCycleRegularity(bool value) {
    setState(() {
      _cyclesRegular = value;
    });

    ref
        .read(onboardingControllerProvider.notifier)
        .updateCycleRegularity(value);

    // Do not reset cycle length when regularity changes.
  }

  void _updateCycleLength(int? value) {
    if (value == null) return;

    setState(() {
      _cycleLengthDays = value;
    });

    ref.read(onboardingControllerProvider.notifier).updateCycleLength(value);
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final datingState = _computeDating();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.questionsPage.title.isNotEmpty) ...[
            Text(
              widget.questionsPage.title,
              style: textTheme.headlineLarge?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap.vMin,
          ],

          if (widget.questionsPage.subTitle.isNotEmpty) ...[
            Text(
              widget.questionsPage.subTitle,
              style: textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w400,
              ),
            ),
            Gap.vGroup,
          ],

          Text(
            'How would you like to calculate?',
            style: textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),

          Gap.vMin,

          DropdownFlutter<DatingMethod>(
            items: DatingMethod.values,
            initialItem: _selectedMethod,
            headerBuilder: (context, selectedItem, enabled) {
              return Text(
                selectedItem.label,
                style: textTheme.bodyLarge?.copyWith(color: colors.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
            listItemBuilder: (context, item, isSelected, onItemSelect) {
              return Text(
                item.label,
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              );
            },
            onChanged: _selectMethod,
          ),

          if (_requiresDate) ...[
            Gap.vStandard,

            Text(
              _dateFieldLabel,
              style: textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),

            Gap.vMin,

            TextFormField(
              controller: _dateController,
              readOnly: true,
              style: TextStyle(color: colors.onSurface),
              onTap: _pickDate,
              decoration: InputDecoration(
                hintText: 'Select a date',
                suffixIcon: const Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],

          // Menstrual-cycle information is collected for BOTH regular
          // and irregular cycles.
          if (_selectedMethod == DatingMethod.lastMenstrualPeriod) ...[
            Gap.vStandard,

            Text(
              'Are your menstrual cycles generally regular?',
              style: textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),

            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(
                _cyclesRegular
                    ? 'Yes, they are regular'
                    : 'No, they are irregular',
                style: textTheme.bodyMedium?.copyWith(color: colors.onSurface),
              ),
              value: _cyclesRegular,
              onChanged: _updateCycleRegularity,
            ),

            Gap.vMin,

            Text(
              'What is your usual cycle length?',
              style: textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),

            Gap.vMin,

            DropdownFlutter<int>(
              items: _cycleLengths,
              initialItem: _cycleLengthDays,
              headerBuilder: (context, selectedDays, enabled) {
                return Text(
                  '$selectedDays days',
                  style: textTheme.bodyLarge?.copyWith(color: colors.onSurface),
                );
              },
              listItemBuilder: (context, days, isSelected, onItemSelect) {
                return Text(
                  '$days days',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                );
              },
              onChanged: _updateCycleLength,
            ),

            if (_cycleGuidance != null) ...[
              Gap.vMin,

              Text(
                _cycleGuidance!,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ],

          if (_selectedMethod == DatingMethod.ultrasound) ...[
            Gap.vStandard,

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _gestationalWeeks,
                    decoration: const InputDecoration(
                      labelText: 'Weeks',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(
                      41,
                      (w) => DropdownMenuItem(value: w, child: Text('$w wks')),
                    ),
                    onChanged: (v) {
                      if (v == null) return;

                      setState(() {
                        _gestationalWeeks = v;
                      });

                      ref
                          .read(onboardingControllerProvider.notifier)
                          .updateUltrasoundGestationalWeeks(v);
                    },
                  ),
                ),

                Gap.hStandard,

                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _gestationalDays,
                    decoration: const InputDecoration(
                      labelText: 'Days',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(
                      7,
                      (d) => DropdownMenuItem(value: d, child: Text('$d days')),
                    ),
                    onChanged: (v) {
                      if (v == null) return;

                      setState(() {
                        _gestationalDays = v;
                      });

                      ref
                          .read(onboardingControllerProvider.notifier)
                          .updateUltrasoundGestationalDays(v);
                    },
                  ),
                ),
              ],
            ),
          ],

          if (_selectedMethod == DatingMethod.ivfTransfer) ...[
            Gap.vStandard,

            DropdownButtonFormField<int>(
              initialValue: _embryoAgeDays,
              decoration: const InputDecoration(
                labelText: 'Embryo age',
                border: OutlineInputBorder(),
              ),
              items: const [3, 5, 6]
                  .map(
                    (age) => DropdownMenuItem(
                      value: age,
                      child: Text('Day $age embryo'),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v == null) return;

                setState(() {
                  _embryoAgeDays = v;
                });

                ref
                    .read(onboardingControllerProvider.notifier)
                    .updateIVFEmbryoAge(v);
              },
            ),
          ],

          if (_selectedMethod == DatingMethod.unknown) ...[
            Gap.vStandard,

            Text(
              'No worries. You can continue without an estimated due date and add or confirm one with your healthcare provider later.',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],

          if (datingState.error != null) ...[
            Gap.vMin,

            Text(
              datingState.error!,
              style: textTheme.bodySmall?.copyWith(color: colors.error),
            ),
          ] else if (datingState.result != null) ...[
            Gap.vStandard,

            Builder(
              builder: (context) {
                final result = datingState.result!;
                final age = gestationalAge(result.edd);
                final currentTrimester = trimester(result.edd);

                final confidenceLabel =
                    result.confidence == DatingConfidence.confirmed
                    ? 'Provider confirmed'
                    : result.confidence == DatingConfidence.low
                    ? 'Needs confirmation'
                    : 'Estimated';

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.standard),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.standard),
                    color: colors.primaryContainer,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.tight,
                          vertical: AppSpacing.tight / 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: colors.surface,
                        ),
                        child: Text(
                          confidenceLabel,
                          style: textTheme.labelMedium?.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),

                      Gap.vMin,

                      Text(
                        'Estimated due date',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onPrimaryContainer,
                        ),
                      ),

                      Gap.vMin,

                      Text(
                        result.edd.dateFormat(),
                        style: textTheme.headlineMedium?.copyWith(
                          color: colors.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Gap.vMin,

                      Text(
                        '${age.weeks}w ${age.days}d • Trimester $currentTrimester',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colors.onPrimaryContainer,
                        ),
                      ),

                      if (result.note != null) ...[
                        Gap.vMin,

                        Text(
                          result.note!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
