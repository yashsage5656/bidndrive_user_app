import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/static_data.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/app_bar_widget.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final uploadedDocs = {'rc': true, 'insurance': true};

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: AppStrings.documents),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.paddingLG),
        child: Column(
          children: [
            // Info Card
            Container(
              padding: EdgeInsets.all(AppSizes.paddingMD),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.info),
                  SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Text(
                      'Upload required documents for faster processing',
                      style: GoogleFonts.poppins(
                        fontSize: AppSizes.fontSM,
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),

            SizedBox(height: AppSizes.lg),

            // Document List
            ...StaticData.documentTypes.asMap().entries.map((entry) {
              final doc = entry.value;
              final isUploaded = uploadedDocs.containsKey(doc['id']);

              return Container(
                margin: EdgeInsets.only(bottom: AppSizes.md),
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
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isUploaded
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.grey100,
                        borderRadius: BorderRadius.circular(AppSizes.sm),
                      ),
                      child: Icon(
                        isUploaded
                            ? Icons.check_circle
                            : Icons.description_outlined,
                        color: isUploaded
                            ? AppColors.success
                            : AppColors.grey500,
                      ),
                    ),
                    SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                doc['name'],
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (doc['required'])
                                Text(
                                  ' *',
                                  style: TextStyle(color: AppColors.error),
                                ),
                            ],
                          ),
                          Text(
                            isUploaded ? 'Uploaded' : 'Not uploaded',
                            style: GoogleFonts.poppins(
                              fontSize: AppSizes.fontSM,
                              color: isUploaded
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isUploaded
                            ? AppColors.grey200
                            : AppColors.primary,
                        foregroundColor: isUploaded
                            ? AppColors.textPrimary
                            : AppColors.white,
                      ),
                      child: Text(isUploaded ? 'View' : 'Upload'),
                    ),
                  ],
                ),
              ).animate(delay: (entry.key * 100).ms).fadeIn();
            }),

            SizedBox(height: AppSizes.lg),
            CustomButton(text: 'Save Documents', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
