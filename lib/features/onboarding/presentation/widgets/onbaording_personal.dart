import 'package:bloom/core/theme/app_utils.dart';
import 'package:bloom/features/onboarding/data/models/onboarding_questions_page.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';

class OnbaordingPersonal extends StatefulWidget {
  final OnboardingQuestionsPage questionsPage;
  const OnbaordingPersonal({super.key, required this.questionsPage});

  @override
  State<OnbaordingPersonal> createState() => _OnbaordingPersonalState();
}

class _OnbaordingPersonalState extends State<OnbaordingPersonal> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  DateTime? _dateOfBirth;

  @override
  void dispose() {
    _firstNameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final fieldDecoration = BoxDecoration(
      color: colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: colors.outline),
    );

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
            final picked = await showDatePicker(
              context: context,
              initialDate: _dateOfBirth ?? DateTime(2000, 1, 1),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                _dateOfBirth = picked;
                _dobController.text =
                    '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
              });
            }
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
          showCities: true,
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
          onCountryChanged: (value) {},
          onStateChanged: (value) {},
          onCityChanged: (value) {},
        ),
      ],
    );
  }
}
