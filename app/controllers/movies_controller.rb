class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
   
    @all_ratings = Movie.ratings # get all the ratings
    
    # store all the movies by either name or date whether they are saved as cookies or not into the @sort
    @sort = params[:sort] || session[:sort]
    
    # give all rating cookies the value of the ratings stored as cookies if they exist or the value of null
    session[:ratings] = session[:ratings] || {'G'=>'','PG'=>'','PG-13'=>'','R'=>''}
    
    # store all the movie ratings or cookies of movie ratings into the @movie_params
    @movie_params = params[:ratings] || session[:ratings]
    
    # assign the sorted values and the movie ratings to the cookies to make sure they are saved
    session[:sort] = @sort
    session[:ratings] = @movie_params
    
    # the movies are displayed by the saved ratings and the saved sorted order of movie names/release dates
    @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])

    # if null values exist redirect to the sortings and ratings saved in the session cookies
    if(params[:sort].nil? and !(session[:sort].nil?)) or (params[:ratings].nil? or !(session[:rating].nil?))
      flash.keep
      redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
    end
     
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
