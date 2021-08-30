# frozen_string_literal: true

require 'pry'
require_relative '../src/1_pipeline.rb'
require 'spec_helper'

describe RactorPipelineExample do
  let(:initial_message) { 'r0' }
  let(:expected_message) { "r3r2r1#{initial_message}" }

  subject { described_class.new.ractor1 << initial_message }

  it 'should return the expected message' do
    puts described_class.new.ractor1
    subject
    expect(Ractor.receive).to eq(expected_message)
  end
end




