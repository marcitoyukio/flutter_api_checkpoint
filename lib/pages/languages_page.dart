import 'package:flutter/material.dart';
import 'package:github_api_demo/api/github_api.dart';
import 'package:github_api_demo/models/language.dart';

class LanguagesPage extends StatefulWidget {
  final String languagesUrl;
  final String repoName;
  const LanguagesPage({required this.languagesUrl, required this.repoName});

  @override
  State<LanguagesPage> createState() => _LanguagesPage();
}

class _LanguagesPage extends State<LanguagesPage> {
  final api = GitHubApi();
  late Future<List<Language>> _futureLanguages;

  @override
  void initState() {
    _futureLanguages = api.getLanguages(widget.languagesUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Languages"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
              child: FutureBuilder<List<Language>>(
                  future: _futureLanguages,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      var languages = snapshot.data ?? [];
                      if (languages.isEmpty) {
                        return const Center(
                            child: Text(
                                'O projeto selecionado não possui uma linguagem de programação'));
                      } else {
                        return Column(children: [
                          Text(
                            widget.repoName,
                            style: const TextStyle(fontSize: 22),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                              child: ListView.builder(
                            itemCount: languages.length,
                            itemBuilder: ((context, index) {
                              var language = languages[index];
                              return ListTile(title: Text(language.name));
                            }),
                          ))
                        ]);
                      }
                    }
                  }))
        ]),
      ),
    );
  }
}
