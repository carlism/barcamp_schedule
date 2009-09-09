class ScheduleController < ApplicationController
  before_filter :is_iphone?, :authorize, :only => :admin
  
  def index
    @days = current_event.days
    session[:selected_day] = params['selected_day'] || session[:selected_day] || @days[0]
    selected_day = session[:selected_day]
    @rooms, @timeslots, @grid = current_event.schedule(selected_day)
  end

  def admin
    index
    render :layout=>"admin"
  end

  def iphone
    index
    render :layout=>"iphone"
  end

  def iphone_presentation
    @presentation = current_event.presentations.find(params[:id], :include=>[:comments])
    render :layout=>"iphone"
  end

  def mobile
    index
    render :layout=>"mobile"
  end

  def mobile_presentation
    @presentation = current_event.presentations.find(params[:id], :include=>[:comments])
    render :layout=>"mobile"
  end
end
