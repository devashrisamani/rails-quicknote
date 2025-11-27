# =============================================================================
# NOTE MODEL - app/models/note.rb
# =============================================================================
# This is the MODEL in MVC (Model-View-Controller)
# Models handle your data and business logic
#
# This file connects to the "notes" table in your database
# Rails automatically gives you methods like:
#   Note.all        - Get all notes
#   Note.find(1)    - Find note with id=1
#   Note.create()   - Create a new note
#   note.save       - Save a note to database
#   note.update()   - Update a note
#   note.destroy    - Delete a note
# =============================================================================

class Note < ApplicationRecord
  # ---------------------------------------------------------------------------
  # BROADCASTS - Real-time updates with Turbo Streams
  # ---------------------------------------------------------------------------
  # This single line does A LOT! It automatically broadcasts changes to all
  # connected browsers when a note is created, updated, or destroyed.
  #
  # Behind the scenes, it's doing this:
  #   after_create_commit  { broadcast_append_to "notes" }
  #   after_update_commit  { broadcast_replace_to "notes" }
  #   after_destroy_commit { broadcast_remove_to "notes" }
  #
  # This means: If User A creates a note, User B will see it appear instantly!
  # ---------------------------------------------------------------------------
  broadcasts

  # ---------------------------------------------------------------------------
  # VALIDATIONS - Rules that must be true before saving to database
  # ---------------------------------------------------------------------------
  # validates :field_name, rule: value
  #
  # Common validation rules:
  #   presence: true              - Field cannot be empty
  #   length: { minimum: 3 }      - At least 3 characters
  #   length: { maximum: 100 }    - No more than 100 characters
  #   uniqueness: true            - No duplicates allowed
  #   numericality: true          - Must be a number
  #   format: { with: /regex/ }   - Must match a pattern
  #
  # If validation fails:
  #   - note.save returns false
  #   - note.errors contains the error messages
  #   - The form is shown again with errors displayed
  # ---------------------------------------------------------------------------

  # Title is required - user cannot leave it blank
  validates :title, presence: true

  # Body is required - user cannot leave it blank
  validates :body, presence: true
end
