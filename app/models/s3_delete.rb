class S3Delete
  def initialize(url)
    @uri = URI(url)
    @access_key_id = ENV['AWS_ACCESS_KEY_ID']
    @secret_access_key_id = ENV['AWS_SECRET_ACCESS_KEY']
  end

  def execute
    http = Net::HTTP.new(@uri.host)
    request = Net::HTTP::Delete.new(@uri.path)
    request['Date'] = Time.now.httpdate
    request['Authorization'] = "AWS #{@access_key_id}:#{signature}"
    response = http.request(request)

    raise "Something went wrong: #{response.body}" unless response.code.starts_with?('2')
  end

  private

  def signature
    S3Signature.new(@secret_access_key_id, string_to_sign).execute
  end

  def string_to_sign
    canonicalized_resource = "/goldfinchjewellery#{@uri.path}"
    S3StringToSign.new(canonicalized_resource, verb: 'DELETE').execute
  end
end
