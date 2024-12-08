class MovieSerializer
  def self.format_movie(movies_list)

    { data: movies_list.map do |result|
        {
          id: result.id,
          type: "movie",
          attributes: {
            title: result.title,
            vote_average: result.vote_average
          }
        }
    end
  }
  end

  def self.movie_details(movie)
    { data: {
      id: movie[:id],
      title: movie[:original_title],
      runtime: movie[:runtime]
    }}
  end
end