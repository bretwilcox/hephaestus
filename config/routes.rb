Rails.application.routes.draw do

  get 'about/index'

  # Adding route to single page app to display information pertaining to the Kubernetes deployment
  # get '/abouthisapp', to: 'about#index'
  get '/aboutthisapp' => 'about#index'

  # Route to example gauge using the Prometheus integration
  get 'test_gauge', to: 'test#gauge'
end