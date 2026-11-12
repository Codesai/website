# Console output in posts and labs

Use `components/console-output.html` to show command output in a dark terminal panel. It shows the first 15 lines, including the command if present, and puts any remaining lines behind an accessible disclosure control. Long lines scroll horizontally. The `$` command line and Git diff statistics receive terminal-style color.

## From a repository file

```liquid
{% include components/console-output.html
   label="git pull"
   path="_embedded/2026-11-12-git-pull.txt"
   caption="Expand the console to inspect the complete output." %}
```

The path is relative to the repository root and must point to a `.txt` or `.log` file inside it. The file is read at build time and displayed as text, so characters such as `<` remain safe and Liquid syntax in the output is not evaluated. Missing files or paths outside the repository fail the build.

The optional `caption` appears below the terminal as a figure caption. Omit it for standalone output that needs no explanation.
The disclosure text follows the page's `written_in` front matter: English pages use English labels, and other pages use Spanish labels.

## From a capture

```liquid
{% capture output %}{% raw %}$ git status --short
 M README.md{% endraw %}{% endcapture %}
{% include components/console-output.html label="git status" content=output %}
```

Use `raw` inside a capture when the output may contain Liquid syntax. Output of 15 lines or fewer has no disclosure control. The [last-pull lab](../../_i18n/es/_labs/2026-11-12-logging-the-last-pull.md) shows the full `git pull` output in context.
