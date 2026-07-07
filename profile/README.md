# Commaleon Task Hub

The **Task Hub** is the single source of truth for planned work across every Commaleon service. It lives in the `Commaleon` GitHub org as **Project #24** and unifies issues from all service repos into one board, sliced by a consistent 4-axis model.

If a piece of work matters, it is a card here. Metadata goes in **fields and labels** â€” never in the title.

---

## The 4-Axis Model

Every card is classified on four independent axes. Together they answer *what*, *why*, *where in flight*, and *which release*.

| Axis | Field | Answers | Values |
|------|-------|---------|--------|
| **Service** | `Service` | Which product surface? | CRM, PIM, PUR, SHIP, OMS, Fulfillment, Shop, WMS, SDM, DevOps & General, TIME |
| **Work Type** | `Work Type` | What kind of work? | Feature, Bug, Refactor, Tech Debt, DevOps, Design, Docs, Chore, Security, Data / Migration |
| **Status** | `Status` | Where in the flow? | Backlog, Ready, In Progress, In Review, Done |
| **Version** | `Version` | Which release? | SemVer per service â€” **real releases only** |

> **Version rule:** `Version` is a SemVer string scoped to one service (e.g. CRM `0.16.0`). Only assign a version that maps to an actual, planned or shipped release. Do not invent placeholder versions.

---

## Status Lifecycle

Cards flow left to right. Movement is driven by both people and automation.

```
Backlog  ->  Ready  ->  In Progress  ->  In Review  ->  Done
```

| Status | Meaning | Entry trigger |
|--------|---------|---------------|
| **Backlog** | Captured, not yet refined | Item added to project |
| **Ready** | Meets Definition of Ready, pullable | Refined and DoR met |
| **In Progress** | Actively being worked | Someone starts work |
| **In Review** | PR open, awaiting review | PR linked to the item |
| **Done** | Meets Definition of Done | Issue/PR closed |

Respect **WIP limits** on *In Progress* and *In Review*. Pull the next card only when there is capacity; finishing work beats starting work.

---

## Definition of Ready (DoR)

A card may move to **Ready** only when all of the following hold:

| # | Criterion |
|---|-----------|
| 1 | Title is clear, imperative, and free of bracket metadata |
| 2 | `Service` and `Work Type` are set |
| 3 | `Priority` is set (P0â€“P3) |
| 4 | Acceptance criteria / expected outcome are written in the body |
| 5 | No unresolved `blocked` label; dependencies are known |
| 6 | Scoped small enough to finish within a normal cycle |

---

## Definition of Done (DoD)

A card may move to **Done** only when all of the following hold:

| # | Criterion |
|---|-----------|
| 1 | Acceptance criteria met |
| 2 | Code merged to the default branch |
| 3 | Tests added/updated and passing in CI |
| 4 | Docs updated where user- or operator-facing |
| 5 | `Version` set to the release that carries the change (real release) |
| 6 | No regressions or follow-ups left untracked (spin off new cards) |

---

## Title Convention

Titles are **imperative mood**, **â‰¤ 70 characters**, and carry **no bracket metadata**.

| | Example |
|---|---------|
| Good | `Add idempotency key to allocation consumer` |
| Good | `Fix cross-tenant leak on Daily Brief endpoint` |
| Bad | `[CRM][P1] fixed the daily brief bug` |
| Bad | `Working on refactoring the purchase saga (WIP)` |

Rules of thumb:
- Start with a verb: *Add, Fix, Refactor, Remove, Document, Migrate, Harden*.
- Describe the change, not the status â€” status lives in the `Status` field.
- No `[Service]`, `[P1]`, `[Bug]` prefixes â€” those are fields and labels.

---

## Labels

Repo labels are **namespaced** and complement (never replace) project fields.

| Label | Purpose |
|-------|---------|
| `area:*` | Component within a service (e.g. `area:allocation`, `area:rls`) |
| `type:bug` / `type:feature` / `type:refactor` / `type:design` | Mirror the `Work Type` field for repo-level filtering |
| `blocked` | Work cannot proceed; note the blocker in the body |
| `good-first-issue` | Approachable entry point for new contributors |

---

## Basis

This standard draws on **Conventional Commits**, **SemVer**, the **Kubernetes label taxonomy** (namespaced, machine-friendly labels), **Kanban WIP limits**, and **Scrum Definition of Ready / Definition of Done**.
