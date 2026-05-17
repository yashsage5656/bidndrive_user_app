import 'dart:async';
import 'dart:ui';

import 'package:bid_driving/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CarCard extends StatefulWidget {
  final dynamic car;
  final VoidCallback onTap;
  final bool isCompact; // 🔥 NEW

  const CarCard({
    super.key,
    required this.car,
    required this.onTap,
    this.isCompact = false,
  });

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    if (widget.car.images.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_pageController.hasClients) {
          _currentPage++;

          if (_currentPage >= widget.car.images.length) {
            _currentPage = 0;
          }

          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        } else {}
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();

    _pageController.dispose();

    super.dispose();
  }

  bool isValidUrl(String? url) {
    return url != null && url.startsWith('http');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final imageHeight = widget.isCompact ? 140.0 : 200.0;
    final padding = widget.isCompact ? 12.0 : 20.0;
    final titleSize = widget.isCompact ? 15.0 : 19.0;
    final spacing = widget.isCompact ? 10.0 : 18.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6,vertical: 2),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkNavyLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            /// 📸 IMAGE
            /// 📸 IMAGE
            Stack(
              children: [
                /// IMAGE SLIDER
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),

                  child: SizedBox(
                    height: imageHeight,
                    width: double.infinity,

                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.car.images.length,

                      onPageChanged: (index) {
                        if (!mounted) return;

                        setState(() {
                          _currentPage = index;
                        });
                      },

                      itemBuilder: (context, index) {
                        final image = widget.car.images[index];

                        return isValidUrl(image)
                            ? Image.network(
                                image,
                                fit: BoxFit.cover,

                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) {
                                    return child;
                                  }

                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                  );
                                },

                                errorBuilder: (_, error, stackTrace) {
                                  return _placeholder(imageHeight);
                                },
                              )
                            : _placeholder(imageHeight);
                      },
                    ),
                  ),
                ),

                /// DOTS
                if (widget.car.images.length > 1)
                  Positioned(
                    bottom: 6,
                    left: 0,
                    right: 0,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: List.generate(
                        widget.car.images.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),

                          margin: const EdgeInsets.symmetric(horizontal: 3),

                          width: _currentPage == index ? 10 : 5,
                          height: 5,

                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white54,

                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),

                /// BADGES
                Positioned(
                  top: 10,
                  left: 10,

                  child: _blurBadge(widget.car.transmission.toUpperCase()),
                ),

                if (widget.car.priceNegotiable)
                  Positioned(
                    top: 10,
                    right: 10,

                    child: _statusBadge("NEGOTIABLE", Colors.green),
                  ),
              ],
            ),

            /// DETAILS
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${widget.car.make} ${widget.car.model}",
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w900,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatPrice(widget.car.price),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: titleSize,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "${widget.car.year} • ${widget.car.city}",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: widget.isCompact ? 11 : 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: spacing),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _specBox(Iconsax.speedometer, "${widget.car.mileage}"),
                      _specBox(Iconsax.gas_station, widget.car.fuelType),
                      _specBox(Iconsax.setting_4, widget.car.transmission),
                      _specBox(Iconsax.user, widget.car.ownership),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _specBox(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.primary.withOpacity(0.8)),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _blurBadge(String text) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    if (price >= 100000) {
      return "₹${(price / 100000).toStringAsFixed(2)} L";
    }
    return "₹$price";
  }

  Widget _placeholder(double h) {
    return Container(
      height: h,
      color: Colors.grey[200],
      child: const Icon(Iconsax.car),
    );
  }
}
