import 'package:flutter/material.dart';

import 'package:memes_app/models/meme.dart';

class MemeScreen extends StatefulWidget {
  final Meme meme;

  // ignore: use_key_in_widget_constructors
  const MemeScreen({ required this.meme });

  @override
  _MemeScreenState createState() => _MemeScreenState();
}

class _MemeScreenState extends State<MemeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Regresar')
      ),
      body: Center(
        child: SingleChildScrollView(
          child: _getContent(),
        )
      )
    );
  }

  _getContent() {
    return Column(
      children: [
        ClipRRect(
          child: !validateImage(widget.meme.submissionUrl)
            ? const Image(
                image: AssetImage('assets/no-image.png'),
                width: 100,
                height: 100,
                fit: BoxFit.fill
              )
            : FadeInImage(
                placeholder: const AssetImage('assets/spinning-loading.gif'),
                image: NetworkImage(widget.meme.submissionUrl),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/deleted-image.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitWidth,
                  );
                },
                width: 300,
                height: 300,
                fit: BoxFit.contain
              )
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.all(5),
          child: Text(
            widget.meme.submissionTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
            overflow: TextOverflow.clip
          )
        ),
        Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          child: Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Text(
                              'Id: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              )
                            ),
                            Text(
                              widget.meme.submissionId,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70
                              )
                            )
                          ]
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            const Text(
                              'Url: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              )
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                widget.meme.submissionUrl,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70
                                ),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis
                              )
                            )
                          ]
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            const Text(
                              'Enlace permanente: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              )
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                widget.meme.permalink,
                                style: const TextStyle(
                                  fontSize: 14,
                                color: Colors.white70
                                ),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis
                              )
                            )
                          ]
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            const Text(
                              'Autor: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              )
                            ),
                            Text(
                              widget.meme.author,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70
                              )
                            )
                          ]
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            const Text(
                              'Creado: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              )
                            ),
                            Text(
                              widget.meme.created,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70
                              )
                            )
                          ]
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            const Text(
                              'Marca de tiempo: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              )
                            ),
                            Text(
                              widget.meme.timestamp,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70
                              )
                            )
                          ]
                        )
                      ]
                    )
                  )
                ]
              )
            )
          )
        )
      ]
    );
  }

  bool validateImage(String urlImage) {
    var splitUrl = urlImage.split('.');
    var extension = splitUrl[splitUrl.length - 1];
    if (extension == "png" || extension == "jpg" || extension == "gif") {
      return true;
    }
    return false;
  }
}