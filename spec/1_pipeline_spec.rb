# frozen_string_literal: true

require 'pry'
require_relative '../src/1_pipeline.rb'
require 'spec_helper'

describe RactorPipelineExample do
  let(:initial_message) { 'r0' }
  let(:expected_message) { "#{initial_message}r1r2r3" }

  subject { described_class.new.ractor1.send(initial_message) }

  it 'should return the expected message' do
    subject
    expect(Ractor.receive).to eq(expected_message)
  end
end




