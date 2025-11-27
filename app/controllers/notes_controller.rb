# Notes controller - handles all note-related requests
# RESTful actions: index, show, new, create, edit, update, destroy

class NotesController < ApplicationController
  before_action :set_note, only: %i[show edit update destroy]

  # GET /notes - List all notes
  def index
    @notes = Note.order(created_at: :desc)
  end

  # GET /notes/:id - Show a single note
  def show
  end

  # GET /notes/new - Display new note form
  def new
    @note = Note.new
  end

  # GET /notes/:id/edit - Display edit form
  def edit
  end

  # POST /notes - Create a new note
  def create
    @note = Note.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/:id - Update an existing note
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: "Note was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/:id - Delete a note
  def destroy
    @note.destroy!

    respond_to do |format|
      # Turbo Stream: smoothly remove note from list (used on index page)
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@note) }
      # HTML: redirect to index (used on show page)
      format.html { redirect_to notes_path, notice: "Note was successfully deleted.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Find note by ID (runs before show, edit, update, destroy)
  def set_note
    @note = Note.find(params.expect(:id))
  end

  # Strong parameters - only allow title and body
  def note_params
    params.expect(note: [:title, :body])
  end
end
