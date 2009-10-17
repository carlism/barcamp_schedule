ActionController::Routing::Routes.draw do |map|
  map.resources :user_sessions
  map.resources :users
  map.resources :comments
  map.resources :presentations
  map.resources :timeslots
  map.resources :rooms
  map.home '', :controller => 'schedule', :action => 'index'
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.iphone 'iphone', :controller=>'schedule', :action=>'iphone'
  map.mobile 'mobile', :controller=>'schedule', :action=>'mobile'
  map.root :controller => 'home', :conditions => { :subdomain => 'www' }
  map.root :controller => 'schedule', :conditions => { :subdomain => /.+/ }
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
