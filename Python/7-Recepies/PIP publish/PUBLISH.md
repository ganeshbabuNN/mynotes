# Publishing pyCoreGage to PyPI — Complete Guide

This document covers every step from a clean checkout to a live PyPI release.

---

## Prerequisites

```bash
pip install build twine
```

You will need:
- A [PyPI account](https://pypi.org/account/register/)
- A [TestPyPI account](https://test.pypi.org/account/register/) (separate from PyPI)
- Two API tokens (one per registry — see Step 2)

---

## Step 1 — Verify your pyproject.toml

Open `pyproject.toml` and confirm these fields before every release:

```toml
[project]
name    = "pyCoreGage"      # must match exactly on PyPI
version = "0.1.0"           # bump this for every release (see Versioning below)

[project.urls]
Homepage = "https://github.com/ganeshbabunn/pyCoreGage"

[build-system]
requires      = ["setuptools>=68", "wheel"]
build-backend = "setuptools.build_meta"
```

Check that `pyCoreGage/data/rule_registry.xlsx` and
`pyCoreGage/templates/*.py` are listed under `[tool.setuptools.package-data]`:

```toml
[tool.setuptools.package-data]
pyCoreGage = [
    "data/*.xlsx",
    "templates/*.py",
]
```

---

## Step 2 — Create API tokens

### PyPI token
1. Log in at https://pypi.org
2. Account settings → API tokens → **Add API token**
3. Scope: **Entire account** (first upload) or project-scoped after first upload
4. Copy the token — it starts with `pypi-`

### TestPyPI token
Same steps at https://test.pypi.org — copy separately.

### Store tokens in `~/.pypirc`

```ini
[distutils]
index-servers =
    pypi
    testpypi

[pypi]
username = __token__
password = pypi-YOUR_PYPI_TOKEN_HERE

[testpypi]
repository = https://test.pypi.org/legacy/
username   = __token__
password   = pypi-YOUR_TESTPYPI_TOKEN_HERE
```

```bash
chmod 600 ~/.pypirc
```

---

## Step 3 — Run the full test suite

Always run tests before building. A broken release is hard to retract.

```bash
cd /path/to/pyCoreGage
pip install -e ".[dev]"
python -m pytest tests/ -v --tb=short
```

All 75 tests must pass. Fix any failures before continuing.

---

## Step 4 — Clean previous builds

```bash
rm -rf dist/ build/ pyCoreGage.egg-info/
```

```Powershell
rm -Recurse -Force dist, build, pyCoreGage.egg-info
```

---

## Step 5 — Build the distribution


```bash
python -m build
```

This produces two files in `dist/`:

```
dist/
  pyCoreGage-0.1.0.tar.gz        ← source distribution
  pyCoreGage-0.1.0-py3-none-any.whl  ← wheel
```

Inspect the wheel to confirm bundled data files are included:

```bash
unzip -l dist/pyCoreGage-0.1.0-py3-none-any.whl | grep -E "xlsx|templates"
```

You should see lines like:
```
pyCoreGage/data/rule_registry.xlsx
pyCoreGage/templates/run_coregage.py
pyCoreGage/templates/project_config.py
pyCoreGage/templates/check_template.py
```

If the data files are missing, check `[tool.setuptools.package-data]` in
`pyproject.toml` and re-build.

---

## Step 6 — Dry-run on TestPyPI

TestPyPI is a sandbox. Upload there first to catch metadata errors
without polluting the real index.

```bash
twine upload --repository testpypi dist/*
twine upload --config-file .pypirc --repository testpypi dist/*
```

Then install from TestPyPI in a fresh virtual environment to verify:

```bash
python -m venv /tmp/test_venv
source /tmp/test_venv/bin/activate          # Linux/macOS
# /tmp/test_venv/Scripts/activate           # Windows

pip install --index-url https://test.pypi.org/simple/ \
            --extra-index-url https://pypi.org/simple/ \
            pyCoreGage
            
pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ pyCoreGage

# Smoke test
python -c "import pyCoreGage; print(pyCoreGage.__version__)"
pycoregage --version

deactivate
```

If the install fails or the wrong version appears, fix the issue,
increment the version, rebuild, and re-upload (TestPyPI does not allow
re-uploading the same version number).

---

## Step 7 — Upload to PyPI (production)

Once the TestPyPI dry-run passes:

```bash
twine upload dist/*
twine upload --config-file .pypirc --repository pypi dist/*
```

Twine reads `~/.pypirc` automatically. After upload, your package is live at:

```
https://pypi.org/project/pyCoreGage/
```

Users can now install with:

```bash
pip install pyCoreGage
```

---

## Step 8 — Tag the release in Git

```bash
git add -A
git commit -m "Release v0.1.0"
git tag v0.1.0
git push origin main --tags
```

Create a GitHub Release from the tag and attach the files from `dist/`
as release assets.

---

## Versioning

pyCoreGage follows [Semantic Versioning](https://semver.org/):

| Version bump | When |
|---|---|
| `PATCH` — 0.1.**1** | Bug fixes, no API changes |
| `MINOR` — 0.**2**.0 | New features, backwards-compatible |
| `MAJOR` — **1**.0.0 | Breaking API changes |

To release a new version:

1. Update `version = "X.Y.Z"` in `pyproject.toml`
2. Update `__version__ = "X.Y.Z"` in `pyCoreGage/__init__.py`
3. Update `CHANGELOG.md` (add a dated entry)
4. Run tests → clean → build → TestPyPI → PyPI → Git tag

---

## Release Checklist

Copy this checklist for every release:

```
[ ] version bumped in pyproject.toml
[ ] version bumped in pyCoreGage/__init__.py
[ ] CHANGELOG.md updated
[ ] all tests pass: python -m pytest tests/ -v
[ ] dist/ cleaned: rm -rf dist/ build/ *.egg-info
[ ] built: python -m build
[ ] wheel inspected — data files present
[ ] uploaded to TestPyPI: twine upload --repository testpypi dist/*
[ ] installed from TestPyPI and smoke-tested
[ ] uploaded to PyPI: twine upload dist/*
[ ] git commit + tag + push
[ ] GitHub Release created
```

---

## Continuous Integration (optional)

To automate publishing on every tagged release, add this GitHub Actions
workflow at `.github/workflows/publish.yml`:

```yaml
name: Publish to PyPI

on:
  push:
    tags:
      - "v*"

jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      id-token: write   # required for trusted publishing

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"

      - name: Install build tools
        run: pip install build pytest

      - name: Install package
        run: pip install -e ".[dev]"

      - name: Run tests
        run: python -m pytest tests/ -v --tb=short

      - name: Build
        run: python -m build

      - name: Publish to PyPI
        uses: pypa/gh-action-pypi-publish@release/v1
        # Uses PyPI Trusted Publishing (no token needed in secrets)
        # Configure at: https://pypi.org/manage/project/pyCoreGage/settings/publishing/
```

With **Trusted Publishing** enabled on PyPI, no API token is stored in
GitHub Secrets — PyPI authenticates via OIDC directly.

---

## Troubleshooting

### `File already exists` on TestPyPI/PyPI

Each version number can only be uploaded once. Increment the version in
`pyproject.toml`, rebuild, and re-upload.

### `Invalid distribution` or metadata error

Run `twine check dist/*` before uploading to catch metadata issues:

```bash
twine check dist/*
```

### Data files missing after `pip install`

Verify `[tool.setuptools.package-data]` in `pyproject.toml` lists the
correct glob patterns, and that the files exist on disk at those paths.

### `ModuleNotFoundError: pyCoreGage` after install

Check that `[tool.setuptools.packages.find]` is correct:

```toml
[tool.setuptools.packages.find]
where   = ["."]
include = ["pyCoreGage*"]
```

### CLI command `pycoregage` not found

Verify the entry point in `pyproject.toml`:

```toml
[project.scripts]
pycoregage = "pyCoreGage._cli:main"
```

Re-install with `pip install -e .` and try again.
