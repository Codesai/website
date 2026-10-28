# Coding-agent transcripts in blog posts

Use the `agent-message.html` include to place an authentic coding-agent message
inside a post. It is intended for transcripts, not for article prose: the body
is displayed verbatim in a monospaced, horizontally scrollable code area.

## What readers see

Each message is a quiet, rectangular panel with a narrow left accent and a small
role label. The label is generated visually, so copying the transcript body does
not copy the label.

```text
│ DEVELOPER PROMPT                         muted blue-grey accent
│ Assess the coverage of forecastColumns.ts

│ CODING AGENT                             green accent
│ I will inspect the direct and indirect coverage.

│ TOOL ACTIVITY                            amber accent
│ $ npm run test:coverage:target -- src/…
```

On narrow screens, long commands retain their original characters and can be
scrolled sideways. Consecutive message panels sit closer together than normal
article sections. A collapsed transcript uses the browser's native disclosure
marker:

```text
▸ Show background tool activity

▾ Show background tool activity
  │ TOOL ACTIVITY
  │ $ pwd
```

## Basic messages

Capture the message body, then pass it to the include. Put the opening and
closing `capture` tags directly next to the first and last character when those
newlines matter.

```liquid
{% capture prompt %}Assess the coverage of `frontend/tests/app/pages/forecast/domain/forecastColumns.ts`{% endcapture %}
{% include agent-message.html role="user" content=prompt %}

{% capture response %}I'm using the frontend coverage-assessment guidance because
this is a direct/indirect test-coverage review.{% endcapture %}
{% include agent-message.html role="agent" content=response %}

{% capture tool_output %}npm run test:coverage:target -- src/app/pages/forecast/utilities/forecastColumns.ts \
  tests/app/pages/forecast/domain/forecastColumns.spec.ts{% endcapture %}
{% include agent-message.html role="tool" content=tool_output %}
```

Valid roles are `user`, `agent`, and `tool`. An omitted or unknown role is
rendered as `agent`.

## Literal Liquid, HTML, Markdown, and Unicode

The component escapes its body and puts it in `pre > code`. Markdown markers,
HTML tags, and scripts therefore display as text and cannot execute. Liquid must
be protected before the include receives it; wrap the capture body in `raw`.

```liquid
{% capture transcript %}{% raw %}{{ variable }}
{% if condition %}
<script>const value = "hello";</script>
*This remains literal Markdown.*
  indented output
✅ done{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=transcript %}
```

This is the recommended form for copied agent output because it does not require
escaping each brace or HTML character. Liquid's one unavoidable limitation is
that a raw block cannot itself contain `{% endraw %}`. For that rare transcript,
split the capture around the delimiter and construct it with Liquid:

```liquid
{% capture endraw_delimiter %}{{ '{%' }} endraw %}{% endcapture %}
{% capture transcript %}{% raw %}Text before the delimiter.
{% endraw %}{{ endraw_delimiter }}{% raw %}
Text after the delimiter.{% endraw %}{% endcapture %}
```

## Collapse one message

Use `collapsible="true"` and provide useful summary text. Add `open="true"` when
the message should start expanded.

```liquid
{% capture output %}npm test
34 tests passed{% endcapture %}
{% include agent-message.html
  role="tool"
  content=output
  collapsible="true"
  summary="Show test command and output"
%}
```

The component renders native `<details>` and `<summary>` elements: it needs no
JavaScript and is keyboard accessible. The summary is visible in the collapsed
state; the transcript is already present in the HTML and appears unchanged when
expanded.

## Collapse a group of messages

Capture the rendered message includes, not raw transcript text, and give that
capture to `agent-details.html`. This ensures each body remains escaped.

```liquid
{% capture background_activity %}
  {% capture command %}{% raw %}pwd
find .. -name AGENTS.md -print{% endraw %}{% endcapture %}
  {% include agent-message.html role="tool" content=command %}

  {% capture result %}Found repository instructions.{% endcapture %}
  {% include agent-message.html role="agent" content=result %}
{% endcapture %}
{% include agent-details.html
  summary="Show background activity"
  content=background_activity
%}
```

Use `open="true"` on `agent-details.html` to expand the group initially.

## Complete post excerpt

```liquid
The following is the relevant part of the session.

{% capture prompt %}Assess the coverage of `forecastColumns.ts`.{% endcapture %}
{% include agent-message.html role="user" content=prompt %}

{% capture response %}I will inspect the target and its direct and indirect tests.{% endcapture %}
{% include agent-message.html role="agent" content=response %}

{% capture command %}{% raw %}npm run test:coverage:target -- src/app/pages/forecast/domain/forecastColumns.ts{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=command collapsible="true" summary="Show coverage command" %}

The command confirmed the branch is protected by its direct tests.
```

## Rules of thumb

- Use normal article Markdown for commentary; reserve transcript panels for the
  actual record.
- Keep important prompts and conclusions expanded. Collapse noisy tool output or
  secondary exchanges.
- Always route transcript text through `agent-message.html`; do not place it
  directly in `agent-details.html`.
- Do not use `markdownify` for transcripts. It would interpret and potentially
  reformat the original text.
- Copying the code area preserves the body text. The visual role label is not
  part of that text.
