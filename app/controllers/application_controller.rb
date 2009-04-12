# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
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
    session[:password] == 'bcn1'
  end 

  def is_iphone?
      request.user_agent =~ /(Mobile\/.+Safari)/
  end

  def get_tweet_hash
    chars = ("A".."Z").to_a + ("1".."9").to_a 
    return "#" + TWITTER_PREFIX + Array.new(6, '').collect{chars[rand(chars.size)]}.join
  end
  
end
