import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Kelurahan extends StatelessWidget {
  final Map<String, dynamic> province;

  Kelurahan(this.province);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            province["name"],
          ),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: KelurahanBody(province["id"]));
  }
}

class KelurahanBody extends StatelessWidget {
  final String kelurahanId;

  KelurahanBody(this.kelurahanId);
  @override
  Widget build(BuildContext context) {
    final apiUrl = Uri.parse(
        "https://api.goapi.io/regional/kelurahan?kecamatan_id=${kelurahanId}&api_key=5c9f85c2-8c84-5191-8a76-33ec1d6b");

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
              final item = snapshot.data![index];
              final kelurahan = snapshot.data![index];

              return ListTile(
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => Kota(kelurahan),
                //     ),
                //   );
                // },
                title: Text(item["name"]),
              );
            },
          );
        }
      },
    );
  }
}
