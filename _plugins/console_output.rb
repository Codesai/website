# frozen_string_literal: true

require "cgi"

module ConsoleOutput
  PREVIEW_LINES = 15

  def console_preview(output)
    output.to_s.lines.first(PREVIEW_LINES).join
  end

  def console_remainder(output)
    output.to_s.lines.drop(PREVIEW_LINES).join
  end

  def console_remaining_lines(output)
    [output.to_s.lines.length - PREVIEW_LINES, 0].max
  end

  def console_format(output)
    output.to_s.lines.map do |line|
      escaped = CGI.escapeHTML(line)
      if line.start_with?("$ ")
        %(<span class="console-output__command">#{escaped}</span>)
      elsif (stat = escaped.match(/\A(.+\|\s+\d+\s+)([+-]+)(\n?)\z/))
        markers = stat[2].scan(/\++|-+/).map do |run|
          color = run.start_with?("+") ? "added" : "removed"
          %(<span class="console-output__#{color}">#{run}</span>)
        end.join
        "#{stat[1]}#{markers}#{stat[3]}"
      else
        escaped
      end
    end.join
  end
end

Liquid::Template.register_filter(ConsoleOutput)
