# frozen_string_literal: true

require 'pry'
require_relative '../src/0_guild_intro.rb'
require 'spec_helper'

describe 'GuildIntro' do
  context '#create_and_run_ractor' do
    let(:arg) { 'iasc' }

    subject { create_and_run_ractor(arg) }

    it 'does return the same value' do
      expect(subject.take).to eq('iasc')
    end

    it 'should raise an error if we try to do two takes' do
      r = subject
      r.take
      expect { r.take }.to raise_error(Ractor::ClosedError)
    end
  end

  context '#receive_only_strings_ractor' do
    let(:ractor) { subject }

    subject { receive_only_strings_ractor }

    it 'does not ' do
      
    end
  end
end

