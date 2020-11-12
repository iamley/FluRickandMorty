import 'package:FluRickandMorty/domain/entities/character.dart';
import 'package:FluRickandMorty/infrastructure/rest/character_api.dart';
import 'package:FluRickandMorty/presentation/characters/character_details.dart';
import 'package:FluRickandMorty/presentation/characters/character_item.dart';
import 'package:FluRickandMorty/presentation/shared/backdrop.dart';
import 'package:flutter/material.dart';

final _characterGridViewMargin = 48.0;
final _characterGridViewSpanCountPortrait = 2;
final _characterGridViewSpanCountLandscape = 4;

final _frontTitle = 'Personajes';
final _backTitle = 'Rick & Morty';

class CharactersPage extends StatefulWidget {
  CharactersPage({Key key}) : super(key: key);

  @override
  _CharactersPageState createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final _characters = <Character>[];
  Character _currentCharacter;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_characters.isEmpty) {
      await _loadCharacters();
    }
  }

  Future _loadCharacters() async {
    final api = CharacterApi();
    final characters = await api.getCharacters();
    setState(() {
      _characters.addAll(characters);
    });
  }

  void _onCharacterTapped(Character character) {
    setState(() {
      _currentCharacter = character;
      print("Personaje tocado");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Backdrop(
      frontTitle: Text(_frontTitle),
      backTitle: Text(_backTitle),
      currentCharacter: _currentCharacter,
      backPanel: _buildBackPanel(),
      frontPanel: _buildFrontPanel(),
    );
  }

  Widget _buildFrontPanel() {
    return CharacterDetail(_currentCharacter);
  }

  Widget _buildBackPanel() {
    if (_characters.isEmpty) {
      return _buildForLoadingState();
    } else {
      return _buildForLoadedState();
    }
  }

  Widget _buildForLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildForLoadedState() {
    return Padding(
      padding: EdgeInsets.only(bottom: _characterGridViewMargin),
      child: GridView.count(
          crossAxisCount: _getCharacterGridViewSpanCount(),
          children: _characters
              .map((character) => CharacterItem(character, _onCharacterTapped))
              .toList()),
    );
  }

  int _getCharacterGridViewSpanCount() {
    if (MediaQuery.of(context).orientation == Orientation.portrait)
      return _characterGridViewSpanCountPortrait;
    return _characterGridViewSpanCountLandscape;
  }
}
