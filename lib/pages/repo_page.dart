import 'package:flutter/material.dart';
import 'package:github_api_demo/api/github_api.dart';
import 'package:github_api_demo/models/repository.dart';
import 'package:github_api_demo/pages/branches_page.dart';
import 'package:github_api_demo/pages/languages_page.dart';
import '../models/user.dart';

class RepoPage extends StatefulWidget {
  final User user;
  const RepoPage({required this.user});

  @override
  State<RepoPage> createState() => _RepoPage();
}

class _RepoPage extends State<RepoPage> {
  final api = GitHubApi();
  late Future<List<Repository>> _futureRepos;

  @override
  void initState() {
    _futureRepos = api.getRepos(widget.user.login);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Repositories"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(widget.user.avatarUrl),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.user.login,
                  style: TextStyle(fontSize: 22),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: FutureBuilder<List<Repository>>(
            future: _futureRepos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                var repos = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: repos.length,
                  itemBuilder: ((context, index) {
                    var repo = repos[index];
                    return ListTile(
                      title: Text(repo.name),
                      subtitle: Text(
                        repo.description,
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              color: Colors.blue,
                              icon: const Icon(Icons.call_split_rounded),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return BranchesPage(
                                        branchesUrl: repo.branchesUrl, repoName: repo.name);
                                  },
                                ));
                              },
                            ),
                            IconButton(
                              color: Colors.blue,
                              icon: const Icon(Icons.code),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return LanguagesPage(
                                        languagesUrl: repo.languagesUrl, repoName: repo.name);
                                  },
                                ));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }
            },
          ))
        ]),
      ),
    );
  }
}
