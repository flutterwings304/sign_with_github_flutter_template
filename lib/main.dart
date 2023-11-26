import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  dotenv.load(fileName: "lib/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSignSuccess = false; //To check user is signed up or not

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("SignIn with Github Template"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have signed in or not',
            ),
            //Here I have shown tthe bool variable
            Text(
              '$isSignSuccess',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      //This button is for signing up with github account
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final GitHubSignIn gitHubSignIn = GitHubSignIn(
            clientId: dotenv.env["CLIENT_ID"] ?? "",
            clientSecret: dotenv.env["CLIENT_SECRET"] ?? "",
            redirectUrl: dotenv.env["REDIRECT_URL"] ?? "",
            title: 'GitHub Connection',
            centerTitle: false,
          );
          //From this we will be redirect to login page of github to get the token
          var result = await gitHubSignIn.signIn(context);
          //To get status whether user is logged in or not
          switch (result.status) {
            //If it is success it will come here
            case GitHubSignInResultStatus.ok:
              print(result.token);
              isSignSuccess = true;
              setState(() {});
              break;

            case GitHubSignInResultStatus.cancelled:
            //If it is cancelled by user it will come here
            case GitHubSignInResultStatus.failed:
              //If it is failed due to any reason it will come here
              print(result.errorMessage);
              break;
          }
        },
        tooltip: 'Sign with Github',
        label: const Text("Sign with Github"),
      ),
    );
  }
}
