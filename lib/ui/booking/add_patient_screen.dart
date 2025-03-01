part of 'package:heaven_canceller_hospital/ui/ui.dart';

class AddPatientScreen extends StatefulWidget {
  static String routeName = '/add_patient_screen';

  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  String selectedGender;
  String selectedStatus;
  bool isSubmit = false;

  @override
  Widget build(BuildContext context) {
    final Box<Patient> patientBox = Hive.box('patients');
    final Patient patient = patientBox.getAt(0);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, ChangePatientScreen.routeName);
        return;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: accentColor,
            ),
            SafeArea(
              child: Stack(
                children: [
                  Container(
                    color: baseColor,
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultMargin,
                        vertical: 24,
                      ),
                      child: Consumer<ValidationProvider>(
                        builder: (context, validation, _) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// SECTION: TITLE BACK BUTTON
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    child: Consumer<ValidationProvider>(
                                      builder: (context, validation, _) => Icon(
                                        Icons.arrow_back,
                                        color: darkGreyColor,
                                        size: 28,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pushReplacementNamed(context, ChangePatientScreen.routeName);
                                      validation.resetChange();
                                    },
                                  ),
                                ),
                                Align(  
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Tambah Pasien",
                                    style: semiBoldBaseFont.copyWith(
                                      fontSize: 18,
                                      color: darkGreyColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 24,
                            ),

                            /// SECTION: INPUT FIELD FORM
                            CustomTextField(
                              controller: nameController,
                              labelText: "Nama Pasien",
                              hintText: "Masukan Nama Pasien",
                              errorValidation: validation.errorName,
                              onChanged: (value) {
                                validation.changeName(value);
                              },
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Jenis Kelamin",
                                  style: mediumBaseFont.copyWith(
                                    fontSize: 12,
                                    color: darkGreyColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomRadioButton(
                                      value: "Pria",
                                      groupValue: selectedGender,
                                      onChange: (value) {
                                        setState(() {
                                          selectedGender = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 32,
                                    ),
                                    CustomRadioButton(
                                      value: "Wanita",
                                      groupValue: selectedGender,
                                      onChange: (value) {
                                        setState(() {
                                          selectedGender = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            CustomDropdownField(
                              labelName: "Status",
                              hintText: "Pilih Salah Satu",
                              options: status,
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: 220,
                            ),

                            /// SECTION: BUTTON REGISTER DATA
                            if (!isSubmit) AccentRaisedButton(
                              color: accentColor,
                              width: defaultWidth(context),
                              text: "Daftar",
                              height: 44,
                              fontSize: 14,
                              borderRadius: 8,
                              onPressed: (validation.errorName == "" && selectedGender != null && selectedStatus != null) ? () {
                                setState(() {
                                  isSubmit = true;
                                });
                                onSubmitPressed(
                                  context,
                                  validation, 
                                  patient: Patient(
                                    id: patient.id,
                                    name: nameController.text,
                                    gender: selectedGender,
                                    status: selectedStatus,
                                  ),
                                );
                              } : null,
                            ) else SpinKitRing(
                              color: accentColor,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Method ketika tombol "daftar" ditekan
  void onSubmitPressed(BuildContext context, ValidationProvider validation, {Patient patient}) {
    Patient.register(patient);
    PatientService.storeResource(patient);

    Navigator.pushReplacementNamed(context, ChangePatientScreen.routeName);
    validation.resetChange();
  }
}