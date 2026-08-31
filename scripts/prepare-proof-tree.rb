# frozen_string_literal: true

site_dir, netlify_file = ARGV
abort "usage: prepare-proof-tree.rb SITE_DIR NETLIFY_FILE" unless site_dir && netlify_file

redirect_years = File.read(netlify_file).scan(%r{from\s*=\s*"/(\d{4})/:month/:slug"}).flatten
abort "No historical post redirects found in #{netlify_file}" if redirect_years.empty?

Dir.glob(File.join(site_dir, "**", "*.html")).each do |file|
  html = File.read(file)
  html.gsub!(%r{https?://(?:www\.)?codesai\.com(?=[/"'#?])}, "")
  # Protocol-relative URLs are external too. Make them explicit so proofer can
  # classify (and then skip) them without attempting a network request.
  html.gsub!(%r{(["'])//}, '\\1https://')
  years = redirect_years.join("|")
  html.gsub!(%r{(["'])/(#{years})/(\d{2})/([^"'#?]+)([?#][^"']*)?\1}) do
    quote, year, month, slug, suffix = Regexp.last_match.captures
    "#{quote}/posts/#{year}/#{month}/#{slug}#{suffix}#{quote}"
  end
  File.write(file, html)
end
