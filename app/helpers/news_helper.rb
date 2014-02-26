module NewsHelper
  def category_as_class_name category
    category.gsub('&', 'and').downcase.parameterize
  end
end
