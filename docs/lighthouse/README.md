# Lighthouse audits

The [backlog](../../.agents/todos/TODO.md) tracks task status. The [18 November 2026 summary](2026-11-18/resumen.md) records the latest production verification.

## Retained milestones

| Date | Documents or evidence | Purpose |
|---|---|---|
| 2026-08-31 | [Initial audit](2026-08-31/lighthouse-codesai-2026-08-31.md) and two HTML reports | Homepage baseline and a summary of September's local improvements. |
| 2026-10-13 | Four HTML reports linked from the [historical estimate](../planificacion/2026-10-19/estimacion-tareas-2026-10-19.md) | Evidence of the difference between local and production results. |
| 2026-11-10 | [Multi-page audit](2026-11-10/lighthouse-codesai-2026-11-10.md) and 38 HTML reports | Production baseline for 19 pages and two profiles, including Publications and routes with work still pending. |
| 2026-11-17 | [Icon improvements](2026-11-17/mejora-carga-cursos-ia.md) and [production verification and fonts](2026-11-17/verificacion-produccion-y-fuentes.md), with eight production HTML reports | Decisions, local comparisons, and production status before the font and course catalogue changes were deployed. |
| 2026-11-18 | [Summary](2026-11-18/resumen.md) and four HTML reports | Completion of the work on fonts, image dimensions, initial loading, and Publications. |

<a name="conservación"></a>

## Retention

- Keep Markdown summaries for milestones. Record the method, version, routes,
  environment, changes, results, ranges, and limits on comparisons.
- Keep the median-run HTML reports for baselines and production checks that
  support decisions or provide a reference for open tasks.
- Keep HTML reports from local experiments during diagnosis. After verifying the
  deployment, summarise the findings and remove reports that are no longer needed
  for diagnosis. Keep reports for unresolved regressions.
- For routine runs without significant changes, document the result. Keep the
  evidence if a regression appears.
- Update links when removing an HTML report. Record the cleanup in a new commit
  so previously tracked reports remain available in Git history.

The cleanup on 18 November 2026 removed 26 local HTML reports from September and
November (about 25.1 MiB) and preserved the documented results. A later
consolidation that day kept the final Publications HTML report and the mobile
reports covering performance exceptions and their follow-up.

## Running audits

Use `scripts/run-lighthouse.sh`. See `--help` for URL, profile, and output
options. By default, the script runs each profile three times in sequence and
keeps only the HTML report for the run with the median performance score.
Record that run's individual metric values. Use the script output to report the
ranges across all runs. Run the audit profiles sequentially and keep builds and
tests from running during the audit.

The agent runs the script directly. If CPU load interferes with the measurement,
the agent tells the user and asks them to rerun the audit in their terminal once
the machine is idle.
