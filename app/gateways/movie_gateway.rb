class MovieGateway
  def self.conn
    Faraday.new(url: "https://api.themoviedb.org")
  end

  def self.get_movies
    response = conn.get("/3/movie/top_rated", {api_key: Rails.application.credentials.moviedb[:key]})
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.search_movies(query)
    response = conn.get("/3/search/movie", {query: query, api_key: Rails.application.credentials.moviedb[:key]})
    JSON.parse(response.body, symbolize_names: true)
  end
end