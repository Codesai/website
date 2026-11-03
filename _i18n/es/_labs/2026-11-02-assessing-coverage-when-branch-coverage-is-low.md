---
layout: post
title: "Assessing Coverage When Branch Coverage Is Low"
date: 2026-11-02 18:00:00.000000000 +01:00
author: Manuel Rivero
linkedin: https://www.linkedin.com/in/manuel-rivero-54411271/
written_in: english
categories: [Agentic-AI, AI experiments, Testing, Mutation Testing]
---

The session below shows what happens when the agent using the test protection skill finds insufficient branch coverage. It also illustrates how surviving mutants can reveal opportunities to simplify production code.

## The session.

{% capture prompt_assess %}> assess the coverage of frontend/src/app/app-shell/load-events.ts{% endcapture %}
{% include agent-message.html role="user" content=prompt_assess %}

{% capture assessment_start %}I’m using the test-coverage assessment guidance because you asked for behavioral coverage, not just a percentage. I’ll examine direct and indirect tests, then use targeted coverage to identify any meaningful unprotected branches.{% endcapture %}
{% include agent-message.html role="agent" content=assessment_start %}

{% capture explore_assessment %}• Explored
  └ Read SKILL.md (test-coverage-assessment skill)
    Read load-events.ts
    Search pageLoadRequested|pageLoadSucceeded|pageLoadFailed|appVersionRequested|appVersionRequestedHandler in tests{% endcapture %}
{% include agent-message.html role="tool" content=explore_assessment collapsible="true" summary="Show" %}

{% capture initial_coverage %}• Ran npm run test:coverage:target -- src/app/app-shell/load-events.ts tests/app/app-shell/events.spec.ts
  └ Functions    : 100% ( 8/8 )
    Lines        : 100% ( 19/19 )
    ================================================================================{% endcapture %}
{% include agent-message.html role="tool" content=initial_coverage collapsible="true" summary="Show" %}

{% capture insufficient_assessment %}## Assessment: insufficiently covered

Targeted coverage for load-events.ts (src/app/app-shell/load-events.ts:22):

| Metric | Result |
|---|---:|
| Statements | 100% |
| Lines | 100% |
| Functions | 100% |
| Branches | 73.52% (25/34) |

The direct tests in events.spec.ts (tests/app/app-shell/events.spec.ts:34) cover normal request/success/failure flows, URL vs payload hotel selection, Forecast vs Standards loading, and all app-version formatting cases.

Meaningful missing branches:

- Failure-message normalization (src/app/app-shell/load-events.ts:71): Error, string, and missing/empty-message fallbacks are untested.
- Load requests with hotelChanged: true (src/app/app-shell/load-events.ts:99): neither Forecast nor non-Forecast request is verified to emit a success event carrying true.

I did not run mutation testing because relevant branch coverage is not yet high enough; it would mostly report noise from these untested paths.{% endcapture %}
{% include agent-message.html role="agent" content=insufficient_assessment %}

The agent used branch coverage to decide whether to proceed with mutation testing.

Since it considered branch coverage insufficient, it stopped and reported the missing behavioral cases instead of running mutation testing.

{% capture prompt_improve %}> improve the coverage{% endcapture %}
{% include agent-message.html role="user" content=prompt_improve %}

{% capture improvement_plan %}I’ll add characterization coverage for the currently untested, observable handler paths: error-message fallback and hotelChanged request propagation. I’m using the Reffects, test-writing, test-data-builder, and coverage-assessment guidance because this adds direct event-handler tests and validates their branch protection.{% endcapture %}
{% include agent-message.html role="agent" content=improvement_plan %}

{% capture explore_characterization %}• Explored
  └ Read characterization-test-workflow.md, partitioning-and-boundary-analysis.md, events.spec.ts, load-events.ts{% endcapture %}
{% include agent-message.html role="tool" content=explore_characterization collapsible="true" summary="Show" %}

{% capture characterization_scope %}Characterization scope is now clear: existing tests cover ordinary object failures and hotelChanged: false; I’ll add reachable cases for Error/fallback message normalization and hotelChanged: true for both Forecast and non-Forecast request paths. null is excluded by the handler’s declared payload type, so I won’t distort the public boundary to test it.{% endcapture %}
{% include agent-message.html role="agent" content=characterization_scope %}

{% capture tests_edited %}• Edited tests/app/app-shell/events.spec.ts (+67 -0)
+  it.each([
+    {
+      page: "forecast" as const,{% endcapture %}
{% include agent-message.html role="tool" content=tests_edited collapsible="true" summary="Show" %}

{% capture tests_explanation %}The added tests characterize the observable effects—not the helper internals—across both unprotected decision families.{% endcapture %}
{% include agent-message.html role="agent" content=tests_explanation %}

{% capture coverage_after_tests %}• Ran npm run test -- tests/app/app-shell/events.spec.ts && npm run test:coverage:target -- src/app/app-shell/load-events.ts tests/app/app-shell/events.spec.ts
  └ Functions    : 100% ( 8/8 )
    Lines        : 100% ( 19/19 )
    ================================================================================{% endcapture %}
{% include agent-message.html role="tool" content=coverage_after_tests collapsible="true" summary="Show" %}

{% capture mutation_gate %}Targeted coverage is now 100% for statements, lines, functions, and branches (19/19, 34/34). The coverage gate is clear, so I’m running the required narrow mutation check against load-events.ts with only its direct spec.{% endcapture %}
{% include agent-message.html role="agent" content=mutation_gate %}


After we asked the agent to improve coverage, it added characterization tests for the missing cases. 
Branch coverage reached 100%, so the agent proceeded to mutation testing.

{% capture mutation_first %}• Ran npm run test:mutation:target -- src/app/app-shell/load-events.ts tests/app/app-shell/events.spec.ts
  └ 17:28:11 (2307465) INFO HtmlReporter Your report can be found at: file:///home/trikitrok/Documentos/Trabajo/codesai/Dreamplace/CdE/app-cde/frontend/reports/mutation/mutation.html
    17:28:11 (2307465) INFO MutationTestExecutor Done in 1 minute and 14 seconds.
    test:mutation:target: Stryker reported 84 mutant(s).{% endcapture %}
{% include agent-message.html role="tool" content=mutation_first collapsible="true" summary="Show" %}

{% capture gate_run %}• Ran npm run agent-validate && git diff --check && git status --short{% endcapture %}
{% include agent-message.html role="tool" content=gate_run collapsible="true" summary="Show" %}

{% capture coverage_summary %}Coverage is now 100% for load-events.ts (src/app/app-shell/load-events.ts:1): 19/19 statements, 34/34 branches, 8/8 functions, and 19/19 lines.

Added characterization cases in events.spec.ts (tests/app/app-shell/events.spec.ts:92) for:

- hotelChanged: true on Forecast and Standards requests.
- Error, empty Error, object without a message, string error, and missing error fallback behavior.

Validation passed: focused tests, targeted coverage, lint, full typecheck/test suite (1,128 tests), and production build.

The targeted mutation run’s dry run passed but the environment terminated it before a final score. The combined agent-validate command likewise hit the 30-second tool limit; its constituent lint, test, and build commands all passed separately.{% endcapture %}
{% include agent-message.html role="agent" content=coverage_summary %}

There was a problem: the agent didn't wait for mutation testing to finish. It reported the incomplete run, so we asked it to try again and wait for the result.

{% capture prompt_mutation %}> run targeted mutation testing and wait until it finish{% endcapture %}
{% include agent-message.html role="user" content=prompt_mutation %}

{% capture mutation_wait %}Targeted branch coverage is already 100%, so the mutation gate is appropriate. I’ll run Stryker only for load-events.ts with its direct spec and poll the active process until it exits.
The mutation run is active: it generated 84 mutants and its initial test run passed. I’m continuing to wait for Stryker’s final report.{% endcapture %}
{% include agent-message.html role="agent" content=mutation_wait %}

{% capture mutation_result %}• Ran npm run test:mutation:target -- src/app/app-shell/load-events.ts tests/app/app-shell/events.spec.ts
  └ 17:32:38 (2334561) INFO MutationTestExecutor Done in 1 minute and 12 seconds.
    test:mutation:target: Stryker reported 84 mutant(s).
    ⠙{% endcapture %}
{% include agent-message.html role="tool" content=mutation_result collapsible="true" summary="Show" %}

{% capture survivors_explained %}Targeted mutation testing completed successfully.

- Scope: src/app/app-shell/load-events.ts
- Tests: tests/app/app-shell/events.spec.ts
- Result: 92.59% mutation score — 50 killed, 4 survived, 0 timed out, 30 errored.

The survivors are explainable:

- Optional chaining on error?.message: equivalent under the declared error type, which excludes null.
- Three mutations of page === "forecast": both branches in pageShellRequestEvents currently return equivalent event shapes, making that condition redundant from an observable-behavior perspective.

Report: reports/mutation/mutation.html (ignored generated output).{% endcapture %}
{% include agent-message.html role="agent" content=survivors_explained %}

The mutation run produced four surviving mutants. The agent classified them as explainable, with no apparent need for additional tests.

The survivors pointed to potentially redundant code: an optional chain and a conditional whose two branches appeared to produce the same behavior.

The optional chain appeared unnecessary under the declared type contract. We asked the agent before deciding to simplify it.

{% capture optional_question %}> "Optional chaining on error?.message: equivalent under the declared error type, which excludes null." <- you mean this could be error.message?{% endcapture %}
{% include agent-message.html role="user" content=optional_question %}

{% capture optional_answer %}Yes. Given ShellError excludes null, the optional chain is redundant:

error.message || hotelContextError

The guard is only needed if null can reach this handler at runtime.{% endcapture %}
{% include agent-message.html role="agent" content=optional_answer %}

Once we understood what was going on, we asked the agent to remove the optional chain.

It did and then rerun the tests, coverage analysis, and mutation testing to check no coverage had been lost and the mutant corresponding to the optional chain had been killed.

{% capture prompt_simplify_optional %}> simplify it{% endcapture %}
{% include agent-message.html role="user" content=prompt_simplify_optional %}

{% capture simplify_optional %}I’ll remove the redundant optional chain while preserving the handler’s typed contract (ShellError excludes null). I’m applying the Reffects and coverage guidance because this changes an event handler whose behavior is protected by its direct tests.{% endcapture %}
{% include agent-message.html role="agent" content=simplify_optional %}

{% capture optional_edit %}• Edited src/app/app-shell/load-events.ts (+1 -1)
-        ? error?.message || hotelContextError
+        ? error.message || hotelContextError{% endcapture %}
{% include agent-message.html role="tool" content=optional_edit collapsible="true" summary="Show" %}

{% capture optional_coverage %}• Ran npm run test -- tests/app/app-shell/events.spec.ts && npm run test:coverage:target -- src/app/app-shell/load-events.ts tests/app/app-shell/events.spec.ts
  └ Functions    : 100% ( 8/8 )
    Lines        : 100% ( 19/19 )
    ================================================================================{% endcapture %}
{% include agent-message.html role="tool" content=optional_coverage collapsible="true" summary="Show" %}

{% capture optional_mutation_plan %}The focused test and coverage pass, retaining 100% branch coverage. I’ll rerun the same targeted mutation scope to confirm the redundant mutation is gone.{% endcapture %}
{% include agent-message.html role="agent" content=optional_mutation_plan %}

{% capture optional_mutation_result %}• Ran npm run test:mutation:target -- src/app/app-shell/load-events.ts tests/app/app-shell/events.spec.ts
  └ 17:38:05 (2366640) INFO MutationTestExecutor Done in 1 minute and 11 seconds.
    test:mutation:target: Stryker reported 83 mutant(s).
    ⠙{% endcapture %}
{% include agent-message.html role="tool" content=optional_mutation_result collapsible="true" summary="Show" %}

{% capture optional_result %}The simplification removed that survivor: mutation score improved from 92.59% to 94.34%, with only three survivors remaining from duplicated pageShellRequestEvents branches. I’ll now format and run the completion checks for the production-code change.{% endcapture %}
{% include agent-message.html role="agent" content=optional_result %}

{% capture optional_format_and_validation %}• Ran npm run format:changed
  └ > node scripts/format-changed.mjs
    
• Ran npm run agent-validate
  └ - Using dynamic import() to code-split the application
    - Use build.rolldownOptions.output.codeSplitting to improve chunking: https://rolldown.rs/reference/OutputOptions.codeSplitting
    - Adjust chunk size limit for this warning via build.chunkSizeWarningLimit.{% endcapture %}
{% include agent-message.html role="tool" content=optional_format_and_validation collapsible="true" summary="Show" %}

{% capture optional_validation_summary %}Simplified load-events.ts (src/app/app-shell/load-events.ts:74) to use error.message.

Validation passed:

- 100% targeted coverage
- Targeted mutation score: 94.34% (the optional-chaining survivor is gone)
- npm run agent-validate: lint, 1,128 tests, and production build all pass.{% endcapture %}
{% include agent-message.html role="agent" content=optional_validation_summary %}

Three survivors remained, all related to a condition distinguishing Forecast from other pages. We asked the agent to explain what behavior the condition was producing.

{% capture branch_question %}> "Three mutations of page === \"forecast\": both branches in pageShellRequestEvents currently return equivalent event shapes, making that condition redundant from an observable-behavior perspective." <- explain me this concisely{% endcapture %}
{% include agent-message.html role="user" content=branch_question %}

{% capture branch_answer %}pageShellRequestEvents has this shape:

return page === "forecast"
  ? { successEvent: ..., errorEvent: ... }
  : { successEvent: ..., errorEvent: ... };

But both branches construct the same events. So changing the condition to always true, always false, or !== does not change output—hence the mutations survive.

It can be simplified to one returned object without the page === "forecast" condition.{% endcapture %}
{% include agent-message.html role="agent" content=branch_answer %}

The explanation suggested that the condition was redundant. Before removing it, we asked why someone might have introduced it, to check whether there was an intention worth preserving.

{% capture intent_question %}> why would that even be there??? what could its intent be? I'm amazed...{% endcapture %}
{% include agent-message.html role="user" content=intent_question %}

{% capture intent_answer %}Most likely it’s leftover scaffolding: the author expected Forecast and non-Forecast pages to eventually need different shell-load events, wrote the branching structure early, but never introduced the divergence.

There’s no current behavior justified by the condition—the tests and mutation results confirm both paths are identical. It may have been intended for things like:

- Forecast carrying a different success/error event or extra payload.
- Standards/Roles skipping or altering a shell-load step.
- A future page-specific request configuration.

Today it is dead conditional structure. Simplifying it is safe as long as there’s no near-term requirement to split those flows.{% endcapture %}
{% include agent-message.html role="agent" content=intent_answer %}

Both branches currently produced the same events, and we found no behavior that required the distinction. We therefore asked the agent to remove the duplicated conditional.

The agent simplified the code and then rerun the tests, coverage analysis, and mutation testing to check no coverage had been lost and the surviving mutant had been killed.

{% capture prompt_simplify_branch %}> simplify it{% endcapture %}
{% include agent-message.html role="user" content=prompt_simplify_branch %}

{% capture simplify_branch %}I’ll remove the duplicate Forecast/non-Forecast branches while preserving the shared success and error event contract. The existing direct tests cover both page categories, and I’ll rerun coverage and mutation testing afterward.{% endcapture %}
{% include agent-message.html role="agent" content=simplify_branch %}

{% capture branch_edit %}• Edited src/app/app-shell/load-events.ts (+6 -13)
-  return page === "forecast"
-    ? {
-        successEvent: hotelChanged{% endcapture %}
{% include agent-message.html role="tool" content=branch_edit collapsible="true" summary="Show" %}

{% capture branch_coverage %}• Ran npm run test -- tests/app/app-shell/events.spec.ts && npm run test:coverage:target -- src/app/app-shell/load-events.ts tests/app/app-shell/events.spec.ts
  └ Functions    : 100% ( 8/8 )
    Lines        : 100% ( 19/19 )
    ================================================================================{% endcapture %}
{% include agent-message.html role="tool" content=branch_coverage collapsible="true" summary="Show" %}

{% capture branch_mutation_plan %}The refactor preserves all 24 focused tests and leaves the module at 100% targeted branch coverage. I’m running the final narrow mutation check now.{% endcapture %}
{% include agent-message.html role="agent" content=branch_mutation_plan %}

{% capture branch_mutation_result %}• Ran npm run test:mutation:target -- src/app/app-shell/load-events.ts tests/app/app-shell/events.spec.ts
  └ 17:44:01 (2402337) INFO MutationTestExecutor Done in 1 minute and 7 seconds.
    test:mutation:target: Stryker reported 78 mutant(s).
    ⠙{% endcapture %}
{% include agent-message.html role="tool" content=branch_mutation_result collapsible="true" summary="Show" %}

{% capture final_result %}The duplicate branch is gone; the targeted mutation run now reports 100% mutation score (50 killed, no survivors or timeouts). I’ll finish with formatting and the full frontend gate.{% endcapture %}
{% include agent-message.html role="agent" content=final_result %}

{% capture final_tools %}• Ran npm run format:changed
  └ > node scripts/format-changed.mjs
    
• Ran npm run agent-validate && git diff --check && git status --short
  └ - Use build.rolldownOptions.output.codeSplitting to improve chunking: https://rolldown.rs/reference/OutputOptions.codeSplitting
    - Adjust chunk size limit for this warning via build.chunkSizeWarningLimit.
     M src/app/app-shell/load-events.ts
{% endcapture %}
{% include agent-message.html role="tool" content=final_tools collapsible="true" summary="Show" %}

{% capture final_summary %}Simplified pageShellRequestEvents to one shared return object in load-events.ts (src/app/app-shell/load-events.ts:96).

Results:

- Targeted coverage: 100%
- Targeted mutation score: 100% (50 killed, 0 survived)
- Lint and full 1,128-test suite passed; production build passed separately after the combined gate hit the tool time limit during build output.{% endcapture %}
{% include agent-message.html role="agent" content=final_summary %}

In this session, we saw the skill stop when branch coverage was insufficient and identify the missing characterization tests.

After adding those tests, the agent proceeded to mutation testing. The surviving mutants didn't reveal additional gaps in behavioral protection. Instead, they pointed to redundant code.

We investigated the survivors, questioned the agent's explanations, and decided to simplify the code.

The result was a smaller implementation with the same observed behavior, 100% targeted branch coverage, and no surviving mutants in the final mutation run.

Note: Stryker's mutation score excludes mutants that produce errors during execution. In the final run, 78 mutants were generated, but only 50 contributed to the score. All 50 were killed, resulting in a 100% mutation score.

