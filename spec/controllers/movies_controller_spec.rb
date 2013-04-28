require "spec_helper"

describe MoviesController do
  describe "find movie with same director" do
    it "follow 'Find Movies With Same Director'" do
      Movie.should_receive(:find_same_director).with('George Lucas')
      post :search_movies_director, {:director => 'George Lucas', :id => '1'}

    end

    it "should be on the Similar Movies page for 'Star Wars'" do
      Movie.stub(:find_same_director)
      post :search_movies_director, {:director => 'George Lucas', :id => '1'}
      response.should render_template('search_movies_director')
    end

    it "should make the movies available to the view" do
      fake_results = [Movie.new]

      Movie.stub(:find_same_director).and_return(fake_results)
      post :search_movies_director, {:director => 'George Lucas', :id => '1'}

      #look for controller method to assign @movies
      assigns(:movies).should == fake_results
    end

    it "should write a message when no director" do
      movie =Movie.new
      movie.id = 3
      movie.title = "Alien"
      movie.rating = 'R'
      movie.director = ""
      movie.release_date = 1979-05-25

      Movie.should_receive(:find).with('3').and_return(movie)
      post :search_movies_director, {:director => '', :id => '3'}
      movie.director.should == ''
      response.should redirect_to(:action => "index", :controller => "movies")
    end
  end
end
