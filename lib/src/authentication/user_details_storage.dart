import 'dart:async';

import 'package:oportunidades_cce/src/authentication/user_details.dart';

const kUserDetailsKey = 'user_details';

abstract class UserDetailsStorage extends Stream<UserDetails> {
  final StreamController<UserDetails> controller =
      StreamController<UserDetails>();

  FutureOr<bool> hasUserDetails() async {
    final userDetails = await getUserDetails();
    return userDetails.isValid;
  }

  FutureOr<UserDetails> getUserDetails();

  FutureOr<void> saveUserDetails(UserDetails userDetails);

  FutureOr<void> deleteUserDetails();

  @override
  StreamSubscription<UserDetails> listen(
      void Function(UserDetails event)? onData,
      {Function? onError,
      void Function()? onDone,
      bool? cancelOnError}) {
    return controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Future<dynamic> close() => controller.close();
}
