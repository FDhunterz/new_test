class MovieModel{
  String? title,
  imdbID,
  type,poster;

  String? languange, country, awards,metaScore, dvd, boxoffice,production,website,rated,genre, runtime, released,director,writer,actors,plot,imdbVotes,imdbRating,year;
  List? rating;

  setDetail(data){
    languange = data['Language'];
    country = data['Country'];
    awards = data['Awards'];
    metaScore = data['Metascore'];
    dvd = data['DVD'];
    imdbRating = data['imdbRating'];
    imdbVotes = data['imdbVotes'];
    try{
      rating = data['Ratings'];
    }catch(_){}
    boxoffice = data['BoxOffice'];
    production = data['Production'];
    website = data['Website'];
    rated = data['Rated'];
    genre = data['Genre']; 
    runtime = data['Runtime']; 
    released = data['Released'];
    director = data['Director'];
    writer = data['Writer'];
    actors = data['Actors'];
    plot = data['Plot'];
  }

  static MovieModel build(data){
    return MovieModel(
      imdbID: data['imdbID'],
      poster: data['Poster'],
      title: data['Title'],
      type: data['Type'],
      year: data['Year'],
    );
  }

  MovieModel({
    this.imdbID,
    this.poster,
    this.title,
    this.type,
    this.year
  });

}