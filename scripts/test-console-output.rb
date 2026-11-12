#!/usr/bin/env ruby
# frozen_string_literal: true

require "jekyll"
require "tmpdir"
require "yaml"
require_relative "../_plugins/markdown_source"
require_relative "../_plugins/console_output"

source = File.expand_path("..", __dir__)
destination = File.join(Dir.mktmpdir, "site")
site = Jekyll::Site.new(Jekyll.configuration("source" => source, "destination" => destination))
site.config["default_lang"] = "es"
site.config["lang"] = "es"
site.parsed_translations = {
  "es" => YAML.load_file(File.join(source, "_i18n/es.yml")),
  "en" => YAML.load_file(File.join(source, "_i18n/en.yml"))
}
site.config["translations"] = site.parsed_translations

def render(site, template, page: {})
  site.liquid_renderer
      .file("console-output-test-#{template.hash}")
      .parse(template)
      .render!(site.site_payload.merge("page" => page), registers: { site: site })
end

def assert(condition, message)
  raise message unless condition
end

output = render(site, '{% include components/console-output.html label="git pull" path="_embedded/2026-11-12-git-pull.txt" caption="Expand for <details>." %}')
preview, remainder = output.split('<details class="console-output__more">', 2)
assert(preview.include?("remote: Enumerating objects"), "The first lines are missing")
assert(preview.include?("AGENTS.md"), "The fifteenth line is missing")
assert(!preview.include?("README.md"), "Lines after the fifteenth must be folded")
assert(remainder.include?("README.md"), "The folded lines are missing")
assert(remainder.include?("90 files changed"), "The complete pull output is missing")
assert(output.include?('console-output__added'), "Added-line markers are not colored")
assert(output.include?('console-output__removed'), "Removed-line markers are not colored")
assert(output.include?('<figcaption class="console-output__caption">Expand for &lt;details&gt;.</figcaption>'), "The caption must render below the console and escape HTML")
assert(output.include?("Mostrar el resto de la salida (146 líneas)"), "Spanish output should use Spanish disclosure text")

english = render(site, '{% include components/console-output.html label="git pull" path="_embedded/2026-11-12-git-pull.txt" %}', page: { "written_in" => "english" })
assert(english.include?("Show remaining output (146 lines)"), "English lab output should use English disclosure text")

short = render(site, <<~LIQUID)
  {% capture output %}{% raw %}$ echo '<script>'
  <script>{% endraw %}{% endcapture %}
  {% include components/console-output.html label="Example" content=output %}
LIQUID
assert(!short.include?("<details"), "Short output should not have a disclosure")
assert(!short.include?("<figcaption"), "A caption should be optional")
assert(short.include?("&lt;script&gt;"), "Console text must be escaped")
assert(!short.include?("<script>"), "Raw HTML reached the rendered panel")

begin
  render(site, '{% include components/console-output.html label="Invalid" path="/etc/passwd" %}')
  raise "Absolute source path was accepted"
rescue Jekyll::Errors::FatalException
  # A console artifact must stay inside the repository.
end

puts "Console output checks passed."
