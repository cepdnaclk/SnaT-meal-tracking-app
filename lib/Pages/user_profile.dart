import 'package:flutter/material.dart';
import 'package:mobile_app/Services/userInforManagement.dart';

import 'package:mobile_app/Pages/welcome_screen.dart';
import 'package:mobile_app/Pages/register_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map userData = {};
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    userData = await userInfor.initializeUser();
    print("ojg");
    print(user!.photoURL);
    setState(() {});
  }
  navigateToRegisterPage() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.only(left: 50, bottom: 20, right: 20),
              centerTitle: false,
              title: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    children: <Widget>[
                      // Stroked text as border.
                      Text(
                        'User Information',
                        textScaleFactor: 1,
                        style: TextStyle(
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 0.5
                            ..color = Colors.black,
                        ),
                      ),
                      // Solid text as fill.
                      const Text('User Information', textScaleFactor: 1)
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: navigateToRegisterPage,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              background: user!.photoURL != null
                  ? Image.network(
                      user!.photoURL!.replaceAll("s96-c", "s384-c"),
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/userImage.png',
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 30,
                ),
                UserInfoSection(
                  value: user!.displayName!,
                  title: "Name",
                ),
                UserInfoSection(
                  title: "Email Address",
                  value: (userData['email'] ?? '').toString(),
                ),
                UserInfoSection(
                  title: "Date of Birth",
                  value: (userData['dateOfBirth'] ?? '').toString(),
                ),
                UserInfoSection(
                  title: "Gender",
                  value: (userData['gender'] ?? '').toString(),
                ),
                UserInfoSection(
                  title: "Height",
                  value: (userData['height'] ?? '').toString() + " cm",
                ),
                UserInfoSection(
                  title: "Weight",
                  value: (userData['weight'] ?? '').toString() + " kg",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(15),
            shape: BoxShape.rectangle,
          ),
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xbf000000),
            ),
          ),
        ),
        Positioned(
            left: 35,
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              color: Colors.white,
              child: Text(
                title,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            )),
      ],
    );
  }
}
