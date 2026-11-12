# Embedded Markdown in posts and labs

Use `components/markdown-embed.html` to render a Markdown document inside a post or Raw AI Lab. The panel styles headings, prose, lists, code, quotes, and wide tables, and works at mobile widths.

## Embed a repository Markdown file

```liquid
{% include components/markdown-embed.html
   label="Agent's plan"
   path=".agents/plans/example.md" %}
```

The path is relative to the repository root and must refer to a `.md` or `.markdown` file inside it. The file is read at build time, so its contents remain in one place and are not processed as Liquid. A missing file or a path outside the repository fails the build.

## Embed Markdown from a capture

```liquid
{% capture logbook %}{% raw %}# Ship's log

## First leg

The course names changed.{% endraw %}{% endcapture %}
{% include components/markdown-embed.html label="Agent's logbook" content=logbook %}
```

Wrap the capture in `raw` when it can contain Liquid syntax. The component escapes HTML before converting Markdown, so code and prose display safely. Markdown links resolve from the post's URL; use absolute paths or full URLs when embedding a document from elsewhere in the repository.

For an authentic agent transcript, also pass the original Markdown to `agent-message.html`. The [last-pull lab](../../_i18n/es/_labs/2026-11-12-logging-the-last-pull.md) shows the transcript collapsed above its rendered document.
