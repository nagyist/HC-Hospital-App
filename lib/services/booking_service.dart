part of 'services.dart';

///* Class Service Booking
/// Class untuk menghandle resource booking dokter

class BookingService {
  static CollectionReference _bookingCollection = FirebaseFirestore.instance.collection('bookings');
  
  /// Melakukan simpan data collection booking dokter
  static Future<void> storeResource(Booking booking) async {
    await _bookingCollection.doc().set({
      'id': booking.id,
      'user_id': booking.userID,
      'schedule': booking.schedule,
      'message': booking.message,
      'time': booking.time,
      'doctor': booking.doctor.toJson(),
      'patient': booking.patient.toJson(),
    });
  }

  /// Melakukan fetch semua data booking dokter
  static Future<List<Booking>> getResource() async {
    QuerySnapshot snapshot = await _bookingCollection.get();

    final Box<Patient> patientBox = Hive.box('patients');

    if (patientBox.isNotEmpty) {
      final Patient patient = patientBox.getAt(0);
      var documents = snapshot.docs.where((document) => document.data()['user_id'] == patient.id);

      List<Booking> bookings = [];

      for (var document in documents) {
        bookings.add(
          Booking(
            id: document.data()['id'],
            userID: document.data()['user_id'],
            schedule: document.data()['schedule'],
            message: document.data()['message'],
            time: document.data()['time'],
            doctor: Doctor.fromJson(document.data()['doctor']),
            patient: Patient.fromJson(document.data()['patient']),
          ),
        );
      }

      return bookings;
    }

    return [];
  }
}