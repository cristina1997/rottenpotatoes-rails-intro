class Movie < ActiveRecord::Base
    
    def self.ratings
        # obtain all the distinct ratings from the movies
        Movie.select(:rating).distinct.inject([]) { |a, m| a.push m.rating}
    end
end
