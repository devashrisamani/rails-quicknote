class Note < ApplicationRecord
  broadcasts

  # Validations - prevent empty notes
  validates :title, presence: true
  validates :body, presence: true
end
