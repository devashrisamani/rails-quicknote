# Routes - maps URLs to controller actions
# Run "rails routes" to see all available routes

Rails.application.routes.draw do
  # Homepage - shows the notes list
  root "notes#index"

  # RESTful routes for notes (index, show, new, create, edit, update, destroy)
  resources :notes

  # Health check endpoint for deployment
  get "up" => "rails/health#show", as: :rails_health_check
end
