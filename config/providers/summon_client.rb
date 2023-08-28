# frozen_string_literal: true

Hanami.app.register_provider(:summon_client) do
  prepare do
    require 'summon'
  end

  start do
    # Invalid ID, secret key or client hash
    client = Summon::Service.new(
      access_id: 'princeton',
      secret_key: Hanami.app["settings"].summon_authcode
    )

    register "summon_client", client
  end
end
