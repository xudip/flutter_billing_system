import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:billing_system/authentication_bloc/authentication_bloc.dart';
import 'package:billing_system/user_repository.dart';
import 'package:billing_system/home_screen.dart';
import 'package:billing_system/login/login.dart';
import 'package:billing_system/splash_screen.dart';
import 'package:billing_system/simple_bloc_delegate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      builder: (context) => AuthenticationBloc(
        userRepository: userRepository,
      ),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return HomeScreen(name: state.displayName);
          } else {
            return LoginScreen(userRepository: _userRepository);
          }
        },
      ),
    );
  }
}
