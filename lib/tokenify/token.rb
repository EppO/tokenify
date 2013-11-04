require 'openssl'
require 'base64'

module Tokenify
  class Token
    attr_reader :encrypted, :plain
  
    def initialize(secret, salt, data)
      @secret = secret
      @salt = salt
      @data = data
    end
  
    def self.cipher(mode, key, data, iv = nil)
      cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc').send(mode)
      cipher.key = Digest::SHA256.hexdigest(key)
      if iv 
        cipher.iv = iv
        cipher.update(data) << cipher.final
      else
        cipher.iv = iv = cipher.random_iv
        iv + cipher.update(data) + cipher.final
      end
    end

    def generate
      @encrypted = Token.cipher(:encrypt, "#{@secret}:#{@salt}", @data)
      self
    end
  
    def encoded
      Base64.urlsafe_encode64(@encrypted)
    end

    def decrypt(is_encoded = true)
      decoded = is_encoded ? Base64.urlsafe_decode64(@data) : @data
      iv = decoded.slice!(0,16)
      @plain = Token.cipher(:decrypt, "#{@secret}:#{@salt}", decoded, iv)
    end
  end
end