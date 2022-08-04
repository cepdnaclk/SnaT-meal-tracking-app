import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/Pages/camera/CameraPage.dart';

// void main() {
//   testWidgets('userInforManagement ...', (tester) async {
//     // TODO: Implement test
//   });
// }

const MessagesCollection = 'messages';

void main() {
  testWidgets('shows messages', (WidgetTester tester) async {
    // Populate the fake database.
    final firestore = FakeFirebaseFirestore();
    await firestore.collection(MessagesCollection).add({
      'message': 'Hello world!',
      'created_at': FieldValue.serverTimestamp(),
    });

    // Render the widget.
    await tester.pumpWidget(const MaterialApp(
        title: 'Firestore Example', home: campage( title: '',)));
    // Let the snapshots stream fire a snapshot.
    await tester.idle();
    // Re-render.
    await tester.pump();
    // // Verify the output.
    expect(find.text('Pick_from_Gallery'), findsOneWidget);
    expect(find.text('Pick_from_Camera'), findsOneWidget);
  });

  testWidgets('adds messages', (WidgetTester tester) async {
    // Instantiate the mock database.
    final firestore = FakeFirebaseFirestore();

    // Render the widget.
    await tester.pumpWidget(const MaterialApp(
        title: 'Firestore Example', home: campage( title: '',)));
    // Verify that there is no data.
    expect(find.text('Please wait'), findsNothing);

    // Tap the Add button.
    await tester.tap(find.byType(FloatingActionButton));
    // Let the snapshots stream fire a snapshot.
    await tester.idle();
    // Re-render.
    await tester.pump();

    // Verify the output.
    expect(find.text('Please wait'), findsOneWidget);
  });
}