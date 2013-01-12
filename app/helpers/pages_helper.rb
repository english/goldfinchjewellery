module PagesHelper
  def navigation links
    links.map { |link_text, path|
      content_tag :li, list_item_options_for(link_text) do
        link_to link_text, path
      end
    }.join "\n"
  end

  def list_item_options_for text
    { class: 'current' } if current_page? controller: 'pages', action: text.parameterize.underscore
  end
end
