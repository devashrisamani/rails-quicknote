# Note model - represents a note in the database
# Table: notes (id, title, body, created_at, updated_at)

class Note < ApplicationRecord
  # Enable real-time updates via Turbo Streams
  broadcasts

  # Validations - both title and body are required
  validates :title, presence: true
  validates :body, presence: true
end
