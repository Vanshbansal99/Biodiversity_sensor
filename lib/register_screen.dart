import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin{
   // ignore: non_constant_identifier_names
  
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

 @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  Future<void> register() async {
    String email = _emailController.text;
    String name = _nameController.text;
    String password = _passwordController.text;

    // Validate input fields
    if (email.isEmpty || name.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please  fill all Fields"),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }
    // Validate email format using email_validator package
    if (!EmailValidator.validate(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter a valid Email"),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
 // Start the animation
    _animationController.forward();
    // Example of registering user with email, name, and password
    // using http package to make API call
    try {
      final response = await http.post(
        Uri.parse(
            'https://uo1t934012.execute-api.us-east-1.amazonaws.com/addNewUser'),
        headers: {"Content-Type": "application/json"}, // Set the content type
        body: json.encode({"email": email, "name": name, "password": password}),
      );
      var parsed = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Registration successful
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(parsed),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        // Registration failed
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(parsed),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Error occurred during registration
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error occurred during registration"),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    }
  finally {
      // Reverse the animation after completion
      _animationController.reverse();
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      
      body: SafeArea(child:
      SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
    
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: SizedBox(
            width: size.width > 700 ? 460 : size.width * 0.9,
            height: size.height > 400 ? 500 : size.height * 0.65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  const  SizedBox(height: 15),
                      // child: Image(
                      //   image: AssetImage(assets/images/syngenta_logo.png) ),
                       Center( // Centering the image
                  child: Image.network(
                      'data:image/png;base64,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',
                      width: 200,
                      height: 100,
                  ),
                    ),
                // const SizedBox(height: 30),
                // const Center(
                //   child: Text(
                //     'Syngenta',
                //     style: TextStyle(
                //       fontSize: 35,
                //       color: Colors.green,
                //       fontWeight: FontWeight.w900,
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 30),
                // const Padding(
                //   padding: EdgeInsets.only(left: 20),
                
                //     child: Text(
                //     'Register',
                //     style: TextStyle(
                //       fontSize: 25,
                //       color: Colors.black,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
                
                 const SizedBox(height: 10),
                       const Center(
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 27,
                        
                            color:Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                       ),

                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                          color: Colors.white,
                        boxShadow: [
                          BoxShadow(color:Color.fromARGB(255, 92, 228, 96),
                          blurRadius: 20,
                          offset:  Offset(0,10),
                        )]),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                          color: Colors.white,
                        boxShadow: [
                          BoxShadow(color:Color.fromARGB(255, 92, 228, 96),
                          blurRadius: 20,
                          offset:  Offset(0,10),
                        )]),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                          color: Colors.white,
                        boxShadow: [
                          BoxShadow(color:Color.fromARGB(255, 92, 228, 96),
                          blurRadius: 20,
                          offset:  Offset(0,10),
                        )]),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(17),
                    ),
                  ),
                  child: InkWell(
                    onTap: register,
                    child: const Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          // Navigate to login screen
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
     ),
      
          ],
    ),
        ),
      )
      );

      
  }
}