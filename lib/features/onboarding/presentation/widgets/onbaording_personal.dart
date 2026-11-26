import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_questions_page.dart';
import 'package:bloom/features/onboarding/presentation/providers/onboarding_controller.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnbaordingPersonal extends ConsumerStatefulWidget {
  final OnboardingQuestionsPage questionsPage;

  const OnbaordingPersonal({super.key, required this.questionsPage});

  @override
  ConsumerState<OnbaordingPersonal> createState() => _OnbaordingPersonalState();
}

class _OnbaordingPersonalState extends ConsumerState<OnbaordingPersonal>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _dobController = TextEditingController();

  // Saved answers, read once. The location picker is heavy, so it must not be
  // rebuilt (or reloaded) every time the user types a letter.
  String? _initialCountry;
  String? _initialState;
  String? _initialCity;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    final data = ref.read(onboardingControllerProvider).value?.data;

    _firstNameController.text = data?.name ?? '';

    final dob = data?.dateOfBirth;
    _dobController.text = dob == null ? '' : _formatDate(dob);

    _initialCountry = data?.country;
    _initialState = data?.state;
    _initialCity = data?.city;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final fieldDecoration = BoxDecoration(
      color: colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: colors.outline),
    );

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
            'First Name',
            style: textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
          Gap.vMin,

          TextFormField(
            controller: _firstNameController,
            style: TextStyle(color: colors.onSurface),
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {
              ref.read(onboardingControllerProvider.notifier).updateName(value);
            },
            decoration: InputDecoration(
              hintText: 'Enter your first name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),

          Gap.vGroup,

          Text(
            'Date of Birth',
            style: textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
          Gap.vMin,

          TextFormField(
            controller: _dobController,
            readOnly: true,
            style: TextStyle(color: colors.onSurface),
            onTap: () async {
              final today = DateUtils.dateOnly(DateTime.now());

              final savedDate = ref
                  .read(onboardingControllerProvider)
                  .value
                  ?.data
                  .dateOfBirth;

              final initialDate = savedDate != null && !savedDate.isAfter(today)
                  ? savedDate
                  : DateTime(2000, 1, 1);

              final picked = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1900),
                lastDate: today,
              );

              if (!mounted || picked == null) return;

              ref.read(onboardingControllerProvider.notifier).updateDOB(picked);

              _dobController.text = _formatDate(picked);
            },
            decoration: InputDecoration(
              hintText: 'Select your date of birth',
              suffixIcon: const Icon(Icons.calendar_today_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),

          Gap.vGroup,

          Text(
            'Location',
            style: textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
          Gap.vMin,

          CSCPickerPlus(
            layout: Layout.vertical,
            showStates: true,
            showCities: true,

            currentCountry: _initialCountry,
            currentState: _initialState,
            currentCity: _initialCity,

            dropdownDecoration: fieldDecoration,

            disabledDropdownDecoration: fieldDecoration.copyWith(
              color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
            ),

            selectedItemStyle: textTheme.bodyLarge?.copyWith(
              color: colors.onSurface,
            ),

            dropdownHeadingStyle: textTheme.titleMedium?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w600,
            ),

            dropdownItemStyle: textTheme.bodyMedium?.copyWith(
              color: colors.onSurface,
            ),

            onCountryChanged: (value) {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .updateCountry(value);
            },

            onStateChanged: (value) {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .updateState(value);
            },

            onCityChanged: (value) {
              ref.read(onboardingControllerProvider.notifier).updateCity(value);
            },
          ),
        ],
      ),
    );
  }
}
