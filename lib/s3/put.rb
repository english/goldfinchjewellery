module S3
  class Put
    def self.call(file)
      new(file).call
    end

    attr_reader :file, :config

    BUCKET = 'goldfinchjewellery'
    REGION = 's3-eu-west-1'
    HOST   = 'amazonaws.com'
    DOMAIN = [BUCKET, REGION, HOST].join('.')

    def initialize(file, config: S3.configuration)
      @file = file
      @config = config
    end

    def call
      http = Net::HTTP.new(DOMAIN)
      request = Net::HTTP::Put.new(path)
      request.initialize_http_header(headers)
      request.body_stream = File.open(file.path)

      response = http.request(request)

      raise S3Error, response.body unless response.code.start_with?('2')

      url
    end

    private

    def url
      "http://#{DOMAIN}/#{file.original_filename}"
    end

    def headers
      { 'Authorization'  => "AWS #{config.access_key_id}:#{signature}",
        'Date'           => Time.now.httpdate,
        'Content-Type'   => content_type,
        'Content-Length' => content_length }
    end

    def path
      '/' + file.original_filename
    end

    def content_type
      extension = File.extname(file.original_filename).gsub('.', '')
      raise 'Unsupported File Type' unless extension.in? %w( jpg png gif )

      Mime[extension].to_s
    end

    def content_length
      File.open(file.path).lstat.size.to_s
    end

    def signature
      S3::Signature.new(string_to_sign).call
    end

    def string_to_sign
      canonicalized_resource = "/#{BUCKET}/#{file.original_filename}"
      S3::StringToSign.new(canonicalized_resource, verb: 'PUT', content_type: content_type).call
    end
  end
end
