# Board Setup - Manual One-Time Checklist

These steps **cannot be done via the GitHub API** and must be performed once in the GitHub web UI by a project admin. They bring the **Commaleon** org **Project #24** into line with the Task Hub standard.

Open the project first: `https://github.com/orgs/Commaleon/projects/24`

> **Order matters:** do section **C step 2** (repoint the "Item added to project" workflow off `Queue`) **before** section **A step 6** (delete the `Queue` option). The `Queue` option is still referenced by that workflow - deleting it first would disable the workflow.

---

## A. Rename & prune Status options

Goal: end with exactly five Status options - **Backlog, Ready, In Progress, In Review, Done**.

- [ ] 1. Open the project. Click the **...** menu (top-right) -> **Settings**.
- [ ] 2. In the left sidebar under **Fields**, click **Status**.
- [ ] 3. Rename **Todo** -> **Ready**. Save.
- [ ] 4. Rename **Ready PR** -> **In Review**. Save.
- [ ] 5. **Queue** should already be empty (the API migration moved all 287 cards to Backlog). Verify on the board with filter `status:Queue` -> should show 0 items.
- [ ] 6. **First complete section C step 2**, then delete the **Queue** option: **Settings -> Fields -> Status**, click the **...** next to **Queue** -> **Delete option** -> confirm.
- [ ] 7. Final option order, top to bottom: **Backlog, Ready, In Progress, In Review, Done**. Drag to reorder if needed.

---

## B. Strip `Done_` prefix from archived CRM Version options

Goal: the 9 archived CRM release versions read as clean SemVer, not `Done_x.y.z`.

- [ ] 1. **Settings -> Fields -> Version**.
- [ ] 2. Find the 9 options prefixed **`Done_`** (archived CRM releases).
- [ ] 3. For each, edit the option name and delete the leading `Done_` (e.g. `Done_CRM v1.0.4` -> `CRM v1.0.4`). Save after each.
- [ ] 4. If an un-prefixed duplicate already exists, re-point its cards to the surviving option, then delete the empty one.

> `Version` carries **real releases only**. Do not add speculative versions.

---

## C. Enable project workflows

GitHub calls automations **"Workflows"** (not "Automations"). Open them from the project's **...** menu (top-right) -> **Workflows**.

The built-in workflow names differ from generic descriptions - map each intent to the **exact name** in the list:

### C.1  Auto-add repo issues  ->  workflow **"Auto-add to project"**

- [ ] Currently **off**. This is **optional** - see the note below.
- [ ] Each "Auto-add to project" workflow accepts **only ONE repository** (a GitHub limitation).
- [ ] If you enable it: pick a **high-traffic work repo** (e.g. `web`, `purchase`), **not** `changelog`.
- [ ] Filter must be `is:issue is:open` (add `is:pr` only if you want PRs auto-added too).
      **Do NOT add `label:bug`** or any label filter - that would auto-add only bug-labelled issues.
- [ ] To cover several repos, add a separate "Auto-add to project" workflow per repo (GitHub allows a few).

> **You may not need this at all.** The issue-form templates in `Commaleon/.github` carry `projects: ["Commaleon/24"]`, so **every issue opened through a form - from any repo - is auto-added to Project 24**. Use the built-in workflow only to also catch issues/PRs created *without* a form, on your busiest repos.

### C.2  Item added -> Backlog  ->  workflow **"Item added to project"**

- [ ] This workflow currently sets **Status = Queue** - that is why every new card used to land in Queue.
- [ ] Open it, change the action to **Set value -> Status -> Backlog**. Toggle **On**. Save.
- [ ] **Do this before deleting the Queue option (section A step 6).**

### C.3  PR linked -> In Review  ->  workflow **"Pull request linked to issue"**

- [ ] Already on. Edit the action to **Set value -> Status -> In Review**. Save.

### C.4  Issue/PR closed -> Done  ->  workflow **"Item closed"**

- [ ] Already on. Edit the action to **Set value -> Status -> Done**. Save.
- [ ] Optional: also set **"Pull request merged"** -> **Set value -> Status -> Done**.

### C.5  The other workflows (optional - leave OFF for the core standard)

Only the four above are required. The remaining built-in workflows are extras; leave them **off** unless noted:

| Workflow | What it does | Recommendation |
|----------|--------------|----------------|
| `Auto-archive items` | Archives items matching a filter (e.g. closed 30+ days) to keep the board lean | OFF now; enable later for `is:closed updated:<-30d` |
| `Code changes requested` | On PR "changes requested", set a field | OFF (optionally -> Status -> In Progress) |
| `Code review approved` | On PR approval, set a field | OFF (leave cards In Review) |
| `Item reopened` | On a closed item reopening, set a field | **Optionally ON -> Status -> In Progress** (pairs with "Item closed -> Done" so reopened cards leave Done) |
| `Auto-close issue`, `Auto-add sub-issues to project` | GitHub defaults | Leave as-is |

---

## D. Create saved views

Four shared views, each a new tab. For each: click **+** next to the view tabs -> **New view**, configure, rename via the tab's **... -> Rename**, then **... -> Save changes** so it persists for everyone.

- [ ] 1. **By Service** - layout **Board**, **Group by -> Service**.
- [ ] 2. **Active Sprint** - layout **Board**, filter `status:"In Progress","In Review"`.
- [ ] 3. **Triage** - layout **Table**, filter `status:Backlog no:priority` (untriaged backlog). Good for clearing the ~190 Work-Type-blank cards.
- [ ] 4. **Bugs by Priority** - layout **Board**, filter `"Work Type":Bug`, **Group by -> Priority**.

---

## Done check

- [ ] Status options: Backlog, Ready, In Progress, In Review, Done - no Todo / Ready PR / Queue.
- [ ] All archived CRM versions are bare SemVer (no `Done_`).
- [ ] "Item added to project" sets Backlog; "Pull request linked to issue" sets In Review; "Item closed" sets Done.
- [ ] Four saved views present and shared: By Service, Active Sprint, Triage, Bugs by Priority.
