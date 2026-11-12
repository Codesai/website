---
layout: post
title: "Agent Applies a Skill to Pin Down a Bug with a Test"
date: 2026-11-12 10:00:00.000000000 +01:00
author: Manuel Rivero
linkedin: https://www.linkedin.com/in/manuel-rivero-54411271/
written_in: english
categories: [Agentic-AI, AI experiments, Testing]
---

## The session

This session follows the agent as it finds the cause of a bug, reproduces it with a test, and verifies the fix.

### A bug: an invalid total was accepted, why?

SA, AD, and MP are the application's Spanish codes for board types: room only, bed and breakfast, and half board, respectively. This percentages must not add up to more than 100%. 

A form was accepting 30% for SA, 20% for AD, and 52% for MP, a total of 102%, without reporting a validation error. The validation was not working.

We gave the agent a screenshot of the form, pointed out that SA 30% + AD 20% + MP 52% totaled 102% while `validationProblems` remained empty, and asked it to find out why the form accepted those values.

{% capture initial_prompt %}{% raw %}> [Image #1] look I'm being able to introduce the following values: SA = 30, AD = 20 and MP = 52 which sums 102 but validationProblems = {} , explain me why this is not working? regime values summing over 100 should not be valid{% endraw %}{% endcapture %}
{% include agent-message.html role="user" content=initial_prompt %}

{% capture investigation_plan %}{% raw %}I’ll trace the forecast cell-validation and calculation flow to see why those regime fields don’t produce a validation problem.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=investigation_plan %}

{% capture initial_search %}{% raw %}• Ran pwd && rg --files -g 'AGENTS.md' -g 'SKILL.md' -g '*.ts' -g '*.tsx' | sed -n '1,220p'
  └ tests/app/pages/roles/saveEvents.spec.ts
    tests/test-helpers/builders/ForecastPageStateBuilder.ts
    src/app/pages/standards/StandardsPage/StandardsTable/StandardRow/SubscribedStandardRow.tsx{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=initial_search collapsible="true" summary="Show repository search" %}

{% capture investigation_tools %}{% raw %}• Explored
  └ Search SKILL.md in .SKILLS
    Read SKILL.md
    Read AGENTS.md
• Ran wc -l .SKILLS/reffects/references/*.md && sed -n '1,260p' .SKILLS/reffects/references/event-handlers-testing.md && printf '\n--- relevant source files ---\n' && rg -l -i 'validateChangedParameters|validationProblems' src/app/pages/forecast tests/app/pages/forecast …
  └ tests/app/pages/forecast/ForecastPage/tables/CommercialForecast/events.spec.ts
    tests/app/pages/forecast/ForecastPage/tables/CommercialForecast/selectors.spec.ts
    tests/app/pages/forecast/domain/forecastInputValidation.spec.ts
• Explored
  └ Read forecastInputValidation.ts, events.ts, forecastInputValidation.spec.ts, events.spec.ts
• Ran sed -n '1,360p' src/app/pages/forecast/domain/forecastValues.ts && printf '\n--- parameter policies ---\n' && sed -n '1,300p' src/app/pages/forecast/domain/forecastParameterCellPolicies.ts && printf '\n--- state type ---\n' && rg -n -C 5 'ForecastParamDefinition|pa…
  └ src/app/pages/forecast/domain/forecastValues.ts-310-    if (stdValue === null) continue;
    src/app/pages/forecast/domain/forecastValues.ts-311-
    --
• Ran rg -n -C 3 '"pct_sa"|"pct_ad"|"pct_mp"|"pct_pc"|"pct_ti"' public src tests -g '*.json' -g '*.ts' | head -380 && printf '\n--- calculation fallback ---\n' && rg -n -C 4 'function buildColumnParams|buildColumnParams' src/app/pages/forecast/domain/forecastValues.ts sr…
  └ 097902ff2 (trikitrok 2026-11-04 19:01:14 +0100 135)
    097902ff2 (trikitrok 2026-11-04 19:01:14 +0100 136)   return latestKeyByColumn;
    097902ff2 (trikitrok 2026-11-04 19:01:14 +0100 137) }{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=investigation_tools collapsible="true" summary="Show validation and calculation investigation" %}

{% capture diagnosis %}{% raw %}This is a validation bug.

The cumulative check requires all five cumulative regimes to be present and individually valid:

SA + AD + MP + PC + TI

But your screen only has values for SA, AD, and MP. PC and TI resolve to null, so this condition fails and the validator skips calculating any total:

if (regimeValues.every(isValidPercentage)) {
  // only then sum them
}

So 30 + 20 + 52 = 102 is never evaluated, and validationProblems stays {}. See forecastInputValidation.ts (src/app/pages/forecast/domain/forecastInputValidation.ts:108).

There is also an inconsistency: forecasting calculations treat missing parameter values as their default—zero for these regimes—so the calculation layer effectively sees 30 + 20 + 52 + 0 + 0; validation does not. See forecastValues.ts (src/app/pages/forecast/domain/forecastValues.ts:393).

The intended correction is to treat absent cumulative regimes as 0 when adding them (or only include configured regime parameters). Then the latest edited cell—MP in this case—would receive:

> La suma de los porcentajes de régimen no puede superar el 100%

PR is deliberately excluded from this sum because it is modeled as a parallel regime.

  Worked for 1m 11s • 9:19 AM{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=diagnosis %}

### Agreeing on the diagnosis

After reading the agent's explanation, we agreed that missing board-type percentages should count as zero in the total. We confirmed this was a bug and asked the agent to fix it.

{% capture confirm_bug %}{% raw %}> yes, this is a bug, absent cumulative regimes should be treated as 0{% endraw %}{% endcapture %}
{% include agent-message.html role="user" content=confirm_bug %}

{% capture test_plan %}{% raw %}I’ll correct the cumulative validator and add a regression test for missing PC/TI values. I’m using the repository’s test-writing guidance because this is a behavior change protected by a frontend test.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=test_plan %}

### The agent decided to pin down the bug with a failing test

Following our test-writing skill, the agent decided to add a regression test that pinned down the bug before changing the validator.

{% capture test_exploration %}{% raw %}• Ran sed -n '1,360p' .SKILLS/test-writing/SKILL.md && printf '\n--- worktree ---\n' && git status --short && printf '\n--- target line numbers ---\n' && nl -ba src/app/pages/forecast/domain/forecastInputValidation.ts | sed -n '96,145p' && nl -ba tests/app/pages/forecast…
  └    178          regimeValue("pct_pc", columnKey, pc),
       179          regimeValue("pct_ti", columnKey, ti),
       180          regimeValue("pct_pr", columnKey, pr),
• Explored
  └ Read SKILL.md, regression-test-workflow.md, category-classification.md, pure-function-and-selector-tests.md, choosing-test-interfaces.md{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=test_exploration collapsible="true" summary="Show test-writing guidance and target inspection" %}

{% capture regression_context %}{% raw %}Regression context: missing PC/TI values, a dirty MP value of 52 alongside SA 30 and AD 20, and validation must flag the last-edited MP cell because the effective total is 102. I’ll test validateChangedParameters directly—a high-confidence pure-function unit test—since it is the public deterministic validation boundary.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=regression_context %}

{% capture red_test_tools %}{% raw %}• Explored
  └ Read SKILL.md, fixture-and-test-data-builder-guidance.md, review-after-writing.md
• Edited tests/app/pages/forecast/domain/forecastInputValidation.spec.ts (+22 -0)
+    it("treats absent cumulative regimes as zero when the present regimes exceed 100", () => {
+      const validationProblems = validateChangedParameters({
+        cells: aForecastValueModel()
• Exited (status 1) npx vitest run tests/app/pages/forecast/domain/forecastInputValidation.spec.ts
  └    Start at  09:21:09
       Duration  613ms (environment 83%, worker 11%, tests 3%, import 3%, transform 1%){% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=red_test_tools collapsible="true" summary="Show regression test and failing run" %}

{% capture red_result %}{% raw %}The regression test reproduces it: it expected an error on pct_mp__STD, but received {}.

May I now apply the production fix and rerun the test green?{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=red_result %}

### The failing test pins down the bug

The new test supplies the three percentages reported by the user and leaves PC and TI absent. It expects the validator to flag MP, the last edited cell, because the total is 102%. Instead, the validator returns an empty set of problems. That failing result confirms the behavior before the agent changes the validator. The user then approves the fix.

Here is [the regression test the agent wrote](https://gist.github.com/trikitrok/79aafdcc74389d0c6c4903fb146bd414):

<script src="https://gist.github.com/trikitrok/79aafdcc74389d0c6c4903fb146bd414.js"></script>

The agent asks us to review the failing test, and then, once we're happy with the test let it fix the production code.

This review step could be a good moment to apply [Improve your reds](https://codesai.com/en/posts/2018/06/improving-your-reds).

### Fixing the bug

{% capture approval %}{% raw %}> yes, go ahead{% endraw %}{% endcapture %}
{% include agent-message.html role="user" content=approval %}

{% capture fix_plan %}{% raw %}I’m applying the narrowly scoped rule: missing regimes count as zero, while any supplied invalid percentage still keeps its own range-validation error.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=fix_plan %}

{% capture green_test_tools %}{% raw %}• Edited src/app/pages/forecast/domain/forecastInputValidation.ts (+6 -2)
-    if (regimeValues.every(isValidPercentage)) {
+    if (
+      regimeValues.every(
• Ran npx vitest run tests/app/pages/forecast/domain/forecastInputValidation.spec.ts
  └    Start at  09:26:06
       Duration  545ms (environment 81%, worker 13%, import 3%, tests 2%, transform 1%){% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=green_test_tools collapsible="true" summary="Show validator edit and focused test" %}

{% capture green_result %}{% raw %}The regression is green: all 57 validation tests pass. I’ll now format the changed files and run the required frontend completion gate.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=green_result %}

{% capture first_gate_tools %}{% raw %}• Ran npm run format:changed
  └ 
    src/app/pages/forecast/domain/forecastInputValidation.ts 92ms
    tests/app/pages/forecast/domain/forecastInputValidation.spec.ts 39ms
• Exited (status 2) npm run agent-validate
  └ src/app/pages/forecast/domain/forecastInputValidation.ts(116,9): error TS2345: Argument of type 'number | null' is not assignable to parameter of type 'number'.
      Type 'null' is not assignable to type 'number'.
    src/app/pages/forecast/domain/forecastInputValidation.ts(116,45): error TS18047: 'sum' is possibly 'null'.{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=first_gate_tools collapsible="true" summary="Show formatting and TypeScript errors" %}

{% capture type_fix_plan %}{% raw %}The completion gate found a TypeScript inference issue in the new reduce expression (the array is number | null). I’ll make the accumulator explicitly numeric, then rerun the full gate.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=type_fix_plan %}

{% capture type_fix_tools %}{% raw %}• Edited src/app/pages/forecast/domain/forecastInputValidation.ts (+1 -1)
-        regimeValues.reduce((sum, value) => sum + (value ?? 0), 0),
+        regimeValues.reduce<number>((sum, value) => sum + (value ?? 0), 0),
• Ran npm run format:changed && npm run agent-validate
  └ - Using dynamic import() to code-split the application
    - Use build.rolldownOptions.output.codeSplitting to improve chunking: https://rolldown.rs/reference/OutputOptions.codeSplitting
    - Adjust chunk size limit for this warning via build.chunkSizeWarningLimit.{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=type_fix_tools collapsible="true" summary="Show type fix and validation gate" %}

{% capture full_gate_result %}{% raw %}The full frontend gate passes: lint, typechecking, 1,199 tests, and the production build. I’m doing the required test-quality review now; no additional behavior changes are planned.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=full_gate_result %}

{% capture review_tools %}{% raw %}• Ran sed -n '1,460p' .SKILLS/test-coverage-assessment/SKILL.md && printf '\n--- final diff ---\n' && git diff --check && git diff -- src/app/pages/forecast/domain/forecastInputValidation.ts tests/app/pages/forecast/domain/forecastInputValidation.spec.ts && printf '\n---…
  └ --- status ---
     M src/app/pages/forecast/domain/forecastInputValidation.ts
     M tests/app/pages/forecast/domain/forecastInputValidation.spec.ts{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=review_tools collapsible="true" summary="Show test-quality review" %}

{% capture review_result %}{% raw %}Review confirms the test directly covers the corrected observable outcome and leaves the existing invalid-value behavior intact. I’m checking targeted coverage before deciding whether a focused mutation run is warranted.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=review_result %}


### Assessing behavior protection after fixing the bug

With the bug fixed, the agent decided to apply [our test-coverage-improvement skill](https://codesai.com/en/posts/2026/11/a-test-coverage-improvement-skill) to assess how well the tests protected the changed validator. It checked targeted coverage before running mutation testing.

{% capture coverage_tool %}{% raw %}• Ran npm run test:coverage:target -- src/app/pages/forecast/domain/forecastInputValidation.ts
  └ Functions    : 100% ( 8/8 )
    Lines        : 100% ( 36/36 )
    ================================================================================{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=coverage_tool collapsible="true" summary="Show targeted coverage run" %}

{% capture mutation_plan %}{% raw %}Targeted coverage is 100% for statements, branches, functions, and lines, so I’ll run the focused mutation check against the validation spec.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=mutation_plan %}

{% capture mutation_tools %}{% raw %}• Ran pgrep -af 'stryker|run-targeted-mutation' || true
  └ 1 codex-linux-sandbox --sandbox-policy-cwd /home/trikitrok/Documentos/Trabajo/codesai/Dreamplace/CdE/app-cde/frontend --command-cwd /home/trikitrok/Documentos/Trabajo/codesai/Dreamplace/CdE/app-cde/frontend --permission-profile {"type":"managed","file_system":{"type"…
    2 /bin/bash -c pgrep -af 'stryker|run-targeted-mutation' || true
• Ran find reports -maxdepth 3 -type f -printf '%p\n' 2>/dev/null | sort | tail -30 && find .stryker-tmp -maxdepth 2 -type f -printf '%p\n' 2>/dev/null | head -20 && git status --short
  └ .stryker-tmp/sandbox-IgV8kr/package.json
     M src/app/pages/forecast/domain/forecastInputValidation.ts
     M tests/app/pages/forecast/domain/forecastInputValidation.spec.ts
• Exited (status 127) jq '{schemaVersion, thresholds, files: (.files | to_entries | map({file: .key, mutants: ([.value.mutants[] | {status, mutatorName, location, description}] | group_by(.status) | map({status: .[0].status, count: length}))}))}' reports/mutation/mutatio…
  └ /bin/bash: jq: orden no encontrada
• Ran npm run test:mutation:target -- src/app/pages/forecast/domain/forecastInputValidation.ts tests/app/pages/forecast/domain/forecastInputValidation.spec.ts
  └ 09:28:48 (329447) INFO HtmlReporter Your report can be found at: file:///home/trikitrok/Documentos/Trabajo/codesai/Dreamplace/CdE/app-cde/frontend/reports/mutation/mutation.html
    09:28:48 (329447) INFO MutationTestExecutor Done in 48 seconds.
    test:mutation:target: Stryker reported 50 mutant(s).
• Ran node -e 'const r=require("./reports/mutation/mutation.json"); for (const [file,data] of Object.entries(r.files)) { const counts={}; for (const mutant of data.mutants) counts[mutant.status]=(counts[mutant.status]||0)+1; console.log(file, JSON.stringify(counts)); for…
  └ {"status":"CompileError","mutatorName":"BooleanLiteral","location":{"end":{"column":18,"line":131},"start":{"column":9,"line":131}}}
    {"status":"CompileError","mutatorName":"LogicalOperator","location":{"end":{"column":77,"line":131},"start":{"column":9,"line":131}}}
    {"status":"CompileError","mutatorName":"BlockStatement","location":{"end":{"column":6,"line":133},"start":{"column":79,"line":131}}}{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=mutation_tools collapsible="true" summary="Show mutation run and report inspection" %}

{% capture mutation_result %}{% raw %}The focused mutation run finished: all 28 runnable mutants were killed; the other 22 were rejected at TypeScript compilation, with no survivors.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=mutation_result %}

{% capture final_check %}{% raw %}• Ran git diff --check && nl -ba src/app/pages/forecast/domain/forecastInputValidation.ts | sed -n '104,122p' && nl -ba tests/app/pages/forecast/domain/forecastInputValidation.spec.ts | sed -n '118,148p' && git status --short
  └    148    
     M src/app/pages/forecast/domain/forecastInputValidation.ts
     M tests/app/pages/forecast/domain/forecastInputValidation.spec.ts{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=final_check collapsible="true" summary="Show final diff check" %}

{% capture final_response %}{% raw %}Fixed.

Missing cumulative regimes now count as 0, so SA 30 + AD 20 + MP 52 correctly produces a validation problem on the latest edited cell. Supplied invalid percentages still retain their own range error.

- Updated forecastInputValidation.ts (src/app/pages/forecast/domain/forecastInputValidation.ts:111)
- Added regression coverage in forecastInputValidation.spec.ts (tests/app/pages/forecast/domain/forecastInputValidation.spec.ts:123)

Behavior-protection results: adequate. The regression test directly asserts the reported bug scenario; targeted coverage is 100% branches, and mutation testing killed all 28 runnable mutants (22 compile-time rejected; no survivors).

Writing-rule findings: none.

Validation passed: npm run agent-validate (lint, typecheck, 1,199 tests, production build).{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=final_response %}

### Conclusions

The agent found why the 102% total passed validation, wrote a failing regression test, fixed the validator to count missing board types as zero, and verified the result with coverage and mutation testing.

The interesting part is the automation. Our test-writing skill turns pinning down a bug with a failing regression test into a repeatable workflow. When we tell the agent about a bug, the skill guides it through that workflow before changing production code. In the spirit of Jeff Atwood's [pit of success](https://blog.codinghorror.com/falling-into-the-pit-of-success/), this lowers the energy barrier to applying a good testing habit and makes it more likely to happen.

