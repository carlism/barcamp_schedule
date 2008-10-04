# FlexTimes - the plugin that gives YOU control over the datetime helpers. 
#
# Author: Sean Cribbs 
#
# See FlexTimes::HelperMethods::datetime_select for more information. 

module FlexTimes
#  def self.append_features(base) #:nodoc:
#    super
#    base.extend(ActiveRecordExtensions)
#  end

  module HelperMethods
    
    # Creates a select box for the hour of the given datetime.
    #    :twelve_hour => true # will use 12 hour time (1..12)
    #    :twelve_hour => false # (or nil) will use 24 hour time (0..23)
    def select_hour(datetime, options = {}) 
      hour_options = []
      
      # allow 24-hour time too!
      if options[:twelve_hour]
        a, b = 1, 12
        hr_format = "%I"
      else
        a, b = 0, 23
        hr_format = "%H"
      end
      selected_hour = Time.local(0, 1, 1, ((datetime.kind_of?(Fixnum)) ? datetime : datetime.hour)).strftime(hr_format).to_i unless datetime.nil?
      a.upto(b) do |hour|
        selected = (selected_hour == hour) ? ' selected="selected"' : ''
        hour_options << %(<option value="#{leading_zero_on_single_digits(hour)}"#{selected}>#{leading_zero_on_single_digits(hour)}</option>\n)
      end
  
      select_html(options[:field_name] || 'hour', hour_options, options)
    end
  
    # Creates a meridian select box (AM/PM)
    def select_ampm(datetime, options = {})
      ampm_options = []
  
      ["AM", "PM"].each do |value|
        time = Time.local(0, 1, 1, datetime.nil? ? 0 : ((datetime.kind_of?(Fixnum)) ? datetime : datetime.hour))
        selected = (time.strftime("%p") == value) ? ' selected="selected"' : ''
        ampm_options << %(<option value="#{value}"#{selected}>#{value}</option>\n)
      end
  
      select_html(options[:field_name] || "ampm", ampm_options, options)
    end
    
    # Specifies the default field and text order for the datetime_select function
    DEFAULT_DATETIME_ORDER = [:year, :month, :day, "&mdash; ", :hour, " : ", :minute, " : ", :second].freeze
    DEFAULT_DATE_ORDER = [:year, :month, :day]
    DEFAULT_TIME_ORDER = [:hour, " : ", :minute]
    
    SELECT_HTML_OPTIONS = [:size, :disabled, :tabindex, :onfocus, :onblur, :onchange, :class, :style, :title, :lang, :dir].freeze #:nodoc:
    YEAR_OPTIONS = [:prefix, :start_year, :end_year].freeze #:nodoc:
    MONTH_OPTIONS = [:prefix, :use_month_numbers, :add_month_numbers].freeze #:nodoc:
    DAY_OPTIONS = [:prefix].freeze #:nodoc:
    HOUR_OPTIONS = [:prefix, :twelve_hour].freeze #:nodoc:
    MINUTE_OPTIONS = [:prefix, :minute_step].freeze #:nodoc:
    SECOND_OPTIONS = [:prefix].freeze #:nodoc:
    AMPM_OPTIONS = [:prefix].freeze #:nodoc:
  
    # Replaces original datetime_select with a more flexible version.  This includes
    # support for 12-hour time and arbitrary ordering of time parameters.
    #
    # ==== 12/24 hour time format
    # To use 12-hour time, set the option :twelve_hour => true.  An AM/PM select will be added
    # to the string if it is not included in the :order option.  :twelve_hour defaults to false/nil.
    #
    # ==== Specifying the output
    # The <tt>:order</tt> option is used to specify the order in which time parameters and
    # any intervening text are output. 
    #
    # Valid keys for the time parameters are:
    # <tt>:year, :month, :day, :hour, :minute, :second, :ampm</tt>. 
    # If <tt>:ampm</tt> occurs in the order, 12-hour time is used automatically (i.e. <tt>:twelve_hour => true</tt>). 
    # You may place any string into the <tt>:order</tt> array and it will be output without modification.
    #
    # ==== Examples
    #   datetime_select "object", "method"  # Uses default order
    #   datetime_select "object", "method", :twelve_hour => true # Uses default order with 12-hour time
    #   datetime_select "object", "method", :order => [:month, :day, " , ", :year] # Creates selects in format "[April][12] , [2006]" 
    #   datetime_select "object", "method", :order => [:month, :day, :hour, :ampm] # Automatically uses 12-hour time and outputs in the format "[April][12][12][PM]"
    def datetime_select(object, method, options = {})
      # extract the data from the object/method
      obj = self.instance_variable_get("@#{object}")
      return if obj.nil?
      m = obj.send(method)
      if m.nil?
        myTime = Time.now
      else
        if m.is_a?(Time) || m.is_a?(Date)
          myTime = m
        else
          myTime = Time.parse(m)
        end
      end
      select_datetime(myTime, options.merge({:prefix => "#{object}[#{method}]"}))
    end

    # Replaces original select_datetime with a more flexible version
    # Options are the same as with datetime_select.
    def select_datetime(datetime = Time.now, options = {})
      # include_blank not allowed!
      options.delete(:include_blank)
      order = options.delete(:order) || DEFAULT_DATETIME_ORDER.dup
      # Make sure it includes :ampm if 12-hour and vice-versa
      (options[:twelve_hour] =  true) if order.include?(:ampm)
      (order << :ampm) if options[:twelve_hour] && !order.include?(:ampm)
      
      outstring = ""
      # Call the non-instanced helpers in order
      select_by_key = Proc.new { |key| self.send("select_#{key.to_s}", datetime, cleanoptions(options, key)) }
      for key in order
        if key.is_a?(Symbol)
          outstring << select_by_key.call(key) rescue outstring << key.to_s
        else
          outstring << key.to_s 
        end
      end
      outstring
    end
    
    # Creates select boxes for the date, without the time.
    # This is a shortcut for calling datetime_select with
    # <tt>:order => [:year, :month, :day]</tt>.
    # You may also specify your own order, but <tt>:hour</tt>, <tt>:minute</tt>, <tt>:second</tt>, and <tt>:ampm</tt> will be removed.
    def date_select(object, method, options = {})  
      if !options[:order]
        options[:order] = [:year, :month, :day]
      else # don't allow time, just dates
        options[:order] = options[:order] - [:hour, :minute, :second, :ampm]
      end
      datetime_select(object, method, options)
    end

    # Returns HTML tags creating select boxes for the date, without the time.
    # This is a shortcut for calling select_datetime with
    # <tt>:order => [:year, :month, :day]</tt>.
    # You may also specify your own order, but <tt>:hour</tt>, <tt>:minute</tt>, <tt>:second</tt>, and <tt>:ampm</tt> will be removed.
    def select_date(date = Date.today, options = {})
      if !options[:order]
        options[:order] = [:year, :month, :day]
      else # don't allow time, just dates
        options[:order] = options[:order] - [:hour, :minute, :second, :ampm]
      end
      select_datetime(date, options)
    end
    
    # Creates select boxes for the time, without the date.
    # This is a shortcut for calling datetime_select with
    # <tt>:order => [:hour, " : ", :minute]</tt>.
    # You may also specify your own order, but <tt>:year</tt>, <tt>:month</tt>, and <tt>:day</tt> will be removed.
    # For compatibility with ActionView's select_time, the :include_seconds option is supported
    # but will be ignored if :order is specified.
    def time_select(object, method, options = {})
      if !options[:order]
        options[:order] = DEFAULT_TIME_ORDER
        options[:order] << ':' << :second if options[:include_seconds]
      else
        options[:order] = options[:order] - [:year, :month, :day]
      end
      datetime_select(object, method, options)
    end

    # Returns HTML tags creating select boxes for the time, without the date.
    # This is a shortcut for calling datetime_select with
    # <tt>:order => [:hour, " : ", :minute]</tt>.
    # You may also specify your own order, but <tt>:year</tt>, <tt>:month</tt>, and <tt>:day</tt> will be removed.
    # For compatibility with ActionView's select_time, the :include_seconds option is supported
    # but will be ignored if :order is specified.
    def select_time(datetime = Time.now, options = {})
      if !options[:order]
        options[:order] = DEFAULT_TIME_ORDER
        options[:order] << ':' << :second if options[:include_seconds]
      else
        options[:order] = options[:order] - [:year, :month, :day]
      end
      select_datetime(datetime, options)
    end

    def cleanoptions(options, param) #:nodoc:  
      validoptions = SELECT_HTML_OPTIONS.dup + FlexTimes::HelperMethods.const_get(param.to_s.upcase + "_OPTIONS").dup
      options.dup.delete_if {|key, value| !validoptions.include?(key)}
    end
  end

  
  
  # Extends Hash to convert a Hash object into Date or Time objects.
  module HashExtensions
    # Converts this Hash of date parameters (:year, :month, :day) into a Date object
    def to_date
      hsh = symbolize_keys
      [:year, :month, :day].each {|key| 
          raise ArgumentError, "Cannot convert to Date, missing #{key}" if !hsh.has_key?(key)
          hsh[key] = hsh[key].to_i
          }
      Date.new(hsh[:year], hsh[:month], hsh[:day])
    end
  
    # Converts this Hash of time parameters (:year, :month, :day, :hour, :minute, :second, :usec, :ampm)
    # into a Time object (using local time).  The Hash need not contain all parameters, but the
    # parameter of the current time is assumed when one is missing.  Includes support for 12-hour time.
    def to_time
      hsh = {:year => Time.now.year, :month => Time.now.month, :day => Time.now.day,
             :hour => Time.now.hour, :minute => Time.now.minute, :second => Time.now.second,
             :usec => Time.now.usec, :ampm => "" }
      hsh = hsh.update(self.symbolize_keys)
      [:year, :month, :day, :hour, :minute, :second, :usec].each {|key| hsh[key] = hsh[key].to_i }
      hsh[:hour] = 0 if hsh[:ampm].downcase == "am" && hsh[:hour] == 12
      hsh[:hour] += 12 if hsh[:ampm].downcase == "pm" && hsh[:hour] != 12
      Time.local(hsh[:year], hsh[:month], hsh[:day], hsh[:hour], hsh[:minute], hsh[:second], hsh[:usec])
    end
  end

  # Defines an extension to Date that converts a Date object into a Hash
  module DateExtensions
    # Converts the Date into a Hash
    def to_hash
      {:year => year, :month => month, :day => day}
    end  
  end
  
  # Defines an extension to Time that converts a Time object into a Hash
  module TimeExtensions
    # Converts the Time into a Hash
    def to_hash
      {:year => year, :month => month, :day => day, :hour => hour, :minute => minute, :second => second, :usec => usec }
    end 
  end
end

module ActiveRecord
  class Base
  #    alias :old_write_attribute :write_attribute    
  private
    def write_attribute(attr_name, value) #:nodoc:
      attr_name = attr_name.to_s
      column = column_for_attribute(attr_name)
      if value.is_a?(Hash) && column
        if column.klass == Date  # takes place of date_column
          @attributes[attr_name] = Date.today.to_hash.update(value.symbolize_keys).to_date
        elsif column.klass == Time # takes place of time_column and datetime_column
          @attributes[attr_name] = value.to_time
        else
          @attributes[attr_name] = value
        end
      elsif column && column.number?
        @attributes[attr_name] = convert_number_column_value(value)
      else
        @attributes[attr_name] = value
      end
    end 
  end
end



module ActionView
  module Helpers
    module DateHelper #:nodoc:
      alias :old_datetime_select :datetime_select
      alias :old_date_select :date_select
      alias :old_select_datetime :select_datetime
      alias :old_select_date :select_date
      alias :old_select_time :select_time
    end
  end
end

ActionView::Base.class_eval do
   include FlexTimes::HelperMethods
end

Time.class_eval do #:nodoc:
    alias :minute :min #:nodoc:
    alias :second :sec #:nodoc:
    include FlexTimes::TimeExtensions
end 

Date.class_eval do #:nodoc:
  include FlexTimes::DateExtensions 
end

Hash.class_eval do #:nodoc:
  include FlexTimes::HashExtensions 
end
