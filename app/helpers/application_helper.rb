# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def set_focus(id)
    javascript_tag("$('#{id}').focus()")
  end
  
  def linkify(text)
    if text
      text = text.gsub(/\s@(\w+)/, ' <a target="_blank" href="http://twitter.com/\1">@\1</a>') 
      text = text.gsub(/^@(\w+)/, '<a target="_blank" href="http://twitter.com/\1">@\1</a>') 
    end
    text
  end
end
