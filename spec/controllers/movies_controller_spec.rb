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

    it "should delete a movie" do
      movie =Movie.new
      movie.id = 1

      Movie.should_receive(:find).with('1').and_return(movie)
      post :destroy, { :controller=>"movies", :id => '1'}
    end

    it "should redirect to the index" do
      movie =Movie.new
      movie.id = 1
      movie.title = "Alien"
      Movie.stub(:find).with('1').and_return(movie)
      post :destroy, { :controller=>"movies", :id => '1'}
      response.should redirect_to(:action => "index", :controller => "movies")
    end

    it "should update a movie" do
      fake_result = Movie.new
      Movie.stub(:find).with('1').and_return(fake_result)
      put :update, {:controller=>"movies", :id => '1'}
      response.should redirect_to(movie_path(fake_result))
    end

    it "should sort by title" do
      ratings = Hash.new(['rating[G]' => 'G','rating[PG]' => 'PG','rating[PG-13]' => 'PG-13','rating[NC-17]' => 'NC-17','rating[R]' => 'R'])
      Movie.stub(:find_all_by_rating).with(ratings,'title')
      get :index, {:controller=>"movies", :sort => 'title'}
      response.should render_template(:action => "index", :controller => "movies", :sort => 'title')
    end
    it "should sort by release_date" do
      ratings = Hash.new(['rating[G]' => 'G','rating[PG]' => 'PG','rating[PG-13]' => 'PG-13','rating[NC-17]' => 'NC-17','rating[R]' => 'R'])

      Movie.stub(:find_all_by_rating).with(ratings,'release_date')
      get :index, {:controller=>"movies", :sort => 'release_date'}
      response.should render_template(:action => "index", :controller => "movies", :sort => 'release_date')
    end

    it "should render according to the selected ratings" do
      ratings = Hash.new(['rating[G]' => 'G','rating[PG]' => 'PG','rating[PG-13]' => 'PG-13','rating[NC-17]' => 'NC-17','rating[R]' => 'R'])

      Movie.stub(:find_all_by_rating).with(ratings,'')
      get :index, {:controller=>"movies", :ratings => ratings}
      response.should render_template(:action => "index", :controller => "movies", :sort => 'release_date', :ratings => ratings)
    end

    it "should display the index the first time" do
      Movie.should_receive(:find_all_by_rating)
      get :index, {:controller=>"movies"}

      response.should render_template("index")
    end

    it "should show details of the selected movie" do

      movie =Movie.new
      movie.id = 3
      movie.title = "Alien"
      movie.rating = 'R'
      movie.director = ""
      movie.release_date = 1979-05-25

      Movie.should_receive(:find).with('3').and_return(movie)
      get :show, {:id => '3'}

      response.should render_template('show')
    end

    it "should create a new movie" do
      movie =Movie.new
      movie.title = "PAV"
      movie.rating = 'R'
      movie.director = ""
      movie.release_date = 1979-05-25
#      fake_result = double('movie1')
      Movie.should_receive(:create!).and_return(movie)
      post :create, {:controller=>"movies"}
      response.should redirect_to(:action => "index", :controller => "movies")
    end

    it "should edit a movie" do
      Movie.should_receive(:find)
      get :edit, {:id => '3'}

      response.should render_template('edit')
    end
  end
end
