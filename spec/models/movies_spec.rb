require "spec_helper"

describe Movie do
  fixtures :movies
  it "should find the movies with the same director" do
    movies = Movie.find_same_director("George Lucas")
    movies.size.should == 2
    end
end
