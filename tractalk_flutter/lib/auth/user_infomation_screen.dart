import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class UserInfomationScreen extends StatefulWidget {
  const UserInfomationScreen({super.key});

  @override
  State<UserInfomationScreen> createState() => _UserInfomationScreenState();
}

class _UserInfomationScreenState extends State<UserInfomationScreen> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('User Information')),
      body: Center(
        child: Column(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.edit, size: 15),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter your name here',

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: Colors.deepPurple),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter your name here',
                  // hintText: 'Enter your name here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: const BorderSide(color: Colors.deepPurple),
                  ),
                ),
              ),
            ),
            
            SizedBox(
              width: double.infinity,
              child: RoundedLoadingButton(
                color: Theme.of(context).primaryColor,
                
                successColor: Colors.green,
                successIcon: Icons.check,

                errorColor: Colors.red,
                

                controller: _btnController,
                onPressed: () {
                  // Perform your action here
                  // For example, navigate to the next screen or show a message
                  // _btnController.success();
                  _btnController.error();

                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pushReplacementNamed(context, '/home');
                  });
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          
          ],
        ),
      ),
    );
  }
}
