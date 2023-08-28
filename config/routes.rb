# frozen_string_literal: true

module BentoHanami
  class Routes < Hanami::Routes
    root { "Hello from Hanami" }
    get "/search/catalog", to: "search.catalog"
    get "/search/summon", to: "search.summon"
  end
end
