import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:genorion_mac_android/main.dart';
import 'package:http/http.dart' as http;

import 'loginscreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignupData data = SignupData();
  bool isVisible = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
   bool isHiddenPassword = true;
  bool onChangedHint = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121421),
      body: isVisible
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              ),
            )
          : SafeArea(
              child: Form(
                key: formKey,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 28,
                        right: 18,
                        top: 36,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              )),
                          Row(
                            children: const [
                              Text("",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(360),
                            onTap: () {},
                            child: const SizedBox(
                              height: 35,
                              width: 35,
                              child: Center(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              // color: Color(0xFF6CA8F1),
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            height: 60.0,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onSaved: (value) {
                                // ignore: unused_local_variable
                                var fName = value!;
                                if (value.contains(" ")) {
                                  int v = value.indexOf(" ");
                                  var ans = value.substring(v);
                                  var first = value.substring(0, v);
                                  if (kDebugMode) {
                                    print("vale $ans");
                                  }
                                  setState(() {
                                    data.lName = ans;
                                    data.fName = first;
                                  });
                                } else {
                                  setState(() {
                                    data.fName = value;
                                    data.lName = " .";
                                  });
                                  if (kDebugMode) {
                                    print("else ${data.lName}");
                                  }
                                }
                              },
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter full name';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                hintText: 'Full Name',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              // color: Color(0xFF6CA8F1),
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            height: 60.0,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  data.email = value!;
                                });
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                hintText: 'Email ',
                                // hintStyle: kHintTextStyle,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              // color: Color(0xFF6CA8F1),
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            height: 60.0,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onSaved: (value) {
                                setState(() {
                                  data.pno = value!;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter mobile';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                ),
                                hintText: 'Phone Number ',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              // color: Color(0xFF6CA8F1),
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            height: 60.0,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                } else {
                                  setState(() {
                                    data.password = value;
                                  });
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  data.password = value!;
                                });
                              },
                              enableSuggestions: false,
                              obscureText: isHiddenPassword,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    onChangedHint = true;
                                  });
                                }
                              },
                              decoration:  InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                prefixIcon: Icon(
                                  Icons.security,
                                  color: Colors.white,
                                ),
                                suffixIcon: InkWell(
                                    onTap: togglePassword,
                                    child: Icon(isHiddenPassword == true
                                        ? Icons.visibility
                                        : Icons.visibility_off)),
                                hintText: 'Enter password',
                              ),
                            ),
                          ),
                          onChangedHint
                              ? passwordHint()
                              : const SizedBox(
                                  height: 10,
                                ),
                          Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              // color: Color(0xFF6CA8F1),
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            height: 60.0,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value != data.password) {
                                  if (kDebugMode) {
                                    print(
                                        "object $value ->  ${data.password} ");
                                  }
                                  return "Password not match";
                                }
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }
                                setState(() {
                                  data.password2 = value;
                                });
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  data.password2 = value!;
                                });
                              },
                              obscureText: isHiddenPassword,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                              ),
                              decoration:  InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                prefixIcon: Icon(
                                  Icons.security,
                                  color: Colors.white,
                                ),
                                suffixIcon: InkWell(
                                    onTap: togglePassword,
                                    child: Icon(isHiddenPassword == true
                                        ? Icons.visibility
                                        : Icons.visibility_off)),
                                hintText: 'confirm password',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          _buildSignUpBtn(),
                          _buildLoginBtn()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
 
  }

  goToNextPage() {
    setState(() {
      isVisible = true;
    });
    formKey.currentState!.save();
    checkDetails(data);
  }



  checkDetails(SignupData data) async {
    const url = api + 'regflu';
    var map = <String, dynamic>{};
    map['username'] = data.email;
    map['password1'] = data.password;
    map['password2'] = data.password;
    map['first_name'] = data.fName;
    map['last_name'] = data.lName;
    map['email'] = data.email;
    map['phone_no'] = data.pno;
    final response = await http.post(
      Uri.parse(url),
      body: map,
      encoding: Encoding.getByName("utf-8"),
    );
    if (kDebugMode) {
      print(map);
    }
    if (response.statusCode == 200) {
      print(response.body);
      const snackBar = SnackBar(
        content: Text('Please Login'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      if (response.statusCode == 400) {
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>WrongPassword()));
        throw ("Details Error");
      }
      if (response.statusCode == 500) {
        if (kDebugMode) {
          print(response.statusCode);
          // print(response.body);
        }
        // print(response.body);
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>WrongPassword()));
        throw ("Internal Server Error");
      }else{
        print(response.statusCode);
      }
      print(response.statusCode);
    }
  }

  void togglePassword() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  passwordHint() {
    return Row(
      children: const [
        Text(
          "Please use",
          style: TextStyle(color: Colors.red, fontSize: 10),
        ),
        Text(
          " special character , one capital alphabet,and numbers",
          style: TextStyle(color: Colors.red, fontSize: 10),
        )
      ],
    );
  }

  Widget _buildSignUpBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      // ignore: deprecated_member_use
      child: ElevatedButton(
        // elevation: 5.0,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            goToNextPage();
          } else {
            if (kDebugMode) {
              print("object");
            }
          }
        },
        // padding: const EdgeInsets.all(15.0),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30.0),
        // ),
        // color: Colors.white,
        child: const Text(
          'SignUp',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Already have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  passwordStrength(value) {
    Pattern pattern = r"^[A-Z a-z]";
    Pattern pattern1 = r"^[0-9]";
    Pattern pattern2 =
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})";
    RegExp regExp = RegExp(pattern.toString());
    RegExp regExp1 = RegExp(pattern1.toString());
    RegExp regExp2 = RegExp(pattern2.toString());
    if (regExp2.hasMatch(value)) {
      return "Strong Password";
    } else if (regExp.hasMatch(value)) {
      return 'Password is weak only alphabets';
    } else if (regExp1.hasMatch(value)) {
      return 'Password is weak only numericals';
    }
  }

  String validatePass(value) {
    if (value.isEmpty) {
      return "Required";
    } else if (value.length < 8) {
      return "should be atleast 8 Character";
    } else if (value.length > 15) {
      return "should not be more than 15 character";
    } else {
      var strength = passwordStrength(value);
      if (strength == "Strong Password") {
        return " ";
      } else {
        return strength;
      }
    }
  }

  String? validateMobile(value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(patttern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    } else if (value.length != 10) {
      return "Please Enter the 10 Digit Mobile Number";
    }
    return null;
  }

  String? validName(value) {
    if (value.isEmpty) {
      return "Required";
    }
    return null;
  }

  String? validateEmail(value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern.toString());
    if (value.isEmpty) {
      return "Required";
    }
    if (!regex.hasMatch(value) || value == null) {
      return 'Enter a valid email address';
    }

    return null;
  }
}

class SignupData {
  String email = '';
  String password = '';
  String password2 = '';
  String fName = '';
  String lName = '';
  String pno = '';
  String username = '';

  checkPassword() {
    if (password.length != password2.length) {
      throw ("Password Doesn't match");
    } else {
      return null;
    }
  }
}
