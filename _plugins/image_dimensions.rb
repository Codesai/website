# frozen_string_literal: true

require "image_size"
require "nokogiri"
require "uri"

# Reserve local image space in rendered pages, including Markdown posts, without
# changing their source or making build-time network requests.
module ImageDimensions
  def self.add(html, site)
    document = Nokogiri::HTML5.parse(html)
    changed = false
    document.css("img[src]").each do |image|
      next if image["width"] || image["height"]

      dimensions = dimensions_for(image["src"], site)
      next unless dimensions

      width, height, viewbox_only = dimensions
      scale = [width, height].any? { |value| value != value.round } ? 100_000 : 1
      image["width"], image["height"] = [width, height].map { |value| (value * scale).round.to_s }
      if viewbox_only || scale > 1
        # Preserve the browser's default 300px width; CSS in page components
        # can still constrain it. The attributes reserve the exact content ratio.
        image["class"] = [image["class"], "intrinsic-svg"].compact.join(" ")
        unless viewbox_only
          image["style"] = "#{image['style']}; --intrinsic-image-width: #{width}px"
        end
      end
      figure = image.parent.name == "picture" ? image.parent.parent : image.parent
      if figure.name == "figure" && !figure["class"] && !figure["style"]
        # A shrink-to-fit figure cannot resolve its percentage-width image until
        # the resource arrives. Give it the same final intrinsic constraint now.
        figure["style"] = "width: min(100%, #{viewbox_only ? 300 : width}px)"
      end
      changed = true
    end
    changed ? document.to_html : html
  end

  def self.dimensions_for(src, site)
    uri = URI.parse(src)
    return if uri.scheme || uri.host || !uri.path.start_with?("/")

    path = File.expand_path(URI::DEFAULT_PARSER.unescape(uri.path).delete_prefix("/"), site.source)
    root = File.realpath(site.source)
    return unless File.file?(path) && File.realpath(path).start_with?("#{root}/")

    cache = site.instance_variable_get(:@image_dimensions_cache) ||
            site.instance_variable_set(:@image_dimensions_cache, {})
    cache[path] ||= File.open(path, "rb") do |file|
      size = ImageSize.new(file).size
      if size && size.all? { |value| value && value.positive? }
        size
      elsif File.extname(path).downcase == ".svg"
        file.rewind
        svg = Nokogiri::XML(file).at_css("svg")
        viewbox = svg&.[]("viewBox")&.split(/[ ,]+/)&.map(&:to_f)
        if viewbox&.length == 4 && viewbox[2].positive? && viewbox[3].positive?
          # SVGs without absolute dimensions have a default intrinsic width of
          # 300 CSS pixels. Preserve that size and reserve the viewBox ratio.
          [viewbox[2], viewbox[3], true]
        end
      end
    end
  rescue URI::InvalidURIError, Errno::ENOENT
    nil
  end
end

# Jekyll reuses its Site while watching. Replacing an image must refresh its size.
Jekyll::Hooks.register :site, :pre_render do |site|
  site.instance_variable_set(:@image_dimensions_cache, {})
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |page|
  next unless page.output_ext == ".html"
  # Audit reports and documentation are evidence, not site templates.
  next if page.path.start_with?("docs/")

  page.output = ImageDimensions.add(page.output, page.site)
end
