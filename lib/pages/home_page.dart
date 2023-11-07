import 'package:flutter/material.dart';
import 'package:github_api_demo/api/github_api.dart';
import 'package:github_api_demo/pages/repo_page.dart';
import 'following_page.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final api = GitHubApi();
  final TextEditingController _controller = TextEditingController();
  bool isLoadingFollowing = false;
  bool isLoadingRepo = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const SizedBox(
                height: 100,
              ),
              const SizedBox(
                width: 150,
                height: 150,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('images/github-icon.jpg'),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Github",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 150,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(.1)),
                child: TextField(
                  onChanged: (value) {
                    if (errorMessage != null) {
                      setState(() {
                        errorMessage = null;
                      });
                    }
                  },
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    errorText: errorMessage,
                    border: InputBorder.none,
                    hintText: "Github username",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                padding: const EdgeInsets.all(20),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Align(
                  child: isLoadingFollowing
                      ? const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text(
                          'Get Your Following Now',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                onPressed: () {
                  _getUser(0);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                padding: const EdgeInsets.all(20),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Align(
                  child: isLoadingRepo
                      ? const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text(
                          'Get Your Repos Now',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                onPressed: () {
                  _getUser(1);
                },
              )
            ]),
          ),
        ),
      ),
    );
  }

  _getUser(int button) {
    if (_controller.text.isEmpty) {
      setState(() {
        errorMessage = "Informe o nome de usuário";
      });
    } else {
      setState(() {
        if (button == 0) {
          isLoadingFollowing = true;
        } else {
          isLoadingRepo = true;
        }
      });
      api.findUser(_controller.text).then((user) {
        setState(() {
          isLoadingFollowing = false;
          isLoadingRepo = false;
        });

        if (user != null) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              if (button == 0) {
                return FollowingPage(user: user);
              } else {
                return RepoPage(user: user);
              }
            },
          ));
        } else {
          setState(() {
            errorMessage = "Usuário não encontrado";
          });
        }
      });
    }
  }
}
