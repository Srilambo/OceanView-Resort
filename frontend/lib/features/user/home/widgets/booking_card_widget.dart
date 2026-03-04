import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../../../../theme/app_colors.dart';

class BookingCardWidget extends StatelessWidget {
  const BookingCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 80),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 32,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Consumer<BookingProvider>(
        builder: (context, booking, _) {
          return Column(
            children: [
              Text(
                'SET YOUR DATES',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.cream,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      context,
                      'CHECK IN',
                      booking.checkInDate,
                      (date) => booking.setCheckInDate(date),
                      'Select date',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildDateField(
                      context,
                      'CHECK OUT',
                      booking.checkOutDate,
                      (date) => booking.setCheckOutDate(date),
                      'Select date',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildGuestField(
                      booking.guestCount,
                      (count) => booking.setGuestCount(count),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: _buildCtaButton(
                      'Check Availability',
                      onPressed: booking.isBookingValid() && !booking.isLoading
                          ? () => booking.checkAvailability()
                          : null,
                      isLoading: booking.isLoading,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? value,
    Function(DateTime) onChanged,
    String placeholder,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.goldAccent,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    primaryColor: AppColors.goldAccent,
                    colorScheme: const ColorScheme.dark(
                      primary: AppColors.goldAccent,
                      onPrimary: AppColors.darkBg,
                      surface: AppColors.darkBgSecondary,
                      onSurface: AppColors.textLight,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              onChanged(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              border: Border.all(
                color: Colors.white.withOpacity(0.12),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.goldAccent,
                ),
                const SizedBox(width: 12),
                Text(
                  value != null
                      ? '${value.day}/${value.month}/${value.year}'
                      : placeholder,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestField(int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GUEST',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.goldAccent,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              icon: const Icon(Icons.keyboard_arrow_down,
                  size: 16, color: AppColors.goldAccent),
              dropdownColor: AppColors.darkBgSecondary,
              items: [1, 2, 3, 4, 5]
                  .map((count) => DropdownMenuItem<int>(
                        value: count,
                        child: Row(
                          children: [
                            const Icon(Icons.people,
                                size: 16, color: AppColors.goldAccent),
                            const SizedBox(width: 12),
                            Text(
                              '$count Guest${count > 1 ? 's' : ''}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCtaButton(String label,
      {VoidCallback? onPressed, bool isLoading = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldAccent.withOpacity(0.4),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.darkBg,
                    ),
                  )
                : Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBg,
                      letterSpacing: 1,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

