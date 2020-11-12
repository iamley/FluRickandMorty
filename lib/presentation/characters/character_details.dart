import 'package:FluRickandMorty/domain/entities/character.dart';
import 'package:flutter/material.dart';

class CharacterDetail extends StatelessWidget {
  final Character _character;
  const CharacterDetail(this._character);

  @override
  Widget build(BuildContext context) {
    return _character == null
        ? _buildForNullCharacter()
        : _buildForNonNullCharacter(context);
  }

  Widget _buildForNullCharacter() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            'Ningún personaje por mostrar',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          )
        ],
      ),
    );
  }

  Widget _buildForNonNullCharacter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        children: <Widget>[
          Image.network(_character.image),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                _character.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
          ),
          _buildInformationWidget(
              Icons.all_inclusive, 'Status', _character.status),
          _buildInformationWidget(Icons.pets, 'Especie', _character.species),
          _buildInformationWidget(Icons.person, 'Tipo', _character.type),
          _buildInformationWidget(Icons.wc, 'Genero', _character.gender),
          _buildInformationWidget(
              Icons.public, 'Origen', _character.origin.name),
          _buildInformationWidget(
              Icons.place, 'Ubicación', _character.location.name),
        ],
      ),
    );
  }

  Widget _buildInformationWidget(IconData icon, String key, String value) {
    return Row(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 20.0,
            bottom: 16.0,
          ),
          child: Icon(icon, color: Colors.grey[600]),
        ),
        _buildKeyValueWidget(key, value)
      ],
    );
  }

  Widget _buildKeyValueWidget(String key, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            key,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(value)
      ],
    );
  }
}
