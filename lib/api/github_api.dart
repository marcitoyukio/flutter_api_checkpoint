import 'dart:convert';
import 'package:github_api_demo/models/branche.dart';
import 'package:github_api_demo/models/language.dart';
import 'package:github_api_demo/models/repository.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class GitHubApi {
  final String baseUrl = 'https://api.github.com/';
  final String token = '';

  Future<User?> findUser(String userName) async {
    final url = '${baseUrl}users/$userName';
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var user = User.fromJson(json);

      return user;
    } else {
      return null;
    }
  }

  Future<List<User>> getFollowing(String userName) async {
    final url = '${baseUrl}users/$userName/following';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      var users = jsonList.map<User>((json) => User.fromJson(json)).toList();

      return users ?? [];
    } else {
      return [];
    }
  }

  Future<List<Repository>> getRepos(String userName) async {
    final url = '${baseUrl}users/$userName/repos';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);

      var repos = jsonList
          .map<Repository>((json) => Repository.fromJson(json))
          .toList();

      return repos ?? [];
    } else {
      return [];
    }
  }

  Future<List<Branche>> getBranches(String branchesUrl) async {
    final url = branchesUrl.substring(0, branchesUrl.length - 9);
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);

      var branches =
          jsonList.map<Branche>((json) => Branche.fromJson(json)).toList();

      return branches ?? [];
    } else {
      return [];
    }
  }

  Future<List<Language>> getLanguages(String languagesUrl) async {
    var response = await http.get(Uri.parse(languagesUrl));

    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

      var languages =
          jsonMap.keys.map<Language>((key) => Language(key)).toList();

      return languages;
    } else {
      return [];
    }
  }
}
