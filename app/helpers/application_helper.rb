module ApplicationHelper
  def navigation(links)
    links.map { |link_text, link_target|
      content_tag :li, list_item_options_for(link_text, link_target) do
        link_to link_text, link_target
      end
    }.join("\n")
  end

  def list_item_options_for(link_text, link_target)
    { class: 'current' } if link_target == request.fullpath ||
                            link_text == 'Gallery' && within_galleries_resource?
  end

  private

  def within_galleries_resource?
    request.fullpath.split('/').second == 'galleries'
  end
end
