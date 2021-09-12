import 'package:count_down_timer/generated/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constant.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    _login();
  }

  Future<void> _login() async {
    final isLoginIn = await _isLoginIn();
    if (isLoginIn) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    _facebookLogin(onSuccess: () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  Future<bool> _isLoginIn() async =>
      (await FacebookAuth.instance.accessToken) != null;

  Future<void> _facebookLogin({VoidCallback? onSuccess}) async {
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile
    // or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged

      onSuccess?.call();
    } else {
      Fluttertoast.showToast(
        msg: txtLoginFail,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.imagesLogo),
              const SizedBox(
                height: 50,
              ),
              !isLoading
                  ? ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        primary: kButtonColor,
                        onPrimary: kButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(
                          width: 1.0,
                          color: kBorderColor,
                        ),
                        fixedSize: const Size(200, 48),
                      ),
                      child: const Text(
                        txtLogin,
                        style: textStyle,
                      ),
                    )
                  : const SizedBox(
                      width: 64,
                      height: 36,
                      child: CupertinoActivityIndicator(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
