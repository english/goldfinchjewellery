module ApplicationHelper
  def navigation links
    links.map { |link_text, path|
      content_tag :li, list_item_options_for(link_text, path) do
        link_to link_text, path
      end
    }.join "\n"
  end

  def list_item_options_for link_text, path
    first_part_of_path       = request.fullpath.split('/').second
    path_minus_leading_slash = path[1..-1]

    { class: 'current' } if first_part_of_path == path_minus_leading_slash || (link_text == 'About' && request.fullpath == '/')
  end

  def logged_in?
    session[:user_id]
  end
end
