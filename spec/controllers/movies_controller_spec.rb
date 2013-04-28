require "spec_helper"

describe MoviesController do
  describe "find movie with same director" do
    it "follow 'Find Movies With Same Director'" do
      Movie.should_receive(:find_same_director).with('director')
      post :search_movies_director, {:director => 'George Lucas'}
    end

    it "should be on the Similar Movies page for 'Star Wars'"
  end
end
