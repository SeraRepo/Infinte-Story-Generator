import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  late User? user;

  void updateUser(User updatedUser) {
    user = updatedUser;
    notifyListeners();
  }
}
