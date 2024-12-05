class MovieSerializer
  def self.format_movie(json)
    top_twenty = json[:results].first(20)
    { data: top_twenty.map do |result|
      movie = Movie.new(result)
        {
          id: movie.id,
          type: "movie",
          attributes: {
            title: movie.title,
            vote_average: movie.vote_average
          }
        }
    end
  }
  end
end