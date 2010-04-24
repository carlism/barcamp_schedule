# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def set_focus(id)
    javascript_tag("$('#{id}').focus()")
  end
  
  def linkify(text)
    text.gsub(/\s@(\w+)/, ' <a target="_blank" href="http://twitter.com/\1">@\1</a>')
      .gsub(/^@(\w+)/, ' <a target="_blank" href="http://twitter.com/\1">@\1</a>') if text
  end
end
