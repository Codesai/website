---
layout: post
title: "Correctly Interpreting Surviving Mutants That Fail Compilation"
date: 2026-11-02 17:00:00.000000000 +01:00
author: Manuel Rivero
linkedin: https://www.linkedin.com/in/manuel-rivero-54411271/
written_in: english
categories: [Agentic-AI, AI experiments]
---

While using the test-protection assessment skill, we came across a mutation report in which seven mutants were reported as surviving.

Normally, that's a good reason to stop and investigate: a surviving mutant may point to behavior that the tests aren't protecting.

However, these seven mutants caused compilation failures. The tests couldn't exercise the mutated code because it failed to compile. Treating them as behavioral survivors would have created false positives, making the test suite appear weaker than it actually was.

The following session shows how the agent investigated the mutation results, identified the compilation failures, and excluded those mutants from its assessment of behavioral protection.

## The session.

{% capture experiment_prompt %}> assess the coverage of frontend/src/app/pages/forecast/ForecastPage/tables/CommercialForecast/ForecastParameterRow/ConnectedForecastParameterRow.tsx{% endcapture %}
{% include agent-message.html role="user" content=experiment_prompt %}

{% capture assessment_plan %}I’ll assess direct and indirect behavior coverage for the connected row, using the repository’s coverage-assessment workflow to identify exercised branches and any meaningful gaps rather than relying only on a line-percentage number.{% endcapture %}
{% include agent-message.html role="agent" content=assessment_plan %}

{% capture explored_skill %}• Explored
  └ List .SKILLS
    Search test-coverage-assessment/.*/?SKILL\.md$|test-coverage-assessment/SKILL\.md$
    Read SKILL.md{% endcapture %}
{% include agent-message.html role="tool" content=explored_skill collapsible="true" summary="Show" %}

{% capture coverage_scope %}The module has one connected-row boundary with these meaningful decisions: accepted vs rejected input, calculated vs editable rows, supplied vs missing values, standard/max vs period columns, and visibility/class forwarding. I’ll now measure targeted coverage using the row and table integration specs that exercise it.{% endcapture %}
{% include agent-message.html role="agent" content=coverage_scope %}

{% capture coverage_run %}• Ran npm run test:coverage:target -- src/app/pages/forecast/ForecastPage/tables/CommercialForecast/ForecastParameterRow/ConnectedForecastParameterRow.tsx tests/app/pages/forecast/ForecastPage/tables/CommercialForecast/ExtraDepartmentRows/SubscribedExtraDepartmentRows.sp…
  └ Functions    : 100% ( 3/3 )
    Lines        : 100% ( 7/7 )
    ================================================================================{% endcapture %}
{% include agent-message.html role="tool" content=coverage_run collapsible="true" summary="Show" %}

{% capture coverage_result %}Targeted coverage is 100% for statements, branches, functions, and lines (9/9, 10/10, 3/3, 7/7). The branch gate is satisfied, so I’ll run a targeted mutation test against only the connected row and its direct row integration spec to check assertion strength.{% endcapture %}
{% include agent-message.html role="agent" content=coverage_result %}

{% capture blocked_mutation_run %}• Exited (status 1) sed -n '1,320p' docs/scripts/targeted-mutation-script.md && npm run test:mutation:target -- src/app/pages/forecast/ForecastPage/tables/CommercialForecast/ForecastParameterRow/ConnectedForecastParameterRow.tsx tests/app/pages/forecast/ForecastPage/tabl…
  └ }
    
    Node.js v22.17.0{% endcapture %}
{% include agent-message.html role="tool" content=blocked_mutation_run collapsible="true" summary="Show" %}

{% capture sandbox_explanation %}The mutation run is blocked by the sandbox because Stryker needs to bind its local logging server (EPERM on 0.0.0.0). I’ll rerun that same targeted analysis with the required local-process permission.{% endcapture %}
{% include agent-message.html role="agent" content=sandbox_explanation %}

{% capture dry_run_status %}The mutation run completed its dry run and identified one covering spec; I’m checking whether its workers are still finishing before reading the report.{% endcapture %}
{% include agent-message.html role="agent" content=dry_run_status %}

{% capture mutation_run %}• Ran npm run test:mutation:target -- src/app/pages/forecast/ForecastPage/tables/CommercialForecast/ForecastParameterRow/ConnectedForecastParameterRow.tsx tests/app/pages/forecast/ForecastPage/tables/CommercialForecast/ExtraDepartmentRows/SubscribedExtraDepartmentRows.sp…
  └ 14:01:04 (1172517) INFO HtmlReporter Your report can be found at: file:///home/trikitrok/Documentos/Trabajo/codesai/Dreamplace/CdE/app-cde/frontend/reports/mutation/mutation.html
    14:01:04 (1172517) INFO MutationTestExecutor Done in 42 seconds.
    test:mutation:target: Stryker reported 29 mutant(s).{% endcapture %}
{% include agent-message.html role="tool" content=mutation_run collapsible="true" summary="Show" %}

{% capture process_check %}• Ran ps -eo pid,etime,cmd | rg 'stryker|child-process-proxy-worker' || true …
  └       "mutatorName": "StringLiteral",
          "replacement": "\"\"",
          "statusReason": "\n> cde@0.0.0 test:behavioral\n> npm run typecheck:test &&vitest run --exclude 'tests/architecture-rules/**' --reporter=dot tests/app/pages/forecast/ForecastPage/tables/CommercialForecast/ExtraDepartmentRows/SubscribedExtraDepartmentRows.spec.t…{% endcapture %}
{% include agent-message.html role="tool" content=process_check collapsible="true" summary="Show" %}

{% capture report_analysis %}The mutation run finished. I’m extracting the report’s status counts and any survivors; several type-invalid mutations were correctly excluded as compile errors, so I’ll keep those separate from behaviorally surviving mutants.{% endcapture %}
{% include agent-message.html role="agent" content=report_analysis %}

{% capture mutation_report %}• Ran node -e "const r=require('./reports/mutation/mutation.json'); const f=r.files['src/app/pages/forecast/ForecastPage/tables/CommercialForecast/ForecastParameterRow/ConnectedForecastParameterRow.tsx']; const ms=f.mutants; const counts=ms.reduce((a,m)=>(a[m.status]=(a[…
  └     "Killed": 22
      }
    }{% endcapture %}
{% include agent-message.html role="tool" content=mutation_report collapsible="true" summary="Show" %}

{% capture conclusion %}Adequately covered.

ConnectedForecastParameterRow.tsx (src/app/pages/forecast/ForecastPage/tables/CommercialForecast/ForecastParameterRow/ConnectedForecastParameterRow.tsx:28) has indirect integration coverage through the subscribed-row tests:

- Targeted coverage: 100% statements (9/9), branches (10/10), functions (3/3), and lines (7/7).
- The tests assert accepted input dispatches and rejected input does not, calculated rows are disabled, editable rows remain enabled, values are propagated or blank when missing, and STD/MAX classification is preserved.
- Targeted mutation testing: 29 mutants — 22 killed and 7 apparent survivors that produce compilation errors. The compile-error mutants are excluded from the behavioral score, leaving no relevant behavioral survivors.

The one direct covering spec is SubscribedExtraDepartmentRows.spec.ts (tests/app/pages/forecast/ForecastPage/tables/CommercialForecast/ExtraDepartmentRows/SubscribedExtraDepartmentRows.spec.ts:273); despite its file name, it directly renders SubscribedForecastParameterRow for the row-specific behavior.{% endcapture %}
{% include agent-message.html role="agent" content=conclusion %}

The agent concluded that the code was **adequately covered**. Although Stryker reported seven surviving mutants, the agent found that they caused compilation failures rather than exposing gaps in behavioral protection.

There were no relevant behavioral survivors to address, so the agent found no reason to add more characterization tests.
