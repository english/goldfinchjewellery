module S3
  class StringToSign
    def initialize(canonicalized_resource, verb: 'GET', date: Time.now.httpdate, content_type: '', content_md5: '')
      @canonicalized_resource = canonicalized_resource
      @verb = verb
      @date = date
      @content_type = content_type
      @content_md5 = content_md5
    end

    def call
      [@verb, @content_md5, @content_type, @date, @canonicalized_resource].join("\n")
    end
  end
end
