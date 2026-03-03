import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guestCount = 1;
  String _selectedTab = 'Rooms';
  bool _isLoading = false;

  DateTime? get checkInDate => _checkInDate;
  DateTime? get checkOutDate => _checkOutDate;
  int get guestCount => _guestCount;
  String get selectedTab => _selectedTab;
  bool get isLoading => _isLoading;

  int get numberOfNights {
    if (_checkInDate != null && _checkOutDate != null) {
      return _checkOutDate!.difference(_checkInDate!).inDays;
    }
    return 0;
  }

  void setCheckInDate(DateTime date) {
    _checkInDate = date;
    notifyListeners();
  }

  void setCheckOutDate(DateTime date) {
    _checkOutDate = date;
    notifyListeners();
  }

  void setGuestCount(int count) {
    _guestCount = count;
    notifyListeners();
  }

  void setSelectedTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  Future<void> checkAvailability() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _isLoading = false;
    notifyListeners();
  }

  bool isBookingValid() {
    return _checkInDate != null &&
        _checkOutDate != null &&
        _checkOutDate!.isAfter(_checkInDate!) &&
        _guestCount > 0;
  }
}
