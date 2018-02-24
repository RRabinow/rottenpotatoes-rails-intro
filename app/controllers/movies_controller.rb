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
    @movies = Movie.all
    @all_ratings = ["G", "PG", "PG-13", "R"]
    
    if(params[:sort_by] == "title" or session[:sort_by].to_s == "title") #Check if title column was clicked or session has the last sort order
      @movies = @movies.order(:title)
      session[:sort_by] = "title"
    end
    if (params[:sort_by] == "release_date" or session[:sort_by].to_s == "release_date")#Check if release_date column was clicked or session has the last sort order
      @movies = @movies.order(:release_date)
      session[:sort_by] = "release_date"
    end
    @sort_column = params[:sort_by]
    if(params[:ratings] != nil) # if boxes were checked, record them into session and selected_ratings
      session[:rating] = params[:ratings] # the rating_pref check is so we don't 
      @selected_ratings = params[:ratings]
    else
      if(session.has_key?(:rating))#if no boxes were checked but there is a session, use that in selected_ratings
        @selected_ratings = session[:rating]
      end
    end#if no boxes were checked and there was no session, leave selected_ratings as nil and index view will auto check all boxes
    
    if (@selected_ratings != nil)
      @movies = @movies.find_all{|m| @selected_ratings.include?(m.rating)}#filter by rating
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
