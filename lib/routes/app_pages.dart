import 'package:bid_driving/features/car_details/screens/car_enquiry.dart';
import 'package:bid_driving/features/enquiries/get_my_enquiries.dart';
import 'package:bid_driving/features/enquiries/get_my_enquiry_details_screen.dart';
import 'package:bid_driving/features/laon/create_laon_req.dart';
import 'package:bid_driving/features/laon/laon_screen.dart';
import 'package:bid_driving/features/pdi/create_pdi_screen.dart';
import 'package:bid_driving/features/pdi/my_pdi_screen.dart';
import 'package:bid_driving/features/pdi/pdi_binding.dart';
import 'package:get/get.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/otp_verification_screen.dart';
import '../features/auth/screens/profile_setup_screen.dart';
import '../features/home/screens/main_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/car_details/screens/buy_cars_screen.dart';
import '../features/car_details/screens/car_details_screen.dart';
import '../features/sell_car/screens/sell_car_number_screen.dart';
import '../features/sell_car/screens/car_condition_screen.dart';
import '../features/sell_car/screens/bid_estimate_screen.dart';
import '../features/sell_car/screens/my_cars_screen.dart';
import '../features/sell_car/screens/my_car_details_view.dart';
import '../features/inspection/screens/schedule_inspection_screen.dart';
import '../features/inspection/screens/inspection_type_screen.dart';
import '../features/inspection/screens/inspection_status_screen.dart';
import '../features/inspection/screens/pre_delivery_inspection_screen.dart';
import '../features/inspection/screens/documents_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/profile/screens/change_password_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import 'app_routes.dart';

/// App Pages with GetX Route Configuration
class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: AppRoutes.carEnq,
      page: () =>  CarEnquiryScreen(),
      transition: Transition.fadeIn,
    ),


    GetPage(
      name: AppRoutes.getEnq,
      page: () =>  InquiryScreen(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: AppRoutes.getEnquiryDetails,
      page: () => InquiryDetailsScreen(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: AppRoutes.loan,
      page: () => MyLoansScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.loanReq,
      page: () => CreateLoanScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignupScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.otpVerification,
      page: () => const OtpVerificationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profileSetup,
      page: () => const ProfileSetupScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.buyCars,
      page: () => const BuyCarsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.carDetails,
      page: () => const CarDetailsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.sellCarNumber,
      page: () => const SellCarNumberScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.carCondition,
      page: () => const CarConditionScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.bidEstimate,
      page: () => const BidEstimateScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: '/create-pdi',
      page: () => const CreatePdiScreen(),
      binding: PdiBinding(),
    ),


    GetPage(
      name: '/my-pdi',
      page: () => const MyPdiScreen(),
      binding: PdiBinding(),
    ),
    GetPage(
      name: AppRoutes.myCars,
      page: () => const MyCarsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.myCarDetails,
      page: () => const MyCarDetailsView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.scheduleInspection,
      page: () => const ScheduleInspectionScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.inspectionType,
      page: () => const InspectionTypeScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.inspectionStatus,
      page: () => const InspectionStatusScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.preDeliveryInspection,
      page: () => const PreDeliveryInspectionScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.documents,
      page: () => const DocumentsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
