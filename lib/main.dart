import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'kota.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Provinsi'), backgroundColor: Colors.green),
        body: MyHomePageBody());
  }
}

class MyHomePageBody extends StatelessWidget {
  const MyHomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final apiUrl = Uri.parse(
        "https://api.goapi.io/regional/provinsi?api_key=5c9f85c2-8c84-5191-8a76-33ec1d6b");

    Future<List<dynamic>> fetchData() async {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["data"];
      } else {
        throw Exception('Failed to load data');
      }
    }

    return FutureBuilder(
      future: fetchData(),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final province = snapshot.data![index];

              final item = snapshot.data![index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Kota(province),
                    ),
                  );
                },
                title: Text(item["name"]),
              );
            },
          );
        }
      },
    );
  }
}
