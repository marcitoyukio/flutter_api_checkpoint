import 'package:flutter/material.dart';
import 'package:github_api_demo/api/github_api.dart';
import 'package:github_api_demo/models/branche.dart';

class BranchesPage extends StatefulWidget {
  final String branchesUrl;
  final String repoName;
  const BranchesPage({required this.branchesUrl, required this.repoName});

  @override
  State<BranchesPage> createState() => _BranchesPage();
}

class _BranchesPage extends State<BranchesPage> {
  final api = GitHubApi();
  late Future<List<Branche>> _futureBranches;

  @override
  void initState() {
    _futureBranches = api.getBranches(widget.branchesUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Branches"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
              child: FutureBuilder<List<Branche>>(
            future: _futureBranches,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                var branches = snapshot.data ?? [];
                return Column(
                  children: [
                    Text(
                      widget.repoName,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                        child: ListView.builder(
                      itemCount: branches.length,
                      itemBuilder: ((context, index) {
                        var branche = branches[index];
                        return ListTile(title: Text(branche.name));
                      }),
                    ))
                  ],
                );
              }
            },
          ))
        ]),
      ),
    );
  }
}
