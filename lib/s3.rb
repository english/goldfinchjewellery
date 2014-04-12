require "s3/string_to_sign"
require "s3/signature"
require "s3/put"
require "s3/delete"

module S3
  class S3Error < StandardError; end

  Configuration = Struct.new(:access_key_id, :secret_access_key_id)

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure(&block)
    yield configuration
  end
end
