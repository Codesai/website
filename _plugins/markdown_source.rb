# frozen_string_literal: true

require "pathname"

module MarkdownSource
  def escape_markdown_html(markdown)
    markdown.to_s.gsub("&", "&amp;").gsub("<", "&lt;")
  end

  def read_markdown(relative_path)
    read_embedded_file(relative_path, [".md", ".markdown"], "Markdown")
  end

  def read_console(relative_path)
    read_embedded_file(relative_path, [".txt", ".log"], "console output")
  end

  private

  def read_embedded_file(relative_path, extensions, kind)
    site = @context.registers[:site]
    root = Pathname.new(site.source).realpath
    requested = Pathname.new(relative_path.to_s)

    if requested.absolute?
      raise Jekyll::Errors::FatalException, "Embedded #{kind} path must be relative: #{relative_path}"
    end

    file = root.join(requested).realpath
    unless file.to_s.start_with?("#{root}#{File::SEPARATOR}") &&
           file.file? && extensions.include?(file.extname.downcase)
      raise Jekyll::Errors::FatalException, "Invalid embedded #{kind} path: #{relative_path}"
    end

    File.read(file.to_s, encoding: "UTF-8")
  rescue Errno::ENOENT
    raise Jekyll::Errors::FatalException, "Embedded #{kind} not found: #{relative_path}"
  end
end

Liquid::Template.register_filter(MarkdownSource)
