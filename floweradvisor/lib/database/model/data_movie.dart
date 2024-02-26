import 'package:floweradvisor/model/movie.dart';
import 'package:sql_query/builder/query_builder.dart';
import 'package:sql_query/database_model.dart';

class DataMovie { 
    static const String table = 'data_user';
    static const String id = 'id';
    static const String language = 'Language';
    static const String country = 'Country';
    static const String awards = 'Awards';
    static const String metascore = 'Metascore';
    static const String dvd = 'DVD';
    static const String imdbrating = 'imdbRating';
    static const String imdbvotes = 'imdbVotes';
    static const String ratings = 'Ratings';
    static const String boxoffice = 'BoxOffice';
    static const String production = 'Production';
    static const String website = 'Website';
    static const String rated = 'Rated';
    static const String genre = 'Genre';
    static const String runtime = 'Runtime';
    static const String released = 'Released';
    static const String director = 'Director';
    static const String writer = 'Writer';
    static const String actors = 'Actors';
    static const String imdbid = 'imdbID';
    static const String poster = 'Poster';
    static const String title = 'Title';
    static const String type = 'Type';
    static const String year = 'Year';
    static const String plot = 'Plot';

    static tables() { 
        return TableDatabase(
            tableName: "data_user",
            column: [
                ColumnDatabase(name: id, typeData:DataType.integer, primaryKey: true, autoIncrement: true),
                ColumnDatabase(name: language, typeData:DataType.text),
                ColumnDatabase(name: country, typeData:DataType.text),
                ColumnDatabase(name: awards, typeData:DataType.text),
                ColumnDatabase(name: metascore, typeData:DataType.text),
                ColumnDatabase(name: dvd, typeData:DataType.text),
                ColumnDatabase(name: imdbrating, typeData:DataType.text),
                ColumnDatabase(name: imdbvotes, typeData:DataType.text),
                ColumnDatabase(name: ratings, typeData:DataType.text),
                ColumnDatabase(name: boxoffice, typeData:DataType.text),
                ColumnDatabase(name: production, typeData:DataType.text),
                ColumnDatabase(name: website, typeData:DataType.text),
                ColumnDatabase(name: rated, typeData:DataType.text),
                ColumnDatabase(name: genre, typeData:DataType.text),
                ColumnDatabase(name: runtime, typeData:DataType.text),
                ColumnDatabase(name: released, typeData:DataType.text),
                ColumnDatabase(name: director, typeData:DataType.text),
                ColumnDatabase(name: writer, typeData:DataType.text),
                ColumnDatabase(name: actors, typeData:DataType.text),
                ColumnDatabase(name: imdbid, typeData:DataType.text),
                ColumnDatabase(name: poster, typeData:DataType.text),
                ColumnDatabase(name: title, typeData:DataType.text),
                ColumnDatabase(name: type, typeData:DataType.text),
                ColumnDatabase(name: year, typeData:DataType.text),
                ColumnDatabase(name: plot, typeData:DataType.text),
            ],
        );
    } 

    static get() async { 
        final q = DB.table(table);
        return await q.get();
    } 

    static insert(MovieModel data) async { 
        final q = DB.table(table);
        q.data({language: data.languange ?? '', country: data.country ?? '', awards: data.awards ?? '', metascore: data.metaScore ?? '', dvd: data.dvd ?? '', imdbrating: data.imdbRating ?? '', imdbvotes: data.imdbVotes ?? '', ratings: '', boxoffice: data.boxoffice ?? '', production: data.production ?? '', website: data.website ?? '', rated: data.rated ?? '', genre: data.genre ?? '', runtime: data.runtime ?? '', released: data.released ?? '', director: data.director ?? '', writer: data.writer ?? '', actors: data.actors ?? '', imdbid: data.imdbID ?? '', poster: data.poster ?? '', title: data.title ?? '', type: data.type ?? '', year: data.year ?? '', plot: data.plot ?? ''}); // add your data here
        return await q.insert();
    } 

    static delete(MovieModel data) async { 
        final q = DB.table(table).where(imdbid, '=', data.imdbID);
        return await q.delete();
    } 

} 
