# frozen_string_literal: true

RSpec.describe BentoHanami::Actions::Search::Summon do
  let(:params) { {} }

  it "works" do
    pending("Figuring out Summon authentication with Gem")
    response = subject.call(params)
    expect(response).to be_successful
  end
end
