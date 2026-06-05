class ApiConstants {
  static const String baseUrl = "https://vgm.online-tech.in";

  // Fee APIs
  static const String saveFeeCollection = "$baseUrl/api/FeeApi/SaveFeeCollection";
  static const String FeeReceivedSummary = "$baseUrl/api/FeeApi/FeeReceivedSummary";
  static const String GetStudentFeeForMonthYear = "$baseUrl/api/FeeApi/GetStudentFeeForMonthYear";
  static const String StudentMonthlyPendingFee = "$baseUrl/api/FeeApi/StudentMonthlyPendingFee";

  //Auth APIs
  static const String login = "$baseUrl/api/AuthApi/login";

  // Student APIs
  static const String getStudentAttendance = "$baseUrl/api/StudentApi/GetStudentAttendance";
  static const String GetTimeTableByClass = "$baseUrl/api/StudentApi/GetTimeTableByClass";
  static const String GetStudentInfoById = "$baseUrl/api/StudentApi/GetStudentInfoById";
  static const String ChangeStudentPassword = "$baseUrl/api/StudentApi/ChangeStudentPassword";
  static const String GetStudentHomework = "$baseUrl/api/StudentApi/GetStudentHomework";
  static const String studentAttendanceStatus = "$baseUrl/api/StudentApi/studentAttendanceStatus";

  //MAster apis
  static const String GetAllLatestNews = "$baseUrl/api/MasterApi/GetAllLatestNews";
  // Dashboard API
static const String GetAppDashboard = "$baseUrl/api/StudentApi/GetAppDashboard";

}