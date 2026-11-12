#!/usr/bin/env ruby
# frozen_string_literal: true

require "jekyll"
require "tmpdir"
require_relative "../_plugins/markdown_source"

source = File.expand_path("..", __dir__)
destination = File.join(Dir.mktmpdir, "site")
site = Jekyll::Site.new(Jekyll.configuration("source" => source, "destination" => destination))

def render(site, template)
  site.liquid_renderer
      .file("markdown-embed-test-#{template.hash}")
      .parse(template)
      .render!(site.site_payload, registers: { site: site })
end

def assert(condition, message)
  raise message unless condition
end

file_embed = render(site, <<~LIQUID)
  {% include components/markdown-embed.html label="Ship log" path="_embedded/2026-11-12-last-pull-logbook.md" %}
LIQUID
assert(file_embed.include?('class="markdown-embed"'), "Markdown panel was not rendered")
assert(file_embed.match?(/<h1\b[^>]*>⚓ Ship’s Log — Last Pull<\/h1>/), "Markdown heading was not rendered")
assert(file_embed.include?("<strong>Voyage:</strong>"), "Markdown formatting was not rendered")
assert(file_embed.include?("<blockquote>"), "Markdown blockquote was not rendered")

inline_embed = render(site, <<~LIQUID)
  {% capture document %}{% raw %}## Plan

  - Check links

  <script>alert(1)</script>{% endraw %}{% endcapture %}
  {% include components/markdown-embed.html label="Plan" content=document %}
LIQUID
assert(inline_embed.match?(/<h2\b[^>]*>Plan<\/h2>/), "Captured Markdown heading was not rendered")
assert(inline_embed.include?("<li>Check links</li>"), "Captured Markdown list was not rendered")
assert(!inline_embed.include?("<script>"), "Embedded HTML was not escaped")

begin
  render(site, '{% include components/markdown-embed.html label="Invalid" path="/etc/passwd" %}')
  raise "Absolute source path was accepted"
rescue Jekyll::Errors::FatalException
  # An embed must stay inside the repository.
end

puts "Embedded Markdown checks passed."
