import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class TempLogin extends StatefulWidget {
  const TempLogin({Key? key}) : super(key: key);

  @override
  State<TempLogin> createState() => _TempLoginState();
}

class _TempLoginState extends State<TempLogin> {
  TextEditingController mobile = TextEditingController();
  String otpPin = " ";
  String countryDial = "+91";
  TextEditingController phoneController = TextEditingController();
  bool  otpPage = false;
  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;
  final scaffoldKey = GlobalKey();
  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;

  Color blue = const Color(0xff8cccff);


  @override
  void initState() {
    super.initState();
    _otpInteractor = OTPInteractor();
    _otpInteractor
        .getAppSignature()
    //ignore: avoid_print
        .then((value) => print('signature - $value'));

    controller = OTPTextEditController(
      codeLength: 5,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
          (code) {
        final exp = RegExp(r'(\d{5})');
        return exp.stringMatch(code ?? '') ?? '';
      },
      strategies: [
        // SampleStrategy(),
      ],
    );
  }
  @override
  Future<void> dispose() async {
    await controller.stopListen();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xff121421),
      appBar: AppBar(
        title: Text("Temp Login"),
      ),
      body:otpPage?Center(child: stateOTP()): Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24,),
          Text(
            "Phone number",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        IntlPhoneField(
      controller: phoneController,
      showCountryFlag: false,
      showDropdownIcon: false,
      initialValue: countryDial,
      onCountryChanged: (country) {
        setState(() {
          countryDial = "+" + country.dialCode;
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
      ),
        ),
          _buildTempBtn()
        ],
      ),
    );
  }
  Widget _buildTempBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: MaterialButton(
        elevation: 5.0,
        onPressed: () {
           setState(() {
             otpPage = true;
           });
        },
        child: const Text(
          'Send OTP',
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


  Widget stateOTP() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 45,),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "We just sent a code to ",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: countryDial + phoneController.text,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: "\nEnter the code here and we can continue!",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          PinCodeTextField(
controller: controller,
          ),
          const SizedBox(height: 20,),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Didn't receive the code? ",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // screenState = 0;
                      });
                    },
                    child: Text(
                      "Resend",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget circle(double size) {
    return Container(
      height: screenHeight / size,
      width: screenHeight / size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }
}

