import 'package:flutter/material.dart';

class Strings {
  static const username = 'User Name';
  static const password = 'Password';
  static const login = 'Login';
  static const offlineMsg =
      'You Are Offline,Please Check Your Internet Connection';

  static const userEmailEmpty = 'Please enter Email';
  static const passwordEmpty = 'Please enter password';
  //static const taskEmpty = 'Please Enter Your Task';
  static const enterTask = 'Enter your task';
  static const task = 'Task';
  static const taskEmpty = 'Please Enter Your Task';
  static const enterBreakReason = 'Enter your Break Reason';
  static const taskReason = 'Please Enter Your Break Reason';

  static const start = 'Start';
  static const finalize = 'Finalize';
  static const timeOut = 'Time Out';
  static const interIn = 'Time In';
  static const reset = 'Reset';
  static const submit = 'Submit';
  static const close = 'Close';
  static const back = 'Back';

  ///drawer item icon list
  static const List<IconData> drawerIcon = [
    Icons.dashboard,
    Icons.list_alt_sharp,
    Icons.timer_outlined,
    Icons.person,
    Icons.leave_bags_at_home,
    /*Icons.devices,*/ Icons.holiday_village,
    /*Icons.timelapse,*/ Icons.library_books,
    Icons.view_list,
    Icons.messenger_outline_rounded,
    Icons.error_outline,
    Icons.money,
    Icons.group,
    Icons.rule,
    Icons.logout,
  ];
  static const List<IconData> adminDrawerIcon = [
    Icons.dashboard,
    Icons.list_alt_sharp,
    Icons.timer_outlined,
    Icons.person,
    Icons.leave_bags_at_home,
    /*Icons.devices,*/ Icons.holiday_village,
    /*Icons.timelapse,*/ Icons.library_books,
    Icons.view_list,
    Icons.messenger_outline_rounded,
    Icons.error_outline,
    Icons.money,
    Icons.group,
    Icons.rule,
    Icons.business,
    Icons.logout,
  ];

  ///drawer item name list
  static const List<String> drawerItem = [
    'Dashboard',
    'My Tasks',
    'Time',
    'Profile',
    'Leave' /*,'Device'*/,
    'Holidays' /*,'Overtime'*/,
    'Knowledge Base',
    'Report List',
    'Employee Reviews',
    'System Faults',
    'My Salary',
    'Ocean Team',
    'Ocean Rules',
    'Logout',
  ];
  // static const List<String> adminDrawerItem=[];
  static const List<String> adminDrawerItem = [
    'Dashboard',
    'My Tasks',
    'Time',
    'Profile',
    'Leave' /*,'Device'*/,
    'Holidays' /*,'Overtime'*/,
    'Knowledge Base',
    'Report List',
    'Employee Reviews',
    'System Faults',
    'My Salary',
    'Ocean Team',
    'Ocean Rules',
    'Employee',
    'Logout',
  ];
  static const List<String> profileItem = ['Update Profile'];
  static const List<String> leaveItem = ['My Leaves', 'Apply Leave'];
  static const List<List<String>> drawerSubItem = [
    [],
    [],
    [],
    profileItem,
    leaveItem,
    /*[],*/ [],
    /*[],*/ [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];

  ///dashboard
  static const todayAllTImeSlots = 'Today All Time Slots';
  static const oceanBitTimeClock = "Oceanbit Time Clock";
  static const total = "Total";
  static const intermediate = "Intermediate";
  static const welcome = "Welcome";
  static const yourTiming = "YOUR TIMING";
  static const totalTime = "Total Time";
  static const intermediateTime = "Intermediate Time";
  static const birthdayInMonth = "Birthday in this month";
  static const holidaysInMonth = "Holidays in this month";
  static const yourTimingForMonth = "Your Timing For This Month";
  static const yAxisChartTitle = "(Time Line)";
  static const xAxisChartTitle = "(Months)";
  static const latestKnowledgeBase = "Latest knowledge base";
  static const lastStatueReport = "Last Status Report";
  static const quoteOfDay = "Quote of the day";
  static const busyOrFree = "Busy or free:You are free now";
  static const warning = "Warning";
  static const busy = "Busy";
  static const showData = "Show Data";
  static const interInTime = 'Inter in-time';
  static const interOutTime = "Inter out-time";
  static const finalOutTime = 'Final out-time';
  static const name = 'Name';
  static const birthdate = 'Birthdate';
  static const internetMissUseCount = 'Internet Miss Use Count';
  static const lateArrivalCount = 'Late Arrival Count';
  static const lateArrivalTimeList = 'Late Arrival Time List';
  static const days = 'Days';
  static const noData = 'No Data';
  static const noHoliday = 'No Holiday';
  static const quote =
      'Before you start some work, always ask yourself three questions - Why am I doing it, What the results might be and will I be successful,Only when you think deeply and find satisfactory answers to these questions, go ahead.';

  ///Birthday array
  static const Map<String, dynamic> birthdayList = {};
  static const List<String> holidayList = [
    '11 - November to 15 - November Diwali holidays',
  ];

  static const List<String> lastStatusReportList = [
    'Nick Name Character issue fixed',
    'My Offer Open Multiple time issue fixed',
    'Default Share issue fixed When FB app not installed',
    'Working on Table Screen optimization',
  ];
  static const Map<String, dynamic> knowledgeBaseList = {
    "Daxit Savaliya": "Most important Things in iOS Development",
    "Jaypal Dhoriya": "Appkit Provides by Apple",
    "Nihar Thakkar": "How to build an AR app",
  };

  ///profile screen
  static const List<String> adminTabList = [
    "Personal Information",
    "Employee Information",
    "Contact Information",
    "Employee Report",
    "Transport Information",
    "Previous Employer",
    "Salary Account",
    "Employee Credential",
  ];
  static const List<String> tabList = [
    "Personal Information",
    "Employee Information",
    "Contact Information",
    "Transport Information",
    "Previous Employer",
    "Salary Account",
  ];
  static const personalInfoTab = "Personal Information";
  static const employeeInfoTab = "Employee Information";
  static const contactInfoTab = "Contact Information";
  static const otherInfoTab = "Other Information";
  static const previousEmpTab = "Previous Employer";
  static const salaryAccountTab = "Salary Account";

  ///profile->personal info
  static const firstName = 'First Name';
  static const firstNameHint = 'Enter First Name';
  static const firstNameEmpty = 'Please Enter First Name';
  static const middleName = 'Middle Name';
  static const middleNameHint = 'Enter Middle Name';
  static const lastName = 'Last Name';
  static const lastNameHint = 'Enter Last Name';
  static const lastNameEmpty = 'Please Enter Last Name';
  static const gender = 'Gender';
  static const genderHint = 'Choose Your Gender';
  static const statusHint = 'Choose Status';
  static const genderEmpty = 'Please Choose Your Gender';
  static const education = 'Education';
  static const educationHint = 'Choose Education';
  static const profilePicture = 'Profile Picture';
  static const bloodGroup = 'Blood Group';
  static const bloodGroupHint = 'Choose Your Blood Group';
  static var chooseFileName = "Choose File Name";
  static var chooseFile = "Choose File";
  static var profilePictureInfo =
      "$profilePicture will be visible after received by admin";
  static var fatherFullName = "Father Full Name";
  static var fatherFullNameHint = "Enter Father's Full Name";
  static var fatherOccupation = "Father's Occupation";
  static var fatherOccupationHint = "Enter Father's Occupation";
  static var dateOfBirth = "Date Of Birth";
  static var fatherBirthdate = "Father's Birthdate";
  static var fatherBirthdateEmpty = "Please Select Your Father's Birthdate";
  static var birthdateEmpty = 'Please select your birthdate';
  static var yearOld = "Years old";
  static var aadharCardNumber = "Aadhar Card Number";
  static var aadharCardNumberHint = "Enter Aadhar Card Number";
  static var aadharCardNumberEmpty = "Please Enter Aadhar Card Number";
  static var message = "Message";
  static var remarks = "Remarks";
  static var remarksHint = "Enter Remarks";
  static var messageHint = "Enter message";
  static var messageEmpty = "Please Enter message";
  static var rating = "Rating";
  static var ratingHint = "Enter rating";
  static var ratingEmpty = "Please Enter rating";
  static var pan = "PAN";
  static var panNumberHint = "Enter Pan Card Number";
  static var panNumberEmpty = "Please Enter Pan Card Number";
  static const List<String> genderList = ['MALE', 'FEMALE'];
  static const List<String> statusList = ['PENDING', 'APPROVED', 'REJECT'];
  static const List<String> educationList = [
    'BCA',
    'B.E.',
    'BSc.It.',
    'M.Tech.',
    'MCA',
    'MSc.It.',
    'Other',
  ];
  static const List<String> bloodGroupList = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];
  static var btnSaveNext = "Save And Next";

  ///profile->Employee Info
  static const employeeCode = 'Employee Code';
  static const employeeType = 'Employee Type';
  static const department = 'Department';
  static const departmentEmpty = 'Please enter department';
  static const designation = 'Designation';
  static const designationEmpty = 'Please enter designation';
  static const joiningDate = 'Start Date';
  static const joiningDateEmpty = 'Please enter joining date';
  static const promotionPeriod = 'Promotion Period';
  static const promotionPeriodEmpty = 'Please enter promotion period';
  static const employeeEmail = 'Employee Email';
  static const basicSalary = 'Basic Salary';
  static const basicSalaryEmpty = 'Please enter basic salary';
  static const hra = 'HRA';
  static const hraEmpty = 'Please enter hra';
  static const da = 'DA';
  static const daEmpty = 'Please enter da';
  static const ta = 'TA';
  static const taEmpty = 'Please enter ta';
  static const securityDepositEmpty = 'Please enter security deposit';
  static const monthlySecurityDeposit = 'Monthly security deposit';
  static const monthlySecurityDepositEmpty =
      'Please enter monthly security deposit';
  static const bonusOne = 'Bonus one';
  static const bonusOneEmpty = 'Please enter bonus one';
  static const bonusTwo = 'Bonus two';
  static const bonusTwoEmpty = 'Please enter bonus two';
  static const minimumFullTime = 'Minimum full time';
  static const minimumFullTimeEmpty = 'Please enter minimum full time';
  static const minimumHalfTime = 'Minimum half time';
  static const minimumHalfTimeEmpty = 'Please enter minimum half time';
  static const workFullTime = 'Work full time';
  static const workFullTimeEmpty = 'Work enter minimum full time';
  static const workHalfTime = 'Work half time';
  static const workHalfTimeEmpty = 'Work enter minimum half time';
  static const allowance1 = 'Allowance 1';
  static const allowance2 = 'Allowance 2';
  static const securityDeposit = 'Security Deposit';
  static const List<String> employeeTypeList = ['Trainee', 'Employee'];
  static const List<String> departmentList = [
    'Admin',
    'HR',
    'Android',
    'Flutter',
    'iOS',
    'Laravel(Php)',
    'BDE',
  ];
  static const List<String> designationList = ['DIR', 'CEO', 'PM', 'SR', 'JR'];

  ///profile-> Other Info
  static const transportName = 'Transport Name';
  static const transportList = ['Two Wheeler', 'Four Wheeler', 'Other'];
  static const transportNumber = 'Transport Number';
  static const rcBook = 'RC Book';
  static const upload = 'Upload';
  static const transportHint = 'Select Transport Name';
  static const transportNumberHint = 'Enter transport number';
  static const transportNumberEmpty = 'Please enter transport number';
  static const transportNameEmpty = 'Please enter transport name';

  ///profile-> previous employee Info
  static const companyName = 'Company Name';
  static const profileDesignation = 'Profile Designation';
  static const salaryPerYear = 'Salary / Per Year';
  static const companyAddress = 'Company Address';
  static const companyMail = 'Company Mail';
  static const companyWebSite = 'Company Website';
  static const address = 'Address';
  static const companyContactNo = 'Company Contact No.';
  static const companyNameHint = 'Enter company name';
  static const profileDesignationHint = 'Enter profile designation';
  static const salaryPerYearHint = 'Enter salary/per year';
  static const companyAddressHint = 'Enter company address';
  static const companyWebsiteHint = 'Enter company website';
  static const addressHint = 'Enter Address';
  static const companyContactNoHint = 'Enter company contact no.';
  static const companyNameEmpty = 'Please enter company name';
  static const profileDesignationEmpty = 'Please enter profile designation';
  static const salaryEmpty = 'Please enter salary';
  static const dataInNumber = 'Please enter salary in number';
  static const companyAddressEmpty = 'Please enter company address';
  static const companyMailEmpty = 'Please enter company mail';
  static const companyWebsiteEmpty = 'Please enter company website';
  static const addressEmpty = 'Please enter address';
  static const companyContactEmpty = 'Please enter company contact no.';

  ///profile->contact info
  static const permanentAddress = "Permanent Address";
  static const city = "City";
  static const correspondAddress = "Correspondence Address";
  static const primaryPhoneNo = "Primary Phone No.";
  static const parentsContactNo = 'Parents Contact No.';
  static const alternateEmail = 'Alternate Email';
  static const saveChanges = 'Save changes';
  static const changesPassword = 'Save password';
  static const increment = 'Increment';
  static const permanentAddressHint = 'Enter permanent address';
  static const cityHint = 'Enter city';
  static const correspondAddressHint = 'Enter Correspondence Address';
  static const primaryPhoneNoHint = 'Enter primary phone no.';
  static const parentsContactNoHint = 'Enter parents contact no.';
  static const alternateEmailHint = 'Enter alternate email';
  static const cityEmpty = 'Please enter city';
  static const permanentAddressEmpty = 'Please enter permanent address';
  static const primaryPhoneNoEmpty = 'Please Enter Primary phone No.';
  static const parentPhoneNoEmpty = 'Please Enter parent contact no.';
  static const alternateEmailEmpty = 'Please Enter alternate email';

  ///profile->salary account
  static const bankName = 'Bank Name';
  static const branch = 'Branch';
  static const accountNo = 'Account No.';
  static const accountType = 'Account Type';
  static const accountTypeHint = 'Select account type';
  static const accountTypeList = ['Savings', 'Current'];
  static const ifscCode = 'IFSC Code';
  static const enterBankName = 'Please enter your bank name';
  static const enterBranch = 'Please enter your branch';
  static const enterAccountNo = 'Please enter your account number';
  static const enterAccountType = 'Please select your account type';
  static const enterIfsc = 'Please enter your IFSC code';

  ///leave screen
  static const leaveDetail = "Leave Detail";
  static const leave = "Leave";
  static const leaveType = 'Leave Type';
  static const lT = 'L. Type';

  static const reason = 'Reason';
  static const halfLeave = 'Half Leave';
  static const fullLeave = 'Full Leave';
  static const startDate = 'Start Date';
  static const selectDate = 'Select Date';
  static const endDate = 'End Date';
  static const status = 'Status';
  static const startDateEmpty = 'Please select start Date';
  static const endDateEmpty = 'Please select end Date';
  static const apply = 'Apply';
  static const applyLeave = 'Apply Leave';
  static const updateLeave = 'Update Leave';
  static const myLeave = 'My Leave';
  static const firstHalfLeave = 'First Half Leave';
  static const leaveTypeList = [halfLeave, fullLeave];
  static const halfLeaveTypeList = [firstHalfLeave, secondHalfLeave];
  static const halfLeaveHint = 'Select Half Leave';
  static const halfLeaveError = 'Please select half leave';
  static const secondHalfLeave = 'Second Half Leave';
  static const leaveTypeHint = 'Select leave type';
  static const leaveTypeEmpty = 'Please select leave type';
  static const reasonHint = 'Enter reason';
  static const reasonEmpty = 'Please enter leave reason';
  static const conformAccept = 'Are you sure to accept leave';
  static const conformReject = 'Are you sure to reject leave';
  static const conformFaultInProgress =
      'Are you sure to change fault status in progress';
  static const conformFaultSolved =
      'Are you sure to change fault status solved';
  static const accept = 'Accept';
  static const reject = 'Reject';
  static const solved = 'Solved';
  static const inProgress = 'In progress';
  static const cancel = 'Cancel';

  ///Rules screen
  static const oceanRules = "Ocean Rules";
  static const rule = "Rule";
  static const addRules = "Add Rules";
  static const updateRules = "Update Rules";
  static const ruleHint = 'Enter Rule';
  static const ruleEmpty = 'Please enter rule';

  ///Quote screen
  static const oceanQuotes = "Ocean Quote";
  static const quoteString = "Quote";
  static const addQuotes = "Add Quote";
  static const updateQuotes = "Update Quote";
  static const quoteHint = 'Enter Quote';
  static const quoteEmpty = 'Please enter quote';

  ///Time sccreen
  static const time = "Time";
  static const noDataFoundForChart = "No Data Found For current Month";
  static const noDataFound = "No Data Found";

  ///setting
  static const setting = "Settings";
  static const isMulti = "isMulti";

  ///My Task Screen
  static const myTask = "My Task";

  ///Holiday Screen
  static const holiday = "Holidays";
  static const update = "Update";
  static const delete = "Delete";
  static const certificate = "Certificate";
  static const internship = "Internship Offer Letter";
  static const markSheet = "Mark Sheet Letter";

  ///Inventory Screen
  static const inventory = "Inventory's";
  static const inventoryName = "Inventory Name";
  static const inventoryHint = "Enter inventory name";
  static const inventoryEmpty = "Please enter inventory name";
  static const amountHint = "Enter amount";
  static const amountEmpty = "Please enter amount";
  static const serialNo = "Serial no";
  static const serialHint = "Enter serial no";
  static const serialEmpty = "Please enter serial no";
  static const purchaseDate = "Purchase date";
  static const purchaseDateHint = "Select purchase date";
  static const purchaseDateEmpty = "Please enter purchase date";
  static const endWarrantyDate = "End warranty date";
  static const endWarrantyDateHint = "Select end warranty date";
  static const endWarrantyDateEmpty = "Please enter end warranty date";
  static const addInventory = "Add Inventory";
  static const updateInventory = "Update Inventory";

  ///employee reviews screen
  static const empReviews = "Employee Reviews";

  ///system faults screen
  static const systemFaults = "System Faults";
  static const myFaults = 'My Faults';
  static const employeeSystemFaults = 'Employee System Faults';
  static const applyFault = 'Apply Fault';
  static const updateFault = 'Update Fault';
  static const systemType = 'System Type';
  static const systemTypeHint = 'Enter system type';
  static const systemTypeEmpty = 'Please enter system type';

  ///my salary screen
  static const mySalary = "My Salary";
  // static const salary = "Salary";
  static const employeeSalary = 'Employee Salary';

  ///knowledge base screen
  static const knowledgeBase = "Knowledge Base";
  static const addLatestKnowledge = 'Add Latest Knowledge Base';
  static const add = 'Add';
  static const link = 'link';
  static const date = 'Date';
  static const language = 'Language';
  static const languageHint = 'Select language';
  static const languageEmpty = 'Please select language';
  static const languageList = ['Flutter', 'Android', 'ios'];
  static const linkHint = 'Enter link';
  static const linkEmpty = 'Please enter link';
  static const title = 'Title';
  static const titleHint = 'Enter title';
  static const titleEmpty = 'Please enter title';
  static const description = 'Description';
  static const descriptionHint = 'Enter Description';
  static const descriptionEmpty = 'Please enter Description';
  static const currentPassword = 'Current password';
  static const newPassword = 'New password';
  static const confirmPassword = 'Confirm password';
  static const changePassword = 'Change password';

  ///Ocean team screen
  static const oceanTeam = "Ocean Team";

  ///report list screen
  static const reportList = "Report List";
  static const reportDate = "Report Date";
  static const report = "Report Detail";
  static const number = "No.";
  static const employeeName = 'Employee Name';
  static const employeeLeave = 'Employee Leave';

  /// employee detail
  static const employeeDetails = 'Employee Details';
  static const skype = 'Skype';
  static const skypePassword = 'Skype Password';
  static const emailPassword = 'Email Password';
  static const addEmployeeDetail = 'Add Employee Details';
  static const updateEmployeeDetail = 'Update Employee Details';
  static const nameEmpty = 'Please Enter Name';
  static const nameHint = 'Enter Name';
  static const emailPasswordEmpty = 'Please Enter Email Password';
  static const emailPasswordHint = 'Enter Email Password';
  static const skypeEmpty = 'Please Enter Skype Id';
  static const skypeHint = 'Enter Skype Id';
  static const skypePasswordEmpty = 'Please Enter Skype Password';
  static const skypePasswordHint = 'Enter Skype Password';

  ///local data for timer list dialog
  static const records = "LOCAL RECORDS";
  static const empName = "NAME";
  static const empId = "ID";
  static const storeDate = "DATE";
  static const storeTime = "TIME";
  static const sessionTime = "SESSION TIME";
  static const recordNo = "NO.";
  static const timeType = "STATUS";

  ///Admin Employee Screens
  static const employee = 'Employee';
  static const employeeList = [
    'Aniket Tank',
    'Daxit Savaliya',
    'Dilip Chavada',
    'Nihar Thakkar',
    'Jaypal Dhoriya',
    'Kavita savani',
    'Jignesh sapara',
    'jay gohil',
  ];
  static const accepted = 'Accepted';
  static const rejected = 'Rejected';
  static const addEmployee = 'Add Employee';
  static const addEmployeeReview = 'Add Employee review';
  static const addReview = 'Add review';
  static const review = 'Review';
  static const employeeReview = 'Employee review';
  static const employeeStatusInfo = 'Employee status info.';
  static const updateEmployee = 'Update Employee';
  static const incrementEmployee = 'Increment Employee';
  static const email = 'Email';
  static const emailHint = 'Enter Email';
  static const emailEmpty = 'Please enter email';
  static const phone = 'Phone';
  static const phoneHint = 'Enter Phone Number';
  static const phoneEmpty = 'Please enter phone';
  static const passwordHint = 'Enter password';
  static const confirmPasswordHint = 'Enter confirm password';
  static const confirmPasswordEmpty = 'Please enter confirm password';
  static const confirmPasswordMisMatch =
      'Password and Confirm Password Mismatch';
  static const resetPassword = 'Reset Password';
  static const pastEmployee = 'Past Employee';
  static const currentEmployee = 'Current Employee';
  static const changeEmployerPast = 'Change Employee Status current to past?';
  static const changeEmployerCurrent =
      'Change Employee Status past to current?';
  static const resetPasswordAlertText =
      'Are you sure you want to reset password for your employee?';
  static const yes = 'Yes';
  static const no = 'No';

  ///Admin holiday screen
  static const addHolidays = 'Add Holiday';
  static const viewHolidays = 'View Holiday';
  static const updateHolidays = 'Update Holiday';
  static const holidayName = 'Holiday Name';
  static const holidayNameHint = 'Enter holiday name';
  static const totalDays = 'Total Days';
  static const action = 'Action';
  static const holidayNameEmpty = 'Please enter holiday name';
  static const holidayType = 'Holiday Type';
  static const List<String> holidayTypeList = [
    'Single Holiday',
    'Multiple Holiday',
  ];

  /// settings

  static const departments = 'Department';
  static const addDepartments = 'Add Department';
  static const updateDepartments = 'Update Department';
  static const departmentsName = 'Department name';
  static const designations = 'Designation';
  static const addDesignations = 'Add Designation';
  static const updateDesignations = 'Update Designation';
  static const designationsName = 'Designation name';
  static const designationHint = 'Enter designation name';
  static const shortName = 'Short Name';
  static const shortNameEmpty = 'Please enter short name';

  /// My salary screen
  static const month = 'Month';
  static const salary = 'Salary';
  static const toAccountNo = 'To Acc. No.';
  static const amount = 'Amount';
  static const employeeAccNo = 'Employee Account No.';
  static const companyAccountNo = 'Company Account No.';
  static const totalLeave = 'Total Leaves';
  static const totalHoliday = 'Total Holidays';
  static const totalWorkingDays = 'Total Working Days';
  static const authorizedSignature = 'Authorized Signature';
  static const employeeSignature = 'Employee Signature';
  static const downloadDirName = 'OBTM_PDF';
  static const download = 'Download';
  static const List<String> totalHolidayList = [
    "sunday - 19/02/2023",
    "sunday - 26/02/2023",
  ];
  static const List<String> totalLeaveList = [
    "monday - 20/02/2023",
    "friday - 10/02/2023",
  ];
  static const List<String> noteDetailList = [
    'Legends : BS - Basic Salary, HRA - House Rent Allowance, OT - Over Time, CL - Casual Leave, PL - Provisional Leave, SL - Sick Leave, LWP - Leave Without Pay, Penalty - Penalty Leave, PT - Professional Tax, Others - Internet Miss Use Fee + Late Arrival Fee + Other Penalties.',
    'This salary slip is generated in reference of employee Handbook Version.',
    'The monthly salary is consolidated salary according to package agreed.',
    'In any dispute please contact HR department within a week once you receive this salary slip.',
    'Subject to surat Jurisdiction.',
  ];

  static const view = 'View';

  ///time status array for local sorage
  static const List<String> time_status = [
    'Initial In',
    'Inter Out',
    'Inter In',
    'Final Out',
  ];

  ///Regex
  static const emailValidate =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const emailValid = "The email must be a valid email address.";

  ///employee transport
  static const transportImageBaseUrl =
      "https://timeclock.oceanbit.info/storage/";

  /// inventory
  static const directorSignature = 'Director Signature';
  static const jigneshSapara = 'Jignesh Sapara';
  static const milinPatel = 'Milin Patel';
}
