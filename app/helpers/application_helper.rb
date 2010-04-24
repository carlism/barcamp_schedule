# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def set_focus(id)
    javascript_tag("$('#{id}').focus()")
  end
  
  def linkify(text)
    gsub(/@(\w+)/, '<a href="http://twitter.com/\1">@\1</a>') if text
  end
end
