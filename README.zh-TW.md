# Secure Coding Review Skill

[English](README.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md)

一套用於 AI 輔助軟體開發的開源安全防護工作流。

`secure-coding-review` 用來協助 AI Coding Agent 在程式碼變更的**之前、進行中與完成後**進行安全性判斷。它將安全編碼規則、Diff 審查、針對性的安全測試，以及確定性掃描工具的輸出整合為一個以證據為基礎的 **Security Gate**。

> 狀態：早期／實驗階段。本專案不能取代專業的安全審查、滲透測試、SAST/DAST 或事件應變。

## 為什麼要做這個專案

AI Coding Assistant 可以提高開發速度，但也可能引入或放大以下風險：

- 缺少授權（Authorization）檢查；
- 不安全的輸入來源到敏感 Sink 的資料流；
- AI 幻覺產生或實際上不需要的依賴套件；
- 安全設定被弱化；
- 為了讓不安全行為通過而修改測試；
- Secret 洩漏；
- 過度寬鬆的 Cloud / IAM 權限；
- 大型 AI 生成 Diff 中被掩蓋的安全退化。

本專案提供一套可重複使用的工作流，使這些風險能夠被明確識別、驗證與審查。

## 功能

本 Skill 會引導 AI Coding 工作流依序完成：

1. **變更分類（Change classification）** — 識別涉及安全性的程式碼變更。
2. **安全不變條件（Security invariants）** — 明確定義修改前後必須持續成立的安全條件。
3. **安全實作（Secure implementation）** — 優先使用框架與平台提供的安全機制。
4. **Diff 審查（Diff review）** — 檢查實際發生的程式碼變更。
5. **資料流分析（Data-flow analysis）** — 從攻擊者可控制的 Source 追蹤到敏感 Sink。
6. **掃描器整合（Scanner integration）** — 在可用時使用 Semgrep、Trivy、Gitleaks 及各語言生態系的 Audit 工具提供獨立證據。
7. **針對性負向測試（Targeted negative tests）** — 驗證授權邊界與不安全輸入是否能被正確阻擋。
8. **Security Gate** — 輸出 `PASS`、`PASS WITH WARNINGS`、`FAIL` 或 `INCOMPLETE`。

## Repository 結構

```text
.
├── skill/
│   └── secure-coding-review/
│       ├── SKILL.md
│       ├── references/
│       ├── scripts/
│       └── configs/
├── docs/
│   ├── architecture.md
│   ├── threat-model.md
│   └── roadmap.md
├── examples/
│   ├── usage.md
│   └── security-gate-example.md
├── tests/
├── scripts/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── workflows/
│   └── pull_request_template.md
├── CONTRIBUTING.md
├── SECURITY.md
├── CODE_OF_CONDUCT.md
├── CHANGELOG.md
└── LICENSE
```

## 快速開始

將 Skill 目錄複製到你的 AI Coding 環境所使用的 Skills 目錄：

```bash
./scripts/install-skill.sh /path/to/your/skills
```

Windows：

```powershell
.\scripts\Install-Skill.ps1 -SkillsDirectory "C:\path\to\your\skills"
```

也可以直接手動複製：

```text
skill/secure-coding-review/
```

宿主 AI 環境必須支援能夠讀取參照檔案的 Skill / Instruction 工作流。實際安裝路徑會因宿主環境而異。

## 掃描器支援

專案附帶的掃描 Wrapper 會視目前環境中已安裝的工具，自動使用：

- Semgrep
- Trivy
- Gitleaks
- `npm audit`
- `govulncheck`
- `pip-audit`

例如：

```bash
cd your-project
/path/to/secure-coding-review/scripts/security-scan.sh . security-reports
```

掃描器不存在時，**不會被視為掃描成功**。如果重要檢查無法執行，Security Gate 應保持為 `INCOMPLETE`。

## 設計原則

### 先有證據，再下結論

Skill 必須區分：

- Confirmed（已確認）
- Likely（很可能）
- Possible（可能）
- Needs verification（需要進一步驗證）

不得虛構 CVE、掃描器結果、可利用性、套件合法性或沒有證據支持的執行時行為。

### AI 自我審查不是獨立證明

產生漏洞的 AI，在重新審查自己的程式碼時，也可能重複相同的錯誤假設。

因此，確定性掃描工具、針對性的安全測試、執行時證據以及人工審查仍然十分重要。

### 保留原始證據

掃描器輸出與實際程式碼 Diff 應保留，以供後續驗證。

摘要不能取代原始證據。

### 優先採用最小且安全的變更

相較於大範圍的 AI 自動重構，本工作流優先採用能解決問題的最小安全變更。

## 目前支援範圍

目前已包含以下參照規則：

- 通用應用程式安全；
- Java / Kotlin；
- Python；
- JavaScript / TypeScript；
- Go；
- AWS / IaC；
- Docker / Kubernetes；
- OAuth / OIDC / JWT；
- 資料庫安全（SQL/NoSQL）；
- AI 生成程式碼特有風險；
- 常見漏洞與資料流模式。

後續規劃請參閱 [roadmap](docs/roadmap.md)。

## Security Gate 範例

```text
Security Gate: FAIL

High: 1
Medium: 1

HIGH — Missing object-level authorization

Status: Confirmed
Location: src/UserController.kt:74

Evidence:
The endpoint loads a resource from an attacker-controlled path ID
without checking whether the authenticated principal may access it.

Verification:
User A requests User B's resource and must receive 403/404
according to application policy.
```

完整範例請參閱 [examples/security-gate-example.md](examples/security-gate-example.md)。

## Contributing

歡迎回報問題與提出技術建議，尤其是：

- 語言／框架安全參照規則；
- 具有明確證據要求的漏洞模式；
- Scanner Adapter；
- False Positive 改善；
- 安全 Regression Test 範例；
- Cloud / IaC 規則。

本專案主要由 Repository Owner 維護。Pull Request 是否接受，將依本專案的安全模型與 Roadmap 決定。

提交 Pull Request 前請先閱讀 [CONTRIBUTING.md](CONTRIBUTING.md)。

## Security

請**不要**將本專案自身可能存在的安全漏洞作為一般公開 Issue 發布。

詳情請參閱 [SECURITY.md](SECURITY.md)。

## License

MIT。請參閱 [LICENSE](LICENSE)。
