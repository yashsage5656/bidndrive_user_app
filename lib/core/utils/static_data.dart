/// Static Data for Car Marketplace
/// Contains sample data for cars, brands, and other static content
library;

class StaticData {
  StaticData._();

  // Network Image URLs (from Unsplash - Free car images)
  static const String carImageBaseUrl = 'https://images.unsplash.com';

  // Car Images
  static const List<String> carImages = [
    'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=800',
    'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800',
    'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800',
    'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800',
    'https://images.unsplash.com/photo-1542362567-b07e54358753?w=800',
    'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=800',
    'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=800',
    'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=800',
  ];

  // Featured Cars
  static const List<Map<String, dynamic>> featuredCars = [
    {
      'id': '1',
      'name': 'BMW 3 Series',
      'brand': 'BMW',
      'model': '320d M Sport',
      'year': 2022,
      'price': 4500000,
      'mileage': 15000,
      'fuelType': 'Diesel',
      'transmission': 'Automatic',
      'image':
          'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800',
      'location': 'Mumbai',
      'rating': 4.8,
      'owner': '1st',
    },
    {
      'id': '2',
      'name': 'Mercedes-Benz C-Class',
      'brand': 'Mercedes-Benz',
      'model': 'C200 AMG Line',
      'year': 2021,
      'price': 5200000,
      'mileage': 22000,
      'fuelType': 'Petrol',
      'transmission': 'Automatic',
      'image':
          'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=800',
      'location': 'Delhi',
      'rating': 4.7,
      'owner': '1st',
    },
    {
      'id': '3',
      'name': 'Audi A4',
      'brand': 'Audi',
      'model': 'A4 Premium Plus',
      'year': 2023,
      'price': 4800000,
      'mileage': 8000,
      'fuelType': 'Petrol',
      'transmission': 'Automatic',
      'image':
          'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=800',
      'location': 'Bangalore',
      'rating': 4.9,
      'owner': '1st',
    },
    {
      'id': '4',
      'name': 'Hyundai Creta',
      'brand': 'Hyundai',
      'model': 'SX(O) Diesel',
      'year': 2023,
      'price': 1800000,
      'mileage': 5000,
      'fuelType': 'Diesel',
      'transmission': 'Automatic',
      'image':
          'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=800',
      'location': 'Chennai',
      'rating': 4.6,
      'owner': '1st',
    },
    {
      'id': '5',
      'name': 'Toyota Fortuner',
      'brand': 'Toyota',
      'model': 'Legender 4x4',
      'year': 2022,
      'price': 4200000,
      'mileage': 18000,
      'fuelType': 'Diesel',
      'transmission': 'Automatic',
      'image':
          'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=800',
      'location': 'Pune',
      'rating': 4.7,
      'owner': '2nd',
    },
    {
      'id': '6',
      'name': 'Porsche 911',
      'brand': 'Porsche',
      'model': 'Carrera S',
      'year': 2021,
      'price': 18500000,
      'mileage': 12000,
      'fuelType': 'Petrol',
      'transmission': 'Automatic',
      'image':
          'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800',
      'location': 'Mumbai',
      'rating': 4.9,
      'owner': '1st',
    },
  ];

  // Popular Brands
  static const List<Map<String, String>> popularBrands = [
    {
      'name': 'Maruti Suzuki',
      'logo': 'https://www.carlogos.org/car-logos/suzuki-logo.png',
    },
    {
      'name': 'Hyundai',
      'logo': 'https://www.carlogos.org/car-logos/hyundai-logo.png',
    },
    {
      'name': 'Tata',
      'logo': 'https://www.carlogos.org/car-logos/tata-logo.png',
    },
    {
      'name': 'Honda',
      'logo': 'https://www.carlogos.org/car-logos/honda-logo.png',
    },
    {
      'name': 'Toyota',
      'logo': 'https://www.carlogos.org/car-logos/toyota-logo.png',
    },
    {
      'name': 'Mahindra',
      'logo': 'https://www.carlogos.org/car-logos/mahindra-logo.png',
    },
    {'name': 'BMW', 'logo': 'https://www.carlogos.org/car-logos/bmw-logo.png'},
    {
      'name': 'Mercedes-Benz',
      'logo': 'https://www.carlogos.org/car-logos/mercedes-benz-logo.png',
    },
    {
      'name': 'Audi',
      'logo': 'https://www.carlogos.org/car-logos/audi-logo.png',
    },
    {'name': 'Kia', 'logo': 'https://www.carlogos.org/car-logos/kia-logo.png'},
  ];

  // Fuel Types
  static const List<String> fuelTypes = [
    'Petrol',
    'Diesel',
    'Electric',
    'Hybrid',
    'CNG',
  ];

  // Transmission Types
  static const List<String> transmissionTypes = [
    'Manual',
    'Automatic',
    'CVT',
    'DCT',
  ];

  // Body Types
  static const List<String> bodyTypes = [
    'Sedan',
    'SUV',
    'Hatchback',
    'Coupe',
    'Convertible',
    'MPV',
    'Pickup',
  ];

  // Price Ranges
  static const List<Map<String, dynamic>> priceRanges = [
    {'label': 'Under ₹5 Lakh', 'min': 0, 'max': 500000},
    {'label': '₹5 - 10 Lakh', 'min': 500000, 'max': 1000000},
    {'label': '₹10 - 20 Lakh', 'min': 1000000, 'max': 2000000},
    {'label': '₹20 - 50 Lakh', 'min': 2000000, 'max': 5000000},
    {'label': 'Above ₹50 Lakh', 'min': 5000000, 'max': null},
  ];

  // User's Cars (for My Cars screen)
  static const List<Map<String, dynamic>> myCars = [
    {
      'id': 'my1',
      'name': 'Honda City',
      'model': 'ZX CVT',
      'year': 2020,
      'registrationNumber': 'MH 02 AB 1234',
      'status': 'Listed',
      'price': 950000,
      'bidsReceived': 5,
      'image':
          'https://images.unsplash.com/photo-1542362567-b07e54358753?w=800',
    },
    {
      'id': 'my2',
      'name': 'Maruti Swift',
      'model': 'VXI AMT',
      'year': 2019,
      'registrationNumber': 'MH 04 CD 5678',
      'status': 'Inspection Pending',
      'price': 520000,
      'bidsReceived': 0,
      'image':
          'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800',
    },
  ];

  // Car Condition Questions
  static const List<Map<String, dynamic>> conditionQuestions = [
    {
      'id': 'q1',
      'question': 'Are the tyres in good condition?',
      'icon': 'tire',
      'image':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    },
    {
      'id': 'q2',
      'question': 'Has the car been in any accidents?',
      'icon': 'accident',
      'image':
          'https://images.unsplash.com/photo-1600320254374-ce2d293c324e?w=400',
    },
    {
      'id': 'q3',
      'question': 'Is the engine sound normal?',
      'icon': 'engine',
      'image':
          'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?w=400',
    },
    {
      'id': 'q4',
      'question': 'Is the paint original?',
      'icon': 'paint',
      'image':
          'https://images.unsplash.com/photo-1502877338535-766e1452684a?w=400',
    },
    {
      'id': 'q5',
      'question': 'Is the body free of rust?',
      'icon': 'body',
      'image':
          'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=400',
    },
  ];

  // Inspection Time Slots
  static const List<String> timeSlots = [
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '12:00 PM - 01:00 PM',
    '02:00 PM - 03:00 PM',
    '03:00 PM - 04:00 PM',
    '04:00 PM - 05:00 PM',
    '05:00 PM - 06:00 PM',
  ];

  // Inspection Types
  static const List<Map<String, dynamic>> inspectionTypes = [
    {
      'id': 'home',
      'title': 'Home Inspection',
      'description': 'Our expert will visit your home',
      'icon': 'home',
      'price': 0,
    },
    {
      'id': 'center',
      'title': 'Center Inspection',
      'description': 'Visit our nearest inspection center',
      'icon': 'location',
      'price': 0,
    },
    // {
    //   'id': 'doorstep',
    //   'title': 'Doorstep Pickup',
    //   'description': 'We\'ll pick up your car for inspection',
    //   'icon': 'car',
    //   // 'price': 500,
    // },
  ];

  // Pre-Delivery Inspection Items
  static const List<Map<String, dynamic>> inspectionChecklist = [
    {
      'category': 'Exterior',
      'items': [
        'Body panels condition',
        'Paint quality',
        'Glass condition',
        'Lights & indicators',
        'Tyres & wheels',
        'Bumpers',
      ],
    },
    {
      'category': 'Interior',
      'items': [
        'Seat condition',
        'Dashboard',
        'Steering wheel',
        'Door panels',
        'Carpet & floor mats',
        'Headliner',
      ],
    },
    {
      'category': 'Engine & Mechanical',
      'items': [
        'Engine sound',
        'Oil levels',
        'Coolant level',
        'Battery condition',
        'Brakes',
        'Suspension',
      ],
    },
    {
      'category': 'Electronics',
      'items': [
        'Infotainment system',
        'AC/Heater',
        'Power windows',
        'Central locking',
        'Sensors',
        'Camera',
      ],
    },
  ];

  // Document Types
  static const List<Map<String, dynamic>> documentTypes = [
    {'id': 'rc', 'name': 'Registration Certificate (RC)', 'required': true},
    {'id': 'insurance', 'name': 'Insurance Papers', 'required': true},
    {'id': 'puc', 'name': 'PUC Certificate', 'required': true},
    {'id': 'noc', 'name': 'NOC (if applicable)', 'required': false},
    {'id': 'service', 'name': 'Service Records', 'required': false},
  ];

  // Cities
  static const List<String> cities = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Chennai',
    'Hyderabad',
    'Pune',
    'Kolkata',
    'Ahmedabad',
    'Jaipur',
    'Lucknow',
  ];

  // Banner Data
  static const List<Map<String, dynamic>> banners = [
    {
      'id': 'b1',
      'title': 'Sell Your Car',
      'subtitle': 'Get the best price instantly',
      'image':
          'https://images.unsplash.com/photo-1493238792000-8113da705763?w=800',
      'color': '#2ECC71',
    },
    {
      'id': 'b2',
      'title': 'Premium Cars',
      'subtitle': 'Certified & Inspected vehicles',
      'image':
          'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800',
      'color': '#3498DB',
    },
    {
      'id': 'b3',
      'title': 'Easy EMI Options',
      'subtitle': 'Starting at ₹9,999/month',
      'image':
          'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=800',
      'color': '#9B59B6',
    },
  ];

  // User Profile Data
  static const Map<String, dynamic> userProfile = {
    'name': 'Rahul Sharmaa',
    'email': 'rahul.sharma@email.com',
    'phone': '+91 98765 43210',
    'avatar':
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    'totalCars': 2,
    'totalBids': 15,
    'memberSince': '2023',
  };
}
