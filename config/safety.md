# Safety rules

## Secrets

- Never read, print, log, commit, or transmit credentials, tokens, private keys,
  session cookies, or production data.
- Use `.env.example` for variable names and safe placeholders.
- If a secret is exposed, stop, report it, and rotate it. Removing it from the
  latest commit is not sufficient; history may retain it.
- Do not paste secrets into an AI prompt, a spec, a review, or a test fixture.

## Destructive and consequential actions

Ask for explicit confirmation before:

- deleting files or data outside a disposable scratch area;
- resetting, rebasing, or force-pushing shared Git history;
- modifying production infrastructure, databases, DNS, or secrets;
- deploying, publishing, sending email, or spending money;
- changing permissions, authentication, or access control.

Prefer reversible steps. State the blast radius before running a risky command.

## Third-party code

- Verify the canonical repository, publisher, licence, recent activity, and
  install instructions.
- Inspect install scripts, hooks, MCP servers, and requested permissions before
  running them.
- Pin versions or commits for critical workflows where practical.
- Do not execute a README command blindly, especially one that pipes a remote
  script into a shell.
- Treat generated code and AI review output as untrusted until tested.

## Agent permissions

- Keep tool permissions narrow.
- Do not use `--dangerously-skip-permissions` outside an isolated, disposable
  environment.
- Do not disable hooks or review gates to make progress faster.
- Review the diff before committing; do not assume the agent's summary is
  accurate.

## Data handling

- Do not copy production data into fixtures, tests, or prompts.
- Redact personal information from logs and screenshots.
- Respect the project's data-retention and privacy constraints.
