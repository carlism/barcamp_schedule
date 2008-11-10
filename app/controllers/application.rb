# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => 'a22409943d82edcfd79d7631314413ca'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  
   helper_method :admin?
  
protected
  def authorize
    unless admin?
      flash[:error] = "unauthorized access"
      redirect_to '/login'
      false
    end
  end

  def admin?
    session[:password] == 'bcp'
  end 
  
end
