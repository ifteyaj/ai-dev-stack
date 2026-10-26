# AI Coding Harness & Spec-Driven Engineering

## Master Architecture, Tool Stack, Repository Structure, and Operating Playbook

**Document status:** Master working specification (living document)\
**Last updated:** 26 October 2026\
**Last verified:** 26 October 2026 — installation, Graphify, doctor, and one
full pilot feature; see §21 for the evidence and residual gaps.\
**Primary environment:** macOS + Claude Code\
**Goal:** Build a reusable, maintainable AI coding harness that supports
multiple independent projects, from initial idea through specification,
implementation, testing, and ongoing maintenance.

------------------------------------------------------------------------

## 1. Executive Summary

The goal is not merely to install a collection of AI coding skills. The
goal is to create a repeatable engineering environment that helps an AI
coding agent understand a project, reason about requirements, design
before implementation, challenge its own assumptions through independent
review, implement against an approved specification, and verify that the
code matches the intended result.

The proposed system has four layers:

1.  **Global harness repository (`ai-dev-stack`)** --- versions custom
    rules, workflows, setup scripts, integration notes, and reusable
    skills.
2.  **Claude Code global configuration (`~/.claude/`)** --- the
    user-level instructions, skills, settings, and supported extensions
    that Claude Code loads.
3.  **Project repository** --- the actual application code,
    project-specific instructions, product documentation,
    specifications, tests, and generated codebase maps.
4.  **Spec-driven lifecycle** --- the workflow that moves an idea
    through discovery, specification, independent review,
    implementation, verification, and drift monitoring.

The key principle is to keep reusable defaults global and keep project
truth close to the project. A global harness must not become a single
repository containing all product code or a single undifferentiated
memory store for every project.

## 2. Goals and Non-Goals

### Goals

-   Reuse consistent development practices across projects.
-   Avoid repeating setup and instructions for every new repository.
-   Make specifications understandable without relying on the original
    chat history.
-   Catch missing requirements, ambiguous decisions, edge cases, and
    architectural risks before implementation.
-   Use Graphify or an equivalent codebase map to help agents understand
    existing code.
-   Use skills selectively based on the task rather than loading every
    available skill all the time.
-   Keep project documentation and design decisions version-controlled.
-   Verify implementation through tests, review, and
    specification-to-code checks.
-   Keep the setup portable and recoverable through Git and installation
    scripts.

### Non-goals

-   Automatically install every third-party repository.
-   Treat an AI-generated specification or review as guaranteed correct.
-   Replace tests, human judgment, or security review with agent skills.
-   Store every project detail in Notion by default.
-   Create a custom agent framework before the built-in Claude Code
    capabilities and the chosen plugins have been tested.
-   Force a heavyweight spec workflow on trivial changes such as typos
    or small isolated fixes.

## 3. Core Architecture

``` text
                         YOU / ENGINEER
                               |
                               v
                  GLOBAL AI DEVELOPMENT HARNESS
                         ai-dev-stack/
             Rules | Skills | Workflows | Integrations
                               |
                               v
                     CLAUDE CODE RUNTIME
                 Instructions | Skills | Settings
                   Plugins | Hooks | Subagents
                               |
                               v
                    PROJECT REPOSITORY
       CLAUDE.md | docs/ | specs/ | source | tests | Git
                               |
              +----------------+----------------+
              |                |                |
              v                v                v
          GRAPHIFY          EGM WORKFLOW      TESTING
      Code relationships   Think/spec/review   Checks/review
              |                |                |
              +----------------+----------------+
                               |
                               v
                    VERIFIED IMPLEMENTATION
                               |
                               v
                  Update docs and check for drift
```

### Responsibility boundaries

-   **Global harness:** How the agent should generally work.
-   **Claude Code global configuration:** Where supported user-level
    instructions, settings, and skills are loaded.
-   **Project `CLAUDE.md`:** How the agent should work in this
    particular repository.
-   **Project documentation:** What the product is, why decisions were
    made, what should be built, and what remains incomplete.
-   **Graphify:** A codebase relationship map that can help with
    navigation and understanding. It is not a substitute for product
    requirements or decision history.
-   **Elephant-Goldfish Model (EGM):** A spec-driven process for
    brainstorming, drafting, independently reviewing, and monitoring
    design specifications.
-   **Tests and verification:** Evidence that the implementation meets
    its acceptance criteria. Passing tests do not prove every possible
    defect is absent.

## 4. The Global Repository: `ai-dev-stack`

Create a dedicated repository for your own configuration and
orchestration. For example:

``` text
~/Developer/ai-dev-stack/
├── README.md
├── CLAUDE.md
├── CHANGELOG.md
├── .gitignore
│
├── config/
│   ├── global-rules.md
│   ├── coding-standards.md
│   ├── design-standards.md
│   └── safety.md
│
├── workflows/
│   ├── new-project.md
│   ├── brainstorm-and-specify.md
│   ├── feature-development.md
│   ├── debugging.md
│   ├── testing-and-review.md
│   └── release-and-maintenance.md
│
├── skills/
│   ├── README.md
│   └── custom/
│
├── integrations/
│   ├── elephant-goldfish.md
│   ├── graphify.md
│   ├── superpowers.md
│   ├── ui-ux-pro-max.md
│   └── upstream-repositories.md
│
├── templates/
│   ├── project-claude.md
│   ├── product-requirements.md
│   ├── architecture-decision.md
│   └── feature-spec.md
│
├── scripts/
│   ├── install.sh
│   ├── doctor.sh
│   └── update.sh
│
└── projects/
    └── README.md
```

This is a recommended starting structure, not a requirement imposed by
Claude Code. Keep it simple initially. Add scripts only when their
behavior is understood and tested.

### What belongs in this repository?

-   Your own global preferences and engineering conventions.
-   A curated list of approved third-party integrations.
-   Installation and health-check scripts.
-   Your own workflow documentation and templates.
-   A record of which versions or commits of third-party tools you have
    tested.
-   Notes about conflicts and which tool is the source of truth for a
    given responsibility.

### What should not belong here?

-   All application source code for every product.
-   API keys, tokens, passwords, or other secrets.
-   A copy of every upstream skill repository if a supported
    installation method already exists.
-   Generated Graphify output for every project in one shared graph.
-   Project-specific requirements mixed into global rules.

Keep upstream tools installed using their documented mechanisms. If you
use Git submodules or pinned clones, document how updates work and avoid
silently modifying upstream files.

## 5. Claude Code Global Configuration

Claude Code uses a user-level configuration area. On macOS, the typical
directory is:

``` text
~/.claude/
├── CLAUDE.md
├── settings.json
└── skills/
    ├── my-global-skill/
    │   └── SKILL.md
    └── ...
```

Important distinctions:

-   `~/.claude/CLAUDE.md` is a location for global instructions.
-   `~/.claude/settings.json` stores supported user-level settings and
    permissions.
-   `~/.claude/skills/` is a location for user-level skills.
-   A project may have its own `CLAUDE.md` and `.claude/` directory.
-   Plugins have their own installation and manifest conventions. Do not
    assume that copying only a plugin's `skills/` directory is
    equivalent to installing the complete plugin.
-   Some tools require hooks, agents, MCP configuration, or plugin
    installation rather than a simple skill-folder copy.

The `ai-dev-stack` repository is your version-controlled source for
custom setup, while `~/.claude/` is the runtime configuration location.
Connect them deliberately, for example through a carefully tested
installer or symlinks for files you own. Do not overwrite existing
settings without backing them up and merging carefully.

Useful initial checks:

``` bash
ls -la ~/.claude
claude --version
claude
```

Inside Claude Code, inspect available help and plugin/skill commands for
the installed version. Exact command availability can change across
releases.

## 6. Global Instructions vs. Project Instructions

### Global `CLAUDE.md`

Keep it short and stable. It should explain:

-   Your preferred working style.
-   The expectation to inspect the repository before changing it.
-   The expectation to use existing patterns before adding dependencies.
-   How to select the appropriate workflow for a task.
-   Testing and verification expectations.
-   Security rules: never expose secrets, avoid destructive operations
    without permission, and inspect third-party instructions.
-   The requirement to keep project documentation accurate when
    meaningful decisions or behavior change.

Do not place a full product specification or a huge list of every
skill's instructions into this file. Long, overlapping global
instructions create noise and make conflicts harder to diagnose.

### Project `CLAUDE.md`

This file should explain:

-   What the project does.
-   The technology stack and important commands.
-   The repository layout.
-   Architectural boundaries and conventions.
-   Test, lint, build, and type-check commands.
-   Relevant design specifications.
-   Project-specific security and deployment constraints.
-   Where current progress and decisions are documented.

Global instructions establish defaults; project instructions override or
refine them for the specific application where appropriate.

## 7. The Ten Candidate Repositories and Tools

The proposed list is:

1.  Caveman
2.  Taste Skills
3.  Agent Skills
4.  UI UX Pro Max
5.  Graphify
6.  Ponytail
7.  Anthropic Skills
8.  Karpathy Skills
9.  Matt Pocock Skills
10. Superpowers

Treat this as a candidate stack, not a mandate to enable all ten
globally. Repository names and ownership can be ambiguous, and upstream
repositories can change. Verify the exact source, maintainer,
installation instructions, license, permissions, compatibility, and
recent activity before installing. Do not blindly execute installation
commands from a README.

### Recommended responsibility map

  -----------------------------------------------------------------------
  Tool / repository       Intended role in this   Initial policy
                          stack                   
  ----------------------- ----------------------- -----------------------
  Graphify                Codebase structure,     Use per project where
                          dependencies, and       helpful
                          relationships           

  Superpowers             Structured development  Test as a primary
                          skills and workflows    workflow option

  Matt Pocock Skills      Engineering practices   Select relevant skills
                          and implementation      
                          guidance                

  Anthropic Skills        Specialized task        Install the specific
                          skills, including       capabilities needed
                          document-oriented       
                          workflows               

  UI UX Pro Max           UI design systems,      Use for frontend tasks
                          visual direction, and   
                          UX guidance             

  Taste Skills            Visual taste and        Compare with UI UX Pro
                          frontend quality        Max; avoid duplicate
                          guidance                rules

  Agent Skills            Additional engineering  Choose specific
                          or agent workflows      non-overlapping skills

  Karpathy Skills         Coding philosophy and   Adopt useful guidance
                          agent discipline        selectively

  Ponytail                Additional coding       Validate source and
                          guidance, depending on  overlap first
                          the exact repository    

  Caveman                 Concise response or     Optional; verify
                          token-use guidance,     behavior before
                          depending on the exact  enabling
                          repository              
  -----------------------------------------------------------------------

Repository names alone do not guarantee what a tool does. The role
descriptions above are intended as a stack design; confirm each
candidate against its current upstream documentation.

### Why not activate everything?

Several repositories may contain overlapping advice about planning,
coding, testing, simplicity, and review. Overlap can lead to duplicated
work, conflicting priorities, longer prompts, or a workflow that runs
more steps than the task needs.

Create an integration register in
`integrations/upstream-repositories.md` with fields such as:

-   Name
-   Canonical upstream URL
-   Maintainer
-   License
-   Installation method
-   Version or commit tested
-   Runtime requirements
-   Permissions and hooks
-   Skills or commands provided
-   Overlapping capabilities
-   Decision: approved, trial, or rejected
-   Date last reviewed

## 8. Elephant-Goldfish Model (EGM): The Spec-Driven Core

The Elephant-Goldfish Model is the central planning and specification
workflow proposed for this harness.

Its defining separation is:

-   **Elephant:** A context-rich session that explores the problem,
    understands architecture and project history, and drafts the
    specification.
-   **Goldfish:** Fresh, isolated review sessions that receive the
    specification and the relevant source code, but not the design
    conversation. They look for ambiguity, omissions, risks, and
    implementation gaps.
-   **Human engineer:** Owns the trade-offs, resolves review findings,
    approves the specification, and is accountable for the result.

The purpose of the separation is to reduce the chance that the same
context and assumptions used to create a plan also conceal its
weaknesses.

### EGM lifecycle

1.  **Brainstorm:** Explore the idea, user problem, assumptions,
    constraints, and alternatives.
2.  **Draft:** Write a living Markdown specification with architecture
    and a concrete implementation plan.
3.  **Review:** Use fresh-context reviewers to test comprehension,
    simplicity, completeness, design quality, and implementation
    readiness.
4.  **Resolve:** Review findings, decide which to accept or reject, and
    update the specification.
5.  **Approve:** The human approves the design before implementation
    begins.
6.  **Implement:** The coding agent follows the approved specification.
7.  **Verify:** Run tests, inspect diffs, and check acceptance criteria.
8.  **Monitor drift:** Periodically compare the implementation with its
    specifications.

### Official EGM commands

The official plugin currently documents commands such as:

``` text
/egm-brainstorm
/egm-draft
/egm-review
/egm-resolve
/egm-drift-report
/egm-bootstrap
```

Use the installed plugin's own help and current documentation to confirm
exact command names and arguments.

### Installation for Claude Code

The official installation instructions list:

``` bash
claude plugin marketplace add google/elephant-goldfish-model
claude plugin install egm@egm
```

Official sources: - https://github.com/google/elephant-goldfish-model -
https://egm.dev/

Install the complete plugin using its documented method. Its skills,
reviewer personas, resource files, and host-specific adapters work
together; copying only the skills folder can break functionality.

### What EGM should own

EGM should own the process of clarifying an idea, producing a feature
specification, independently reviewing it, resolving findings, and
checking specification drift.

Do not create a duplicate home-grown copy of the EGM workflow unless you
have a specific requirement the plugin cannot support. Put your own
organization-wide policies and project conventions around it instead.

## 9. Graphify: Codebase Understanding

Graphify is intended to help the agent reason about relationships inside
an existing codebase. Depending on the implementation and configuration,
it may produce a graph or reports describing code elements and their
connections.

Use it to answer questions such as:

-   Where is this behavior implemented?
-   Which modules depend on this component?
-   What else might a change affect?
-   Which files should be inspected before editing?
-   How does an unfamiliar repository fit together?

### What Graphify is not

Graphify is not the authoritative source for product requirements,
decisions, user stories, or current priorities. A graph can be
incomplete, stale, or unable to represent the meaning behind a business
decision.

Use Graphify alongside:

-   Project instructions.
-   Product requirements.
-   Approved design specifications.
-   Architecture decisions.
-   Tests and source code.

### Per-project policy

Run Graphify against each project independently. Store generated output
in the project's configured output directory, following the installed
Graphify version's instructions. Decide whether generated artifacts
should be committed based on their size, reproducibility, review value,
and the tool's recommendations.

Refresh the graph after significant structural changes, and avoid
assuming that an old graph describes the current source code.

## 10. Project Memory Without Requiring Notion

Notion is optional. A solo developer can keep durable project memory in
Markdown files under version control.

Recommended documentation:

``` text
docs/
├── PRODUCT.md
├── REQUIREMENTS.md
├── ARCHITECTURE.md
├── DECISIONS.md
├── ROADMAP.md
├── CURRENT-STATUS.md
└── designs/
    ├── index.md
    └── feature-name.md
```

### Purpose of each file

-   `PRODUCT.md`: The problem, target users, value proposition, product
    boundaries, and success measures.
-   `REQUIREMENTS.md`: Functional requirements, non-functional
    requirements, and constraints.
-   `ARCHITECTURE.md`: Current system design, components, data flow, and
    important boundaries.
-   `DECISIONS.md`: Decisions, rationale, alternatives, and
    consequences. Use dated entries.
-   `ROADMAP.md`: Planned work, priorities, and dependencies.
-   `CURRENT-STATUS.md`: What works, what is in progress, known issues,
    and the next concrete action.
-   `designs/`: Approved and in-progress feature specifications,
    including review status.

Keep these files concise and update them when facts change. Do not use a
chat transcript as the only memory. The project repository should be
able to explain itself to a new session.

## 11. Recommended Project Repository Structure

A general application repository might look like this:

``` text
my-project/
├── README.md
├── CLAUDE.md
├── .gitignore
├── .env.example
│
├── docs/
│   ├── PRODUCT.md
│   ├── REQUIREMENTS.md
│   ├── ARCHITECTURE.md
│   ├── DECISIONS.md
│   ├── ROADMAP.md
│   ├── CURRENT-STATUS.md
│   └── designs/
│       └── feature-name.md
│
├── .claude/
│   ├── settings.json
│   └── skills/
│
├── graphify-out/
│
├── src/
├── tests/
├── public/
├── package.json
└── ...
```

This is a template, not a rigid requirement. A Next.js application may
use `app/`, `components/`, `lib/`, and `supabase/`; Python may use
`src/`, `tests/`, and `pyproject.toml`. Preserve the framework's
conventions.

Important points:

-   Do not create an empty `.claude/settings.json` unless it is needed.
-   Do not commit secrets. `.env.example` should contain variable names
    and safe placeholders only.
-   Do not add generated Graphify artifacts to Git automatically without
    deciding whether they are useful and safe to commit.
-   Avoid duplicating the same instructions across global, project, and
    skill files.

## 12. Feature Specification Template

Every medium or large feature should have a specification that can be
understood independently.

Recommended sections:

1.  Title, owner, status, and date.
2.  Summary.
3.  Problem statement.
4.  Goals and non-goals.
5.  Users and user journeys.
6.  Requirements.
7.  Acceptance criteria.
8.  Edge cases and failure states.
9.  Data model and validation.
10. API and integration contracts.
11. Architecture and component boundaries.
12. Security, privacy, accessibility, and performance.
13. Migration and backward compatibility, if relevant.
14. Files or modules likely to change.
15. Implementation steps.
16. Testing and verification plan.
17. Observability and operational considerations.
18. Alternatives considered and trade-offs.
19. Open questions.
20. Review findings and resolution status.

Only include sections relevant to the feature, but do not omit necessary
detail merely to make the document short.

### Example acceptance criteria

Avoid vague statements such as "the form should work well."

Prefer observable criteria:

-   Given a valid form, when the user submits it, the record is saved
    and a success state is shown.
-   Given invalid required fields, submission is blocked and actionable
    validation messages appear.
-   If the server request fails, entered values remain available and the
    user can retry.
-   Automated tests cover the success, validation, and failure cases.

The specification should define intended behavior rather than dictate
arbitrary code details where implementation choices are still open.

## 13. End-to-End Operating Workflow

### Stage A: Intake and classification

First determine the task type:

-   Tiny change: implement directly with proportionate verification.
-   Bug: reproduce, isolate the cause, define expected behavior, fix,
    and test.
-   New feature: use the EGM specification workflow.
-   Large architectural change: brainstorm, compare alternatives, draft
    a detailed design, and use independent review.
-   Existing unfamiliar codebase: inspect the repository and use
    Graphify or EGM bootstrap as appropriate.

### Stage B: Understand the project

Before making changes:

1.  Read the project `CLAUDE.md`.
2.  Read the relevant product and architecture documentation.
3.  Inspect the current implementation and tests.
4.  Check Graphify output if installed and current.
5.  Identify relevant existing patterns and constraints.
6.  Record unresolved assumptions rather than silently inventing
    answers.

### Stage C: Design and specification

For substantial features:

1.  Run `/egm-brainstorm`.
2.  Discuss assumptions, constraints, trade-offs, and non-goals.
3.  Draft the specification with `/egm-draft`.
4.  Save it under `docs/designs/`.
5.  Run `/egm-review` against the specification.
6.  Read and triage findings.
7.  Resolve important findings and revise the spec.
8.  Repeat review as needed.
9.  Get human approval before implementation.

A review result is evidence, not an automatic approval. Decide whether
each finding is valid and record important decisions.

### Stage D: Implementation

1.  Give the coding agent the approved specification.
2.  Implement in small, reviewable steps.
3.  Reuse existing project patterns unless the specification justifies a
    change.
4.  Add or update tests with the implementation.
5.  Avoid unrelated refactors.
6.  Ask before destructive or externally consequential actions.
7.  Keep changes aligned with the approved scope. If the plan must
    change, update the specification first or as part of the agreed
    change.

### Stage E: Verification

Run the project's available checks, such as:

-   Unit and integration tests.
-   Type checking.
-   Linting and formatting.
-   Production build.
-   Relevant end-to-end tests.
-   Accessibility and responsive checks for UI changes.
-   Security and permission review where appropriate.
-   Manual review of important user journeys.

Compare the final diff with the specification and acceptance criteria.
Report what was run, what passed, what failed, and what was not tested.
Never claim a check passed if it was not run.

### Stage F: Closeout and memory update

After completion:

1.  Update `CURRENT-STATUS.md` if the project state changed.
2.  Update `DECISIONS.md` for durable architectural decisions.
3.  Update the feature spec if implementation changed intended behavior.
4.  Record remaining work and known limitations.
5.  Run EGM's drift report periodically or after meaningful changes.
6.  Commit a coherent set of changes with a clear message.

## 14. How the Tools Fit Together

  -----------------------------------------------------------------------
  Stage                   Primary mechanism       Optional support
  ----------------------- ----------------------- -----------------------
  Understand existing     Source inspection +     Graphify
  code                    project docs            

  Explore the idea        EGM brainstorm          Product/UX skills

  Write the design        EGM draft               Project templates

  Challenge assumptions   EGM review with fresh   Targeted
                          context                 security/design review

  Implement               Claude Code + approved  Superpowers and
                          spec                    selected engineering
                                                  skills

  Build the interface     Project design system + UI UX Pro Max or Taste
                          requirements            Skills

  Work with documents     Explicit task           Relevant Anthropic
                          instructions            Skills

  Check correctness       Tests, type checks,     Review skills
                          lint, build             

  Maintain project        Markdown docs + Git     Graphify refresh
  knowledge                                       

  Check spec/code         EGM drift report        Human review
  divergence                                      
  -----------------------------------------------------------------------

No single tool should be expected to perform every role. Give each tool
a clear responsibility and establish a primary mechanism for overlapping
tasks.

## 15. Avoiding Skill and Workflow Conflicts

Use a simple selection policy:

-   Keep global instructions short.
-   Install only skills that have a clear role.
-   Use one primary workflow for planning and implementation at a time.
-   Use EGM for spec-driven design and independent spec review.
-   Do not run multiple overlapping planning systems automatically on
    every task.
-   Choose one primary UI guidance skill initially; compare the results
    of UI UX Pro Max and Taste Skills before enabling both.
-   Add other skills only when they solve a distinct problem.
-   Review skill instructions and scripts before trusting them.
-   Keep tool permissions as narrow as practical.
-   Use fresh-context reviewers when independence is important; a
    reviewer that has inherited all the designer's assumptions is not
    equivalent to a zero-context review.

## 16. Security and Reliability Principles

-   Inspect third-party repositories before installation.
-   Verify the repository's canonical URL and publisher.
-   Review scripts, hooks, MCP servers, and requested permissions.
-   Pin versions or commits for critical workflows when practical.
-   Never place secrets in `CLAUDE.md`, specs, logs, or committed
    settings.
-   Keep `.env` files and credentials out of Git.
-   Back up existing settings before modifying them.
-   Avoid destructive shell commands unless their impact is understood
    and authorized.
-   Treat generated code and AI reviews as untrusted until verified.
-   Require human confirmation for deployment, data deletion, financial
    actions, or other consequential operations.
-   Test the installation and update scripts in a safe environment
    before relying on them.
-   Maintain a rollback path for changes to the global harness.

## 17. Installation and Maintenance Strategy

Do this incrementally.

### Initial setup

1.  Create `~/Developer/ai-dev-stack/` and initialize Git.
2.  Write a concise global `CLAUDE.md`.
3.  Create the integration register and record upstream URLs.
4.  Install EGM using its official installation instructions.
5.  Install Graphify using its own current instructions.
6.  Add one or two engineering skills and one design skill.
7.  Test each tool in a disposable or non-critical project.
8.  Add installation automation only after the manual process is
    understood.

### Health-check script

A future `doctor.sh` can check:

-   Claude Code is installed and the version is known.
-   Required configuration directories exist.
-   Expected skills or plugins are present.
-   External commands are available.
-   The active project has a `CLAUDE.md`.
-   Documentation and generated Graphify output exist where expected.
-   No obvious secret files are staged for commit.

The script should report problems rather than silently changing the
system. Any automatic repair should be explicit and documented.

### Update policy

When updating a tool:

1.  Review upstream changes and release notes.
2.  Inspect changed instructions, scripts, hooks, and permissions.
3.  Test core workflows.
4.  Check for command or file-layout changes.
5.  Update the integration register.
6.  Keep the previous working version or a rollback procedure until the
    update is verified.

## 18. Suggested Phased Roadmap

### Phase 1: Minimal reliable harness

-   Create `ai-dev-stack`.
-   Configure global and project-level instructions.
-   Set up a small `docs/` structure.
-   Install EGM and test brainstorm, draft, and review.
-   Establish a basic verification checklist.

### Phase 2: Codebase intelligence

-   Install Graphify according to its current documentation.
-   Test it on an existing project.
-   Document when and how to refresh its output.
-   Decide what artifacts should be committed.

### Phase 3: Curated skills

-   Test Superpowers.
-   Test selected Matt Pocock engineering skills.
-   Test UI UX Pro Max and Taste Skills separately.
-   Evaluate Anthropic Skills for tasks you actually perform.
-   Review Caveman, Agent Skills, Ponytail, and Karpathy Skills for
    distinct value and overlap.

### Phase 4: Automation

-   Create a safe installer and health-check script.
-   Add reusable templates and workflows.
-   Add pre-commit or CI checks only where they provide real value.
-   Automate spec drift reports at a cadence appropriate to the project.

### Phase 5: Mature harness

-   Pin and document tool versions.
-   Track failure cases and workflow effectiveness.
-   Improve skills based on real project evidence.
-   Consider additional subagents or integrations only when the current
    system has a demonstrated limitation.

## 19. Definition of Done for the Harness

The initial harness is ready when:

-   [x] Global instructions load correctly. (Verified: `~/.claude/CLAUDE.md`
    is a symlink to `config/global-rules.md`; `doctor.sh` passes.)
-   [x] Project instructions remain separate from global defaults. (Verified
    on `agentic-cicd`; project truth lives in its repository.)
-   [ ] EGM brainstorming, drafting, and review work end to end. (Blocked at
    runtime: the Claude Code model endpoint returned HTTP 402 billing failure.
    Installation and plugin validation passed; reviews were run with
    fresh-context OpenCode subagents instead. See §21.5.)
-   [x] The team or developer can identify which spec is approved. (Verified:
    `m1-webhook-intake.md` records `Status: Approved (revision 4)` and an
    approval date.)
-   [x] Graphify can be run for an individual project, where appropriate.
    (Verified on the pilot: 53 nodes, 55 edges; query/report/god-nodes work.)
-   [x] Project memory is stored in understandable Markdown files. (Verified:
    PRODUCT, REQUIREMENTS, ARCHITECTURE, DECISIONS, ROADMAP, CURRENT-STATUS,
    and `docs/designs/`.)
-   [x] At least one representative feature has gone through spec, review,
    implementation, and verification. (Verified: M1 webhook intake; three
    review passes found and resolved 35 findings before implementation.)
-   [x] The verification report distinguishes tests run from tests not run.
    (Verified in `docs/CURRENT-STATUS.md`, including the unbuilt Docker image
    and the 402-blocked EGM runtime.)
-   [x] Skills have clear responsibilities and known installation methods.
    (Verified in `integrations/upstream-repositories.md`; deferred candidates
    are recorded with reasons.)
-   [x] Secrets and risky operations have appropriate protections. (Verified:
    global rules forbid blind installs and committed secrets; the pilot fails
    closed on unusable webhook secrets and never logs bodies or headers.)
-   [x] The setup can be reproduced on the same machine from documented
    steps. (Verified: `scripts/install.sh` is idempotent and backs up
    `~/.claude`; a clean-machine reproduction is still untested.)
-   [x] There is a documented update and rollback process. (Verified in §17
    and `scripts/update.sh`; installer backups provide rollback points.)

One item remains open by design: live EGM execution. It is a billing/credential
issue, not a harness defect.

## 20. Final Recommended Operating Model

The simplest strong version of this system is:

-   **`ai-dev-stack`** is your version-controlled global configuration
    and integration guide.
-   **Claude Code global configuration** loads your general instructions
    and selected user-level skills.
-   **EGM** is the primary spec-driven workflow for substantial
    features.
-   **Graphify** helps the agent understand each project's code
    relationships.
-   **Project Markdown docs** hold durable product knowledge, decisions,
    requirements, and progress.
-   **A small curated skill set** provides specialist support without
    duplicate workflows.
-   **Tests, code review, and human approval** provide verification and
    accountability.
-   **Git** preserves history and lets you review changes to both code
    and documentation.

Do not try to perfect the global stack before building with it. Start
with one real project, complete the full workflow, note where the
process is slow or confusing, and refine the harness based on evidence.

The objective is not to maximize the number of tools. It is to make the
path from idea to a correct, maintainable, verified implementation more
consistent.

------------------------------------------------------------------------

## 21. Implementation Log (2026-10-26)

This section is the evidence trail for the living document. It records what was
actually installed, exercised, and measured, and what remains unverified.

### 21.1 Installed stack

| Component | Version / identity | Install method | Verification |
| --- | --- | --- | --- |
| Elephant-Goldfish Model | `0.1.0`, marketplace commit `3d0b348` | `claude plugin install` + `claude plugin enable egm@egm` | Plugin validates; 7 skills, 1 hook, 9 declared agent adapters. `claude plugin details` still reports `Agents (0)`; unresolved display discrepancy. |
| Graphify | `0.9.92` (PyPI `graphifyy`) | `uv tool install graphifyy`; `graphify install --platform claude` | Extract, query, report, and god-nodes run on the pilot. |
| Matt Pocock Skills | `1.3.1`, sha `49dd158…` | Claude Code plugin | Skills registered and enabled. |
| Taste Skill | `2.1.5`, commit `12af471` | Claude Code plugin | Registered and enabled; UI workflow not exercised (backend pilot). |
| Harness repository | `0.2.0` (0.1.0 baseline + OpenCode adapter) | `scripts/install.sh`; new `config/global-rules.md` mandatory-workflow block and AGENTS adapters | Global rules symlinked to both `~/.claude/CLAUDE.md` and `~/.config/opencode/AGENTS.md`; auto-loading verified in this session. |
| Health check | `scripts/doctor.sh` | Local script | 26 ok, 1 warning (stale Graphify output after a commit). |

### 21.2 Deferred or rejected candidates

| Candidate | Decision | Reason |
| --- | --- | --- |
| Superpowers | Deferred | Overlaps EGM planning and Matt Pocock execution; activating it would create competing workflows. |
| UI UX Pro Max | Deferred | Overlaps Taste Skill, which is the chosen primary UI skill. |
| Anthropic document skills | Deferred | No current document-generation need in the pilot. |
| Agent Skills | Deferred | Upstream identity could not be established unambiguously; unsafe to install. |
| Karpathy Skills | Not installed | No licence file. Its principles (think before coding, simplicity, surgical changes, verifiable goals) were folded into global rules. |
| Ponytail | Deferred | Not yet evaluated against a real need. |
| Caveman | Rejected for now | Style/overlap with the curated stack; no demonstrated value. |

### 21.3 Pilot: M1 webhook intake

- Repository: `/Users/ifteyajahmed/Desktop/agentic-cicd`
- Branch: `harness/m1-webhook-intake`
- Implementation commit: `99b1892`
- Spec: `docs/designs/m1-webhook-intake.md`, **Approved (revision 4)**

Review history:

| Pass | Reviewers | Findings | Outcome |
| --- | --- | --- | --- |
| Round 1 | 4 fresh-context sessions (design, comprehension, security, readiness) | R-01…R-16 | 8 high-severity issues accepted and fixed |
| Round 2 | 2 fresh-context sessions | R-17…R-26 | 4 high-severity issues accepted and fixed |
| Final readiness | 1 fresh-context session | R-27…R-35 | Verdict BLOCK; 7 contradictions fixed in revision 4 before approval |

The final pass is the important result: a spec that had already survived two
review rounds still contained ordering contradictions between requirements,
acceptance criteria, and the processing sequence. A separate readiness gate is
now part of the workflow.

Implementation:

- `app/domain/status.py`, `app/domain/run.py`
- `app/security/signature.py`
- `app/services/runs.py`
- `app/config.py`
- `app/routes/webhooks.py`
- `app/main.py` factory wiring
- Tests: `test_webhook_signature.py`, `test_webhook_dedupe.py`,
  `test_webhook_route.py`, `test_runs.py`, `test_config.py`

Verification:

| Check | Result |
| --- | --- |
| `uv run pytest -q` | 161 passed, 4 xfailed (status machine only) |
| `uv run ruff check .` | Pass |
| `uv run ruff format --check .` | 20 files formatted |
| `uv run mypy` | Pass, 12 source files |
| Live uvicorn smoke test | health 200; new 202; duplicate 200; signed replay with new delivery 200; `ping` 204; malformed JSON 400; bad signature 401; missing event 422 |

Residual risk: dedupe is in memory and resets on restart; the store is capped
at 10,000 runs; the service is single-process only; the Docker image was not
built; no real GitHub delivery was sent.

### 21.4 What the pilot proved

1. Global defaults and project truth can stay separate without friction: the
   global rules supplied the workflow, and the pilot repository held all
   product, architecture, and status facts.
2. Independent fresh-context review changes outcomes. It caught a
   verify-before-parse flaw, a non-atomic duplicate race, and seven final
   contradictions that the author and earlier reviewers missed.
3. Graphify is useful for navigation but goes stale after commits. Refresh it
   after implementation, not just at onboarding.
4. Installation is not runtime verification. EGM installed and validated while
   its model-backed commands could not execute because of billing.

### 21.5 Known gaps and blockers

- **Claude Code model endpoint:** `HTTP 402: Billing verification failed` at
  `https://codecraftapi.com/v1/messages`. EGM, Matt Pocock, and Taste runtime
  workflows are therefore unexercised. Reviews used fresh-context OpenCode
  subagents instead.
- **EGM agent adapters:** plugin metadata declares 9 adapters but the details
  command reports `Agents (0)`. Verify in a live Claude Code session once the
  endpoint is available.
- OpenCode-specific gotchas are closed in v0.2.0: `~/.config/opencode/AGENTS.md`
  is now a symlink to `config/global-rules.md`, project-level `AGENTS.md`
  adapters exist in both repositories, and `workflows/tool-adapters.md`
  documents the single-source-of-truth model. Re-verification of `doctor.sh`
  remains 27 ok / 0 failures, untouched by this change.
- **UI design workflow:** Taste Skill was not exercised because the pilot is
  backend-only.

### 21.6 Reproduce

```bash
cd ~/ai-dev-stack/ai-dev-stack

./scripts/install.sh --dry-run
./scripts/install.sh
./scripts/doctor.sh ~/Desktop/agentic-cicd

cd ~/Desktop/agentic-cicd
graphify extract . --code-only --no-cluster
graphify cluster-only . --no-label

cd api
uv sync --frozen
uv run ruff check .
uv run ruff format --check .
uv run mypy
uv run pytest -q
```

------------------------------------------------------------------------

## Reference Links

-   Google Elephant-Goldfish Model repository:
    https://github.com/google/elephant-goldfish-model
-   EGM official site and workflow overview: https://egm.dev/
-   Anthropic skills repository: https://github.com/anthropics/skills
-   Superpowers repository: https://github.com/obra/superpowers
-   UI UX Pro Max repository (verify current upstream details):
    https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
-   Graphify repository (verify the exact Graphify project you intend to
    use): https://github.com/Graphify-Labs/graphify

For the remaining candidate repositories, add the canonical URLs only
after confirming the exact intended upstream project. Repository names
alone are not sufficient to safely identify software to install.
