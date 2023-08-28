# frozen_string_literal: true

require 'summon'

module BentoHanami
  module Actions
    module Search
      class Summon < BentoHanami::Action
        include Deps["summon_client"]
        def handle(request, response)
          halt 422, { errors: request.params.errors }.to_json unless request.params.valid?

          query_terms = request.params[:query]
          summon_response = summon_response(query_terms:)
          response.format = :json
          response.body = our_response(summon_response:, query_terms:)
        end

        def our_response(summon_response:, _query_terms:)
          {
            number: number(summon_response:),
            more: 'val',
            records: ['val']
          }.to_json
        end

        # https://princeton.summon.serialssolutions.com/search?s.q=pangulubalang&s.fvf=ContentType,Newspaper+Article,t&keep_r=true&s.dym=t&s.ho=t
        def summon_response(query_terms:)
          summon_client.search(
            's.q': query_terms,
            's.fvf': "ContentType,Newspaper+Article,t",
            keep_r: "true",
            's.dym': "t",
            's.ho': "t"
          )
          # foo = summon_client.search("s.q": query_terms, "s.fvf": "ContentType,Newspaper+Article,t")
          # foo = summon_client.search("s.q" => "Elephants", "s.fvf" => "ContentType,Book")
        end

        def number(_summon_response:)
          414
        end
      end
    end
  end
end
