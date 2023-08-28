# frozen_string_literal: true

RSpec.describe BentoHanami::Actions::Search::Dpul do
  let(:params) { { query: 'cats' } }

  it "works" do
    response = subject.call(params)
    expect(response).to be_successful
  end
end
