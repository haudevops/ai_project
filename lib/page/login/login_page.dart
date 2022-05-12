import 'package:ai_project/page/home/home_page.dart';
import 'package:ai_project/routes/screen_argument.dart';
import 'package:ai_project/utils/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userNameController = TextEditingController();
  final _userPasswordController = TextEditingController();

  final _userNameKey = GlobalKey<FormState>();
  final _userPasswordKey = GlobalKey<FormState>();

  final _userNameFocus = FocusNode();
  final _userPasswordFocus = FocusNode();

  final _auth = LocalAuthentication();
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  _SupportState _supportState = _SupportState.unknown;


  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await _auth.authenticate(
          localizedReason: 'Scan your face',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    setState(
            () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  @override
  void initState() {
    super.initState();
    _auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
          ? _SupportState.supported
          : _SupportState.unsupported),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _bodyWidget(),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chào mừng đến với SUPRA',
          style: TextStyle(
              fontSize: ScreenUtil.getInstance().getAdapterSize(20),
              fontWeight: FontWeight.w600),
        ),
        SizedBox(height: ScreenUtil.getInstance().getAdapterSize(20)),
        Form(
          key: _userNameKey,
          child: TextFormField(
            focusNode: _userNameFocus,
            autofocus: true,
            controller: _userNameController,
            decoration: InputDecoration(
              labelText: 'Nhập tài khoản',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 2, color: Colors.pinkAccent),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onFieldSubmitted: (value) {
              if (_userNameKey.currentState!.validate()) {
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(_userPasswordFocus);
              } else {
                FocusScope.of(context).requestFocus(_userNameFocus);
              }
            },
            validator: (value) {
              if (value!.isEmpty ||
                  RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                return 'Nhập tài khoản';
              } else {
                return null;
              }
            },
          ),
        ),
        SizedBox(height: ScreenUtil.getInstance().getAdapterSize(20)),
        Form(
          key: _userPasswordKey,
          child: TextFormField(
            focusNode: _userPasswordFocus,
            autofocus: false,
            controller: _userPasswordController,
            decoration: InputDecoration(
              labelText: 'Nhập mật khẩu',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 2, color: Colors.pinkAccent),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty ||
                  RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                return 'Sai mật kh';
              } else {
                return null;
              }
            },
          ),
        ),
        SizedBox(height: ScreenUtil.getInstance().getAdapterSize(20)),
        Center(
          child: Container(
            width: ScreenUtil.getInstance().getAdapterSize(200),
            child: ElevatedButton(
                onPressed: () {
                  if (_userNameKey.currentState!.validate() &&
                      _userPasswordKey.currentState!.validate()) {
                    Navigator.pushNamed(context, HomePage.routeName,
                            arguments: ScreenArguments(
                                arg1: _userNameController.text,
                                arg2: _userPasswordController.text))
                        .then((value) {
                      _userPasswordController.clear();
                      FocusScope.of(context).requestFocus(_userPasswordFocus);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 1,
                ),
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: ScreenUtil.getInstance().getAdapterSize(16),
                  ),
                )),
          ),
        ),
        SizedBox(height: ScreenUtil.getInstance().getAdapterSize(20)),
        Center(
            child: IconButton(
                onPressed: () {
                  print('OK');
                  _authenticate();
                },
                icon: Icon(
                  Icons.fingerprint,
                  size: ScreenUtil.getInstance().getAdapterSize(35),
                ))),
      ],
    );
  }
}
