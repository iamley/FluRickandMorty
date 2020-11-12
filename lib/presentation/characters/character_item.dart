import 'package:FluRickandMorty/domain/entities/character.dart';
import 'package:flutter/material.dart';

class CharacterItem extends StatelessWidget {
  final Character _character;
  final ValueChanged<Character> onTap;

  const CharacterItem(this._character, this.onTap) : assert(_character != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => onTap(_character),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
                child: Image.network(
              _character.image,
              fit: BoxFit.fill,
            )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Wrap(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(color: Colors.black54),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          _character.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
