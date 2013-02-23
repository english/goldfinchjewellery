class S3Image
  BUCKET = 'goldfinchjewellery'
  REGION = 's3-eu-west-1'
  HOST   = 'amazonaws.com'

  def initialize(file)
    @file = file
  end

  def store!
    http = Net::HTTP.new(domain)
    http.request(put_request)
  end

  def url
    "http://#{domain}/#{@file.original_filename}"
  end

  private

  def domain
    "#{BUCKET}.#{REGION}.#{HOST}"
  end

  def put_request
    path = '/' + @file.original_filename
    request = Net::HTTP::Put.new(path)
    headers = S3Headers.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'], @file)

    request.initialize_http_header(headers.to_hash)
    request.body_stream = File.open(@file.path)

    request
  end
end
