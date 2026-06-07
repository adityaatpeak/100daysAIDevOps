# AI Infra Upskill — GitOps Edition

A 3-month upskilling roadmap, run the way you run production: **declaratively, in git, merged through PRs, synced to a cluster by Argo CD.**

This repo is two things at once:

1. **A tracked plan.** Each week is an issue → a branch → a PR. "Done" means *merged*, not "I read about it."
2. **Your real infra-as-code repo.** The builds you do are committed here as manifests and synced to your learning cluster by Argo CD. By Month 3 this repo *is* a working GitOps stack — Istio, KServe, vLLM, monitoring, all declarative.

---

## Repo layout

```
ai-infra-upskill/
├── README.md                       # you are here
├── ROADMAP.md                      # the 3-month plan, week by week (the source of truth for progress)
├── PROGRESS.md                     # status board
├── scripts/
│   └── progress.sh                 # counts ticked milestones in ROADMAP.md → completion %
├── notes/                          # "learning weeks" land here (mechanics you can't deploy)
├── .github/
│   ├── pull_request_template.md    # "complete a week" PR template
│   └── ISSUE_TEMPLATE/week.md      # weekly milestone issue template
└── clusters/
    └── learning/
        ├── bootstrap/
        │   └── app-of-apps.yaml    # Argo CD root app — apply once, it manages the rest
        ├── apps/                   # one Argo CD Application per component (the app-of-apps children)
        │   └── vllm.yaml           # example child Application
        └── manifests/              # the actual k8s manifests each Application points at
            └── vllm/               # (your builds get committed here, per week)
```

## The weekly workflow

1. **Open the week's issue** from the template (`.github/ISSUE_TEMPLATE/week.md`).
2. **Branch:** `week-NN-short-name` (e.g. `week-02-service-mesh`).
3. **Do the build.** Two kinds of weeks:
   - **`[infra]` weeks** → add/modify manifests under `clusters/learning/manifests/...` and an `Application` under `clusters/learning/apps/`.
   - **`[notes]` weeks** → add a markdown note under `notes/` (inference internals, networking model — things you learn but don't deploy).
4. **Tick the milestone box** in `ROADMAP.md` *in the same PR*.
5. **Open the PR** (template auto-fills). Merge when the milestone is genuinely met.
6. **For infra weeks, merging → Argo CD auto-syncs.** Done = *synced & healthy* in the Argo CD UI, not just merged.

This is the same loop you'd want in prod: change is a PR, the cluster reflects git, drift self-heals.

## Bootstrap Argo CD (once)

```bash
# install Argo CD into the cluster
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# point it at THIS repo's app-of-apps root (edit repoURL first)
kubectl apply -f clusters/learning/bootstrap/app-of-apps.yaml
```

The root app watches `clusters/learning/apps/` and deploys each child `Application`. Add a new component = add one file under `apps/` = Argo CD picks it up. That's the app-of-apps pattern.

## Secrets hygiene (non-negotiable)

- **Never commit** kubeconfigs, tokens, AWS creds, or raw k8s `Secret` manifests.
- Use **Sealed Secrets / SOPS / External Secrets** — commit the *encrypted* or *referenced* form, never plaintext.
- `.gitignore` covers the obvious traps (kubeconfig, `.env`, keys). When in doubt, redact.

## Progress

```bash
./scripts/progress.sh        # reads ROADMAP.md, prints ticked/total + a bar
```

## Getting started

```bash
git init && git add . && git commit -m "scaffold: AI infra upskill roadmap"
# create the repo on your git host, then:
git remote add origin <your-repo-url> && git push -u origin main
# bootstrap Argo CD (above), open the Week 01 issue, branch, go.
```
