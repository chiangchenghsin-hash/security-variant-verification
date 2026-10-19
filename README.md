# Security Variant Verification

An agent skill for machine-verifying that a design holds in production: extract
the violated-invariant pattern from a CVE or patch → state it as a small-model
property → generate candidates (neural layer) → machine-verdict them (symbolic
layer) → bind model to implementation by differential testing → gate the
release on exit codes.

Two rules never bend:

1. The LLM does judgment-intensive work only (candidate generation, pattern
   abstraction). Every verdict runs through deterministic tools.
2. Every number carries its source and its data-generating mechanism. A bare
   claim is never an anchor.

## Pairing with TRIZ

This skill is the adjudication half of a pair. The generation half is the
[`triz`](https://github.com/chiangchenghsin-hash/triz) skill (Five-Bridges
innovation methodology): TRIZ produces candidate designs, this skill decides
whether they hold. They invoke each other by skill name via the Skill tool —
handoff rules, payloads, and boundary clauses live in each skill's `SKILL.md`;
the design-gap handoff format is in `references/triz-mapping.md`. Install both
if you want the full loop; this skill stands alone for verification work.

## Installation

```bash
./install.sh
# -> ~/.openclaw/skills/security-variant-verification/  (SKILL.md + scripts/ + references/ + examples/)
```

Or copy `.claude/skills/security-variant-verification/` into your platform's
skills directory (Claude Code project skills, WorkBuddy, other OpenClaw-style
workspaces). Keep the directory's bundled files — the workflow calls them.

## Quick start (verified)

```bash
cd .claude/skills/security-variant-verification/examples/forbid-trumps-permit
# 1) seeded bug: permit checked before forbid -> gate blocks (exit 1)
python ../../scripts/diff_test.py --gen gen.py --model model.py --impl impl.py \
    --n 2000 --seed 42 --ledger divergence.tsv
# 2) fix impl.py (scan forbid first) -> exit 0; rerun -> ledger deduped
```

Harness contract tests (8 cases: exit-code gate semantics, dedup, crash
timeout findings, infra errors, path/module loading):

```bash
python scripts/test_diff_test.py
```

## Tooling

**`scripts/diff_test.py`** — differential random testing, model vs
implementation. Runner contract: `gen(rng) -> inp`, `run(inp) -> output` (model
and impl sides). Exit codes are the release gate: `0` clean · `1` any
DIVERGENCE/CRASH (block) · `2` infrastructure error (never a product verdict).
Reruns deduplicate by input hash; full inputs archive to
`<ledger>.inputs.jsonl`. Per-case `--timeout`, `--fail-fast`, `--quiet`.

Two ledgers, never merged: `divergence.tsv` (machine-written by the runner) and
`findings.tsv` (manual pattern-hunt rows with symbolic verdicts and confidence
labels). Schemas and the claim-labelling discipline are in `SKILL.md`.

## Layout

```
.claude/skills/security-variant-verification/
├── SKILL.md            # the skill (P0–P5 workflow, ledgers, discipline)
├── scripts/            # diff_test.py + its contract tests
├── references/         # cornerstones (provenance notes), triz-mapping (handoff card)
└── examples/           # forbid-trumps-permit worked example (5-minute loop)
```

## License

MIT License - Free to use and modify.
