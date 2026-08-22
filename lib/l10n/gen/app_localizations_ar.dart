// dart format off
// coverage:ignore-file

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get counterAppBarTitle => 'عداد';

  @override
  String get appTitle => 'خدمات العناية بالسيارات';

  @override
  String get maintenanceRequestsTitle => 'طلبات الصيانة';

  @override
  String get totalRequestsLabel => 'إجمالي الطلبات';

  @override
  String get uploadLogoLabel => 'رفع الشعار';

  @override
  String vehicleOwnerWithParamLabel(String name) {
    return 'المالك: $name';
  }

  @override
  String get roleTechnician => 'فني';

  @override
  String get roleCarWasher => 'مغسلة';

  @override
  String get roleFuelProvider => 'مزود وقود';

  @override
  String get roleShopOwner => 'صاحب متجر';

  @override
  String get roleCustomer => 'عميل';

  @override
  String get myServicesAsProvider => 'خدماتي كمزود';

  @override
  String get joinAsServiceProvider => 'انضم كمزود خدمة';

  @override
  String get applyAsTechnician => 'التقديم كفني';

  @override
  String get registerCarWash => 'تسجيل مغسلة سيارات';

  @override
  String get registerAsFuelProvider => 'التسجيل كمزود وقود';

  @override
  String get openSparePartsShop => 'فتح متجر قطع غيار';

  @override
  String get maintenanceRequests => 'طلبات الصيانة';

  @override
  String get technicianProfile => 'ملف الفني';

  @override
  String get myJobs => 'أعمالي';

  @override
  String get availableSosRequests => 'طلبات الطوارئ المتاحة';

  @override
  String get acceptedSosRequests => 'طلبات الطوارئ المقبولة';

  @override
  String get myStatistics => 'إحصائياتي';

  @override
  String get myInvoices => 'فواتيري';

  @override
  String get carWashProfile => 'ملف المغسلة';

  @override
  String get bookings => 'الحجوزات';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get fuelProviderProfile => 'ملف مزود الوقود';

  @override
  String get fuelOrders => 'طلبات الوقود';

  @override
  String get fuelProvider => 'مزود الوقود';

  @override
  String get shareLocation => 'مشاركة الموقع';

  @override
  String get shopProfile => 'ملف المتجر';

  @override
  String get shopOrders => 'طلبات المتجر';

  @override
  String get shopProducts => 'منتجات المتجر';

  @override
  String get shopSpecializations => 'تخصصات المتجر';

  @override
  String get optionsTitle => 'الخيارات';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get onboardingTitleMaintenance => 'صيانة ذكية للسيارات';

  @override
  String get onboardingSubtitleMaintenance => 'تتبع سجل صيانة مركبتك، واحصل على تذكيرات في الوقت المناسب، واطلب الصيانة بضغطة زر واحدة.';

  @override
  String get onboardingTitleEmergency => 'المساعدة الطارئة على الطريق';

  @override
  String get onboardingSubtitleEmergency => 'عالِق في الطريق؟ أرسل نداء استغاثة SOS واحصل على فني معتمد في موقعك خلال دقائق معدودة.';

  @override
  String get onboardingTitleAllInOne => 'خدمات متكاملة لسيارتك';

  @override
  String get onboardingSubtitleAllInOne => 'توصيل الوقود، غسيل السيارات، المتجر والمزيد — كل ما تحتاجه مركبتك في تطبيق واحد.';

  @override
  String get washerSelectProvinceMessage => 'الرجاء اختيار المحافظة';

  @override
  String get enableLocationPrompt => 'يرجى تفعيل الموقع';

  @override
  String get locationErrorPrefix => 'خطأ بالموقع';

  @override
  String get requestSentSuccess => 'تم إرسال الطلب ✓';

  @override
  String get cancelSosQuestion => 'ما سبب إلغاء الطلب ؟';

  @override
  String get cancelSosHint => 'ادخل هنا سبب إلغاء طلب الطوارئ ...';

  @override
  String get trackTechnician => 'تتبع الفني';

  @override
  String get searchingForTechnicianTitle => 'جارٍ البحث عن فني';

  @override
  String get searchingForTechnicianSubtitle => 'نبحث لك عن أقرب فني متاح، يرجى الانتظار قليلاً';

  @override
  String createdAgoLabel(String time) {
    return 'أنشئ منذ $time';
  }

  @override
  String get technicianOnWayLiveTracking => 'الفني في الطريق - تتبع مباشر';

  @override
  String get waitingForLocationUpdate => 'انتظار تحديث الموقع...';

  @override
  String get distanceLabel => 'المسافة';

  @override
  String get cartPageTitle => 'سلة المشتريات';

  @override
  String get checkoutButton => 'إتمام الطلب';

  @override
  String get confirmOrderTitle => 'تأكيد الطلب';

  @override
  String get orderCreatedSuccessfully => 'تم إنشاء الطلب بنجاح';

  @override
  String get orderTotalLabel => 'إجمالي الطلب';

  @override
  String get currencySyp => 'ل.س';

  @override
  String get pleaseSelectDeliveryLocation => 'يرجى اختيار موقع التوصيل من الخريطة';

  @override
  String get pleaseEnterAddressNote => 'يرجى إدخال ملاحظة العنوان';

  @override
  String get confirmOrderButton => 'تأكيد الطلب';

  @override
  String get addressNoteLabel => 'ملاحظة العنوان';

  @override
  String get addressNoteHint => 'مثال: بصرى الشام - الحي الغربي - قرب الصيدلية';

  @override
  String get deliveryLocationLabel => 'موقع التوصيل';

  @override
  String get selectLocationFromMapHint => 'اختر الموقع من الخريطة';

  @override
  String get locationSelectedBadge => 'تم التحديد';

  @override
  String get changeLocationButton => 'تغيير الموقع';

  @override
  String get appName => 'كار كير';

  @override
  String get noAvailableRequests => 'لا يوجد طلبات متاحة حالياً';

  @override
  String get welcome => 'مرحباً';

  @override
  String get welcomeBack => 'أهلاً بعودتك';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'تسجيل حساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get submit => 'إرسال';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get assistantChatTitle => 'المساعد الذكي';

  @override
  String get assistantChatHint => 'اكتب رسالتك هنا...';

  @override
  String get assistantChatEmpty => 'ما في رسائل بعد، ابدأ المحادثة';

  @override
  String get assistantChatTyping => 'المساعد عم يكتب...';

  @override
  String get assistantChatDeleteHistoryTitle => 'حذف سجل المحادثة';

  @override
  String get assistantChatDeleteHistoryConfirm => 'متأكد إنك بدك تحذف كل سجل المحادثة؟';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';

  @override
  String get done => 'تم';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get refresh => 'تحديث';

  @override
  String get search => 'بحث';

  @override
  String get filter => 'تصفية';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get createAccount => 'إنشاء حساب جديد';

  @override
  String get otpVerification => 'التحقق بالرمز';

  @override
  String get enterOtp => 'أدخل رمز التحقق';

  @override
  String get otpSent => 'تم إرسال رمز التحقق إلى';

  @override
  String get resendOtp => 'إعادة إرسال الرمز';

  @override
  String get resendOtpIn => 'إعادة الإرسال خلال';

  @override
  String get verify => 'تحقق';

  @override
  String get home => 'الرئيسية';

  @override
  String get schedules => 'مواعيد الخدمة';

  @override
  String get complaints => 'مشاكل السيارات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get mySchedules => 'مواعيدي';

  @override
  String get upcomingSchedules => 'المواعيد القادمة';

  @override
  String get nextPumpingSchedule => 'موعد الخدمة القادم';

  @override
  String get scheduleDetails => 'تفاصيل الموعد';

  @override
  String get viewAllSchedules => 'عرض جميع المواعيد';

  @override
  String get startTime => 'وقت البدء';

  @override
  String get endTime => 'وقت الانتهاء';

  @override
  String get actualStartTime => 'وقت البدء الفعلي';

  @override
  String get actualEndTime => 'وقت الانتهاء الفعلي';

  @override
  String get status => 'الحالة';

  @override
  String get notes => 'ملاحظات';

  @override
  String get createdBy => 'تم الإنشاء بواسطة';

  @override
  String get scheduled => 'مجدول';

  @override
  String get active => 'قيد التنفيذ';

  @override
  String get completed => 'مكتمل';

  @override
  String get cancelled => 'ملغى';

  @override
  String get startsIn => 'يبدأ خلال';

  @override
  String get activeNow => 'نشط الآن';

  @override
  String get endedAgo => 'انتهى منذ';

  @override
  String get today => 'اليوم';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get dateRange => 'نطاق التاريخ';

  @override
  String get selectDateRange => 'اختر نطاق التاريخ';

  @override
  String get myComplaints => 'مشاكلي';

  @override
  String get submitComplaint => 'الإبلاغ عن مشكلة';

  @override
  String get complaintDetails => 'تفاصيل المشكلة';

  @override
  String get complaintTitle => 'عنوان المشكلة';

  @override
  String get complaintDescription => 'وصف المشكلة';

  @override
  String get complaintCategory => 'تصنيف المشكلة';

  @override
  String get selectCategory => 'اختر التصنيف';

  @override
  String get noWater => 'مشكلة في المحرك';

  @override
  String get waterQuality => 'مشكلة في الإطارات';

  @override
  String get lowPressure => 'مشكلة في البطارية';

  @override
  String get scheduleIssue => 'تأخير في الخدمة';

  @override
  String get other => 'أخرى';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get inProgress => 'قيد التنفيذ';

  @override
  String get resolved => 'تم الحل';

  @override
  String get rejected => 'مرفوض';

  @override
  String get adminResponse => 'رد الخدمة';

  @override
  String get handledBy => 'تم التعامل بواسطة';

  @override
  String get handledAt => 'تم التعامل في';

  @override
  String get createdAt => 'تم الإنشاء في';

  @override
  String get updatedAt => 'تم التحديث في';

  @override
  String get complaintSubmitted => 'تم الإبلاغ عن المشكلة بنجاح';

  @override
  String get region => 'مركز الخدمة';

  @override
  String get unit => 'الوحدة';

  @override
  String get neighborhood => 'الحي';

  @override
  String get zone => 'المنطقة';

  @override
  String get selectRegion => 'اختر مركز الخدمة';

  @override
  String get selectUnit => 'اختر الوحدة';

  @override
  String get selectNeighborhood => 'اختر الحي';

  @override
  String get selectZone => 'اختر المنطقة';

  @override
  String get location => 'الموقع';

  @override
  String get selectLocation => 'اختر الموقع';

  @override
  String get clearSelection => 'مسح الاختيار';

  @override
  String get myProfile => 'ملفي الشخصي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get role => 'الدور';

  @override
  String get admin => 'مدير';

  @override
  String get operator => 'مشغل';

  @override
  String get citizen => 'عميل';

  @override
  String get defaultLocation => 'الموقع الافتراضي';

  @override
  String get watchedLocation => 'الموقع المراقب';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get networkError => 'خطأ في الاتصال بالشبكة';

  @override
  String get serverError => 'خطأ في الخادم';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get noDataSubtitle => 'تحقق لاحقاً أو أضف طلباً جديداً';

  @override
  String get noSchedules => 'لا توجد مواعيد';

  @override
  String get noComplaints => 'لا توجد مشاكل تم الإبلاغ عنها';

  @override
  String get noSchedulesMessage => 'لا توجد مواعيد خدمة في الوقت الحالي';

  @override
  String get noComplaintsMessage => 'لم تقم بالإبلاغ عن أي مشاكل بعد';

  @override
  String get pullToRefresh => 'اسحب للتحديث';

  @override
  String get releaseToRefresh => 'حرر للتحديث';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get viewSchedules => 'عرض المواعيد';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get invalidPhoneNumber => 'رقم هاتف غير صحيح';

  @override
  String get invalidEmail => 'بريد إلكتروني غير صحيح';

  @override
  String get passwordTooShort => 'كلمة المرور قصيرة جداً (الحد الأدنى 6 أحرف)';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String maxCharacters(int max) {
    return 'الحد الأقصى $max حرف';
  }

  @override
  String charactersRemaining(int count) {
    return 'باقي $count حرف';
  }

  @override
  String get loginSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get registrationSuccess => 'تم التسجيل بنجاح';

  @override
  String get logoutConfirmation => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get confirm => 'تأكيد';

  @override
  String get language => 'اللغة';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get settings => 'الإعدادات';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get appNameAr => 'كار كير أكس';

  @override
  String get splashScreen => 'شاشة البدء';

  @override
  String get profileSetup => 'إعداد الملف الشخصي';

  @override
  String get myVehicles => 'مركباتي';

  @override
  String get addVehicle => 'إضافة مركبة';

  @override
  String get editVehicle => 'تعديل المركبة';

  @override
  String get vehicleDetails => 'تفاصيل المركبة';

  @override
  String get maintenanceHistory => 'سجل الصيانة';

  @override
  String get vinNumber => 'رقم الهيكل';

  @override
  String get plateNumber => 'رقم اللوحة';

  @override
  String get brand => 'الماركة';

  @override
  String get model => 'الموديل';

  @override
  String get year => 'السنة';

  @override
  String get maintenance => 'الصيانة';

  @override
  String get maintenanceRequest => 'طلب صيانة';

  @override
  String get serviceType => 'نوع الخدمة';

  @override
  String get oilChange => 'تغيير الزيت';

  @override
  String get inspection => 'فحص';

  @override
  String get repair => 'إصلاح';

  @override
  String get technicianOffers => 'عروض الفنيين';

  @override
  String get requestStatus => 'حالة الطلب';

  @override
  String get rateService => 'تقييم المغسلة';

  @override
  String get emergencySOS => 'طوارئ';

  @override
  String get sosButton => 'زر الطوارئ';

  @override
  String get emergencyStatus => 'حالة الطوارئ';

  @override
  String get carWash => 'غسيل السيارات';

  @override
  String get bookCarWash => 'حجز غسيل';

  @override
  String get washBookingStatus => 'حالة الحجز';

  @override
  String get centerWash => 'غسيل في المركز';

  @override
  String get mobileWash => 'غسيل متنقل';

  @override
  String get basicWash => 'غسيل أساسي';

  @override
  String get premiumWash => 'غسيل مميز';

  @override
  String get fullWash => 'غسيل كامل';

  @override
  String get marketplace => 'المتجر';

  @override
  String get products => 'المنتجات';

  @override
  String get productDetails => 'تفاصيل المنتج';

  @override
  String get cart => 'السلة';

  @override
  String get orderStatus => 'حالة الطلب';

  @override
  String get addToCart => 'أضف إلى السلة';

  @override
  String get checkout => 'إتمام الشراء';

  @override
  String get subtotal => 'المجموع الجزئي';

  @override
  String get total => 'الإجمالي';

  @override
  String get rentX => 'تأجير سيارات';

  @override
  String get availableCars => 'السيارات المتاحة';

  @override
  String get daily => 'يومي';

  @override
  String get weekly => 'أسبوعي';

  @override
  String get monthly => 'شهري';

  @override
  String get rentalPeriod => 'فترة التأجير';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get sellX => 'بيع سيارات';

  @override
  String get sellListings => 'عروض البيع';

  @override
  String get myListings => 'عروضي';

  @override
  String get publishListing => 'نشر العرض';

  @override
  String get contactSeller => 'تواصل مع البائع';

  @override
  String get fuelX => 'توصيل وقود';

  @override
  String get fuelRequest => 'طلب وقود';

  @override
  String get fuelType => 'نوع الوقود';

  @override
  String get gasoline91 => 'بنزين 91';

  @override
  String get gasoline95 => 'بنزين 95';

  @override
  String get diesel => 'ديزل';

  @override
  String get quantity => 'الكمية';

  @override
  String get liters => 'لتر';

  @override
  String get fuelOrderStatus => 'حالة طلب الوقود';

  @override
  String get carOwner => 'مالك سيارة';

  @override
  String get technician => 'فني';

  @override
  String get accept => 'قبول';

  @override
  String get reject => 'رفض';

  @override
  String get proceed => 'متابعة';

  @override
  String get continueButton => 'استمرار';

  @override
  String get select => 'اختر';

  @override
  String get choose => 'اختر';

  @override
  String get onTheWay => 'في الطريق';

  @override
  String get arrived => 'وصل';

  @override
  String get delivered => 'تم التسليم';

  @override
  String get assigned => 'تم التكليف';

  @override
  String get requested => 'مطلوب';

  @override
  String get loadingData => 'جاري تحميل البيانات...';

  @override
  String get noVehicles => 'لا توجد مركبات';

  @override
  String get noOffers => 'لا توجد عروض';

  @override
  String get noListings => 'لا توجد عروض';

  @override
  String get success => 'نجاح';

  @override
  String get failed => 'فشل';

  @override
  String get currentLocation => 'موقعي الحالي';

  @override
  String get useCurrentLocation => 'استخدم موقعي الحالي';

  @override
  String get enterAddress => 'أدخل العنوان';

  @override
  String get city => 'المدينة';

  @override
  String get pickImage => 'اختر صورة';

  @override
  String get camera => 'الكاميرا';

  @override
  String get gallery => 'المعرض';

  @override
  String get profilePhoto => 'صورة الملف الشخصي';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get more => 'المزيد';

  @override
  String get searchProducts => 'ابحث عن منتجات...';

  @override
  String get searchCars => 'ابحث عن سيارات...';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get priceLowHigh => 'السعر: منخفض إلى مرتفع';

  @override
  String get priceHighLow => 'السعر: مرتفع إلى منخفض';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get selectTime => 'اختر الوقت';

  @override
  String get timeSlot => 'الفترة الزمنية';

  @override
  String get now => 'الآن';

  @override
  String get schedule => 'جدولة';

  @override
  String get price => 'السعر';

  @override
  String get cost => 'التكلفة';

  @override
  String get estimatedPrice => 'السعر التقديري';

  @override
  String get rating => 'التقييم';

  @override
  String get stars => 'نجوم';

  @override
  String get leaveComment => 'اترك تعليقاً';

  @override
  String get userType => 'نوع المستخدم';

  @override
  String get userProfile => 'ملف المستخدم';

  @override
  String get validationError => 'خطأ في التحقق';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get invalidInput => 'إدخال غير صحيح';

  @override
  String get optional => 'اختياري';

  @override
  String get required => 'مطلوب';

  @override
  String get description => 'الوصف';

  @override
  String get problemDetails => 'تفاصيل المشكلة';

  @override
  String get attachPhotos => 'إرفاق صور';

  @override
  String get summary => 'ملخص';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get bookingSummary => 'ملخص الحجز';

  @override
  String get readySummary => 'هل أنت مستعد للعودة إلى الطريق؟';

  @override
  String get editPassword => 'تعديل كلمة المرور';

  @override
  String get savePassword => 'حفظ كلمة المرور';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get creating => 'جاري الإنشاء...';

  @override
  String get enterFirstName => 'أدخل الاسم الأول';

  @override
  String get enterEmail => 'أدخل البريد الإلكتروني';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get passwordMinLength => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get reEnterPassword => 'أعد إدخال كلمة المرور';

  @override
  String get addVehicleImage => 'أضف صورة المركبة';

  @override
  String get tapToSelectImage => 'اضغط لاختيار صورة';

  @override
  String get selectVehicleImage => 'الرجاء اختيار صورة للمركبة';

  @override
  String get fillAllFields => 'الرجاء تعبئة جميع الحقول';

  @override
  String get vehicleAddedSuccess => 'تمت إضافة المركبة بنجاح';

  @override
  String get odometer => 'عداد الكيلومترات';

  @override
  String get licensePlateNumberFull => 'رقم لوحة السيارة';

  @override
  String get serviceRecords => 'سجلات الخدمات';

  @override
  String get fuelRecords => 'سجل الوقود';

  @override
  String get plate => 'اللوحة';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get createYourAccount => 'إنشاء حسابك';

  @override
  String get carReadyMessage => 'نحن هنا للحفاظ على سيارتك بأفضل حالة، هل أنت مستعد؟';

  @override
  String get sos => 'نجدة';

  @override
  String get fuel => 'الوقود';

  @override
  String get notification => 'الإشعارات';

  @override
  String get messages => 'الرسائل';

  @override
  String get changedpasswordsuccessfully => 'تم تغيير كلمة السر بنجاح';

  @override
  String get enterphone => 'أدخل رقم الهاتف ';

  @override
  String get thepasswordsdonotmatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get activeorders => 'الطلبات النشطة ';

  @override
  String get saveandfollow => 'حفظ و متابعة';

  @override
  String get savevehicle => 'حفظ المركبة ';

  @override
  String get parts => 'قطع الغيار ';

  @override
  String get details => 'التفاصيل';

  @override
  String get updateCarsList => 'تحديث قائمة السيارات...';

  @override
  String get noCarsYet => 'لا توجد سيارات حتى الآن';

  @override
  String get vehicleUpdatedSuccessfully => 'تم تحديث المركبة بنجاح';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get saving => 'جارٍ الحفظ...';

  @override
  String get updateVehicle => 'تحديث مركبة';

  @override
  String get deleteVehicle => 'حذف المركبة';

  @override
  String get failedToLoadAds => 'Failed to load advertisements';

  @override
  String get invalidInputData => 'إدخال بيانات خاطئة';

  @override
  String get deliveryTrackingTitle => 'تتبع التوصيل';

  @override
  String get selectDeliveryLocationTitle => 'حدد موقع التوصيل';

  @override
  String get myLocationLabel => 'موقعي';

  @override
  String get moveMapToPickLocation => 'حرّك الخريطة لتحديد موقع التوصيل';

  @override
  String get confirmLocationButton => 'تأكيد الموقع';

  @override
  String get invoiceDetails => 'تفاصيل الفاتورة';

  @override
  String get processingStatusLabel => 'قيد التجهيز';

  @override
  String get outForDeliveryStatusLabel => 'قيد التوصيل';

  @override
  String get deliveredStatusLabel => 'تم التسليم';

  @override
  String get rejectedStatusLabel => 'مرفوض';

  @override
  String get allRequestsTitle => 'طلباتي';

  @override
  String get shopLabel => 'المتجر';

  @override
  String get noProductsAvailable => 'لا توجد منتجات مضافة';

  @override
  String plusMoreProductsLabel(int count) {
    return '+$count منتج آخر';
  }

  @override
  String get quantityLabel => 'الكمية';

  @override
  String addToCartWithPriceLabel(String price) {
    return 'أضف إلى السلة — $price';
  }

  @override
  String get inStockStatus => 'متوفر';

  @override
  String get outOfStockStatus => 'غير متوفر';

  @override
  String productConditionLabel(String condition) {
    return 'Condition: $condition';
  }

  @override
  String productCategoryLabel(String category) {
    return 'Category: $category';
  }

  @override
  String productCarBrandLabel(String brand) {
    return 'Car Brand: $brand';
  }

  @override
  String discountPercentLabel(String percent) {
    return '$percent% OFF';
  }

  @override
  String inStockWithCountLabel(int count) {
    return 'In Stock ($count items)';
  }

  @override
  String get shopsTitle => 'المتاجر';

  @override
  String get cartLabel => 'السلة';

  @override
  String get shopDetailsPageTitle => 'معلومات المتجر';

  @override
  String get businessTypeLabel => 'نوع النشاط';

  @override
  String get carBrandsLabel => 'ماركات السيارات';

  @override
  String get partCategoriesLabel => 'فئات القطع';

  @override
  String get shopStorefrontPageTitle => 'واجهة المتجر';

  @override
  String get sparePartsStoreTitle => 'متاجر قطع الغيار';

  @override
  String get shareDeliveryLocationTitle => 'مشاركة موقع التوصيل';

  @override
  String get startProcessingButton => 'بدء التجهيز';

  @override
  String get startDeliveryButton => 'بدء التوصيل';

  @override
  String get confirmDeliveryButton => 'تأكيد التوصيل';

  @override
  String orderNumberLabel(String id) {
    return 'طلب رقم #$id';
  }

  @override
  String get orderCancelledSuccessMessage => 'تم إلغاء الطلب بنجاح';

  @override
  String get tapToTrackFuelProviderLive => 'اضغط لتتبع مزود الوقود مباشرة';

  @override
  String get trackFuelProviderTitle => 'تتبع مزود الوقود';

  @override
  String get waitingFuelProviderAcceptance => 'بانتظار قبول مزود الوقود';

  @override
  String get orderNotesTitle => 'ملاحظات الطلب';

  @override
  String get fuelProviderHasNotSharedLocationYet => 'لم يشارك مزود الوقود موقعه بعد';

  @override
  String get avatarUpdatedSuccess => 'تم تحديث الصورة بنجاح';

  @override
  String get accountDeletedSuccessMessage => 'تم حذف الحساب بنجاح';

  @override
  String get fuelLogTitle => 'سجل الوقود';

  @override
  String costWithParamLabel(String cost) {
    return 'التكلفة: $cost';
  }

  @override
  String odometerReadingWithParamLabel(String km) {
    return 'قراءة العداد: $km كم';
  }

  @override
  String get brandRequiredError => 'يرجى إدخال الماركة';

  @override
  String get brandMinLengthError => 'الماركة يجب أن تكون حرفين على الأقل';

  @override
  String get brandMaxLengthError => 'الماركة طويلة جدًا (الحد الأقصى 50 حرفًا)';

  @override
  String get brandInvalidCharsError => 'الماركة تحتوي على رموز غير مسموحة';

  @override
  String get modelRequiredError => 'يرجى إدخال الطراز';

  @override
  String get modelMaxLengthError => 'الطراز طويل جدًا (الحد الأقصى 50 حرفًا)';

  @override
  String get modelInvalidCharsError => 'الطراز يحتوي على رموز غير مسموحة';

  @override
  String get plateNumberRequiredError => 'يرجى إدخال رقم اللوحة';

  @override
  String get plateInvalidCharsError => 'رقم اللوحة يحتوي على رموز غير مسموحة';

  @override
  String get plateLengthError => 'رقم اللوحة يجب أن يكون بين 4 و 9 محارف';

  @override
  String get manufactureYearRequiredError => 'يرجى إدخال سنة الصنع';

  @override
  String get invalidYearError => 'يرجى إدخال سنة صحيحة';

  @override
  String yearRangeError(int maxYear) {
    return 'سنة الصنع يجب أن تكون بين 1900 و $maxYear';
  }

  @override
  String get odometerRequiredError => 'يرجى إدخال قراءة العداد';

  @override
  String get odometerRangeError => 'قراءة العداد يجب أن تكون بين 0 و 2000000';

  @override
  String get unsupportedImageFormatError => 'صيغة الصورة غير مدعومة (jpg، jpeg، png أو webp فقط)';

  @override
  String get imageSizeExceededError => 'حجم الصورة يجب ألا يتجاوز 5 ميجابايت';

  @override
  String get pleaseSelectVehicleImageError => 'الرجاء اختيار صورة للمركبة';

  @override
  String get defaultVehicleLabel => 'سيارة';

  @override
  String get vehicleDeletedSuccess => 'تم حذف المركبة بنجاح';

  @override
  String fuelAmountDetailsLabel(String type, String amount) {
    return '$type — $amount لتر';
  }

  @override
  String get gasoline98 => 'بنزين 98';

  @override
  String get completeAllFieldsError => 'من فضلك أكمل جميع الحقول';

  @override
  String get fuelOrderSentSuccessfully => 'تم إرسال طلب الوقود بنجاح';

  @override
  String get editButtonLabel => 'تعديل';

  @override
  String ownerStockCountLabel(int count) {
    return 'Stock: $count';
  }

  @override
  String get addProduct => 'إضافة منتج';

  @override
  String get basicInformation => 'المعلومات الأساسية';

  @override
  String get productName => 'اسم المنتج';

  @override
  String get productNameRequired => 'اسم المنتج مطلوب';

  @override
  String get enterValidPrice => 'أدخل سعرًا صالحًا';

  @override
  String get availableQuantity => 'الكمية المتوفرة';

  @override
  String get enterValidQuantity => 'أدخل كمية صالحة';

  @override
  String get classification => 'التصنيف';

  @override
  String get productCondition => 'حالة المنتج';

  @override
  String get carBrand => 'ماركة السيارة';

  @override
  String get partCategory => 'فئة القطعة';

  @override
  String get noSelection => 'بدون تحديد';

  @override
  String get productImages => 'صور المنتج';

  @override
  String get addImages => 'إضافة صور';

  @override
  String imagesCount(int count, int max) {
    return 'الصور ($count/$max)';
  }

  @override
  String get confirmSelectionButtonLabel => 'تأكيد الاختيار';

  @override
  String get shopProfilePageTitle => 'ملف المتجر';

  @override
  String get fillAllFieldsRequiredError => 'يرجى تعبئة جميع الحقول المطلوبة';

  @override
  String get shopSavedSuccess => 'تم حفظ المتجر بنجاح';

  @override
  String get shopNameLabel => 'اسم المتجر';

  @override
  String get shopNameHint => 'أدخل اسم المتجر';

  @override
  String get phoneNumberLabel => 'رقم الهاتف';

  @override
  String get phoneNumberHint => 'أدخل رقم الهاتف';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get cityHint => 'أدخل اسم المدينة';

  @override
  String get activeStatus => 'نشط';

  @override
  String get unknownStatus => 'غير محدّد';

  @override
  String unknownProfileValuesError(String values) {
    return 'قيم غير معروفة في ملفك: $values\nلا يمكن الحفظ حتى تتم مطابقة هذه القيم في النظام.';
  }

  @override
  String get updateProduct => 'تحديث المتجر';

  @override
  String get chooseActionLabel => 'اختيار';

  @override
  String get noSelectionMadeYet => 'لم يتم الاختيار بعد';

  @override
  String confirmMultiSelectionCount(int count) {
    return 'تأكيد الاختيار ($count)';
  }

  @override
  String get shopSpecializationsPageTitle => 'تخصصات المتجر';

  @override
  String get specializationsUpdatedSuccess => 'تم تحديث التخصصات بنجاح';

  @override
  String get inactiveStatus => 'غير نشط';

  @override
  String get myJobsTitle => 'أعمالي';

  @override
  String get jobAssignedStatusLabel => 'مُسند';

  @override
  String get jobStatusUpdatedSuccess => 'تم تحديث حالة المهمة بنجاح';

  @override
  String get jobLoadErrorLabel => 'حدث خطأ أثناء تحميل الأعمال';

  @override
  String get refreshOrdersLogHint => 'تحديث سجل الطلبات ...';

  @override
  String get clientLabel => 'العميل';

  @override
  String get appointmentNotesLabel => 'ملاحظات الموعد';

  @override
  String get startWorkButtonLabel => 'بدء العمل';

  @override
  String get endWorkButtonLabel => 'إنهاء العمل';

  @override
  String get completeJobTitle => 'إنهاء المهمة';

  @override
  String get completionNotesLabel => 'ملاحظات الإنجاز';

  @override
  String get completionNotesHint => 'اكتب ما تم إنجازه...';

  @override
  String get completionNotesRequiredError => 'ملاحظات الإنجاز مطلوبة';

  @override
  String get confirmCompletionButton => 'تأكيد الإنهاء';

  @override
  String get updatingProgress => 'جارٍ التحديث...';

  @override
  String get quotationPriceLabel => 'عرض السعر';

  @override
  String get quotationSentWaitingApproval => 'تم إرسال عرضك — بانتظار قبول العميل';

  @override
  String get submitQuotationButtonLabel => 'تقديم عرض سعر';

  @override
  String get quotationSubmittedSuccess => 'تم إرسال العرض بنجاح';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get customerDataTitle => 'بيانات العميل';

  @override
  String get malfunctionDetailsTitle => 'تفاصيل العطل';

  @override
  String get requestDateLabel => 'تاريخ الطلب';

  @override
  String get statusLabel => 'الحالة';

  @override
  String get vehicleDataTitle => 'بيانات المركبة';

  @override
  String get addTechnicianLabel => 'إضافة فني';

  @override
  String get editTechnicianProfileLabel => 'تعديل ملف الفني';

  @override
  String get technicianJoinRequestSuccess => 'تم إرسال طلب الانضمام كفني بنجاح';

  @override
  String get certificationsSectionTitle => 'الشهادات';

  @override
  String get maxThreeImagesHint => 'حد أقصى 3 صور';

  @override
  String get workshopLocationSet => 'تم تحديد موقع الورشة';

  @override
  String get selectWorkshopLocation => 'حدد موقع الورشة';

  @override
  String get myLocation => 'موقعي';

  @override
  String get moveMapToSelectLocation => 'حرّك الخريطة لتحديد الموقع الصحيح';

  @override
  String get savingInProgress => 'جاري الحفظ...';

  @override
  String get confirmLocationAction => 'تأكيد الموقع';

  @override
  String get currencySuffix => 'ل.س';

  @override
  String get availableQuantityLabel => 'الكمية المتوفرة';

  @override
  String get saveChangesButtonLabel => 'حفظ التعديل';

  @override
  String get availabilityStatusLabel => 'حالة التوفر';

  @override
  String get availableForWork => 'متاح للعمل';

  @override
  String get unavailableForWork => 'غير متاح للعمل';

  @override
  String maxImagesLimitError(int count) {
    return 'يمكنك اختيار $count صور كحد أقصى';
  }

  @override
  String get personalDataTitle => 'البيانات الشخصية';

  @override
  String get professionalDataTitle => 'البيانات المهنية';

  @override
  String get hourlyRateLabel => 'الأجر بالساعة';

  @override
  String get mechanicLabel => 'ميكانيك';

  @override
  String get electricityLabel => 'كهرباء';

  @override
  String get paintLabel => 'دهان';

  @override
  String get tiresLabel => 'إطارات';

  @override
  String get airConditioningLabel => 'تكييف';

  @override
  String get plumbingLabel => 'بنشر';

  @override
  String get profileLoadError => 'حدث خطأ أثناء تحميل الملف';

  @override
  String get updateWorkshopLocationDescription => 'يمكنك تحديث موقع الورشة عند الحاجة';

  @override
  String get addNewCertificationsHint => 'يمكنك إضافة شهادات جديدة';

  @override
  String get professionalInfo => 'البيانات المهنية';

  @override
  String get specialization => 'التخصص';

  @override
  String get experienceYears => 'سنوات الخبرة';

  @override
  String get hourlyRate => 'الأجر بالساعة';

  @override
  String get contactInfo => 'بيانات التواصل';

  @override
  String get certifications => 'الشهادات';

  @override
  String get durationRequiredError => 'يرجى إدخال المدة المتوقعة';

  @override
  String get invalidNumberError => 'يرجى إدخال رقم صحيح';

  @override
  String get durationRangeError => 'المدة يجب أن تكون بين 1 و 30 يومًا';

  @override
  String get enterExpectedPriceHint => 'يرجى كتابة السعر المتوقع...';

  @override
  String get durationInDaysLabel => 'المدة (بالأيام)';

  @override
  String get durationRangeHint => 'من 1 إلى 30 يومًا';

  @override
  String get requiredPartsLabel => 'القطع المطلوبة';

  @override
  String get includedInPriceLabel => 'ضمن السعر';

  @override
  String get additionalPriceLabel => 'سعر إضافي';

  @override
  String get netEarningsLabel => 'صافي الأرباح';

  @override
  String get statusDetailsTitle => 'تفاصيل الحالات';

  @override
  String get assignedStatusLabel => 'المعينة';

  @override
  String get cancellationReasonRequired => 'سبب الإلغاء مطلوب';

  @override
  String cancellationReasonMinLengthError(int count) {
    return 'يرجى كتابة سبب لا يقل عن $count أحرف';
  }

  @override
  String get sosGenericActionError => 'حدث خطأ أثناء تنفيذ العملية، حاول مرة أخرى';

  @override
  String sosStatusUpdatedWithLabel(String status) {
    return 'تم تحديث الحالة: $status';
  }

  @override
  String get startHeadingButtonLabel => 'ابدأ التوجه';

  @override
  String get acceptRequestToNavigateHint => 'اقبل الطلب لتبدأ التوجه للعميل';

  @override
  String get headingToClientTitle => 'التوجه للعميل';

  @override
  String get cancelResponseTitle => 'إلغاء الاستجابة';

  @override
  String get cancelResponseLabel => 'سبب إلغاء الاستجابة';

  @override
  String get cancelResponseHint => 'اكتب سبب إلغاء الاستجابة...';

  @override
  String trackOrderWithIdLabel(String id) {
    return 'تتبع الطلب #$id';
  }

  @override
  String get confirmExitTitle => 'تأكيد الخروج';

  @override
  String get pressBackAgainToExit => 'اضغط رجوع مرة ثانية للخروج';

  @override
  String get stopSharingLocationWarning => 'سيتوقف إرسال موقعك للعميل. هل تريد الخروج؟';

  @override
  String get exitActionLabel => 'خروج';

  @override
  String get jobCompletedSuccessMessage => 'تم إنهاء الطلب بنجاح ✓';

  @override
  String get writeAdditionalNotesHint => 'كتابة أي ملاحظات إضافية...';

  @override
  String get sendQuotationActionLabel => 'إرسال العرض';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي بنجاح ✓';

  @override
  String get noCertificatesUploaded => 'لا توجد شهادات مرفوعة بعد';

  @override
  String get workshopLocationTitle => 'موقع الورشة';

  @override
  String get workshopLocationDescriptionHint => 'حدد موقع ورشتك حتى يظهر للعملاء القريبين منك';

  @override
  String vehicleLabelWithParam(Object brand, Object model) {
    return '$brand $model';
  }

  @override
  String get productAddedSuccessfully => 'تم إضافة المنتج بنجاح';

  @override
  String get saveProduct => 'حفظ المنتج';

  @override
  String get ownerProductsPageTitle => 'منتجات المتجر';

  @override
  String sosRequestCreatedAgo(String time) {
    return 'أُنشئ منذ $time';
  }

  @override
  String get sosAcceptingInProgress => 'جاري القبول...';

  @override
  String get sosAcceptRequest => 'قبول الطلب';

  @override
  String get sosProcessingInProgress => 'جاري التنفيذ...';

  @override
  String get sosStartProgress => 'بدء التنفيذ';

  @override
  String get sosFinishRequest => 'إنهاء الطلب';

  @override
  String get sosCancelResponse => 'إلغاء الاستجابة';

  @override
  String get sosChangeStatusTitle => 'تغيير حالة الطلب';

  @override
  String get sosInProgressStatus => 'قيد التنفيذ';

  @override
  String get sosCompletedStatus => 'منتهي';

  @override
  String get sosNavigateToCustomer => 'التوجه للعميل';

  @override
  String get sosUpdatingInProgress => 'جاري التحديث...';

  @override
  String get shopOrdersPageTitle => 'طلبات المتجر';

  @override
  String get statusUpdatedSuccessMessage => 'تم تحديث حالة الطلب بنجاح';

  @override
  String statusUpdatedWithDynamicLabel(String status) {
    return 'تم تحديث الحالة: $status';
  }

  @override
  String get sosStatusUpdated => 'تم تحديث حالة الطلب';

  @override
  String get sosCustomerLocation => 'موقع العميل';

  @override
  String get sosStartNavigateToCustomer => 'ابدأ التوجه للعميل';

  @override
  String get sosAcceptToNavigateHint => 'اقبل الطلب لتبدأ التوجه للعميل';

  @override
  String get locationPermissionDenied => 'صلاحية الموقع مرفوضة';

  @override
  String sosLocationSendError(String message) {
    return 'خطأ في إرسال الموقع: $message';
  }

  @override
  String get customerLabel => 'العميل';

  @override
  String get youLabel => 'أنت';

  @override
  String distanceInMeters(String value) {
    return '$value م';
  }

  @override
  String distanceInKm(String value) {
    return '$value كم';
  }

  @override
  String get sharingLocationActive => 'يتم إرسال موقعك للعميل';

  @override
  String get locatingInProgress => 'جاري تحديد الموقع...';

  @override
  String get calculatingRouteInProgress => 'جاري حساب المسار...';

  @override
  String distanceToCustomer(String distance) {
    return 'المسافة للعميل';
  }

  @override
  String get conditionNew => 'جديد';

  @override
  String get conditionUsed => 'مستعمل';

  @override
  String get productImageLabel => 'صورة المنتج';

  @override
  String get allProductsPageTitle => 'كل المنتجات';

  @override
  String get productDetailsTitle => 'تفاصيل المنتج';

  @override
  String get productAddedToCartSuccess => 'تمت إضافة المنتج إلى السلة بنجاح';

  @override
  String get viewCartButton => 'عرض السلة';

  @override
  String get cancelOrderFormHint => 'مثال: لم أعد بحاجة للطلب';

  @override
  String get orderDetailsTitle => 'تفاصيل الطلب';

  @override
  String get orderNumberLabel1 => 'طلب رقم';

  @override
  String get cancellableLabel => 'قابل للإلغاء';

  @override
  String get rejectOrderFormHint => 'مثال: المنتج غير متوفر حالياً';

  @override
  String get confirmRejectionButton => 'تأكيد الرفض';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get themeLabel => 'المظهر';

  @override
  String get arabicLabel => 'العربية';

  @override
  String get englishLabel => 'English';

  @override
  String get lightModeLabel => 'فاتح';

  @override
  String get darkModeLabel => 'داكن';

  @override
  String get systemModeLabel => 'حسب النظام';

  @override
  String get productsLabel => 'المنتجات';

  @override
  String get deliveryLabel => 'التوصيل';

  @override
  String get grandTotalLabel => 'الإجمالي الكلي';

  @override
  String get trackDeliveryButton => 'تتبع التوصيل';

  @override
  String get cancelOrderButton => 'إلغاء الطلب';

  @override
  String get invoiceNumber => 'رقم الفاتورة';

  @override
  String get invoicePeriod => 'الفترة';

  @override
  String get invoiceTotal => 'الإجمالي';

  @override
  String get invoiceSubtotal => 'الفرعي';

  @override
  String get invoiceCommission => 'العمولة';

  @override
  String get invoiceSubscription => 'الاشتراك';

  @override
  String get invoiceStatus => 'الحالة';

  @override
  String get invoicePaidAt => 'تاريخ الدفع';

  @override
  String get invoiceItems => 'بنود الفاتورة';

  @override
  String get statusDraft => 'مسودة';

  @override
  String get statusIssued => 'صادرة';

  @override
  String get statusOverdue => 'متأخرة';

  @override
  String get statusPaid => 'مدفوعة';

  @override
  String get confirmDeleteTitle => 'تأكيد الحذف';

  @override
  String get confirmDeleteMessage => 'هل أنت متأكد من حذف هذه المركبة؟هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get owner => 'المالك';

  @override
  String get km => 'كم';

  @override
  String get maintenanceRecord => 'سجل الصيانة';

  @override
  String get fuelRecord => 'سجل الوقود';

  @override
  String get alertsRecord => 'سجل التنبيهات';

  @override
  String get totalJobs => 'إجمالي الأعمال';

  @override
  String get assignedJobs => 'المعيّنة';

  @override
  String get inProgressJobs => 'قيد التنفيذ';

  @override
  String get completedJobs => 'المكتملة';

  @override
  String get totalQuotations => 'إجمالي العروض';

  @override
  String get pendingQuotations => 'العروض المعلّقة';

  @override
  String get acceptedQuotations => 'العروض المقبولة';

  @override
  String get totalRatings => 'عدد التقييمات';

  @override
  String get deleteProfile => 'حذف الحساب';

  @override
  String get confirmDeleteProfileTitle => 'تأكيد الحذف';

  @override
  String get confirmDeleteProfileMessage => 'هل أنت متأكد من حذف الحساب؟\nهذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get profileDeletedSuccessfully => 'تم حذف الحساب بنجاح';

  @override
  String get enterPhone => 'الرجاء إدخال رقم الهاتف';

  @override
  String get invalidPhone => 'رقم الهاتف غير صالح';

  @override
  String get enterAsTechnician => 'الدخول كفني';

  @override
  String get washersPageTitle => 'مغاسل السيارات';

  @override
  String get washersByCity => 'حسب المدينة';

  @override
  String get washersBookAppointment => 'حجز موعد';

  @override
  String get washersViewDetails => 'عرض التفاصيل';

  @override
  String washersCityWithName(String cityName) {
    return 'المدينة : $cityName';
  }

  @override
  String washersRatingsWithCount(int count) {
    return 'التقييمات : $count';
  }

  @override
  String get washerTierBasic => 'BASIC';

  @override
  String get washerTierVip => 'VIP';

  @override
  String get washerTierPremium => 'PREMIUM';

  @override
  String get washerDetailsTitle => 'تفاصيل المغسلة';

  @override
  String washerOpenTime(String time) {
    return 'الفتح : $time';
  }

  @override
  String washerCloseTime(String time) {
    return 'الإغلاق : $time';
  }

  @override
  String get washerSectionCityAndAddress => 'المدينة و العنوان';

  @override
  String get washerSectionServicesAndPrices => 'الخدمات و الأسعار';

  @override
  String get washerSectionCustomerReviews => 'تقييم العملاء';

  @override
  String get washerServiceExterior => 'خارجي';

  @override
  String get washerServiceInterior => 'داخلي';

  @override
  String get washerServiceEngine => 'محرك';

  @override
  String washerPackagePrice(int amount) {
    return 'السعر : $amount \$';
  }

  @override
  String get washerReservationTitle => 'الحجز';

  @override
  String get washerReservationFieldDate => 'التاريخ';

  @override
  String get washerReservationFieldTime => 'الوقت';

  @override
  String get washerReservationFieldVehicleLabel => 'ادخل نوع مركبتك';

  @override
  String get washerReservationFieldVehicleHint => 'ادخل هنا نوع مركبتك';

  @override
  String get washerReservationFieldNotesLabel => 'ملاحظات';

  @override
  String get washerReservationFieldNotesHint => 'اضف اي ملاحظات تريدها';

  @override
  String get washerReservationChooseService => 'اختر الخدمة المناسبة';

  @override
  String get washerReservationConfirm => 'تأكيد حجز';

  @override
  String get washerReservationCancel => 'إلغاء الحجز';

  @override
  String get washerReservationPickDate => 'اختر التاريخ';

  @override
  String get washerReservationPickTime => 'اختر الوقت';

  @override
  String get washerReservationServicePremium => 'Premium';

  @override
  String get washerReservationServiceVip => 'Vip';

  @override
  String get washerReservationServiceBasic => 'Basic';

  @override
  String get bookingsPageTitle => 'حجوزاتي';

  @override
  String get bookingsFilterByStatus => 'حسب الحالة';

  @override
  String get washerNoVehiclesMessage => 'لا توجد مركبات لديك، يرجى إضافة مركبة أولاً من صفحة مركباتي';

  @override
  String get washerSelectVehicleMessage => 'الرجاء اختيار المركبة';

  @override
  String get washerSelectDateTimeMessage => 'الرجاء اختيار التاريخ والوقت';

  @override
  String get washerBookingSuccessMessage => 'تم الحجز بنجاح';

  @override
  String get loadingYourVehicles => 'جارٍ تحميل مركباتك...';

  @override
  String get noVehiclesAdded => 'لا توجد مركبات مضافة';

  @override
  String get selectYourVehicle => 'اختر مركبتك';

  @override
  String get bookingStatusesTitle => 'حالات الحجوزات';

  @override
  String get pleaseEnterCancellationReason => 'يرجى إدخال سبب الإلغاء';

  @override
  String get orderAcceptedSuccess => 'تم قبول الطلب بنجاح';

  @override
  String get orderStartedSuccess => 'تم بدء تنفيذ الطلب بنجاح';

  @override
  String get orderCompletedSuccess => 'تم إكمال الطلب بنجاح';

  @override
  String get orderCancelledSuccess => 'تم إلغاء الطلب بنجاح';

  @override
  String get cancelFuelOrderTitle => 'إلغاء طلب الوقود';

  @override
  String get ratingsTitle => 'التقييمات';

  @override
  String get noRatingsYet => 'لا توجد تقييمات بعد';

  @override
  String get showMore => 'عرض المزيد';

  @override
  String get defaultUserName => 'مستخدم';

  @override
  String ratingsCountLabel(int count) {
    return '($count تقييمًا)';
  }

  @override
  String currencyFormat(String amount) {
    return '$amount ل.س';
  }

  @override
  String get shareLocationTitle => 'مشاركة الموقع';

  @override
  String get shareLocationDescription => 'اختر طلب وقود قيد التنفيذ من طلباتي لمشاركة موقعك';

  @override
  String get goToMyOrders => 'الذهاب إلى طلباتي';

  @override
  String get orderStatusesTitle => 'حالات الطلبات';

  @override
  String get homeWelcomeGreeting => '- كيف نساعدك اليوم؟ -';

  @override
  String get quotationDetailsTitle => 'تفاصيل العرض';

  @override
  String get quotationAcceptedSuccess => 'تم قبول العرض بنجاح';

  @override
  String get quotationRejectedSuccess => 'تم رفض العرض';

  @override
  String get quotationsTitle => 'عروض الأسعار';

  @override
  String get noQuotationsAvailable => 'لا توجد عروض أسعار';

  @override
  String get acceptQuotationTitle => 'قبول عرض السعر';

  @override
  String get selectedDateLabel => 'التاريخ المحدد';

  @override
  String get chooseDateLabel => 'اختر التاريخ';

  @override
  String get notesLabel => 'ملاحظات';

  @override
  String get confirmLabel => 'تأكيد';

  @override
  String get cancelLabel => 'إلغاء';

  @override
  String get technicianLabel => 'الفني';

  @override
  String get repairDurationLabel => 'مدة الإصلاح';

  @override
  String get partsIncludedLabel => 'يشمل القطع';

  @override
  String durationInDays(int count) {
    return '$count أيام';
  }

  @override
  String get cannotShareLocationOrderFinished => 'لا يمكن مشاركة الموقع لطلب منتهٍ أو ملغى';

  @override
  String get enableLocationServiceMessage => 'يرجى تفعيل خدمة الموقع من إعدادات الجهاز';

  @override
  String get locationPermissionDeniedForever => 'صلاحية الموقع مرفوضة نهائيًا، يرجى تفعيلها من إعدادات التطبيق';

  @override
  String get locationPermissionRequired => 'صلاحية الموقع مطلوبة لمشاركة موقعك مع العميل';

  @override
  String get unableToDetermineLocation => 'تعذر تحديد موقعك الحالي، حاول مرة أخرى';

  @override
  String get genericErrorTryAgain => 'حدث خطأ أثناء تنفيذ العملية، حاول مرة أخرى';

  @override
  String get errorSendingLocation => 'خطأ في إرسال الموقع';

  @override
  String get deliveryLocation => 'موقع التوصيل';

  @override
  String get you => 'أنت';

  @override
  String get sharingLocationWithCustomer => 'يتم إرسال موقعك للعميل';

  @override
  String get determiningLocation => 'جاري تحديد الموقع...';

  @override
  String get calculatingRoute => 'جاري حساب المسار...';

  @override
  String get meterUnit => 'م';

  @override
  String get kmUnit => 'كم';

  @override
  String get technicianInfoCardTitle => 'معلومات الفني';

  @override
  String get specializationLabel => 'التخصص';

  @override
  String get experienceYearsLabel => 'سنوات الخبرة';

  @override
  String get quotationDateLabel => 'تاريخ العرض';

  @override
  String get technicianNotesCardTitle => 'ملاحظات الفني';

  @override
  String get acceptQuotationButton => 'قبول العرض';

  @override
  String get rejectQuotationButton => 'رفض العرض';

  @override
  String get rejectQuotationReasonTitle => 'سبب رفض العرض';

  @override
  String durationInYears(int count) {
    return '$count سنوات';
  }

  @override
  String get maintenanceRequestDetailsTitle => 'تفاصيل طلب صيانة';

  @override
  String get unexpectedErrorTryAgain => 'حدث خطأ أثناء تنفيذ العملية، حاول مرة أخرى';

  @override
  String get add => 'إضافة';

  @override
  String get selectPreferredDateTitle => 'اختيار التاريخ المفضل';

  @override
  String get selectPriorityTitle => 'اختيار الأولوية';

  @override
  String get problemDescriptionTitle => 'وصف المشكلة';

  @override
  String get problemDescriptionHint => 'يرجى كتابة تفاصيل المشكلة هنا...';

  @override
  String get noVehicleSelectedPrompt => 'لم يتم اختيار مركبة';

  @override
  String get changeVehicleButton => 'تغيير المركبة';

  @override
  String kilometerCountLabel(int count) {
    return '$count كم';
  }

  @override
  String get descriptionLabel => 'الوصف';

  @override
  String get vehicleLabel => 'المركبة';

  @override
  String get appointmentLabel => 'الموعد';

  @override
  String get confirmCancellationButton => 'تأكيد الإلغاء';

  @override
  String get backButton => 'تراجع';

  @override
  String get cancellationReason => 'سبب الإلغاء';

  @override
  String get bookingsCancelReasonHint => 'اكتب سبب الإلغاء...';

  @override
  String get cancelRequestButton => 'إلغاء الطلب';

  @override
  String get deleteRequestTitle => 'حذف الطلب';

  @override
  String get deleteRequestConfirmation => 'هل أنت متأكد من حذف هذا الطلب؟';

  @override
  String get cannotUndoActionWarning => 'لا يمكن التراجع عن هذه العملية';

  @override
  String get yesDeleteButton => 'نعم، احذف';

  @override
  String get requestDeletedSuccess => 'تم حذف الطلب بنجاح';

  @override
  String get cancellingProgress => 'جاري الإلغاء...';

  @override
  String get deletingProgress => 'جاري الحذف...';

  @override
  String quotationsCountLabel(int count) {
    return 'عروض الأسعار ($count)';
  }

  @override
  String get requestImagesTitle => 'صور الطلب';

  @override
  String get requestInfoCardTitle => 'بيانات الطلب';

  @override
  String get preferredDateLabel => 'الموعد المفضل';

  @override
  String get priorityLabel => 'الأولوية';

  @override
  String get creationDateLabel => 'تاريخ الإنشاء';

  @override
  String get technicianLocationTitle => 'موقع الفني';

  @override
  String get plateNumberLabel => 'رقم اللوحة';

  @override
  String get mileageLabel => 'الكيلومترات';

  @override
  String get priorityLow => 'منخفضة';

  @override
  String get priorityMedium => 'متوسطة';

  @override
  String get priorityHigh => 'طارئة';

  @override
  String get noVehiclesAddOneFirst => 'لا توجد مركبات لديك، يرجى إضافة مركبة أولاً من صفحة مركباتي';

  @override
  String get maxThreeImagesAllowed => 'يمكنك اختيار 3 صور كحد أقصى';

  @override
  String get pleaseSelectVehicleFirst => 'يرجى اختيار المركبة أولاً';

  @override
  String get pleaseDescribeProblem => 'يرجى وصف المشكلة';

  @override
  String get internalError => 'خطأ داخلي';

  @override
  String get requestSentSuccessfully => 'تم إرسال الطلب بنجاح';

  @override
  String get maintenanceRequestTitle => 'طلب صيانة';

  @override
  String fuelAmountLabel(String type, num amount) {
    return '$type - $amount لتر';
  }

  @override
  String get all => 'الكل';

  @override
  String get pleaseEnterRejectionReason => 'يرجى إدخال سبب الرفض';

  @override
  String get otherServices => 'خدمات أخرى';

  @override
  String get washerAvailabilityUpdateSuccess => 'تم تحديث حالة التوفر بنجاح';

  @override
  String get washerAvailabilityTitle => 'متاح لاستقبال الحجوزات';

  @override
  String get washerAvailabilityStatusAvailable => 'متاح حاليًا';

  @override
  String get washerAvailabilityStatusUnavailable => 'غير متاح حاليًا';

  @override
  String get send => 'إرسال';

  @override
  String get profileWasherDefaultServices => 'غسيل عادي, غسيل ممتاز, تلميع';

  @override
  String get pleaseEnterShopName => 'يرجى إدخال اسم المغسلة';

  @override
  String get pleaseEnterPhoneNumber => 'يرجى إدخال رقم الهاتف';

  @override
  String get pleaseEnterCity => 'يرجى إدخال المدينة';

  @override
  String get profileWasherCreateSuccessMessage => 'تم إنشاء بروفايل المغسلة بنجاح';

  @override
  String get profileWasherEditSuccessMessage => 'تم حفظ التعديلات بنجاح';

  @override
  String get allGovernorates => 'كل المحافظات';

  @override
  String get filterByGovernorate => 'حسب المحافظة';

  @override
  String get damascus => 'دمشق';

  @override
  String get rifDimashq => 'ريف دمشق';

  @override
  String get aleppo => 'حلب';

  @override
  String get homs => 'حمص';

  @override
  String get hama => 'حماة';

  @override
  String get latakia => 'اللاذقية';

  @override
  String get tartus => 'طرطوس';

  @override
  String get idlib => 'إدلب';

  @override
  String get daraa => 'درعا';

  @override
  String get asSuwayda => 'السويداء';

  @override
  String get quneitra => 'القنيطرة';

  @override
  String get deirEzZor => 'دير الزور';

  @override
  String get raqqa => 'الرقة';

  @override
  String get alHasakah => 'الحسكة';

  @override
  String get bookingStatusPinding => 'انتظار';

  @override
  String get bookingsWasherName => 'مغسل المقداد';

  @override
  String get bookingsServiceLabel => 'الخدمة ';

  @override
  String get bookingsServiceVip => 'Vip';

  @override
  String get bookingsDateTimeLabel => 'الموعد';

  @override
  String get bookingsAtLabel => 'الساعة';

  @override
  String get bookingsPriceLabel => 'السعر';

  @override
  String get bookingsMenuShowDetails => 'عرض تفاصيل';

  @override
  String get washerBookingViewDetails => 'عرض التفاصيل';

  @override
  String get washerBookingAccept => 'قبول';

  @override
  String get washerBookingReject => 'رفض';

  @override
  String get washerBookingStartExecution => 'بدأ التنفيذ';

  @override
  String get washerBookingCompleted => 'اكتمل';

  @override
  String get washerBookingCustomerNameLabel => 'اسم العميل :';

  @override
  String get washerBookingRequestedServiceLabel => 'الخدمة المطلوبة :';

  @override
  String get washerBookingAppointmentLabel => 'الموعد :';

  @override
  String get bookingsMenuCancelBooking => 'إلغاء الحجز';

  @override
  String get bookingsMenuRateService => 'تقييم الخدمة';

  @override
  String get bookingDetailsPageTitle => 'تفاصيل الحجوزات';

  @override
  String get bookingDetailsServiceSectionTitle => 'تفاصيل عن الخدمة';

  @override
  String get bookingDetailsAppointmentSectionTitle => 'تفاصيل عن الموعد';

  @override
  String get bookingDetailsUserNotesSectionTitle => 'ملاحظات المستخدم';

  @override
  String get bookingDetailsWasherNameLabel => 'اسم المغسل';

  @override
  String get bookingDetailsOrderDateLabel => 'تاريخ الطلب';

  @override
  String get bookingDetailsVehicleLabel => 'المركبة';

  @override
  String get ratingsServiceInfoSectionTitle => 'معلومات عن الخدمة';

  @override
  String get ratingsYourRatingQuestion => 'ما تقييمك للخدمة';

  @override
  String get ratingsTellUsExperienceTitle => 'أخبرنا عن تجربتك';

  @override
  String get ratingsCommentExperienceHint => 'اترك لنا تعليقاً عن تجربتك';

  @override
  String get ratingsSendRating => 'إرسال التقييم';

  @override
  String get profileWasherPageTitle => 'ملف المنظّف';

  @override
  String get profileWasherEditProfile => 'تعديل الملف';

  @override
  String get profileWasherSampleShopName => 'مغسل المحبة';

  @override
  String profileWasherRatingsCountLine(int count) {
    return '$count تقييمات';
  }

  @override
  String get profileWasherSampleFullAddress => 'دمشق - ساحة العباسيين - مدخل ساحة القصور';

  @override
  String get profileWasherSamplePhone => '0987654321';

  @override
  String get profileWasherAboutTitle => 'عن المغسلة';

  @override
  String get profileWasherDescriptionSample => 'في مغسل المحبة نوفّر لكم غسيلاً احترافياً للسيارات بمنتجات آمنة وصديقة للبيئة، مع فريق يهتم بتفاصيل السيارة من الخارج إلى الداخل. نسعى لخدمتكم يوماً بعد يوم بأسعار واضحة ووقت انتظار مريح، لتشعرون أن سيارتكم في عناية ناس بتحب الشغل النظيف.';

  @override
  String get profileWasherEditPageTitle => 'تعديل ملف المنظّف';

  @override
  String get profileWasherFieldWasherName => 'اسم المغسل';

  @override
  String get profileWasherHintWasherName => 'ادخل اسم المغسل';

  @override
  String get profileWasherFieldPhone => 'رقم الهاتف';

  @override
  String get profileWasherHintPhone => 'ادخل رقم الهاتف للتواصل';

  @override
  String get profileWasherFieldAddress => 'المدينة والعنوان';

  @override
  String get profileWasherHintAddress => 'ادخل عنوان المغسل بالتفصيل';

  @override
  String get profileWasherFieldWorkStart => 'بداية العمل';

  @override
  String get profileWasherHintWorkStart => 'ادخل وقت بداية العمل';

  @override
  String get profileWasherFieldWorkEnd => 'نهاية العمل';

  @override
  String get profileWasherHintWorkEnd => 'ادخل وقت نهاية العمل';

  @override
  String get profileWasherChooseServicesTitle => 'اختر الخدمات التي تقدمها';

  @override
  String get profileWasherFieldDescription => 'الوصف';

  @override
  String get profileWasherHintDescription => 'ادخل وصف المغسلة';

  @override
  String get profileWasherTierBasic => 'Basic';

  @override
  String get profileWasherTierVip => 'Vip';

  @override
  String get profileWasherTierPremium => 'Premium';

  @override
  String get profileWasherFieldPrice => 'السعر';

  @override
  String get profileWasherHintPrice => 'ادخل السعر';

  @override
  String get profileWasherSaveChanges => 'حفظ التغييرات';

  @override
  String get profileWasherCreatePageTitle => 'إنشاء بروفايل المغسلة';

  @override
  String get profileWasherUploadLogo => 'رفع الشعار';

  @override
  String get profileWasherFieldCity => 'المدينة';

  @override
  String get profileWasherHintCity => 'ادخل المدينة';

  @override
  String get profileWasherFieldStreetAddress => 'العنوان';

  @override
  String get profileWasherHintStreetAddress => 'ادخل العنوان';

  @override
  String get profileWasherFieldServicesList => 'الخدمات';

  @override
  String get profileWasherHintServicesList => 'افصل بين الخدمات بفاصلة ,';

  @override
  String get profileWasherWorkingHoursTitle => 'ساعات العمل';

  @override
  String get profileWasherFieldSaturdayHours => 'السبت';

  @override
  String get profileWasherHintSaturdayHours => 'مثال: 11:00-15:00';

  @override
  String get profileWasherFieldSundayHours => 'الأحد';

  @override
  String get profileWasherHintSundayHours => 'مثال: 10:00-16:00';

  @override
  String get profileWasherCreateSave => 'حفظ البروفايل';

  @override
  String get showRatingTotalBookings => 'اجمالي الحجوزات';

  @override
  String get showRatingAllReserved => 'إجمالي الحجوزات';

  @override
  String get bookingStatusPending => 'قيد الانتظار';

  @override
  String get bookingStatusAccepted => 'تم القبول';

  @override
  String get bookingStatusProgress => 'قيد التنفيذ';

  @override
  String get bookingStatusCompleted => 'مكتمل';

  @override
  String get bookingStatusCanceled => 'ملغي';

  @override
  String get showRatingAverageRatings => 'متوسط التقييمات';

  @override
  String get showRatingUsersComments => 'تعليقات المستخدمين';

  @override
  String get createSosTitle => 'إنشاء طلب نجدة';

  @override
  String get createSosChooseVehicle => 'اختر المركبة';

  @override
  String get createSosChooseProvince => 'اختر المحافظة';

  @override
  String get createSosLocationAutoHint => '* سيتم إرسال موقعك الحالي تلقائياً';

  @override
  String get createSosProblemDescription => 'أدخل وصفاً للمشكلة';

  @override
  String get createSosSendRequest => 'إرسال الطلب';

  @override
  String get createSosSampleProblemText => 'ادخل الوصف هنا';

  @override
  String get fuelSosCreateTitle => 'إنشاء طلب وقود طارئ';

  @override
  String get fuelSosCreateVehicleTitle => 'المركبة';

  @override
  String get fuelSosCreateVehicleHint => 'اختر المركبة التي تريدها للخدمة';

  @override
  String get fuelSosCreateFuelTypeTitle => 'نوع الوقود';

  @override
  String get fuelSosCreateFuelTypeHint => 'اختر نوع الوقود الذي تريده';

  @override
  String get fuelSosCreateQuantityTitle => 'الكمية';

  @override
  String get fuelSosCreateQuantityHint => 'أدخل الكمية التي تريد تعبئتها';

  @override
  String get fuelSosCreateNotesTitle => 'ملاحظات';

  @override
  String get fuelSosCreateNotesHint => 'أدخل أي ملاحظات تريد إضافتها';

  @override
  String get fuelSosCreateProvinceTitle => 'المحافظة';

  @override
  String get fuelSosCreateProvinceHint => 'اختر المحافظة في مكانك الحالي';

  @override
  String get fuelSosCreateSelectVehicleRequired => 'الرجاء اختيار المركبة';

  @override
  String get fuelSosCreateSelectFuelTypeRequired => 'الرجاء اختيار نوع الوقود';

  @override
  String get fuelSosCreateQuantityRequired => 'الرجاء إدخال الكمية';

  @override
  String get fuelSosCreateSelectProvinceRequired => 'الرجاء اختيار المحافظة';

  @override
  String get fuelSosCreateNoVehicles => 'لا توجد سيارات';

  @override
  String get sosRequestsListTitle => 'قائمة طلبات النجدة';

  @override
  String get sosRequestIdLabel => 'رقم المعرف';

  @override
  String get sosRequestVehicleLabel => 'المركبة';

  @override
  String get sosRequestShortDescriptionLabel => 'وصف مختصر';

  @override
  String get sosStatusFinished => 'منتهية';

  @override
  String get sosStatusInProgress => 'قيد التنفيذ';

  @override
  String get sosStatusWaiting => 'انتظار';

  @override
  String get sosRequestAccept => 'قبول';

  @override
  String get sosRequestViewDetails => 'عرض التفاصيل';

  @override
  String sosRequestCreatedAtHours(int hours) {
    return 'تم الإنشاء منذ $hours ساعة';
  }

  @override
  String sosRequestCreatedAtMinutes(int minutes) {
    return 'تم الإنشاء منذ $minutes دقيقة';
  }

  @override
  String get sosDetailsTitle => 'تفاصيل النجدة';

  @override
  String get sosDetailsRequestAccepted => 'تم قبول الطلب';

  @override
  String get sosDetailsRequestData => 'بيانات الطلب';

  @override
  String get sosDetailsPlateNumberLabel => 'رقم اللوحة';

  @override
  String get sosDetailsTechnicianLabel => 'الفني';

  @override
  String get sosDetailsDescriptionLabel => 'وصف';

  @override
  String get sosDetailsCurrentLocation => 'الموقع الحالي';

  @override
  String get sosDetailsTrack => 'تتبع';

  @override
  String get sosDetailsCancelRequest => 'إلغاء الطلب';

  @override
  String get fuelOrdersListTitle => 'قائمة طلبات الوقود';

  @override
  String get fuelOrderDetailsTitle => 'تفاصيل طلب الوقود';

  @override
  String get fuelOrderDetailsProviderSection => 'بيانات الشركة المزودة للخدمة';

  @override
  String get cancelReasonDialogTitle => 'Cancel SOS';

  @override
  String get cancelReasonDialogQuestion => 'ما سبب إلغاء الطلب ؟';

  @override
  String get cancelReasonDialogHint => 'ادخل هنا سبب إلغاء طلب الوقود ...';

  @override
  String get cancelReasonDialogBack => 'تراجع';

  @override
  String get fuelCancelReasonDialogTitle => 'إلغاء الطلب';

  @override
  String get providerProfilePageTitle => 'بروفايل المزود';

  @override
  String get providerProfileAvailabilityTitle => 'التوافر للعمل';

  @override
  String get providerProfileAvailableNow => 'متوفر الآن';

  @override
  String get providerProfileNotAvailableNow => 'غير متوفر الآن';

  @override
  String get providerProfileLocationSectionTitle => 'موقع مقدم الخدمة';

  @override
  String get providerProfileServicesAndPricesTitle => 'الخدمات و الأسعار';

  @override
  String get providerProfileSampleName => 'خالد الخالد';

  @override
  String providerProfilePriceLine(String price) {
    return 'السعر : $price \$';
  }

  @override
  String get providerEditProfilePageTitle => 'تعديل بروفايل المزود';

  @override
  String get providerEditProfilePersonalInfoTitle => 'معلومات ملفك الشخصي';

  @override
  String get providerEditProfileProviderNameLabel => 'اسم مقدم الخدمة';

  @override
  String get providerEditProfileProviderNameHint => 'ادخل اسم مقدم الخدمة';

  @override
  String get providerEditProfileProviderPhoneLabel => 'رقم مقدم الخدمة';

  @override
  String get providerEditProfileProviderPhoneHint => 'ادخل رقم مقدم الخدمة';

  @override
  String get providerEditProfileGovernorateLabel => 'اختر محافظة مقدم الخدمة';

  @override
  String get providerEditProfileGovernorateHint => 'اختر المحافظة';

  @override
  String get providerEditProfileAddressLabel => 'العنوان';

  @override
  String get providerEditProfileAddressHint => 'ادخل العنوان بالتفصيل';

  @override
  String get providerEditProfileLocationNote => '* سيتم استخدام موقعك كنقطة انطلاق للمزود';

  @override
  String get providerEditProfileActivateServiceLine => 'تفعيل الخدمة و تحديد السعر';

  @override
  String get providerEditProfileSaveInfo => 'حفظ المعلومات';

  @override
  String get providerEditProfileSampleAddress => 'ساحة العباسيين - مدخل ساحة القصور';

  @override
  String get providerCreateProfilePageTitle => 'إنشاء ملف المزود';

  @override
  String get providerCreateProfileSave => 'إنشاء الملف';

  @override
  String providerEditProfileSetPriceTitle(String fuelType) {
    return 'تحديد سعر $fuelType';
  }

  @override
  String get providerEditProfileSetPriceHint => 'أدخل السعر';

  @override
  String get providerEditProfileSetPriceRequired => 'الرجاء إدخال السعر';

  @override
  String get providerAvailableOrdersTitle => 'الطلبات المتاحة';

  @override
  String get providerAvailableOrderNoNotes => 'لا يوجد';

  @override
  String get providerOrderDetailsTitle => 'تفاصيل طلب المزود';

  @override
  String get providerOrderDetailsPendingAcceptance => 'بانتظار قبول الطلب';

  @override
  String get providerOrderDetailsCustomerSection => 'بيانات العميل';

  @override
  String get providerOrderDetailsAcceptOrder => 'قبول الطلب';

  @override
  String get providerOrderDetailsShareLocationOn => 'مشاركة الموقع';

  @override
  String get providerOrderDetailsShareLocationOff => 'عدم مشاركة الموقع';

  @override
  String get providerOrderDetailsEstimatedArrivalDialogTitle => 'الوقت المتوقع للوصول بالدقائق';

  @override
  String get providerOrderDetailsEnterDurationMinutes => 'ادخل المدة بالدقائق';

  @override
  String get providerOrderDetailsEnterAdditionalNotes => 'ادخل ملاحظات اضافية';

  @override
  String get providerMyOrdersTitle => 'طلباتي';

  @override
  String get providerStatisticsTotalOrdersTitle => 'اجمالي الطلبات';

  @override
  String get providerStatisticsTotalProfitsTitle => 'اجمالي الأرباح';

  @override
  String get providerStatisticsAllOrders => 'All Reserved';

  @override
  String get advertisementSemanticLabel => 'إعلان';

  @override
  String advertisementSemanticLabelWithTitle(String title) {
    return 'إعلان: $title';
  }

  @override
  String get advertisementLinkOpenFailed => 'تعذر فتح رابط الإعلان';

  @override
  String get requestStatusPending => 'قيد الانتظار';

  @override
  String get requestStatusAccepted => 'تم القبول';

  @override
  String get requestStatusCompleted => 'مكتمل';

  @override
  String get requestStatusAll => 'الكل';

  @override
  String get orderStatusAll => 'الكل';

  @override
  String get orderStatusPending => 'قيد الانتظار';

  @override
  String get orderStatusAccepted => 'مقبول';

  @override
  String get orderStatusProcessing => 'قيد التجهيز';

  @override
  String get orderStatusOutForDelivery => 'قيد التوصيل';

  @override
  String get orderStatusDelivered => 'تم التسليم';

  @override
  String get orderStatusRejected => 'مرفوض';

  @override
  String get orderStatusCancelled => 'ملغي';

  @override
  String get bookingStatusAll => 'الكل';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور';

  @override
  String get enterYourEmailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get sendVerificationCode => 'إرسال رمز التحقق';

  @override
  String get otpCardTitle => 'التحقق من الرمز';

  @override
  String get otpSentDescription => 'لقد أرسلنا رمز تحقق من 6 أرقام إلى';

  @override
  String get confirmOtp => 'تأكيد';

  @override
  String get resetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordButton => 'تغيير كلمة المرور';

  @override
  String get invalidVerificationCode => 'رمز التحقق غير صحيح';

  @override
  String get verificationCodeExpired => 'انتهت صلاحية رمز التحقق';

  @override
  String get tooManyAttempts => 'عدد المحاولات كثير جدًا';

  @override
  String get passwordChangedSuccessfully => 'تم تغيير كلمة المرور بنجاح';

  @override
  String get otpExpiresIn => 'تنتهي صلاحية الرمز خلال';

  @override
  String get otpExpiredNotice => 'انتهت صلاحية الرمز، يرجى طلب رمز جديد.';

  @override
  String get orContinueWith => 'أو تابع باستخدام';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get notificationsAllFilter => 'الكل';

  @override
  String get notificationsUnreadFilter => 'غير مقروءة';

  @override
  String get markAllAsRead => 'تحديد الكل كمقروء';

  @override
  String get deleteNotification => 'حذف';

  @override
  String get notificationJustNow => 'الآن';

  @override
  String notificationMinutesAgo(int minutes) {
    return 'منذ $minutes د';
  }

  @override
  String notificationHoursAgo(int hours) {
    return 'منذ $hours س';
  }

  @override
  String get notificationYesterday => 'أمس';

  @override
  String notificationDaysAgo(int days) {
    return 'منذ $days يوم';
  }

  @override
  String get selectGovernorate => 'اختر المحافظة';

  @override
  String get readygSummary => 'هل أنت مستعد للعودة إلى الطريق؟';
}
