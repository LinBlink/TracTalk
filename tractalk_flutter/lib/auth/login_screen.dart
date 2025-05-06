import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tractalk_flutter/providers/authentication_provider.dart';
import 'package:tractalk_flutter/utils/assets_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_picker/country_picker.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Country _selectedCountry = Country(
    phoneCode: '86',
    countryCode: 'CN',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'China',
    example: 'China',
    displayName: 'China',
    displayNameNoCountryCode: 'CN',
    e164Key: '',
  );

  final TextEditingController _phoneNumberController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  void dispose() {
    // TODO: implement dispose
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              SizedBox(
                height: 150,
                width: 150,
                child: Lottie.asset(AssetsManager.chatBubble),
              ),
              Text(
                'Welcome to TracTalk',
                style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Add your phone number to get started",
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),

              Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),

              TextFormField(
                onChanged: (value) {
                  setState(() {});
                },

                controller: _phoneNumberController,

                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',

                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(Icons.phone),
                          InkWell(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                countryListTheme: CountryListThemeData(
                                  bottomSheetHeight:
                                      500, // Set this to your desired height
                                  inputDecoration: InputDecoration(
                                    labelText: 'Search',
                                    hintText: 'Search',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                                onSelect: (Country country) {
                                  setState(() {
                                    _selectedCountry = country;
                                  });
                                },
                              );
                            },
                            child: Text(
                              '${_selectedCountry.flagEmoji} +${_selectedCountry.phoneCode}',
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  suffixIcon:
                      _phoneNumberController.text.length > 9
                          ? authProvider.isLoading
                              ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              )
                              : MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: InkWell(
                                  onTap: () {
                                    // sign in with phone number
                                    authProvider.signInWithPhoneNumber(
                                      '+${_selectedCountry.phoneCode}${_phoneNumberController.text}',
                                      context,
                                    );
                                    
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 20.0),
                                    child: const Icon(
                                      Icons.arrow_circle_right,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              )
                          : null,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),

                keyboardType: TextInputType.phone,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },

                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
