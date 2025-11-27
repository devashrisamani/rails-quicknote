# =============================================================================
# NOTES CONTROLLER - app/controllers/notes_controller.rb
# =============================================================================
# This is the CONTROLLER in MVC (Model-View-Controller)
# Controllers handle requests from users and coordinate between Models and Views
#
# Each method (called an "action") handles a specific URL:
#   index   - GET  /notes          - List all notes
#   show    - GET  /notes/1        - Show one note
#   new     - GET  /notes/new      - Show form for new note
#   create  - POST /notes          - Save the new note
#   edit    - GET  /notes/1/edit   - Show form to edit note
#   update  - PATCH /notes/1       - Save the edited note
#   destroy - DELETE /notes/1      - Delete the note
# =============================================================================

class NotesController < ApplicationController
  # ---------------------------------------------------------------------------
  # BEFORE_ACTION - Run this method before certain actions
  # ---------------------------------------------------------------------------
  # This line says: "Before running show, edit, update, or destroy,
  # first run the set_note method to find the note"
  #
  # %i[ show edit update destroy ] is shorthand for [:show, :edit, :update, :destroy]
  # The %i creates an array of symbols
  # ---------------------------------------------------------------------------
  before_action :set_note, only: %i[ show edit update destroy ]

  # ---------------------------------------------------------------------------
  # INDEX ACTION - List all notes
  # ---------------------------------------------------------------------------
  # URL: GET /notes
  # This runs when user visits the main notes page
  #
  # @notes is an "instance variable" (starts with @)
  # Instance variables are available in the view (index.html.erb)
  # Regular variables (without @) are NOT available in views
  # ---------------------------------------------------------------------------
  def index
    # Get all notes, ordered by newest first
    # :desc means descending (newest to oldest)
    # :asc would mean ascending (oldest to newest)
    @notes = Note.order(created_at: :desc)
  end

  # ---------------------------------------------------------------------------
  # SHOW ACTION - Display one note
  # ---------------------------------------------------------------------------
  # URL: GET /notes/1 (where 1 is the note's ID)
  #
  # This method is empty because before_action already set @note for us!
  # The view (show.html.erb) can use @note directly
  # ---------------------------------------------------------------------------
  def show
  end

  # ---------------------------------------------------------------------------
  # NEW ACTION - Show the form for creating a note
  # ---------------------------------------------------------------------------
  # URL: GET /notes/new
  #
  # We create an empty Note object for the form to use
  # Note.new creates a Note in memory (NOT saved to database yet)
  # ---------------------------------------------------------------------------
  def new
    @note = Note.new
  end

  # ---------------------------------------------------------------------------
  # EDIT ACTION - Show the form for editing a note
  # ---------------------------------------------------------------------------
  # URL: GET /notes/1/edit
  #
  # Like show, this is empty because before_action already set @note
  # The form will be pre-filled with @note's current values
  # ---------------------------------------------------------------------------
  def edit
  end

  # ---------------------------------------------------------------------------
  # CREATE ACTION - Save a new note to the database
  # ---------------------------------------------------------------------------
  # URL: POST /notes
  # This runs when user submits the "new note" form
  #
  # note_params is a private method (see below) that safely extracts
  # only the allowed fields (title, body) from the form data
  # ---------------------------------------------------------------------------
  def create
    # Create a new Note with the form data
    @note = Note.new(note_params)

    # respond_to lets us handle different request formats
    # (HTML from browser, JSON from API, etc.)
    respond_to do |format|
      # Try to save the note to the database
      if @note.save
        # SUCCESS: Redirect to the note's show page with a success message
        # redirect_to @note is shorthand for redirect_to note_path(@note)
        # notice: sets a flash message that appears on the next page
        format.html { redirect_to @note, notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        # FAILURE: Validation failed, show the form again with errors
        # render :new shows new.html.erb again
        # status: :unprocessable_entity (422) tells browser there was an error
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # ---------------------------------------------------------------------------
  # UPDATE ACTION - Save changes to an existing note
  # ---------------------------------------------------------------------------
  # URL: PATCH /notes/1 or PUT /notes/1
  # This runs when user submits the "edit note" form
  # ---------------------------------------------------------------------------
  def update
    respond_to do |format|
      # Try to update the note with new values
      if @note.update(note_params)
        # SUCCESS: Redirect to show page
        # status: :see_other (303) is required for proper redirect after PATCH
        format.html { redirect_to @note, notice: "Note was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @note }
      else
        # FAILURE: Show the edit form again with errors
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # ---------------------------------------------------------------------------
  # DESTROY ACTION - Delete a note from the database
  # ---------------------------------------------------------------------------
  # URL: DELETE /notes/1
  # This runs when user clicks the delete button
  #
  # destroy! (with !) raises an error if deletion fails
  # destroy (without !) returns false if deletion fails
  # ---------------------------------------------------------------------------
  def destroy
    @note.destroy!

    respond_to do |format|
      # TURBO_STREAM: For Turbo/AJAX requests (from index page)
      # turbo_stream.remove(@note) tells browser to remove the note's HTML element
      # This makes the note disappear without a full page reload!
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@note) }

      # HTML: For regular requests (from show page)
      # Redirect to the notes list with a success message
      format.html { redirect_to notes_path, notice: "Note was successfully deleted.", status: :see_other }

      # JSON: For API requests
      # head :no_content sends a 204 response with no body
      format.json { head :no_content }
    end
  end

  # ---------------------------------------------------------------------------
  # PRIVATE METHODS - Only accessible within this controller
  # ---------------------------------------------------------------------------
  private

  # ---------------------------------------------------------------------------
  # SET_NOTE - Find and load a note from the database
  # ---------------------------------------------------------------------------
  # This runs before show, edit, update, and destroy actions
  # It finds the note by ID from the URL (params[:id])
  #
  # If note doesn't exist, Rails raises RecordNotFound error (404 page)
  # ---------------------------------------------------------------------------
  def set_note
    @note = Note.find(params.expect(:id))
  end

  # ---------------------------------------------------------------------------
  # NOTE_PARAMS - Strong Parameters (Security Feature)
  # ---------------------------------------------------------------------------
  # This is VERY IMPORTANT for security!
  #
  # Problem: Hackers could add extra fields to the form
  #   (like admin: true) and try to save them
  #
  # Solution: Strong parameters only allow specific fields through
  #
  # params.expect(note: [:title, :body]) means:
  #   "Only allow title and body fields from the note form data"
  #   Everything else is ignored!
  # ---------------------------------------------------------------------------
  def note_params
    params.expect(note: [ :title, :body ])
  end
end
