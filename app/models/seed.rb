class Seed
  def self.run
    Dir['db/seeds/birds/*.jpg'].each do |path|
      image = Rack::Test::UploadedFile.new(path, 'image/jpeg')
      description = description_for(path)

      Jewellery.create!(gallery: 'Birds', image: image, description: description, name: 'name')
    end
  end

  def self.description_for(path)
    File.read(path.gsub('jpg', 'txt'))
  rescue Errno::ENOENT => e
    "No description."
  end
end
