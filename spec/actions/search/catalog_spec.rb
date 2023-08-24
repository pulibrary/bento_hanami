# frozen_string_literal: true

RSpec.describe BentoHanami::Actions::Search::Catalog do
  let(:params) { { query: 'rubix' } }

  it "works" do
    response = subject.call(params)
    expect(response).to be_successful
  end
end
