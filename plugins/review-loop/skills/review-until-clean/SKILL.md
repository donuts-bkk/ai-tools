---
name: review-until-clean
description: Runs the diff-reviewer subagent (Opus, high effort) on the current uncommitted change, fixes Critical and High findings, and re-reviews (resuming the same subagent) until clean or 5 reviews.
disable-model-invocation: true
allowed-tools: Agent, SendMessage, Bash(git diff *), Bash(git status *), Bash(git ls-files *), Bash(git rev-parse *)
---

## Change overview
!`git rev-parse --show-toplevel`
!`git status --short --branch`

## Instructions
Talk to the user in Thai (ภาษาไทย): progress notes, stop messages, the
Final report and any escalation question. Keep code, paths, commands,
finding IDs and severity names as they are.

Blocking findings = Critical and High. Medium and Low never block and are
never fixed inside this loop.

The review is only valid for the repo path shown above, in its current
state. It must be the checkout the user will commit from: if the change was
developed elsewhere (another worktree, sandbox or copy), tell the user to move
it first and rerun this skill there, then stop. Any code change after the
last review, including moving or copying files, invalidates a PASS and needs
another review round.

0. Preconditions:
   - The header line says "No commits yet" → tell the user the repo has no
     commits (the reviewer diffs against HEAD) and stop.
   - No file lines below the `##` header → say there is nothing to review
     and stop.
1. Set `max_reviews = 5`, `review = 1`. Keep a ledger of every finding ID
   and its status across rounds.
2. Spawn the reviewer: Agent tool, `subagent_type: review-loop:diff-reviewer`,
   `run_in_background: false`, prompt:
   "Review the current uncommitted change, tracked and untracked files.
   Use your strict output format and end with the VERDICT line."
   Record the returned agentId; every later round resumes this agentId.
   Do not pass a `model` override.
3. Read the report and update the ledger.
   - `VERDICT: PASS` → go to Final.
   - No VERDICT line → SendMessage to the agentId asking it to reissue the
     report in its required format. This does not count as a review.
   - `review == max_reviews` → go to Final (escalate). Do not change code
     after this point without another review.
   - Any blocking ID marked NOT FIXED in two consecutive reviews → go to
     Final (escalate).
4. For each open blocking finding: fix it, or if you believe it is a false
   positive, leave the code unchanged and write a rebuttal with evidence
   (file:line, test output, spec). Never delete or skip tests, weaken
   assertions, or suppress lint/type errors to clear a finding.
5. Run the project's tests, build, and lint for the touched area. Fix any
   failures before re-review.
6. `review += 1`. SendMessage to the agentId:
   "Re-review round {review}. Changes: C1 → <what changed, file:line>;
   H1 → rebuttal: <evidence>. Open IDs: <list from ledger>. Re-collect the
   change yourself (git diff HEAD plus untracked files); do not trust this
   description. Verify each prior finding, then re-scan the whole change for
   new issues including regressions from these fixes. End with the VERDICT
   line."
   Do not paste the diff. Wait for the reviewer's result before continuing
   (it may arrive as a notification). Then go to step 3.

Never skip the reviewer step to save time.

## Final
Report:
- the repo path that was reviewed
- reviews used
- every Critical and High ID and its outcome (fixed / retracted / open)
- Medium and Low findings from the latest review (list them; do not fix them)
- verification commands run and their results

If escalated, list each open Critical and High finding with the reviewer's
evidence and your position, then ask the user how to proceed. Never report
the change as clean while any Critical or High finding is open.
