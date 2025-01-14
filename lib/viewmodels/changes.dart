import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:hackfest/models/appstate.dart';

class Changes extends StatelessWidget {
  const Changes({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return StateNotifierProvider<MyModel, Appstate>(
      create: (c) => MyModel(),
      child: child,
    );
  }
}

class MyModel extends StateNotifier<Appstate> with LocatorMixin {
  MyModel() : super(Appstate());
  Future<void> register1(
      String name, String location, String mail, String password) async {
    state = state.rebuild((p0) {
      p0.name = name;
      p0.location = location;
      p0.mail = mail;
      p0.password = password;
    });
  }

  Future<void> regPrimaryPhone(String primaryPhone) async {
    state = state.rebuild((p0) {
      p0.primaryphno = primaryPhone;
    });
  }

  Future<void> regSecondaryPhone(String secondaryPhone) async {
    state = state.rebuild((p0) {
      p0.secondaryphno = secondaryPhone;
    });
  }
}
