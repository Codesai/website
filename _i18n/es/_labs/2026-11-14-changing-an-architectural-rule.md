---
layout: post
title: "Changing an Architectural Rule Skilfully"
date: 2026-11-14 10:00:00.000000000 +01:00
author: Manuel Rivero
linkedin: https://www.linkedin.com/in/manuel-rivero-54411271/
written_in: english
categories: [Agentic-AI, AI experiments, Architecture, Testing]
---

In this lab we show a session in which an agent used our architecture-rules skill to modify an existing architectural rule.

The change itself was quite simple: we wanted to prevent domain classes from using `javax`. The interesting part is how the skill guided the agent through the process of changing the rule and checking that it still worked.

We had previously experimented with using LLM-generated counter-examples to test our architectural rules. This time, we wanted the agent to follow that approach as part of a repeatable workflow defined in a skill.

## Finding the gap between current code and the rule

{% capture initial_prompt %}{% raw %}> are we using any javax in the domain code?{% endraw %}{% endcapture %}
{% include agent-message.html role="user" content=initial_prompt %}

{% capture investigation_plan %}{% raw %}Now I'm examining the Java files in the domain area to identify where javax libraries are used, aiming to understand dependencies or features relying on these imports.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=investigation_plan %}

The agent found no `javax.*` imports in the domain code. However, `javax` was included in the dependencies allowed by the architecture test.

So, although the code was already following the constraint we wanted, the architecture test would allow someone to introduce a `javax` dependency into the domain without complaining.

{% capture initial_result %}{% raw %}No, we are not using any javax APIs in the domain code.

Where javax appears across the codebase:

1. Infrastructure Layer: javax.sql.DataSource is imported in src/main/java/com/dreamplace/cde/infrastructure/shared/persistence/PostgresSqlJdbcDatabaseConnection.java.
2. Architecture Rules: "javax.." is listed in ArchitectureRulesTests.java alongside "java.." to permit any standard Java SE platform extension packages should one ever be needed, but none are currently referenced by domain classes.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=initial_result %}

## Applying the architecture-rules skill

{% capture change_request %}{% raw %}> modify the architecture rule so that domain can't use javax either{% endraw %}{% endcapture %}
{% include agent-message.html role="user" content=change_request %}

We asked the agent to change the rule. Since the repository has an `architecture-rules` skill, the agent used it to guide the work.

The skill describes how to add or modify architectural rules, including how to generate and store counter-examples that can be used to check that the rules actually work.

As we can see in the following trace, the agent started by reading the skill, the existing architecture tests, and the counter-examples already available in the project.

{% capture skill_inspection %}{% raw %}I will examine the architecture rules and relevant architectural testing guidelines to prepare for removing the javax dependency exemption from the domain layer constraints.

• Read src/test/java/com/dreamplace/cde/architecture_rules/ArchitectureRulesTests.java
• Searched "javax"
• Read .SKILLS/architecture-rules/SKILL.md
• Read src/test/java/com/dreamplace/cde/architecture_rules/counter-examples/counter-examples.json
• Read src/test/java/com/dreamplace/cde/architecture_rules/counter-examples/domain-external-dependency.md
• Read src/test/java/com/dreamplace/cde/architecture_rules/counter-examples/validations-external-dependency.md{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=skill_inspection collapsible="true" summary="Show the architecture-rules skill being applied" %}

Before changing anything, the skill instructed the agent to run the architectural mutation tests to establish a baseline.

As we explained in [our previous post](https://codesai.com/posts/2026/06/architectural-mutants), the mutation script introduces previously generated counter-examples, one at a time, and checks whether the corresponding architectural tests fail. The counter-examples are stored, so we don't need an LLM to generate them every time we run the tests.

In this case, all eight existing mutants were killed. This meant that the architecture tests were still detecting the violations represented by those counter-examples before we started changing the rule.

{% capture baseline %}{% raw %}Architecture test mutation report
Killed mutants: 8
Surviving mutants: 0
Architectural rules without counter-examples:
  - none

All architecture mutation tests passed with no surviving mutants.{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=baseline collapsible="true" summary="Show the architecture-rule baseline" %}

## Enforcing the boundary and proving it

The agent removed `javax..` from the dependencies allowed for domain and validation classes. The domain could now depend only on its own classes and `java..`, while validations kept their existing exception for `org.apache.commons.lang3.Validate`.

But we also wanted to see the modified rule fail when confronted with a counter-example. Otherwise, we would only know that we had changed the test, not that it was checking what we intended.

Following the skill, the agent generated a counter-example that introduced a dependency on `javax.sql.DataSource` into a domain class. You can see the complete counter-example, including the expected failure and its verification, in [this Gist](https://gist.github.com/trikitrok/515783e62a10d74ac1f34d49395cce1f).

It also documented the counter-example and registered it as `domain-javax-dependency`, so that the mutation script could use it in future runs.

After adding the new counter-example, the mutation script reported nine killed mutants and no survivors. The new mutant was killed by `domain_classes_should_only_depend_on_domain_and_java_se`, which was the rule we wanted to check.


{% capture counter_example %}{% raw %}Edited src/test/java/com/dreamplace/cde/architecture_rules/counter-examples/domain-javax-dependency.md +34
Edited src/test/java/com/dreamplace/cde/architecture_rules/counter-examples/counter-examples.json +12

Testing domain-javax-dependency...

Killed mutants: 9
  - domain-javax-dependency: domain_classes_should_only_depend_on_domain_and_java_se
Surviving mutants: 0{% endraw %}{% endcapture %}
{% include agent-message.html role="tool" content=counter_example collapsible="true" summary="Show the new javax counter-example" %}

The counter-example document confirmed that `make arch-tests` failed for the expected reason: the domain rule detected the dependency on `javax.sql.DataSource`.

At this point, we would have liked the agent to stop and ask us to review the counter-example and the failing architectural test. We wanted to check that the counter-example was actually violating the intended constraint and that the test was failing for the right reason.

However, in this session the agent didn't stop. It continued with the rest of the work without asking for approval 🤷 ... This is something we need to make more explicit in the skill.

The mutation script removed the temporary violating code after running the tests, but the counter-example remained stored so that it could be used again in future mutation runs.

The agent also updated `ARCHITECTURE.md`, `AGENTS.md`, and the existing dependency counter-example descriptions to reflect the change.

This was part of keeping the architectural rules and the documentation that agents use consistent.

## Verification

The agent finished by running the mutation tests again. All nine mutants were killed, including the new one.

It also ran the project's usual checks: `make test` executed 1,460 tests without failures, and `make pmd` reported no violations.

The new counter-example was now part of the architectural mutation suite. If we change the architectural rule again in the future, the script will introduce the same `javax` dependency and check whether the rule still detects it, without having to ask an LLM to generate the counter-example again.

{% capture final_response %}{% raw %}Updated the architecture rules and architectural documentation to disallow javax dependencies in domain code.

Changes
• Modified ArchitectureRulesTests.java to remove "javax.." from allowedDomainDependencies and allowedValidationsDependencies.
• Added a new counter-example domain-javax-dependency demonstrating that a domain dependency on javax.sql.DataSource is caught and fails the architecture test.
• Updated documentation in ARCHITECTURE.md, AGENTS.md, and counter-example markdown files.

Verification
• Ran make arch-mutation-tests killing all 9 mutants with 0 surviving.
• Ran make test executing all 1,460 tests with 0 failures.
• Ran make pmd confirming 0 static analysis violations.{% endraw %}{% endcapture %}
{% include agent-message.html role="agent" content=final_response %}

## Conclusion

This was a small change, but I think it illustrates quite well what we are trying to achieve with the `architecture-rules` skill.

Instead of just asking the agent to change an architectural test, we gave it a workflow to follow. It checked the existing mutants before making changes, generated a new counter-example for the modified rule, and stored it for future mutation runs.

The agent did skip the human review step. We need to make sure that the workflow gives us the opportunity to inspect the counter-example and the failing test before accepting a change to an architectural rule.

Apart from that, the session shows how we can combine the inferential work of an agent with deterministic tests. We use the LLM to generate the counter-example once, and then rely on the mutation script to check the rule whenever we change it.

