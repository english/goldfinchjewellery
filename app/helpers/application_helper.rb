module ApplicationHelper
  def navigation links
    links.map { |link_text, path|
      content_tag :li, list_item_options_for(path) do
        link_to link_text, path
      end
    }.join "\n"
  end

  def list_item_options_for path
    { class: 'current' } if request.fullpath == path
  end
end
