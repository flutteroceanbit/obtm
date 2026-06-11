import 'package:flutter/foundation.dart';

class Api {
  static const baseurl = 'https://obtm-pms-dev.oceanbitsolutions.com';
  // 'https://timeclock.oceanbitsolutions.com';
  //  'https://obtm-dev.oceanbitsolutions.com';

  // static const getOptionValue = "bile/option/values"

  static const database = kDebugMode ? 'TIMER_DETAIL_TEST' : 'TIMER_DETAIL';
  static const databaseSmall = kDebugMode
      ? 'timer_detail_test'
      : 'timer_detail';
  static const newDatabaseSmall = kDebugMode
      ? 'oceanbit_timeclock_db_test.db'
      : 'oceanbit_timeclock_db.db';
  // static const database = 'TIMER_DETAIL';
  // static const databaseSmall = 'timer_detail';
  // static const newDatabaseSmall = 'oceanbit_timeclock_db.db';

  /// Auth
  static const login = '/api/user/login';
  static const register = '/api/user/register';
  static const addUpdatePersonalDetail = '/api/personalDetail/addUpdate';
  static const addUpdateContactDetail = '/api/contactDetail/addUpdate';
  static const resetPassword = '/api/password/reset';
  static const changePassword = '/api/password/update';

  ///Daily Report
  static const addDailyReport = '/api/daily_report/add';
  static const getDailyReports = '/api/user/daily_reports';
  static const getUserLastDailyReport = '/api/user/last_daily_reports';

  ///user detail apis
  static const userList = '/api/user/list';
  static const userDetail = '/api/user/detail';
  static const userProfile = '/api/user/profile';
  static const userUpdate = '/api/user/updateProfile';
  static const changeIsActive = '/api/user/changeIsActive';
  static const usersBirthday = '/api/personalDetail/birthdayUsers?month=';

  ///time slot api
  static const addTimeSlot = '/api/timeSlot/add';
  static const getAllTimeSlot = '/api/timeSlot/list';
  static const getCurrentMonthChartData = '/api/timeSlot/thisMonthChartData';
  static const addLocalTimeSlots = '/api/timeSlot/addLocalTimeSlots';
  static const getTodayLastTimeSlot = '/api/timeSlot/todayLastTimeSlot';

  ///holiday
  static const allHolidaysType = '/api/holiday-type';
  static const allHolidays = '/api/holiday';
  static const addHolidayType = '/api/holiday-type';
  static const addHoliday = '/api/holiday';
  static const getHolidayByMonth = '/api/holiday-month';
  static const updateHolidayType = '/api/holiday-type';
  static const deleteHolidayType = '/api/holiday-type';
  static const updateHoliday = '/api/holiday';
  static const deleteHoliday = '/api/holiday';

  /// Department
  static const getDepartment = '/api/get_all_departments';
  static const addDepartment = '/api/add_departments';
  static const updateDepartment = '/api/update_departments';
  static const deleteDepartment = '/api/delete_departments';

  /// Quote
  static const getQuote = '/api/get_all_quotes';
  static const addQuote = '/api/add_quotes';
  static const updateQuote = '/api/update_quotes';
  static const deleteQuote = '/api/delete_quotes';

  /// Department
  static const getReview = '/api/get_all_reviews';
  static const getAllEmployeeReview = '/api/all_employees_daily_rate';
  static const addReview = '/api/daily_rate/update';
  // static const updateReview = '/api/update_quotes';
  static const deleteReview = '/api/delete_reviews';

  /// Designation
  static const getDesignation = '/api/get_all_designation';
  static const addDesignation = '/api/add_designation';
  static const updateDesignation = '/api/update_designation';
  static const deleteDesignation = '/api/delete_designation';

  /// bank info

  static const getBankInformation = '/api/get-bank-information';
  static const addBankInformation = '/api/bank-information';
  static const updateBankInformation = '/api/bank-information';
  static const deleteBankInformation = '/api/bank-information';

  static const getLeave = '/api/leaveRequest/list';
  static const addLeave = '/api/leaveRequest/add';
  static const getLeaveByUser = '/api/leaveRequest/list/';
  static const getUserLeave = '/api/leaveRequest/user/list';
  static const updateLeave = '/api/leaveRequest/statusUpdate';
  static const deleteLeave = '/api/leaveRequest/delete';

  static const getFault = '/api/get_system_faults';
  static const addFault = '/api/add_system_faults';
  static const getAdminFault = '/api/get_all_system_faults';
  static const updateAdminFault = '/api/update_system_faults_status';
  static const updateFault = '/api/update_system_faults';
  static const deleteFault = '/api/delete_system_faults';

  /// Previous Employer

  static const getPreviousEmployer = '/api/get_previous_employee_details';
  static const addPreviousEmployer = '/api/previous_employee_details';
  static const updatePreviousEmployer = '/api/previous_employee_details';
  static const deletePreviousEmployer = '/api/previous_employee_details';

  static const getRules = '/api/get_all_ocean_rules';
  static const addRules = '/api/add_ocean_rules';
  static const updateRules = '/api/update_ocean_rules';
  static const deleteRules = '/api/delete_ocean_rules';

  static const getEmployeeInfo = '/api/get_employee_information';
  static const getEmployeeInfoDetail = '/api/department_designation_list';
  static const addEmployeeInfo = '/api/add_employee_information';
  static const incrementApi = '/api/employee_increment';
  static const updateEmployeeInfo = '/api/update_employee_information';
  static const deleteEmployeeInfo = '/api/delete_employee_information';

  static const getInventory = '/api/get_all_inventory_details';
  static const getInventoryById = '/api/get_inventory_details';
  static const addInventory = '/api/add_inventory_details';
  static const updateInventory = '/api/update_inventory_details';
  static const deleteInventory = '/api/delete_inventory_details';

  static const getKnowledge = '/api/get_knowledge_base_information';
  static const addKnowledge = '/api/add_knowledge_base_information';
  static const updateKnowledge = '/api/knowledge_base_information';
  static const deleteKnowledge = '/api/knowledge_base_information';

  /// Employee credential

  static const getEmployeeCredential = '/api/get_employee_credentials';
  static const addEmployeeCredential = '/api/employee_credentials';
  static const updateEmployeeCredential = '/api/employee_credentials';
  static const deleteEmployeeCredential = '/api/employee_credentials';

  /// Transport

  static const getTransport = '/api/get_employee_transport_information';
  static const addTransport = '/api/employee_transport_information';
  static const deleteTransport = '/api/employee_transport_information';

  ///salary
  static const getSalary = '/api/get-salary-report';

  ///salary
  static const allOceanTeams = '/api/departments_wise_employees';
}
