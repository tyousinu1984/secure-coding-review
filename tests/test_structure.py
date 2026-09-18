from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
SKILL = ROOT / "skill" / "secure-coding-review"
SKILL_MD = SKILL / "SKILL.md"

required_repo_files = [
    ROOT / "README.md",
    ROOT / "LICENSE",
    ROOT / "CONTRIBUTING.md",
    ROOT / "SECURITY.md",
    ROOT / "CODE_OF_CONDUCT.md",
    SKILL_MD,
]

required_skill_files = [
    SKILL / "references" / "common-rules.md",
    SKILL / "references" / "vulnerability-patterns.md",
    SKILL / "references" / "ai-generated-code.md",
    SKILL / "references" / "java-kotlin.md",
    SKILL / "references" / "python.md",
    SKILL / "references" / "javascript-typescript.md",
    SKILL / "references" / "aws-security.md",
    SKILL / "references" / "security-gate.md",
    SKILL / "scripts" / "security-scan.sh",
    SKILL / "scripts" / "security-scan.ps1",
]

errors = []

for path in required_repo_files + required_skill_files:
    if not path.exists():
        errors.append(f"Missing required file: {path.relative_to(ROOT)}")

if SKILL_MD.exists():
    text = SKILL_MD.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        errors.append("SKILL.md must begin with YAML-style front matter")
    if "name: secure-coding-review" not in text:
        errors.append("SKILL.md is missing expected skill name")
    if "description:" not in text:
        errors.append("SKILL.md is missing description")

    refs = set(re.findall(r'`(references/[^`]+\.md)`', text))
    for ref in refs:
        if not (SKILL / ref).exists():
            errors.append(f"SKILL.md references missing file: {ref}")

if errors:
    print("Repository validation failed:")
    for error in errors:
        print(f"- {error}")
    sys.exit(1)

print("Repository structure OK")
