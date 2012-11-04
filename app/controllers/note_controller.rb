class NoteController < ApplicationController
  def index
    @notes = Note.search(params[:search]).order(sort_column + " " + sort_direction)
  end

  def show
    @note = Note.find(params[:id])
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def sort_column
    Note.column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
