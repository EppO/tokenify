require 'spec_helper'

module Tokenify
  describe Token do
    subject { token_instance }
    
    let(:secret) { SecureRandom.hex }
    let(:salt) { SecureRandom.hex }
    let(:data) { "this is secret data. Don't let the NSA see this." }
    
    let(:token_instance) { Token.new(secret, salt, data) }
    let(:encrypted_token) { token_instance.generate }
    
    describe "#new" do
      it "creates a new token instance" do
        expect(subject).to be_kind_of(Token)
      end
      
      it "sets secret instance variable" do
        expect(subject.instance_variable_get(:@secret)).to eq(secret)
      end
      
      it "sets salt instance variable" do
        expect(subject.instance_variable_get(:@salt)).to eq(salt)
      end
      
      it "sets data instance variable" do
        expect(subject.instance_variable_get(:@data)).to eq(data)
      end
    end
    
    describe "#generate" do
      let(:another_token) { Token.new(secret, salt, data).generate }
      
      it "creates a unique encrypted token" do
        expect(subject.generate).to_not eq(another_token)
      end
    end
    
    describe "#encoded" do
      let(:encoded_token) { encrypted_token.encoded }
      
      it "creates a unique encrypted token" do
        expect(encoded_token).to eq(Base64.urlsafe_encode64(encrypted_token.encrypted))
      end
    end
    
    describe "#decrypt" do
      context "with a good key and a good salt" do
        subject { Token.new(secret, salt, encrypted_token.encoded) }
      
        it "decrypts successfully the token" do
          expect(subject.decrypt).to eq(data)
        end
      end
      
      context "with a good key and a good salt and a token not encoded" do
        subject { Token.new(secret, salt, encrypted_token.encrypted) }
      
        it "decrypts successfully the token" do
          expect(subject.decrypt(false)).to eq(data)
        end
      end
      
      context "with a bad secret key" do
        subject { Token.new(bad_secret, salt, encrypted_token.encoded) }
      
        let(:bad_secret) { SecureRandom.hex }
        
        it "raises a decryption error" do
          expect { subject.decrypt }.to raise_error(OpenSSL::Cipher::CipherError)
        end
      end
      
      context "with a bad secret salt" do
        subject { Token.new(secret, bad_salt, encrypted_token.encoded) }
        
        let(:bad_salt) { SecureRandom.hex }
        
        it "raises a decryption error" do
          expect { subject.decrypt }.to raise_error(OpenSSL::Cipher::CipherError)
        end
      end
    end
  end
end