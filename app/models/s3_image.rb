class S3Image
  def initialize file
    @file = file
  end

  def store!
    http = Net::HTTP.new("goldfinchjewellery.s3-eu-west-1.amazonaws.com")
    request = Net::HTTP::Put.new('/' + @file.original_filename)

    headers = S3Headers.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'], @file)
    request.initialize_http_header(headers.to_hash)

    request.body_stream = File.open(@file.path)
    response = http.request(request)
  end

  def url
    "http://goldfinchjewellery.s3-eu-west-1.amazonaws.com/#{@file.original_filename}"
  end
end
