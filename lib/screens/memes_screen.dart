import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
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
  bool _isFiltered = false;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _getMemes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('Memes'),
        backgroundColor: Colors.grey[900],
        actions: <Widget>[
          _isFiltered
          ? IconButton(
              onPressed: _removeFilter, 
              icon: const Icon(Icons.filter_none)
            )
          : IconButton(
              onPressed: _showFilter, 
              icon: const Icon(Icons.filter_alt)
            )
        ]
      ),
      body: Center(
        child: _showLoader ? const LoaderComponent(text: 'Cargando...') : _getContent()
      )
    );
  }

  Future<void> _getMemes() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });

      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estés conectado a internet.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar')
        ]
      );
      return;
    }

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
              margin: const EdgeInsets.all(5),
              child: Row(
                children: [
                  ClipRRect(
                    child: !validateImage(meme.submissionUrl)
                      ? const Image(
                          image: AssetImage('assets/no-image.png'),
                          width: 90,
                          height: 90,
                          fit: BoxFit.fill,
                        )
                      : FadeInImage(
                          placeholder: const AssetImage('assets/spinning-loading.gif'),
                          image: NetworkImage(meme.submissionUrl),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/deleted-image.png',
                              width: 90,
                              height: 90,
                              fit: BoxFit.fitWidth,
                            );
                          },
                          width: 90,
                          height: 90,
                          fit: BoxFit.fill
                        ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        meme.submissionTitle, 
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                        overflow: TextOverflow.clip,
                      )
                    )
                  ),
                  const Icon(Icons.arrow_forward_ios)
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
    var splitUrl = urlImage.split('.');
    var extension = splitUrl[splitUrl.length - 1];
    if (extension == "png" || extension == "jpg" || extension == "gif") {
      return true;
    }
    return false;
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });

    _getMemes();
  }

  void _showFilter() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.grey[300],
          title: const Text('Filtrar Meme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Escriba las primeras letras del título del meme'),
              const SizedBox(height: 10,),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Criterio de búsqueda...',
                  labelText: 'Buscar',
                  suffixIcon: Icon(Icons.search)
                ),
                onChanged: (value) {
                  _search = value;
                },
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text('Cancelar')
            ),
            TextButton(
              onPressed: () => _filter(), 
              child: const Text('Filtrar')
            ),
          ],
        );
      });
  }

  void _filter() {
    if (_search.isEmpty) return;

    List<Meme> filteredList = [];
    for (Meme meme in _memes) {
      if (meme.submissionTitle.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(meme);
      }
    }

    setState(() {
      _memes = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }
}