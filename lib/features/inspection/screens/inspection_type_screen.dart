import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/static_data.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/app_bar_widget.dart';
import '../../../routes/app_routes.dart';
import '../../sell_car/models/sell_car_enquiry_draft.dart';

class InspectionTypeScreen extends StatefulWidget {
  const InspectionTypeScreen({super.key});

  @override
  State<InspectionTypeScreen> createState() => _InspectionTypeScreenState();
}

class _InspectionTypeScreenState extends State<InspectionTypeScreen> {
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final draft = Get.arguments is SellCarEnquiryDraft
        ? Get.arguments as SellCarEnquiryDraft
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: AppStrings.inspectionType),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Inspection Type',
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontXL,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ).animate().fadeIn(),

            SizedBox(height: AppSizes.xs),

            Text(
              'Select how you would like to get your car inspected',
              style: GoogleFonts.poppins(
                fontSize: AppSizes.fontMD,
                color: AppColors.textSecondary,
              ),
            ),

            SizedBox(height: AppSizes.lg),

            // Inspection Type Cards
            Expanded(
              child: ListView.builder(
                itemCount: StaticData.inspectionTypes.length,
                itemBuilder: (context, index) {
                  final type = StaticData.inspectionTypes[index];
                  final isSelected = _selectedType == type['id'];

                  return _InspectionTypeCard(
                        type: type,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() => _selectedType = type['id']);
                        },
                      )
                      .animate(delay: (index * 100).ms)
                      .fadeIn()
                      .slideX(begin: -0.1, end: 0);
                },
              ),
            ),

            // Continue Button
            CustomButton(
              text: 'Continue',
              onPressed: _selectedType != null
                  ? () {
                      final selected = StaticData.inspectionTypes.firstWhere(
                        (type) => type['id'] == _selectedType,
                        orElse: () => <String, dynamic>{'title': _selectedType},
                      );
                      Get.toNamed(
                        AppRoutes.scheduleInspection,
                        arguments: {
                          'draft': draft,
                          'inspectionType': (selected['title'] ?? _selectedType)
                              .toString(),
                        },
                      );
                    }
                  : null,
            ),

            SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }
}

class _InspectionTypeCard extends StatelessWidget {
  final Map<String, dynamic> type;
  final bool isSelected;
  final VoidCallback onTap;

  const _InspectionTypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getIcon() {
    switch (type['icon']) {
      case 'home':
        return Icons.home_outlined;
      case 'location':
        return Icons.location_on_outlined;
      case 'car':
        return Icons.directions_car_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: AppSizes.md),
        padding: EdgeInsets.all(AppSizes.paddingLG),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: AppSizes.iconLG + 16,
              height: AppSizes.iconLG + 16,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(AppSizes.sm),
              ),
              child: Icon(
                _getIcon(),
                size: AppSizes.iconMD,
                color: isSelected ? AppColors.primary : AppColors.grey600,
              ),
            ),

            SizedBox(width: AppSizes.md),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        type['title'],
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontMD,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (type['price'] > 0) ...[
                        SizedBox(width: AppSizes.sm),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSizes.xs),
                          ),
                          child: Text(
                            '₹${type['price']}',
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontXS,
                              fontWeight: FontWeight.w600,
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: AppSizes.xs / 2),
                  Text(
                    type['description'],
                    style: GoogleFonts.poppins(
                      fontSize: AppSizes.fontSM,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Radio
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
