# frozen_string_literal: true

module BentoHanami
  class Routes < Hanami::Routes
    root { "Hello from Hanami" }
    get "/search/catalog", to: "search.catalog"
    get "/search/dpul", to: "search.dpul"
    get "/search/dpul", to: "search.dpul"
    get "/search/findingaids", to: "search.findingaids"
  end
end
