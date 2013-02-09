class S3Image
  def initialize file
    @original_filename = file.original_filename
    @path = file.path
  end

  def store!
    now = Time.now
    http = Net::HTTP.new("goldfinchjewellery.s3-eu-west-1.amazonaws.com")
    request = Net::HTTP::Put.new('/' + @original_filename)

    auth = S3AuthorizationHeader.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'], @original_filename, now)
    request['Authorization']  = auth.value
    request['Date']           = now.httpdate
    request['Content-Type']   = content_type
    request['Content-Length'] = File.open(@path).lstat.size

    request.body_stream = File.open(@path)
    response = http.request(request)
  end

  def url
    "http://goldfinchjewellery.s3-eu-west-1.amazonaws.com/#{@original_filename}"
  end

  private

  def content_type
    case File.extname(@original_filename)
    when '.jpg' then 'image/jpeg'
    when '.png' then 'image/png'
    else
      raise "Unsupported File Type"
    end
  end
end
