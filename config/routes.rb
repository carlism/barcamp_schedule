ActionController::Routing::Routes.draw do |map|
  map.resources :user_sessions
  map.resources :users
  map.resources :comments
  map.resources :presentations
  map.resources :timeslots
  map.resources :rooms
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.iphone 'iphone', :controller=>'schedule', :action=>'iphone'
  map.mobile 'mobile', :controller=>'schedule', :action=>'mobile'
  map.home '', :controller => 'home', :action => 'index', :conditions=>{:subdomain=>'www'}
  map.home '', :controller => 'schedule', :action => 'index'
  map.root :controller => 'home', :action => 'index', :conditions=>{:subdomain=>'www'}
  map.root :controller => 'schedule'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
