import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/static_data.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/app_bar_widget.dart';
import '../../../routes/app_routes.dart';

class PreDeliveryInspectionScreen extends StatefulWidget {
  const PreDeliveryInspectionScreen({super.key});

  @override
  State<PreDeliveryInspectionScreen> createState() =>
      _PreDeliveryInspectionScreenState();
}

class _PreDeliveryInspectionScreenState
    extends State<PreDeliveryInspectionScreen> {
  final Map<String, bool> _checkedItems = {};
  int _expandedCategory = 0;

  bool get _allChecked =>
      _checkedItems.length == _totalItems &&
      _checkedItems.values.every((v) => v);

  int get _totalItems {
    int count = 0;
    for (var category in StaticData.inspectionChecklist) {
      count += (category['items'] as List).length;
    }
    return count;
  }

  int get _checkedCount => _checkedItems.values.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppStrings.preDeliveryInspection,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.documents),
            icon: const Icon(Icons.description_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Card with Car Image
          Container(
            margin: EdgeInsets.all(AppSizes.paddingLG),
            padding: EdgeInsets.all(AppSizes.paddingMD),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              boxShadow: [
                BoxShadow(color: AppColors.shadowLight, blurRadius: 10),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.sm),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=400',
                    width: AppSizes.w(20),
                    height: AppSizes.h(8),
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.grey200),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.grey200,
                      child: const Icon(Icons.directions_car),
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Maruti Swift VXI',
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontMD,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'MH 02 AB 1234',
                        style: GoogleFonts.poppins(
                          fontSize: AppSizes.fontSM,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Progress
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            value: _totalItems > 0
                                ? _checkedCount / _totalItems
                                : 0,
                            backgroundColor: AppColors.grey200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                            strokeWidth: 4,
                          ),
                        ),
                        Text(
                          '${(_totalItems > 0 ? (_checkedCount / _totalItems * 100).round() : 0)}%',
                          style: GoogleFonts.poppins(
                            fontSize: AppSizes.fontXS,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(),

          // Checklist
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLG),
              itemCount: StaticData.inspectionChecklist.length,
              itemBuilder: (context, categoryIndex) {
                final category = StaticData.inspectionChecklist[categoryIndex];
                final items = category['items'] as List;
                final isExpanded = _expandedCategory == categoryIndex;

                return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.sm),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          AppSizes.cardRadius,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowLight,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Category Header
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _expandedCategory = isExpanded
                                    ? -1
                                    : categoryIndex;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(AppSizes.paddingMD),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.primarySurface,
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.sm,
                                      ),
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(category['category']),
                                      color: AppColors.primary,
                                      size: AppSizes.iconSM,
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.md),
                                  Expanded(
                                    child: Text(
                                      category['category'],
                                      style: GoogleFonts.poppins(
                                        fontSize: AppSizes.fontMD,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${_getCategoryCheckedCount(category['category'])}/${items.length}',
                                    style: GoogleFonts.poppins(
                                      fontSize: AppSizes.fontSM,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.sm),
                                  AnimatedRotation(
                                    turns: isExpanded ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.grey500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Items
                          AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Column(
                              children: items.map<Widget>((item) {
                                final key = '${category['category']}_$item';
                                final isChecked = _checkedItems[key] ?? false;

                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: AppColors.grey100),
                                    ),
                                  ),
                                  child: CheckboxListTile(
                                    value: isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        _checkedItems[key] = value ?? false;
                                      });
                                    },
                                    title: Text(
                                      item,
                                      style: GoogleFonts.poppins(
                                        fontSize: AppSizes.fontSM,
                                        color: isChecked
                                            ? AppColors.textSecondary
                                            : AppColors.textPrimary,
                                        decoration: isChecked
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                    activeColor: AppColors.primary,
                                    checkColor: AppColors.white,
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: AppSizes.paddingMD,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            crossFadeState: isExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 200),
                          ),
                        ],
                      ),
                    )
                    .animate(delay: (categoryIndex * 100).ms)
                    .fadeIn()
                    .slideY(begin: 0.1, end: 0);
              },
            ),
          ),

          // Bottom Button
          Container(
            padding: EdgeInsets.all(AppSizes.paddingLG),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowMedium,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: CustomButton(
              text: _allChecked
                  ? 'Complete Inspection'
                  : 'Submit Partial Report',
              onPressed: () {
                Get.snackbar(
                  'Success',
                  'Inspection report submitted',
                  backgroundColor: AppColors.success,
                  colorText: AppColors.white,
                );
                Get.offAllNamed(AppRoutes.main);
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Exterior':
        return Icons.directions_car;
      case 'Interior':
        return Icons.airline_seat_recline_normal;
      case 'Engine & Mechanical':
        return Icons.settings;
      case 'Electronics':
        return Icons.electrical_services;
      default:
        return Icons.check_circle;
    }
  }

  int _getCategoryCheckedCount(String category) {
    final categoryData = StaticData.inspectionChecklist.firstWhere(
      (c) => c['category'] == category,
    );
    final items = categoryData['items'] as List;
    int count = 0;
    for (var item in items) {
      if (_checkedItems['${category}_$item'] == true) {
        count++;
      }
    }
    return count;
  }
}
