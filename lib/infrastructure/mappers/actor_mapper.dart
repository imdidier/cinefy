import 'package:cinefy/domain/entities/actor.dart';

import '../models/moviedb/credits_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
        character: cast.character,
        id: cast.id,
        name: cast.name,
        profilePath: (cast.profilePath != null)
            ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
            : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_hWubOwCUsUchCRvVuMya7QQXwsSTuuhpHA&usqp=CAU',
      );
}
