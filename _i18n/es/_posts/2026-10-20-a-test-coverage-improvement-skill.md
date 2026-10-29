---
layout: post
title: "A test coverage improvement skill"
date: 2026-10-28 06:30:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - AI
  - Open Source
  - Testing
author: Manuel Rivero
linkedin: https://www.linkedin.com/in/manuel-rivero-54411271/
written_in: english
small_image: reffects_visual_metaphor.png
---

One of the skills I've found most useful lately is one for assessing and improving the protection against regressions provided by a test suite.

The skill is called test-coverage-improvement. 
Until recently, it was called test-coverage-assessment (the name you'll see in the demos). 
I renamed it because the new name better reflects what the skill does.

I use it before refactoring code to systematically assess whether the existing tests provide enough protection against unintended changes in observable behavior, i.e., regressions.

I've also found it useful for improving characterization tests in legacy code.

## The skill in action

Let’s see it in action:

### Assessing the existing tests

{% capture initial_prompt %}{% raw %}› assess the coverage of frontend/tests/app/pages/forecast/domain/forecastColumns.ts{% endraw %}{% endcapture %}
{% include agent-message.html role="user" content=initial_prompt %}

{% capture skill_selection -%}
  {% raw %}• I’m using the frontend coverage-assessment guidance because this is a direct/indirect test-coverage review. I’ll inspect the applicable repository instructions, the target and its production dependencies, then run focused coverage checks and report gaps without changing files.{% endraw %}
{%- endcapture %}
{% capture initial_activity -%}
  {% capture command -%}
    {% raw %}• Ran pwd; find .. -name AGENTS.md -print; printf '%s\n' '--- coverage skill ---'; sed -n '1,240p' .SKILLS/test-coverage-assessment/SKILL.md; printf '%s\n' '--- target ---'; sed -n{% endraw %}
  {%- endcapture %}
  {%- include agent-message.html role="tool" content=command collapsible="true" summary="Show" %}
{%- endcapture %}
{% include agent-message.html role="agent" content=skill_selection activity=initial_activity %}

The agent inferred from my prompt that it should use the skill, without me explicitly mentioning it. 
It then started inspecting the repository to decide how to proceed. I've omitted some intermediate activity for brevity.

The agent found the spec testing the module and ran our targeted coverage script, `test:coverage:target`.

{% capture coverage_investigation -%}
  {% raw %}• The forecastColumns.spec.ts directly exercises all four exported functions, and buildColumnsFromWeekKey is also used indirectly by forecast event handling. I’m checking both paths now, with line/branch/function metrics and the production branches that the current cases do or do not reach.{% endraw %}
{%- endcapture %}
{% capture coverage_activity -%}
  {% capture tool_messages -%}
    {% capture coverage_command -%}
      {% raw %}• Ran npm run test:coverage:target -- src/app/pages/forecast/utilities/forecastColumns.ts tests/app/pages/forecast/domain/forecastColumns.spec.ts …{% endraw %}
    {%- endcapture %}
    {%- include agent-message.html role="tool" content=coverage_command %}
    {% capture mutation_command -%}
      {% raw %}• Ran npm run test:mutation:target -- src/app/pages/forecast/utilities/forecastColumns.ts tests/app/pages/forecast/domain/forecastColumns.spec.ts{% endraw %}
    {%- endcapture %}
    {%- include agent-message.html role="tool" content=mutation_command %}
  {%- endcapture %}
  {%- include agent-details.html summary="Show coverage and mutation-testing activity" content=tool_messages %}
{%- endcapture %}
{% include agent-message.html role="agent" content=coverage_investigation activity=coverage_activity %}

After checking the targeted coverage, the agent considered the branch coverage high enough to justify running mutation testing.

Once mutation testing finished, the agent reported its findings. 

Several mutants survived. The agent assessed which ones revealed weaknesses in the tests 
(the [relevant mutants](https://codesai.com/posts/2026/02/relevant_mutants_in_a_flash)) and which ones were equivalent or affected unreachable code.

{% capture assessment -%}
  {% raw %}
• Assessment: covered with two meaningful gaps.

- Direct spec: 13/13 tests pass.
- Indirect integration: initialization test also asserts the generated columns.
- Targeted coverage: 97.67% statements, 83.33% branches, 100% functions.
- Uncovered line 94 (continue) is effectively unreachable because dateToIsoWeekKey() always returns a syntactically valid key.

Mutation testing found 7 survivors. The meaningful gaps are:

1. parseWeekKey() lacks tests for malformed keys with valid prefixes/suffixes, such as 2026-W04-extra; regex-anchor mutations survived.
  	src/app/pages/forecast/utilities/forecastColumns.ts:13

2. buildColumnsFromWeekKey() is only started at W01. Arithmetic mutations in ISO-week conversion survived because (week - 1) is zero. Add a case starting at W04 or another non-first week.
       src/app/pages/forecast/utilities/forecastColumns.ts:30

Other survivors were either equivalent (slice(+2) behaves like slice(-2) for four-digit years) or defensive/unreachable behavior.
  {% endraw %}
{%- endcapture %}
{% include agent-message.html role="agent" content=assessment %}

The agent concluded its assessment with this verdict about regression protection:

{% capture verdict -%}
  {% raw %}Verdict: Insufficiently covered for high-confidence regression protection, despite excellent line/function coverage.{% endraw %}
{%- endcapture %}
{% include agent-message.html role="agent" content=verdict %}

What's interesting here is that the module already had very high statement and function coverage, but mutation testing still revealed two meaningful gaps in the tests.

### Improving the tests

I then asked the agent to improve the protection against regressions without changing any production code. 
I wanted to avoid the problems I described in my [previous post](https://codesai.com/posts/2026/04/agents-blindly-killing-mutants) 
about agents blindly trying to kill surviving mutants.

{% capture improvement_prompt -%}
  {% raw %}› kill the mutants you can without changing any production code (types or interfaces){% endraw %}
{%- endcapture %}
{% include agent-message.html role="user" content=improvement_prompt %}

The agent started adding tests to kill the relevant surviving mutants. I've omitted some intermediate activity for brevity:

{% capture test_improvement -%}
  {% raw %}• I’ll update only the forecast-column tests, targeting the mutation survivors that represent real behavior gaps. I’m reading the frontend test-writing guidance first, then I’ll add focused cases, rerun coverage and mutation testing, and leave production types/interfaces untouched.{% endraw %}
{%- endcapture %}

{% capture implementation_messages -%}
  {% capture explored -%}
    {% raw %}• Explored
  └ Read SKILL.md, forecastColumns.spec.ts, run-targeted-mutation.mjs{% endraw %}
  {%- endcapture %}
  {%- include agent-message.html role="tool" content=explored %}
  
  {% capture edited -%}
    {% raw %}• Edited tests/app/pages/forecast/domain/forecastColumns.spec.ts (+26 -0)
    …{% endraw %}
  {%- endcapture %}
  {%- include agent-message.html role="tool" content=edited %}
  
  {% capture tests -%}
    {% raw %}• Ran npm run typecheck:test && npx vitest run tests/app/pages/forecast/domain/forecastColumns.spec.ts --reporter=verbose
    …{% endraw %}
  {%- endcapture %}
  {%- include agent-message.html role="tool" content=tests %}
{%- endcapture %}
{% capture implementation_activity -%}
  {%- include agent-details.html summary="Show test-writing activity" content=implementation_messages %}
{%- endcapture %}
{% include agent-message.html role="agent" content=test_improvement activity=implementation_activity %}

The agent then reran mutation testing to check whether the new tests killed the relevant mutants:

{% capture focused_test_result %}{% raw %}• The focused suite now has 17 passing tests. The added cases cover strict week-key anchoring, the runtime nullish fallback, and generation from a non-first ISO week; I’m rerunning mutation testing to distinguish killed survivors from equivalent or unreachable mutations{% endraw %}{% endcapture %}

{% capture second_mutation_messages -%}
{% capture second_mutation_command %}{% raw %}• Ran npm run test:mutation:target -- src/app/pages/forecast/utilities/forecastColumns.ts tests/app/pages/forecast/domain/forecastColumns.spec.ts
…{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=second_mutation_command collapsible="true" summary="Show follow-up mutation-testing activity" %}
{%- endcapture %}

{% include agent-message.html role="agent" content=focused_test_result activity=second_mutation_messages %}

After a while, the agent reported that the new tests had killed all the relevant surviving mutants and classified the remaining ones as behaviorally equivalent
[andamio: esto debe ir a una nota: I later examined the remaining mutants to see whether any of them pointed to superfluous production code that could be removed.]

{% capture mutation_result %}{% raw %}• Mutation testing improved from 48 to 52 killed mutants, raising the mutation score from 87.72% to 94.74%. The three remaining survivors are equivalent for the public behavior: the nullish fallback still produces an invalid key either way, removing the ISO-date
  normalization block preserves the derived week key, and slice(+2) equals slice(-2) for four-digit years. I’m formatting and running the frontend completion gate now.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=mutation_result %}

The agent then ran the final validation gate and summarized the changes:

{% capture validation %}{% raw %}• Ran npm run agent-validate…{% endraw %}
{% endcapture %}
{% include agent-message.html role="tool" content=validation %}

{% capture completion_summary %}{% raw %}• Updated only frontend/tests/app/pages/forecast/domain/forecastColumns.spec.ts.

  Added tests for:

  - Strict rejection of prefixed/suffixed week keys.
  - Missing week-key fallback.
  - Column generation from a non-first week (W04), killing the ISO arithmetic mutants.

  Results:

  - 17 focused tests passing.
  - Coverage: 97.67% statements, 91.66% branches, 100% functions.
  - Mutation score: 94.74% — 52/55 covered mutants killed.
  - Remaining 3 survivors are equivalent for observable behavior.
  - npm run agent-validate passed: lint, 332 tests, and production build.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=completion_summary %}

### Examining the remaining mutants

I wanted to understand why the remaining mutants had survived, so I asked the agent to explain them:

{% capture survivors_prompt %}{% raw %}› what about the remaining survivors? tell me about them{% endraw %}{% endcapture %}
{% include agent-message.html role="user" content=survivors_prompt %}

{% capture survivor_explanation %}{% raw %}• The three remaining survivors are:

1. Nullish fallback replacement

frontend/src/app/pages/forecast/utilities/forecastColumns.ts:13

Mutation:  weekKey ?? ""

becomes: weekKey ?? "Stryker was here!"

Both values fail the week-key regex, so both produce null. The mutation is behaviorally equivalent unless parseWeekKey is changed to return a different result for arbitrary invalid strings.

2. Removing ISO-week normalization

frontend/src/app/pages/forecast/utilities/forecastColumns.ts:34

Mutation removes the dayOfWeek <= 4 branch body. Although this changes the intermediate date from the calculated Monday, the caller immediately converts that date back into an ISO week key. The resulting week key remains the same, so the public output does not change.

3. slice(-2) changed to slice(+2)

frontend/src/app/pages/forecast/utilities/forecastColumns.ts:70

For four-digit years:
 	"2026".slice(-2) // "26"
 	"2026".slice(+2) // "26"

Therefore this mutation is equivalent under the current four-digit year contract.

None currently indicates a missing behavioral assertion. Killing them would require tests coupled to intermediate implementation details or changing the production contract.
{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=survivor_explanation %}

The agent explained why each mutant had survived. I agreed with its assessment that trying to kill them would only lead to tests coupled to implementation details.

Now that we've seen the skill in action, let's look at how it's written and how it guides the agent through this process.

## How the skill works



