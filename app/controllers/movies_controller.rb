class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  #def show_director
  #  p params[:director]
  #  director = params[:director]

    # @movies = Movie.where("director like ?",  director)
    #p '>>>>:' + @movies.size.to_s + "<<<<<"
    #redirect_to movies_path(@movies)
  #end


  def index
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering,@title_header = {:order => :title}, 'hilite'
    when 'release_date'
      ordering,@date_header = {:order => :release_date}, 'hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}

    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end

    if params[:sort] != session[:sort]
      session[:sort] = sort
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end

    if params[:ratings] != session[:ratings] and @selected_ratings != {}
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      flash.keep
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end


  #  p "director key: " + params.has_key?("director").to_s
  #  p "directore value: " + params[:director].to_s

#    if (params.has_key?("director") && (!params[:director].nil?))
 #     director = params[:director]
  #    p "|||||||||||||" + director.to_s

#      @movies = Movie.find_all_by_director(director)
 #     if director.empty?
  #      flash[:notice] = "'#{@movies[0].title}' has no director info"
   #   end
    # p "size : " + @movies.size.to_s
     # return
   # else
      @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)
#    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def search_movies_director
    #p params.to_s
    director = params[:director]
    if director.nil? || director.empty?
      @movie = Movie.find(params[:id])
      flash[:notice] = "'#{@movie.title}' has no director info"
      redirect_to movies_path
    else
      @movies = Movie.find_same_director params[:director]
    end
  end
end
