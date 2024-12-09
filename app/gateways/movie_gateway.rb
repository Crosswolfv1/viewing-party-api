# frozen_string_literal: true

class MovieGateway
  def self.conn
    Faraday.new(url: 'https://api.themoviedb.org')
  end

  def self.get_movies
    response = conn.get('/3/movie/top_rated', { api_key: Rails.application.credentials.moviedb[:key] })
    json = JSON.parse(response.body, symbolize_names: true)
    create_movies(json)
  end

  def self.search_movies(query)
    response = conn.get('/3/search/movie', { query: query, api_key: Rails.application.credentials.moviedb[:key] })
    json = JSON.parse(response.body, symbolize_names: true)
    create_movies(json)
  end

  def self.get_one_movie(query)
    response = conn.get("/3/movie/#{query}?append_to_response=credits,reviews",
                        { api_key: Rails.application.credentials.moviedb[:key] })
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.create_movies(json)
    top_twenty = json[:results].first(20)
    top_twenty.map do |result|
      Movie.new(result)
    end
  end
end
