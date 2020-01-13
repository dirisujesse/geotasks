import 'package:flutter/material.dart';
import 'package:geotasks/services/storage.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ValueNotifier<String> submitState;
  TextEditingController fName;
  TextEditingController lName;
  TextEditingController email;
  TextEditingController uName;
  TextEditingController pass;

  @override
  initState() {
    fName = TextEditingController();
    lName = TextEditingController();
    uName = TextEditingController();
    email = TextEditingController();
    pass = TextEditingController();
    submitState = ValueNotifier('idle');
    super.initState();
  }

  _defaultValidator(String val, String label) {
    if (val.isEmpty) {
      return "$label is required";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SIGNUP',
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ValueListenableBuilder(
                    valueListenable: submitState,
                    builder: (context, val, _) {
                      switch(val) {
                        case 'inprogress':
                          return Column(
                            children: <Widget>[
                              LinearProgressIndicator(),
                              SizedBox(height: 5,)
                            ],
                          );
                          break;
                        case 'failed':
                          return Column(
                            children: <Widget>[
                              Text("Signup failed"),
                              SizedBox(height: 5,)
                            ],
                          );
                          break;
                        default:
                          return SizedBox();
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Firstname"),
                    autocorrect: false,
                    validator: (val) => _defaultValidator(val, "Firstname"),
                    controller: fName,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Lastname"),
                    autocorrect: false,
                    validator: (val) => _defaultValidator(val, "Lastname"),
                    controller: lName,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (String val) {
                      if (val.isEmpty ||
                          !RegExp(r'\b[\w\d\W\D]+(?:@(?:[\w\d\W\D]+(?:\.(?:[\w\d\W\D]+))))\b')
                              .hasMatch(val)) {
                        return 'Email is invalid';
                      }
                      return null;
                    },
                    controller: email,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Username"),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (val) => _defaultValidator(val, "Username"),
                    controller: uName,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (val) => _defaultValidator(val, "Password"),
                    controller: pass,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    child: Text('SIGNUP'),
                    onPressed: () async {
                      submitState.value = 'inprogress';
                      if (formKey.currentState.validate()) {
                        submitState.value = 'idle';
                        await StorageService.setItem(key: 'isLoggedIn', val: true);
                        Navigator.of(context).pushReplacementNamed('/home');
                      } else {
                        submitState.value = 'failed';
                      }
                    }
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Text("Already registered?"),
                      FlatButton(
                        child: Text("Login"),
                        padding: EdgeInsets.only(left: 0),
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/login'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
