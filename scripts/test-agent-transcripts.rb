#!/usr/bin/env ruby
# frozen_string_literal: true

require "cgi"
require "jekyll"
require "tmpdir"

source = File.expand_path("..", __dir__)
destination = File.join(Dir.mktmpdir, "site")
site = Jekyll::Site.new(Jekyll.configuration("source" => source, "destination" => destination))

def render(site, source)
  site.liquid_renderer
      .file("agent-transcript-test-#{source.hash}")
      .parse(source)
      .render!(site.site_payload, registers: { site: site })
end

def assert(condition, message)
  raise message unless condition
end

transcript = "  npm run test -- --grep '🧪'\n{{ variable }}\n<script>const value = \"hello\";</script>\n"
rendered_message = render(site, <<~LIQUID)
  {% capture transcript %}{% raw %}#{transcript}{% endraw %}{% endcapture %}
  {% include agent-message.html role="tool" content=transcript %}
LIQUID

encoded_message = rendered_message.match(/<code>(.*?)<\/code>/m)&.captures&.first
assert(encoded_message, "agent-message did not render a code element")
assert(CGI.unescapeHTML(encoded_message) == transcript, "agent-message changed transcript text")
assert(!rendered_message.include?("<script>"), "agent-message did not escape HTML")
assert(rendered_message.include?("data-agent-message-label=\"Tool activity\""), "agent-message did not expose its role")

rendered_collapsible_message = render(site, <<~LIQUID)
  {% capture transcript %}Short output{% endcapture %}
  {% include agent-message.html role="tool" content=transcript collapsible="true" summary="Show tool activity" open="true" %}
LIQUID
assert(rendered_collapsible_message.include?("<details class=\"agent-message__details\" open>"), "agent-message did not open when requested")
assert(rendered_collapsible_message.include?("<summary>Show tool activity</summary>"), "agent-message changed its summary")

rendered_details = render(site, <<~LIQUID)
  {% capture tool_output %}pwd
  find .. -name AGENTS.md -print{% endcapture %}
  {% capture messages %}{% include agent-message.html role="tool" content=tool_output %}{% endcapture %}
  {% include agent-details.html summary="Show tool activity" content=messages %}
LIQUID
assert(rendered_details.include?("<details class=\"agent-details\">"), "agent-details did not render")
assert(rendered_details.include?("<summary>Show tool activity</summary>"), "agent-details changed its summary")
assert(rendered_details.include?("<article class=\"agent-message agent-message--tool\""), "agent-details did not keep nested messages")

puts "Agent transcript include checks passed."
