# frozen_string_literal: true

class MovieSerializer
  def self.format_movie(movies_list)
    { data: movies_list.map do |result|
      {
        id: result.id,
        type: 'movie',
        attributes: {
          title: result.title,
          vote_average: result.vote_average
        }
      }
    end }
  end

  def self.movie_details(movie)
    { data: {
      id: movie[:id],
      type: 'movie',
      attributes: {
        title: movie[:original_title],
        release_year: movie[:release_date].split('-').first.to_i,
        vote_average: movie[:vote_average],
        runtime: time_conversion(movie[:runtime]),
        genres: genres(movie[:genres]),
        summary: movie[:overview],
        cast: cast(movie[:credits][:cast]),
        total_reviews: movie[:reviews][:total_results],
        reviews: reviews(movie[:reviews][:results])
      }
    } }
  end

  def self.time_conversion(minutes)
    hours = minutes / 60
    rest = minutes % 60
    "#{hours} hours, #{rest} minutes"
  end

  def self.genres(genres)
    genres.pluck(:name)
  end

  def self.cast(cast_members)
    cast_members.first(10).map do |cast|
      {
        character: cast[:character],
        actor: cast[:name]
      }
    end
  end

  def self.reviews(reviews)
    reviews.first(5).map do |review|
      {
        author: review[:author],
        review: review[:content]
      }
    end
  end
end
