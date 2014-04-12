class Seed
  def self.run
    Dir['db/seeds/*'].each do |gallery_path|
      gallery = File.basename(gallery_path)

      Dir["db/seeds/#{gallery}/*.jpg"].each do |path|
        image       = Rack::Test::UploadedFile.new(path, 'image/jpeg')
        description = description_for(path)
        name        = File.basename(path, '.jpg').titleize

        Jewellery.create(gallery: gallery.titleize, description: description, name: name)
      end
    end
  end

  def self.description_for(path)
    File.read(path.gsub('jpg', 'txt')).chomp
  rescue Errno::ENOENT => e
    'No description.'
  end
end
