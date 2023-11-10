import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// website --> Album JSON --> Dart class -->present the info flutter

// Dart class <--> JSON
// class Album : UserId,id,title
// fromJson --> Dart Object

class Album {
  final int userId;
  final int id;
  final String title;


const Album ({
  required this.userId,
  required this.id,
  required this.title,
});
//Factory Keyword?
//var myAlbum = Album(1,2,'this is my album')
//method --> create an instance of object
factory Album.fromJson(Map<String,dynamic> json){
  return Album(userId: json['userId'],id: json['id'],title: json['title']);
}

}

// function async Future Album(grab from the website)
//Grab album 1
Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/2'));

if(response.statusCode==200){
  return Album.fromJson(jsonDecode(response.body));
} else{
  throw Exception('Failure to load album!');
}

}

//flutter app --> text(widget)

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key?key}):super(key: key);

  @override
   State<MyApp> createState() => _myAppState();
}

class _myAppState extends State<MyApp> {
  late Future<Album> futureAlbum;
  
  @override
  void initState(){
    super.initState();
    futureAlbum = fetchAlbum();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'demo',
      theme: ThemeData(primarySwatch: Colors.red),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GET HTTP EXAMPLE')),
          body: Center(
            child: FutureBuilder<Album>( 
              future: futureAlbum,
              builder:(context, snapshot) {
                if(snapshot.hasData){
                  return Text(snapshot.data!.title);
                }else if (snapshot.hasError){
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              }),
             )
      )
    );
  }

}
