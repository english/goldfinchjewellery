categories = YAML.load_file(File.expand_path('seed_data.yml', File.dirname(__FILE__)))

categories.each do |category, news|
  news.each do |content|
    News.create(category: category, content: content)
  end
end

User.create(email: 'someone@example.org', password: 'secret')

Seed.run
