module S3
  class Delete
    def self.call(url)
      new(url).call
    end

    attr_reader :uri, :config

    def initialize(url, config: S3.configuration)
      @uri = URI(url)
      @config = config
    end

    def call
      http = Net::HTTP.new(uri.host)
      request = Net::HTTP::Delete.new(uri.path)
      request.initialize_http_header(headers)
      response = http.request(request)

      raise S3Error, response.body unless response.code.starts_with?('2')
    end

    private

    def headers
      { 'Date'          => Time.now.httpdate,
        'Authorization' => "AWS #{config.access_key_id}:#{signature}" }
    end

    def signature
      S3::Signature.new(string_to_sign).call
    end

    def string_to_sign
      canonicalized_resource = "/goldfinchjewellery#{uri.path}"
      S3::StringToSign.new(canonicalized_resource, verb: 'DELETE').call
    end
  end
end
