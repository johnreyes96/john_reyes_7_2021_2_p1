import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:memes_app/components/loader_component.dart';
import 'package:memes_app/helpers/api_helper.dart';
import 'package:memes_app/models/meme.dart';
import 'package:memes_app/models/response.dart';
import 'package:memes_app/screens/meme_screen.dart';

class MemesScreen extends StatefulWidget {
  const MemesScreen({ Key? key }) : super(key: key);

  @override
  _MemesScreenState createState() => _MemesScreenState();
}

class _MemesScreenState extends State<MemesScreen> {
  List<Meme> _memes = [];
  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    _getMemes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memes'),

      ),
      body: Center(
        child: _showLoader ? LoaderComponent(text: 'Cargando...') : _getContent()
      )
    );
  }

  Future<Null> _getMemes() async {
    setState(() {
      _showLoader = true;
    });

    Response response = await ApiHelper.getMemes();

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: response.message,
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar')
        ]
      );
      return;
    }
    
    setState(() {
      _memes = response.result;
    });
  }

  Widget _getContent() {
    return _memes.isEmpty
      ? _noContent()
      : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: const Text(
          'No hay memes disponibles.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          )
        )
      )
    );
  }

  Widget _getListView() {
    return ListView(
      children: _memes.map((meme) {
        return Card(
          child: InkWell(
            onTap: () => _goDetailMeme(meme),
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  ClipRRect(
                    child: !validateImage(meme.submissionUrl)
                      ? const Image(
                          image: AssetImage('assets/no-image.png'),
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                        )
                      : FadeInImage(
                          placeholder: const AssetImage('assets/spinning-loading.gif'),
                          image: NetworkImage(meme.submissionUrl),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/deleted-image.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.fitWidth,
                            );
                          },
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill
                        ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                meme.submissionTitle, 
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ]
                          )
                        ]
                      )
                    )
                  ),
                  Icon(Icons.arrow_forward_ios)
                ]
              )
            )
          )
        );
      }).toList()
    );
  }

  void _goDetailMeme(Meme meme) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemeScreen(meme: meme)
      )
    );

    if (result == 'yes') {
      _getMemes();
    }
  }

  bool validateImage(String urlImage) {
    print(urlImage);
    var splitUrl = urlImage.split('.');
    var extension = splitUrl[splitUrl.length - 1];
    if (extension == "png" || extension == "jpg" || extension == "gif") {
      return true;
    }
    return false;
  }
}