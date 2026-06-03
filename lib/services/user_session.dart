class UserSession {
  static int? userId;
  static String? fullName;
  static String? email;
  static String? phoneNumber;
  static String? address;
  static String? gender;
  static String? dateOfBirth;
  static String? profileImage;

  static void saveUser(Map<String, dynamic> user) {
    userId = user['userId'];
    fullName = user['fullName'];
    email = user['email'];
    phoneNumber = user['phoneNumber'];
    address = user['address'];
    gender = user['gender'];
    dateOfBirth = user['dateOfBirth'];
    profileImage = user['profileImage'];
  }

  static void clear() {
    userId = null;
    fullName = null;
    email = null;
    phoneNumber = null;
    address = null;
    gender = null;
    dateOfBirth = null;
    profileImage = null;
  }
}