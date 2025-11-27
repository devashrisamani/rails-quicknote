# =============================================================================
# ROUTES - config/routes.rb
# =============================================================================
# Routes connect URLs to controller actions
# Think of it as a "map" that tells Rails where to send each request
#
# When someone visits a URL, Rails looks here to figure out:
#   1. Which controller to use
#   2. Which action (method) to call
#
# You can see all routes by running: rails routes
# =============================================================================

Rails.application.routes.draw do
  # ---------------------------------------------------------------------------
  # ROOT ROUTE - The homepage of your app (/)
  # ---------------------------------------------------------------------------
  # This makes visiting "/" show your notes list
  # Without this, "/" would show a 404 error!
  root "notes#index"

  # ---------------------------------------------------------------------------
  # RESOURCES - Create all 7 RESTful routes automatically!
  # ---------------------------------------------------------------------------
  # This single line creates ALL these routes:
  #
  #   HTTP Method   URL                Controller#Action   Helper Method
  #   -----------   ---                -----------------   -------------
  #   GET           /notes             notes#index         notes_path
  #   GET           /notes/new         notes#new           new_note_path
  #   POST          /notes             notes#create        notes_path
  #   GET           /notes/:id         notes#show          note_path(@note)
  #   GET           /notes/:id/edit    notes#edit          edit_note_path(@note)
  #   PATCH/PUT     /notes/:id         notes#update        note_path(@note)
  #   DELETE        /notes/:id         notes#destroy       note_path(@note)
  #
  # The :id in the URL becomes params[:id] in the controller
  # For example: /notes/5 → params[:id] = "5"
  # ---------------------------------------------------------------------------
  resources :notes

  # ---------------------------------------------------------------------------
  # HEALTH CHECK - Used by deployment tools to check if app is running
  # ---------------------------------------------------------------------------
  get "up" => "rails/health#show", as: :rails_health_check

end
