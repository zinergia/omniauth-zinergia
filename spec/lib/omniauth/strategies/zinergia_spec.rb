require "spec_helper"

describe OmniAuth::Strategies::Zinergia do
  let(:app){ Rack::Builder.new do |b|
    b.use Rack::Session::Cookie, {:secret => "abc123"}
    b.run lambda{|env| [200, {}, ['Not Found']]}
  end.to_app }

  let(:request) { double('Request').stub(params: {}, cookies: {}, env: {}) }
  let(:session) { double('Session')..stub(:delete).with('omniauth.state').and_return('state') }

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  subject do
    OmniAuth::Strategies::Zinergia.new(app,"client_id", "client_secret").tap do |strategy|
      strategy.stub(:request) { request }
    end
  end

  context "request phase" do
    before(:each){ get '/auth/zinergia' }

    it "authenticate" do
      expect(last_response.status).to eq(200)
    end
  end

  describe "callback phase" do
    before :each do
      @raw_info = {
        "id" => "10",
        "email" => "user@mail.com",
        "name" => "Nicolás Hock Isaza",
        "links" => [
          {
            "url" => "some_url",
            "rel" => "self",
            "description" => "Logged in user's information."
          }
        ]
      }
      subject.stub(:raw_info) { @raw_info }
    end

    context "info" do
      it 'returns the uid (required)' do
        subject.uid.should eq('10')
      end

      it 'returns the name (required)' do
        subject.info[:name].should eq('Nicolás Hock Isaza')
      end

      it 'returns the email' do
        subject.info[:email].should eq('user@mail.com')
      end
    end
  end

  context "get token" do
    before :each do
      @access_token = double('OAuth2::AccessToken')
      @access_token.stub(:token)
      @access_token.stub(:expires?)
      @access_token.stub(:expires_at)
      @access_token.stub(:refresh_token)
      subject.stub(:access_token) { @access_token }
    end

    it 'returns a Hash' do
      subject.credentials.should be_a(Hash)
    end

    it 'returns the token' do
      @access_token.stub(:token) {
        {
          :access_token => "OTqSFa9zrh0VRGAZHH4QPJISCoynRwSy9FocUazuaU950EVcISsJo3pST11iTCiI",
          :token_type => "bearer"
        } }
      subject.credentials['token'][:access_token].should eq('OTqSFa9zrh0VRGAZHH4QPJISCoynRwSy9FocUazuaU950EVcISsJo3pST11iTCiI')
      subject.credentials['token'][:token_type].should eq('bearer')
    end
  end
end