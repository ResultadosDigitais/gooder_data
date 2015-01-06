require 'spec_helper'

describe GooderData::ApiClient, :vcr do

  let(:user) { 'user@example.org' }
  let(:password) { 'my_password' }

  let(:client) { GooderData::ApiClient.new }

  describe "#login" do
    subject(:login) { client.login(user, password) }
    let(:sst) { login }

    context "when the user and the password are correct" do
      it "should login successfully" do
        login.to_s.should_not be_empty
      end

      it "should return the super secure token" do
        sst.should eq 'M0ckEdSST0000001'
      end
    end

    context "when the user and the password are incorrect" do
      let(:user) { 'wrong_user@mail.com' }
      let(:password) { 'wrongpassword' }
      it "should raise error" do
        expect { login }.to raise_error "wrong user or password for user #{ user }"
      end
    end
  end

  shared_examples "login is required" do
    context "when there are no logged user" do
      it "should raise error instructing to login first" do
        expect { subject }.to raise_error "login is required at this point: please inform the super_secure_token (SST) or call login! first"
      end
    end
  end

  describe "#api_token" do
    subject(:api_token) { client.api_token }

    it_behaves_like "login is required"

    context "when there are logged user" do
      before { client.login!(user, password) }

      it "should get api token successfully" do
        api_token.to_s.should_not be_empty
      end

      it "should return the temporary token as api token" do
        api_token.should eq 'pd4bZoguqAWDpNPliomGRVvGA_CoCSOki6IKfOFDiJhJuvwyIs3dlyi8oiCdpDUa1dPIHXm18DPfvaFQfSqst57WoeepmOkMdepsJ-Y9jyZAPk0nNI8A8QqRMS8LFnH4O_aaOqdZO_RD8t_y3hyTm2AWz2g75FQlx8FbFwsaR7t7InYiOjE0MDAyNzAzMzEsInUiOiI2NjYzODAiLCJsIjoiMCIsImsiOiI0MTZlODFlMS1iZTFhLTRkMTQtYWYwNS01OWIyOTcwODdlMzcifQ'
      end
    end
  end

  describe "#api_to" do
    subject(:api_to) do
      client.api_to("retrieve profile's first name") do |options|
        client.get("/account/profile/m0ckedpr0f1le0000000000000000001")
      end.that_responds do |response|
        response['accountSetting']['firstName']
      end
    end

    it_behaves_like "login is required"

    context "when there are logged user" do
      before { client.login!(user, password) }

      context "and the api token were not given" do
        it "should raise error instructing to request api token first" do
          expect { subject }.to raise_error "api token is required at this point: please inform the api_token (temporary token - TT) or call api_token! first"
        end
      end

      context "and the api token were set" do
        before { client.api_token! }

        it "should execute successfully" do
          expect(client).to receive(:get).with("/account/profile/m0ckedpr0f1le0000000000000000001").and_call_original
          expect(api_to).to eq 'John'
        end
      end
    end
  end

  describe "#retry_api_to" do
    subject(:retry_api_to) do
      client.retry_api_to("retrieve profile's first name") do |options|
        client.get("/api/path")
      end.parsed_response
    end

    it_behaves_like "login is required"

    context "when there are logged user" do
      before { client.login!(user, password) }

      context "and the api token were not given" do
        it "should raise error instructing to request api token first" do
          expect { subject }.to raise_error "api token is required at this point: please inform the api_token (temporary token - TT) or call api_token! first"
        end
      end

      context "and the api token were set" do

        before { client.api_token! }

        context "and the response is success in the first time" do
          xit "should execute successfully" do
            expect(client).to receive(:get).with("/api/path").and_return response(200, 'John')
            expect(retry_api_to).to eq 'John'
          end
        end

        context "and the response is still processing (code: 202)" do
          xit "should retry the api call" do
            times_to_be_retried = 3
            times_called = 0
            expect(client).to receive(:get).with("/api/path").exactly(4).times do
              times_called += 1
              if times_called > times_to_be_retried
                response(200, 'John')
              else
                response(202, nil)
              end
            end
            expect(client.options).to receive(:require).with(:max_retries).and_return 10
            expect(client.options).to receive(:require).with(:retry_delay_in_seconds).exactly(3).times.and_return 0.33
            expect(client).to receive(:sleep).with(0.33).exactly(3).times
            expect(retry_api_to).to eq 'John'
          end

          xit "should call the api 'max_retries' + 1 times and return the last response" do
            times_called = 0
            expect(client).to receive(:get).with("/api/path").exactly(6).times do
              times_called += 1
              response(202, times_called)
            end
            allow(client.options).to receive(:require).and_call_original
            expect(client.options).to receive(:require).with(:max_retries).and_return 5
            expect(client).to receive(:sleep).exactly(6).times
            expect(retry_api_to).to eq 6
          end
        end
      end
    end

    def response(code, parsed_response)
      response = double(:response)
      allow(response).to receive(:parsed_response).and_return parsed_response
      allow(response).to receive(:code).and_return code
      response
    end

  end

end
