# frozen_string_literal: true

query = ARGV[0]

exit 1 if query.strip.empty?

require 'json'

results = JSON.parse `/usr/local/bin/googler --json -n 9 -w docs.github.com #{query}`

output = {
  items: results.map do |result|
    host = URI.parse(result['url']).host
    url_cleaned = result['url'].sub("en/","")

    {
      title: result['title'],
      subtitle: [result['metadata'], result['abstract']].compact.join(' '),
      arg: url_cleaned,
      quicklookurl: url_cleaned,
      autocomplete: result['title'],
      largetype: result['title'],
      mods: {
        alt: {
          valid: true,
          subtitle: result['title']
        },
        cmd: {
          valid: true,
          subtitle: url_cleaned
        }
      }
    }
  end
}

output = { items: [{ title: "No results for '#{query}'." }] } if output[:items].empty?

puts output.to_json
