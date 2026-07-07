# Board Setup â€” Manual One-Time Checklist

These steps **cannot be done via the GitHub API** and must be performed once in the GitHub web UI by a project admin. They bring **Commaleon** org **Project #24** into line with the Task Hub standard.

Work top to bottom. Each section is independent, but do them in order to avoid confusion.

Open the project first: `https://github.com/orgs/Commaleon/projects/24`

---

## A. Rename & prune Status options

Goal: end with exactly five Status options â€” **Backlog, Ready, In Progress, In Review, Done**.

- [ ] 1. Open the project. Click the **â‹¯** menu (top-right) â†’ **Settings**.
- [ ] 2. In the left sidebar under **Fields**, click **Status**.
- [ ] 3. Find the option named **Todo**. Click its **â‹¯** â†’ **Edit** (or click the name inline) and rename it to **Ready**. Save.
- [ ] 4. Find the option named **Ready PR**. Rename it to **In Review**. Save.
- [ ] 5. Locate the **Queue** option. First re-file any cards still on it: go back to the board, filter `Status:Queue`, and move each card to **Backlog** or **Ready** as appropriate, until `Status:Queue` shows zero items.
- [ ] 6. Return to **Settings â†’ Fields â†’ Status**, click the **â‹¯** next to the now-empty **Queue** option â†’ **Delete option** â†’ confirm.
- [ ] 7. Confirm the final option list reads, top to bottom: **Backlog, Ready, In Progress, In Review, Done**. Drag to reorder if needed.

---

## B. Strip `Done_` prefix from archived CRM Version options

Goal: the 9 archived CRM release versions read as clean SemVer, not `Done_x.y.z`.

- [ ] 1. In **Settings â†’ Fields**, click the **Version** field.
- [ ] 2. Scroll to the 9 options prefixed **`Done_`** (the archived CRM releases).
- [ ] 3. For each of the 9, click the option name (or **â‹¯ â†’ Edit**) and delete the leading `Done_` so only the SemVer remains (e.g. `Done_0.15.5` â†’ `0.15.5`). Save after each.
- [ ] 4. Verify all 9 now show bare SemVer and that no duplicate un-prefixed option already existed (if a collision appears, merge by re-pointing cards to the surviving option, then delete the empty one).

> Reminder: `Version` carries **real releases only**. Do not add speculative versions here.

---

## C. Enable the 4 project automations (built-in workflows)

Goal: cards flow through the lifecycle without manual field edits.

- [ ] 1. In the project, click **â‹¯** (top-right) â†’ **Workflows**.
- [ ] 2. **Auto-add repo issues**
      - Select **Auto-add to project**.
      - Click **Edit**, choose the Task Hub service repos, and set the filter to `is:issue is:open` (add `is:pr` too if PRs should auto-add).
      - Toggle the workflow **On**. Save.
- [ ] 3. **Item added â†’ Backlog**
      - Select **Item added to project**.
      - Set **Set value â†’ Status â†’ Backlog**.
      - Toggle **On**. Save.
- [ ] 4. **PR linked â†’ In Review**
      - Select **Pull request linked / merged** (use the linked-PR trigger; if only status-change triggers exist, use **Code changes requested** is *not* it â€” pick the trigger fired when a PR is linked to the item).
      - Set **Set value â†’ Status â†’ In Review**.
      - Toggle **On**. Save.
- [ ] 5. **Issue/PR closed â†’ Done**
      - Select **Item closed**.
      - Set **Set value â†’ Status â†’ Done**.
      - Toggle **On**. Save.
- [ ] 6. Confirm all four workflows show **On** in the Workflows list.

> Note: GitHub's built-in workflow set has fixed triggers. Map each intent to the closest available trigger (`Auto-add to project`, `Item added to project`, the pull-request-linked trigger, and `Item closed`). If a desired trigger is unavailable on your plan, leave that transition manual and note it here.

---

## D. Create saved views

Goal: four shared views everyone opens by default. Create each as a new tab.

For every view: click the **+** next to the existing view tabs â†’ **New view**, then configure and rename via the tab's **â‹¯ â†’ Rename**. Save the view (**â‹¯ â†’ Save changes**) so it persists for all members.

- [ ] 1. **By Service**
      - Layout: **Board**.
      - **Group by â†’ Service**.
      - Rename tab to `By Service`. Save.
- [ ] 2. **Active Sprint**
      - Layout: **Board** (or Table).
      - Filter: `status:"In Progress","In Review"`.
      - Rename tab to `Active Sprint`. Save.
- [ ] 3. **Triage**
      - Layout: **Table**.
      - Filter: `status:Backlog no:priority` (untriaged backlog â€” Status is Backlog and Priority is empty).
      - Rename tab to `Triage`. Save.
- [ ] 4. **Bugs by Priority**
      - Layout: **Board**.
      - Filter: `"Work Type":Bug`.
      - **Group by â†’ Priority**.
      - Rename tab to `Bugs by Priority`. Save.

---

## Done check

- [ ] Status options: Backlog, Ready, In Progress, In Review, Done â€” no Todo/Ready PR/Queue.
- [ ] All 9 archived CRM versions are bare SemVer.
- [ ] Four workflows enabled and On.
- [ ] Four saved views present and shared: By Service, Active Sprint, Triage, Bugs by Priority.
