class NoteController < ApplicationController
  def index
    if params[:search].blank?
      @notes = Note.order(sort_column + " " + sort_direction).all
      #@notes = Note.search(params[:search]).order(sort_column + " " + sort_direction)
    else
      @search = Note.search do
        fulltext params[:search]
      end
      @notes = @search.results
    end
  end

  def show
    @note = Note.find(params[:id])
    respond_to do |format|
      format.html { render :layout => false }
      format.js
    end
  end

  def sort_column
    Note.column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
