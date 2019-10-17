# frozen_string_literal: true

require 'spec_helper'
require 'omniauth-parallelmarkets'

describe OmniAuth::Strategies::ParallelMarkets do
  let(:request) do
    double('Request', params: {}, cookies: {}, env: {})
  end

  let(:app) do
    -> { [200, {}, ['Hello.']] }
  end

  subject do
    OmniAuth::Strategies::ParallelMarkets.new(app, 'appid', 'secret', @options || {}).tap do |strategy|
      allow(strategy).to receive(:request) { request }
    end
  end

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  it 'has a version number' do
    expect(OmniAuth::ParallelMarkets::VERSION).not_to be nil
  end

  describe '#client_options' do
    it 'has correct site' do
      expect(subject.client.site).to eq('https://api.parallelmarkets.com')
    end

    it 'has correct authorize_url' do
      expect(subject.client.options[:authorize_url]).to eq('/v1/oauth/authorize')
    end

    it 'has correct token_url' do
      expect(subject.client.options[:token_url]).to eq('/v1/oauth/token')
    end
  end

  describe '#callback_path' do
    it 'has the correct callback path' do
      expect(subject.callback_path).to eq('/auth/parallelmarkets/callback')
    end
  end

  describe '#uid' do
    before :each do
      allow(subject).to receive(:raw_info) { { 'id' => 'a unique id' } }
    end

    it 'returns the id from raw_info' do
      expect(subject.uid).to eq('a unique id')
    end
  end

  describe '#info' do
    before :each do
      allow(subject).to receive(:raw_info) { {} }
    end

    context 'has all the necessary fields' do
      it { expect(subject.info).to have_key :name }
      it { expect(subject.info).to have_key :first_name }
      it { expect(subject.info).to have_key :last_name }
      it { expect(subject.info).to have_key :email }
    end
  end

  describe '#extra' do
    before :each do
      allow(subject).to receive(:raw_info) { { 'type' => 'individual' } }
      allow(subject).to receive(:raw_accreditations) { { 'accreditations' => [{ id: 123 }] } }
    end
    it 'should return correct extra data' do
      expect(subject.extra[:accreditations]).to eq([{ id: 123 }])
      expect(subject.extra[:type]).to eq('individual')
    end
  end

  describe '#raw_info' do
    before :each do
      access_token = double('access token')
      response = double('response', parsed: { first_name: 'Snake' })
      expect(access_token).to receive(:get).with('/v1/me').and_return(response)
      allow(subject).to receive(:access_token) { access_token }
    end

    it 'returns parsed response from access token' do
      expect(subject.send(:raw_info)).to eq(first_name: 'Snake')
    end
  end

  describe '#access_token' do
    before :each do
      response = double('access token',
                        access_token: 'access_token',
                        refresh_token: 'refresh_token',
                        expires_in: 3600,
                        expires_at: 12_345).as_null_object
      allow(subject).to receive(:access_token) { response }
    end

    it { expect(subject.access_token.access_token).to eq('access_token') }
    it { expect(subject.access_token.expires_in).to eq(3600) }
    it { expect(subject.access_token.expires_at).to eq(12_345) }
    it { expect(subject.access_token.refresh_token).to eq('refresh_token') }
  end
end
