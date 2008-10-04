ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../../../config/environment')
require 'test/unit'
# TODO: Write new tests to deal with the new method of assignment

## Model used to test FlexTimes
#class ModelWithDate < ActiveRecord::Base
#  datetime_column :dt
#  time_column :tim
#  date_column :dat
#end

class FlexTimesTest < Test::Unit::TestCase
  # Sets up the tests
  def setup
#    @model = ModelWithDate.new
#    @text_dt = "2005-06-01 12:34:56 CDT"
#    @text_date = "2005-06-01"
#    @text_time = "12:34:56 CDT"
#    @hash_dt = { :year => "2005", :month => "06", :day => "01", :hour => "12", :minute => "34", :second => "56"}    
#    @hash_date = { :year => "2005", :month => "06", :day => "01" }
#    @hash_time = { :hour => "12", :minute => "34", :second => "56" }
#    @hash_12hr_dt = { :year => "2005", :month => "06", :day => "01", :hour => "12", :minute => "34", :second => "56", :ampm => "AM"}    
#    @hash_12hr_time = { :hour => "12", :minute => "34", :second => "56", :ampm => "AM"}
  end
  
#  # Tests datetime_column
#  def test_dt_column
#    @model.dt = @text_dt
#    assert_equal @model.dt, @text_dt
#    
#    @model.dt = @hash_dt
#    assert @model.dt.is_a?(Time)
#    
#    @model.dt = @hash_12hr_dt
#    assert @model.dt.is_a?(Time)
#    assert_equal @model.dt.hour, 0 # adjusts for 12hr time
#  end

#  # Tests time_column
#  def test_time_column
#    @model.tim = @text_time
#    assert_equal @model.tim, @text_time
#    
#    @model.tim = @hash_time
#    assert @model.tim.is_a?(Time)
#    
#    @model.tim = @hash_12hr_time
#    assert @model.tim.is_a?(Time)
#    assert_equal @model.tim.hour, 0 
#  end
  
#  # Tests date_column
#  def test_date_column
#    @model.dat = @text_date
#    assert_equal @model.dat, @text_date
#    
#    @model.dat = @hash_date
#    assert @model.dat.is_a?(Date)
#  end

  # Make sure that select_... helpers don't change output format TOO much from ActionView's originals.
  # These tests are valid for Rails 1.1.6 but may change if ActionView changes.
  def test_select_date_compatibility
    view = ActionView::Base.new
    t = Time.now()
    # Use gsub, rather than :order, so that we can test default order
    assert_equal view.old_select_datetime(t) + view.select_second(t), view.select_datetime(t).gsub(/ *(:|&mdash;) */, '')
    assert_equal view.old_select_date(t), view.select_date(t)
    assert_equal view.old_select_time(t), view.select_time(t).gsub(/ *: */, '')
  end

  # Test each helper method with numeric, date/time, and nil values.
  def test_helper_method_input_types
    view = ActionView::Base.new
    [ :year, :month, :day, :hour, :minute, :second ].each do |helper|
      [ 1, Time.now(), nil ].each do |t|
        assert_match /<select.*>/, view.send("select_#{helper.to_s}", t)
      end
    end
  end

  # Should probably test AM/PM handling specifically...
  
end

