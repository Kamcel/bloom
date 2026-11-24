import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/core/utils/date_util.dart';
import 'package:bloom/core/utils/edd_calculator.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_questions_page.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';

enum DueDateCalculationMethod {
  lastMenstrualPeriod,
  conceptionDate,
  ivfTransfer,
  ultrasound,
  knowDueDate,
  iDontKnow,
}

extension DueDateCalculationMethodLabel on DueDateCalculationMethod {
  String get label => switch (this) {
    DueDateCalculationMethod.lastMenstrualPeriod => 'Last menstrual period',
    DueDateCalculationMethod.conceptionDate => 'Conception date',
    DueDateCalculationMethod.ivfTransfer => 'IVF transfer',
    DueDateCalculationMethod.ultrasound => 'Ultrasound',
    DueDateCalculationMethod.knowDueDate => 'I know my due date',
    DueDateCalculationMethod.iDontKnow => "I don't know",
  };
}

class OnboardingPregnancy extends StatefulWidget {
  final OnboardingQuestionsPage questionsPage;
  final ValueChanged<DatingResult?>? onDatingChanged;

  const OnboardingPregnancy({
    super.key,
    required this.questionsPage,
    this.onDatingChanged,
  });

  @override
  State<OnboardingPregnancy> createState() => _OnboardingPregnancyState();
}

class _OnboardingPregnancyState extends State<OnboardingPregnancy> {
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
  DueDateCalculationMethod _selectedMethod =
      DueDateCalculationMethod.lastMenstrualPeriod;
  DateTime? _selectedDate;

  // LMP options
  bool _cyclesRegular = true;
  int _cycleLengthDays = 28;

  // Ultrasound options
  int _gestationalWeeks = 8;
  int _gestationalDays = 0;

  // IVF options (3, 5, or 6)
  int _embryoAgeDays = 5;

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  bool get _requiresDate =>
      _selectedMethod != DueDateCalculationMethod.iDontKnow;

  String get _dateFieldLabel => switch (_selectedMethod) {
    DueDateCalculationMethod.lastMenstrualPeriod => 'First day of last period',
    DueDateCalculationMethod.conceptionDate => 'Conception date',
    DueDateCalculationMethod.ivfTransfer => 'Transfer date',
    DueDateCalculationMethod.ultrasound => 'Scan date',
    DueDateCalculationMethod.knowDueDate => 'Estimated due date',
    DueDateCalculationMethod.iDontKnow => '',
  };

  DateTime get _firstDate =>
      _selectedMethod == DueDateCalculationMethod.knowDueDate
      ? DateTime.now()
      : DateTime.now().subtract(const Duration(days: 300));

  DateTime get _lastDate =>
      _selectedMethod == DueDateCalculationMethod.knowDueDate
      ? DateTime.now().add(const Duration(days: 300))
      : DateTime.now();

  ({DatingResult? result, String? error}) _computeDating() {
    if (!_requiresDate) return (result: null, error: null);

    final date = _selectedDate;
    if (date == null) return (result: null, error: null);

    try {
      final result = switch (_selectedMethod) {
        DueDateCalculationMethod.lastMenstrualPeriod => eddFromLastPeriod(
          lastPeriod: date,
          cyclesRegular: _cyclesRegular,
          cycleLengthDays: _cycleLengthDays,
        ),
        DueDateCalculationMethod.conceptionDate => eddFromConception(date),
        DueDateCalculationMethod.ivfTransfer => eddFromIvfTransfer(
          transferDate: date,
          embryoAgeDays: _embryoAgeDays,
        ),
        DueDateCalculationMethod.ultrasound => eddFromUltrasound(
          scanDate: date,
          gestationalWeeks: _gestationalWeeks,
          gestationalDays: _gestationalDays,
        ),
        DueDateCalculationMethod.knowDueDate => providerConfirmedEdd(date),
        DueDateCalculationMethod.iDontKnow => throw StateError('Unreachable'),
      };
      return (result: result, error: null);
    } on ArgumentError catch (e) {
      return (result: null, error: e.message?.toString());
    }
  }

  void _emitDating() {
    widget.onDatingChanged?.call(_computeDating().result);
  }

  void _selectMethod(DueDateCalculationMethod? value) {
    if (value == null) return;
    setState(() {
      _selectedMethod = value;
      _selectedDate = null;
      _cyclesRegular = true;
      _cycleLengthDays = 28;
      _dateController.clear();
    });
    _emitDating();
  }

  Future<void> _pickDate() async {
    final fallback = _selectedMethod == DueDateCalculationMethod.knowDueDate
        ? _firstDate
        : _lastDate;
    final rawInitial = _selectedDate ?? fallback;
    final initial = rawInitial.isBefore(_firstDate)
        ? _firstDate
        : (rawInitial.isAfter(_lastDate) ? _lastDate : rawInitial);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _firstDate,
      lastDate: _lastDate,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = picked.dateFormat();
      });
      _emitDating();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final datingState = _computeDating();

    return Column(
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
          style: textTheme.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
        ),
        Gap.vMin,
        DropdownFlutter<DueDateCalculationMethod>(
          items: DueDateCalculationMethod.values,
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
        if (_selectedMethod == DueDateCalculationMethod.ultrasound) ...[
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
                    setState(() => _gestationalWeeks = v);
                    _emitDating();
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
                    setState(() => _gestationalDays = v);
                    _emitDating();
                  },
                ),
              ),
            ],
          ),
        ],
        if (_selectedMethod == DueDateCalculationMethod.ivfTransfer) ...[
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
              setState(() => _embryoAgeDays = v);
              _emitDating();
            },
          ),
        ],
        if (_selectedMethod ==
            DueDateCalculationMethod.lastMenstrualPeriod) ...[
          Gap.vMin,
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Regular cycles',
              style: textTheme.bodyMedium?.copyWith(color: colors.onSurface),
            ),
            value: _cyclesRegular,
            onChanged: (v) {
              setState(() {
                _cyclesRegular = v;
                if (v) {
                  _cycleLengthDays = 28;
                }
              });
              _emitDating();
            },
          ),
          if (!_cyclesRegular) ...[
            Gap.vMin,
            Text(
              'Cycle length',
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
              onChanged: (value) {
                if (value == null) return;
                setState(() => _cycleLengthDays = value);
                _emitDating();
              },
            ),
          ],
        ],
        if (_selectedMethod == DueDateCalculationMethod.iDontKnow) ...[
          Gap.vStandard,
          Text(
            'No worries—you can start with gentle daily check-ins now and add or confirm a due date later.',
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
          // TODO: UPDATE TO FANCY CONTAINER
          Text(
            'Estimated due date: ${datingState.result!.edd.dateFormat()}',
            style: textTheme.titleMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
