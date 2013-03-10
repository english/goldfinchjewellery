module S3
  class Put
    BUCKET = 'goldfinchjewellery'
    REGION = 's3-eu-west-1'
    HOST   = 'amazonaws.com'
    DOMAIN = [BUCKET, REGION, HOST].join('.')

    def initialize(file)
      @file = file
      @access_key_id = ENV['AWS_ACCESS_KEY_ID']
      @secret_access_key_id = ENV['AWS_SECRET_ACCESS_KEY']
    end

    def execute
      http = Net::HTTP.new(DOMAIN)
      request = Net::HTTP::Put.new(path)
      request.initialize_http_header(headers)
      request.body_stream = File.open(@file.path)

      response = http.request(request)

      raise "Upload error: #{response.code}" unless response.code == '200'
    end

    def url
      "http://#{DOMAIN}/#{@file.original_filename}"
    end

    private

    def headers
      { 'Authorization'  => "AWS #{@access_key_id}:#{signature}",
        'Date'           => Time.now.httpdate,
          'Content-Type'   => content_type,
          'Content-Length' => content_length }
    end

    def path
      '/' + @file.original_filename
    end

    def content_type
      extension = File.extname(@file.original_filename).gsub('.', '')
      raise 'Unsupported File Type' unless extension.in? %w( jpg png gif )

      Mime[extension].to_s
    end

    def content_length
      File.open(@file.path).lstat.size.to_s
    end

    def signature
      S3::Signature.new(@secret_access_key_id, string_to_sign).execute
    end

    def string_to_sign
      canonicalized_resource = "/#{BUCKET}/#{@file.original_filename}"
      S3::StringToSign.new(canonicalized_resource, verb: 'PUT', content_type: content_type).execute
    end
  end
end
