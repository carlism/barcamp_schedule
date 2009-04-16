class PresentationsController < ApplicationController
  before_filter :authorize, :except=>:show
  layout 'admin'

  # GET /presentations
  # GET /presentations.xml
  def index
    @presentations = current_event.presentations

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @presentations }
    end
  end

  # GET /presentations/1
  # GET /presentations/1.xml
  def show
    @presentation = current_event.presentations.find(params[:id])    
    @comment = Comment.new
        
    respond_to do |format|
      format.html { render :layout=>"application" }# show.html.erb
      format.xml  { render :xml => @presentation }
    end
  end

  # GET /presentations/new
  # GET /presentations/new.xml
  def new
    @presentation = current_event.presentations.build(params[:presentation])
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @presentation }
    end
  end

  # GET /presentations/1/edit
  def edit
    @presentation = current_event.presentations.find(params[:id])
  end

  # POST /presentations
  # POST /presentations.xml
  def create
    @presentation = current_event.presentations.build(params[:presentation])
    @presentation.tweet_hash = get_tweet_hash

    respond_to do |format|
      if @presentation.save
        flash[:notice] = 'Presentation was successfully created.'
        # post a twitter note with random hash and presentation name
        # twit = Twitter::Base.new(TWITTER_USER, TWITTER_PASS)
        # twit.post("To post notes to \"" + @presentation.title[0..80] + "\" post using " + @presentation.tweet_hash)
        format.html { redirect_to(:controller=>'schedule', :action=>'admin') }
        format.xml  { render :xml => @presentation, :status => :created, :location => @presentation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @presentation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /presentations/1
  # PUT /presentations/1.xml
  def update
    @presentation = current_event.presentations.find(params[:id])

    respond_to do |format|
      if @presentation.update_attributes(params[:presentation])
        flash[:notice] = 'Presentation was successfully updated.'
        format.html { redirect_to(@presentation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @presentation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /presentations/1
  # DELETE /presentations/1.xml
  def destroy
    @presentation = current_event.presentations.find(params[:id])
    @presentation.destroy

    respond_to do |format|
      format.html { redirect_to(:controller=>:schedule, :action=>:admin) }
      format.xml  { head :ok }
    end
  end
  
  def swap
    from_type, from_id = params[:from].split "_"
    to_type, to_id = params[:to].split "_"
    if from_type == 'presentation' and to_type == 'presentation'
      @from = current_event.presentations.find from_id
      @to = current_event.presentations.find to_id
      @to_id = "#{@to.timeslot_id}.#{@to.room_id}"
      @from_id = "#{@from.timeslot_id}.#{@from.room_id}"
      @from.room_id, temp_room_id, @to.room_id = @to.room_id, @from.room_id, nil
      @from.timeslot_id, temp_timeslot_id, @to.timeslot_id = @to.timeslot_id, @from.timeslot_id, nil
      @to.save
      @from.save
      @to.room_id, @to.timeslot_id = temp_room_id, temp_timeslot_id
      @to.save
    elsif from_type == 'presentation'
      @from = current_event.presentations.find from_id
      @from_id = "#{@from.timeslot_id}.#{@from.room_id}"
      @from.timeslot_id, @from.room_id = to_id.split "."
      @from.save
      @to_id = to_id
    elsif to_type == 'presentation'
      @to = current_event.presentations.find to_id
      @to_id = "#{@to.timeslot_id}.#{@to.room_id}"
      @to.timeslot_id, @to.room_id = from_id.split "."
      @to.save
      @from_id = from_id
    end
  end
end
