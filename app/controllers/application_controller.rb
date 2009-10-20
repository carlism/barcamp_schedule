# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details\
  filter_parameter_logging :password
  before_filter :set_current_event
  helper_method :current_event, :current_user, :is_admin?

   def current_event
     set_current_event
   end
  
  protected

  def is_admin?
    if current_user && current_event
        current_event.admins.find current_user
    else
        flash[:error] = "unauthorized access"
        redirect_to login_path
        false
    end
  end

  def is_iphone?
      request.user_agent =~ /(Mobile\/.+Safari)/
  end

  def get_tweet_hash
    chars = ("A".."Z").to_a + ("1".."9").to_a 
    return "#" + TWITTER_PREFIX + Array.new(6, '').collect{chars[rand(chars.size)]}.join
  end
  
  private
  
  def set_current_event
    @current_event ||= Event.find_by_short_name(request.subdomains.last)
  end

  def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
  end

  def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
  end

end
