import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/constant/utils/utils.dart';
import 'package:whatsapp/constant/widgets/custom_button.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneContoller = TextEditingController();
  Country? country;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneContoller.dispose();
  }

  void countryPicker() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void sendPhoneNumber() {
    // https://www.youtube.com/watch?v=2Y5tITAttog
    // Watch it to perform OTP
    String phoneNumber = phoneContoller.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else {
      showSnackBar(context: context, text: 'Fill out all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your Phone Number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                        'Chatterly will need to verify your phone number.'),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: countryPicker,
                      child: Text('Pick country'),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        if (country != null) Text('+${country!.phoneCode}'),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: size.width * 0.75,
                          child: TextField(
                            controller: phoneContoller,
                            decoration:
                                InputDecoration(hintText: 'phone number'),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 90,
                child: CustomButton(
                  text: 'NEXT',
                  onPressed: sendPhoneNumber,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
