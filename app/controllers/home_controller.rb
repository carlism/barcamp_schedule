class HomeController < ApplicationController
  skip_before_filter :set_current_event
  def index
  end

end
