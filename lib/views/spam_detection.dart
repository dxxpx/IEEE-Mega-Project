import 'package:cloud_firestore/cloud_firestore.dart';

// Function to check if distress limit has been exceeded
Future<bool> hasExceededDistressLimit(
    String userId, String distressType) async {
  final now = DateTime.now();
  final timeRange = Duration(minutes: 2); // Define the time range (2 minutes)

  final firestore = FirebaseFirestore.instance;

  try {
    // Query the 'distress' collection
    final querySnapshot = await firestore
        .collection('distress')
        .where('userId', isEqualTo: userId) // Filter by userID
        .where('type', isEqualTo: distressType) // Filter by distressType
        .where('time',
            isGreaterThan: Timestamp.fromDate(
                now.subtract(timeRange))) // Filter by timestamp
        .orderBy('time') // Order by timestamp
        .get();

    // Convert timestamps to DateTime for easier processing
    final requests = querySnapshot.docs
        .map((doc) => (doc.data()['time'] as Timestamp).toDate())
        .toList();

    // Check if the number of requests exceeds the threshold in any 2-minute window
    const int threshold = 5; // Adjust threshold as needed
    return _hasMoreThanThresholdInTimeWindow(requests, threshold, timeRange);
  } catch (e) {
    // Handle errors (e.g., network issues, Firestore exceptions)
    print('Error checking recent distress requests: $e');
    return false; // Return false or handle it according to your application's needs
  }
}

// Helper function to check if more than the threshold has been exceeded in the given time window
bool _hasMoreThanThresholdInTimeWindow(
    List<DateTime> requests, int threshold, Duration window) {
  for (int i = 0; i <= requests.length - threshold; i++) {
    final startTime = requests[i];
    final endTime = startTime.add(window);
    final count = requests
        .where((request) =>
            request.isAfter(startTime) && request.isBefore(endTime))
        .length;
    if (count >= threshold) {
      return true;
    }
  }
  return false;
}
