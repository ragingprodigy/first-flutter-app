import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Statrup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: FlutterApp()
    );
  } 
}

class FlutterApp extends StatefulWidget {
  @override
  FlutterAppState createState() {
    return new FlutterAppState();
  }
}

class FlutterAppState extends State<FlutterApp> {

  void _toListComponent() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return Scaffold(
            body: RandomWords(),
          );
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statrup Name Gen'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.arrow_forward), onPressed: _toListComponent)
        ],
      ),
      body: ListView(
        children: <Widget>[
          Image.asset(
            'images/lake.jpg',
            height: 240.0,
            fit: BoxFit.cover,
          ),
          PictureTitleWidget(),
          PictureButtonRowWidget(),
          PictureTextWidget(),
        ],
      ),
    );
  }
}

class PictureTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Text(
        '''
Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.
        ''',
        softWrap: true,
      ),
    );
  }
}

class PictureTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Oeschinen Lake Campground',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'Kandersteg, Switzerland',
                  style: TextStyle(color: Colors.grey[500]),
                )
              ],
            ),
          ),
          FavoriteWidget(),
        ],
      ),
    );
  }
}

class PictureButtonRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buttonColumnBuilder(Icons.call, 'CALL'),
          buttonColumnBuilder(Icons.near_me, 'ROUTE'),
          buttonColumnBuilder(Icons.share, 'SHARE'),
        ],
      ),
    );
  }
}

Column buttonColumnBuilder(IconData icon, String label) {
  Color color = Colors.blue;

  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(icon, color: color),
      Container(
        margin: const EdgeInsets.only(top: 8.0),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: color
          ),
        ),
      )
    ],
  );
}

class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          child: IconButton(
            icon: Icon(
              _isFavorited ? Icons.star : Icons.star_border,
              color: Colors.red[500],
            ),
            onPressed: _toggleFavorite
          ),
        ),
        SizedBox(
          width: 18.0,
          child: Text('$_favoriteCount'),
        ),
      ],
    );
  }

}

class RandomWords extends StatefulWidget {
  @override
  createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];
  final _biggerFont = TextStyle(fontSize: 18.0);
  final _saved = Set<WordPair>();

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        final tiles = _saved.map(
          (pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont
              ),
            );
          }
        );

        final divided = ListTile.divideTiles(tiles: tiles, context: context)
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Favorites'),
          ),
          body: ListView(children: divided),
        );
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statrup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildRow(WordPair wordPair) {
    final alreadySaved = _saved.contains(wordPair);

    return ListTile(
      title: Text(
        wordPair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(wordPair);
          } else {
            _saved.add(wordPair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),

      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }
}
