import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OMDb API Demo',
      debugShowCheckedModeBanner: false,
      home: MovieListScreen(),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Movie> _movies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OMDb Movie Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search Movies'),
              onSubmitted: (value) {
                _searchMovies(value);
              },
            ),
            
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    
                    title: Text(_movies[index].title),

                    subtitle: Text(_movies[index].year),

                    leading: _movies[index].poster != 'N/A'
                    ? Image.network(_movies[index].poster)
                        : const Icon(Icons.movie),                  
                      onTap: () {
                        Navigator.push(
                        context, 
                        MaterialPageRoute(
                        builder: (BuildContext context) => MovieDetails(movie : _movies[index]))
                        );

                      },

                      
                  );
                },
                
              ),
              
            ),
      
          ],
          
        ),
        
      ),
     
    );
  }

  Future<void> _searchMovies(String query) async {
    const apiKey = '4deec7f7';
    final apiUrl = 'http://www.omdbapi.com/?apikey=$apiKey&s=$query';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> movies = data['Search'];

      setState(() {
        _movies = movies.map((movie) => Movie.fromJson(movie)).toList();
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }
}



class Movie  {

  final String title;
  final String year;
  final String poster;
  final String imdbID;

  Movie({required this.title, required this.year, required this.poster, required this.imdbID});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'],
      year: json['Year'],
      poster: json['Poster'],
      imdbID: json['imdbID']

    );
  }
}


//Page avec plus d'infos

class MovieDetails extends StatefulWidget {
  final Movie movie;
  MovieDetails({required this.movie});
  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  Map<String, dynamic>? _movieInfo;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMovie();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
      title: Text(widget.movie.title ?? 'Details du film'),
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _movieInfo == null
        ? Center(child: Text('Erreur de chargement'))
        : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Image.network(_movieInfo!['Poster']),        

            Text(
            _movieInfo!['Title'],
            style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold)
            ),

            SizedBox(height: 10),
            Text(
            _movieInfo!['Year']
            ),
            SizedBox(height: 10),
            Text(
            _movieInfo!['Genre']
            ),
            SizedBox(height: 10),
            Text(
            _movieInfo!['Director']
            ),
            SizedBox(height: 10),
            Text(
            _movieInfo!['Plot']
            ),
          ],
          ),
        ),
      );
      }
  

  Future<void> _getMovie() async {
    const apiKey = '4deec7f7';
    final apiUrl = 'http://www.omdbapi.com/?apikey=$apiKey&i=${widget.movie.imdbID}';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      
      setState((){
        _movieInfo = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

}