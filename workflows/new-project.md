# Workflow: new project

Use this when starting a repository that will use the harness.

## 1. Decide the project boundary

- Create the application repository outside `ai-dev-stack`.
- Do not put product code in the harness repository.
- Register the project in `projects/README.md`.

## 2. Establish project truth

Copy and fill the templates:

```bash
mkdir -p docs/designs
cp <harness>/templates/product-requirements.md docs/PRODUCT.md
cp <harness>/templates/requirements.md docs/REQUIREMENTS.md
cp <harness>/templates/architecture.md docs/ARCHITECTURE.md
cp <harness>/templates/decisions.md docs/DECISIONS.md
cp <harness>/templates/roadmap.md docs/ROADMAP.md
cp <harness>/templates/current-status.md docs/CURRENT-STATUS.md
cp <harness>/templates/project-claude.md CLAUDE.md
```

Fill in only what is known. Mark unknowns as open questions; do not invent them.

## 3. Add project instructions

The project `CLAUDE.md` must state:

- what the project does;
- the stack and exact commands for install, dev, test, lint, type-check, build;
- repository layout and architectural boundaries;
- where product docs, specs, and decisions live;
- project-specific security and deployment constraints.

Keep it under one page if possible.

## 4. Verify the baseline

Run the documented commands before adding features. Record the results in
`docs/CURRENT-STATUS.md`. A failing baseline is a finding, not a blocker to
document.

## 5. Add codebase intelligence

If the project is non-trivial:

```bash
cd <project>
graphify . --wiki
```

Review `graphify-out/GRAPH_REPORT.md`. Decide whether to commit `graphify-out/`
based on size and usefulness. Refresh after structural changes.

## 6. Start the first feature

Use `workflows/brainstorm-and-specify.md`. Do not skip independent review for a
substantial first feature.
