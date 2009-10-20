class ScheduleController < ApplicationController
  before_filter :is_iphone?
  before_filter :is_admin?, :only => :admin
  before_filter :setup_selected_day

  def setup_selected_day
    session[:selected_day] = params['selected_day'] || session[:selected_day] || current_event.days[0]        
  end
  
  def index
    @rooms, @timeslots, @grid = current_event.schedule(session[:selected_day])
  end

  def admin
    index
    render :layout=>"admin"
  end

  def iphone
    @rooms, @timeslots, @grid = current_event.schedule
    render :layout=>"iphone"
  end

  def iphone_presentation
    @presentation = current_event.presentations.find(params[:id], :include=>[:comments])
    render :layout=>"iphone"
  end

  def mobile
    @rooms, @timeslots, @grid = current_event.schedule
    render :layout=>"mobile"
  end

  def mobile_presentation
    @presentation = current_event.presentations.find(params[:id], :include=>[:comments])
    render :layout=>"mobile"
  end
end
