class ScheduleController < ApplicationController
  before_filter :is_iphone?, :authorize, :only => :admin
  
  def index
    @days = Timeslot.find(:all, :select=>'distinct day').map{|ts| ts.day }
    @selected_day = params['selected_day'] || @days[0]
    @rooms = Room.find(:all)
    @timeslots = Timeslot.find_all_by_day(@selected_day, :order=>'time(start_time)')
    @grid = []
    @timeslots.each do
      row = []
      @rooms.each do
        row << ""
      end
      @grid << row
    end
    @presentations ||= Presentation.find(:all)
    @presentations.each do |presentation|
      room_index = @rooms.index(presentation.room)
      timeslot_index = @timeslots.index(presentation.timeslot)
      if( room_index and timeslot_index )
        @grid[@timeslots.index(presentation.timeslot)][@rooms.index(presentation.room)] = presentation
      end
    end
  end

  def admin
    index
  end

  def iphone
    index
    render :layout=>"iphone"
  end

  def iphone_presentation
    @presentation = Presentation.find(params[:id], :include=>[:comments])
    render :layout=>"iphone"
  end

  def mobile
    index
  end

  def mobile_presentation
    @presentation = Presentation.find(params[:id], :include=>[:comments])
  end
end
