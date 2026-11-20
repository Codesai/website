#!/usr/bin/env ruby
# frozen_string_literal: true

require "jekyll"
require "tmpdir"
require "fileutils"
require_relative "../_plugins/image_dimensions"

def assert(condition, message)
  raise message unless condition
end

Dir.mktmpdir do |root|
  FileUtils.mkdir_p("#{root}/assets")
  File.write("#{root}/assets/test.svg", '<svg xmlns="http://www.w3.org/2000/svg" width="482" height="159"></svg>')
  FileUtils.cp("#{root}/assets/test.svg", "#{root}/assets/toño.svg")
  File.write("#{root}/assets/viewbox.svg", '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 520 64"></svg>')
  site = Struct.new(:source).new(root)
  input = <<~HTML
    <!DOCTYPE html><html><head><script>const image = '<img src="/assets/test.svg">';</script></head><body>
    <img id="local" src="/assets/test.svg?version=1">
    <figure><img id="figure" src="/assets/test.svg"></figure>
    <figure><picture><img id="picture" src="/assets/test.svg"></picture></figure>
    <img id="viewbox" src="/assets/viewbox.svg">
    <img id="explicit" src="/assets/test.svg" width="100" height="80">
    <img id="partial" src="/assets/test.svg" width="100">
    <img id="remote" src="https://example.com/test.svg">
    <img id="missing" src="/assets/missing.png">
    <pre>&lt;img src="/assets/test.svg"&gt;</pre>
    </body></html>
  HTML
  result = ImageDimensions.add(input, site)
  document = Nokogiri::HTML5.parse(result)
  assert(document.at_css('#local')['width'] == '482' && document.at_css('#local')['height'] == '159', 'Local dimensions missing')
  assert(ImageDimensions.dimensions_for('/assets/to%C3%B1o.svg', site) == [482, 159], 'Escaped Unicode path dimensions missing')
  assert(document.at_css('#figure').parent['style'] == 'width: min(100%, 482px)', 'Figure space not reserved')
  assert(document.at_css('#picture').parent.parent['style'] == 'width: min(100%, 482px)', 'Picture figure space not reserved')
  assert(document.at_css('#viewbox')['width'] == '520' && document.at_css('#viewbox')['class'].include?('intrinsic-svg'), 'SVG viewBox ratio missing')
  assert(document.at_css('#explicit')['height'] == '80', 'Explicit geometry changed')
  assert(!document.at_css('#partial')['height'], 'Partial sizing changed')
  assert(!document.at_css('#remote')['width'], 'Remote image changed')
  assert(!document.at_css('#missing')['width'], 'Missing image changed')
  assert(document.at_css('script').content.include?(%q(const image = '<img src="/assets/test.svg">';)), 'Script content changed')
  assert(document.at_css('pre').text == '<img src="/assets/test.svg">', 'Code sample changed')
  assert(ImageDimensions.add(result, site) == result, 'Processing is not idempotent')
  File.write("#{root}/assets/test.svg", '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="50"></svg>')
  Jekyll::Hooks.trigger(:site, :pre_render, site)
  assert(ImageDimensions.dimensions_for('/assets/test.svg', site) == [100, 50], 'Rebuild reused stale dimensions')
  assert(ImageDimensions.dimensions_for('/../etc/passwd', site).nil?, 'Path traversal accepted')
  File.symlink('/etc/passwd', "#{root}/assets/outside.svg")
  assert(ImageDimensions.dimensions_for('/assets/outside.svg', site).nil?, 'Outside symlink accepted')
end

puts 'Image dimensions checks passed.'
