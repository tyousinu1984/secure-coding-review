# Secure Coding Review Skill

[English](README.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md)

AI 支援ソフトウェア開発のための、オープンソースのセキュリティ・ガードレールです。

`secure-coding-review` は、AI Coding Agent がコード変更の**前・実装中・実装後**にセキュリティを考慮できるよう支援します。セキュアコーディングルール、Diff レビュー、対象を絞ったセキュリティテスト、決定論的なスキャナの結果を組み合わせ、根拠に基づく **Security Gate** を構成します。

> ステータス：初期段階／実験的。本プロジェクトは、専門的なセキュリティレビュー、ペネトレーションテスト、SAST/DAST、インシデント対応を代替するものではありません。

## このプロジェクトの目的

AI Coding Assistant は開発速度を向上させる一方で、次のようなリスクを導入・増幅する可能性があります。

- 認可（Authorization）チェックの欠落
- 信頼できない入力から危険な Sink への不安全なデータフロー
- AI が生成した実在しない、または不要な依存パッケージ
- セキュリティ設定の弱体化
- 不安全な挙動を通すためのテスト改変
- Secret の漏えい
- 過剰な Cloud / IAM 権限
- 大規模な AI 生成 Diff に埋もれたセキュリティリグレッション

本プロジェクトは、これらのリスクを明示的かつ検証可能な形でレビューするための、再利用可能なワークフローを提供します。

## 主な機能

本 Skill は AI Coding ワークフローを次の順序で支援します。

1. **Change classification** — セキュリティに関係する変更を識別します。
2. **Security invariants** — 変更後も維持すべきセキュリティ条件を定義します。
3. **Secure implementation** — フレームワークやプラットフォームが提供する安全な仕組みを優先します。
4. **Diff review** — 実際に変更されたコードを確認します。
5. **Data-flow analysis** — 攻撃者が制御可能な Source から機密性の高い Sink までを追跡します。
6. **Scanner integration** — 利用可能な場合、Semgrep、Trivy、Gitleaks、および各言語エコシステムの Audit ツールを独立した証拠として利用します。
7. **Targeted negative tests** — 認可境界や不正入力への耐性を確認します。
8. **Security Gate** — `PASS`、`PASS WITH WARNINGS`、`FAIL`、`INCOMPLETE` のいずれかを出力します。

## Repository 構成

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

## Quick start

Skill ディレクトリを、利用している AI Coding 環境の Skills ディレクトリへコピーします。

```bash
./scripts/install-skill.sh /path/to/your/skills
```

Windows：

```powershell
.\scripts\Install-Skill.ps1 -SkillsDirectory "C:\path\to\your\skills"
```

または、次のディレクトリを手動でコピーできます。

```text
skill/secure-coding-review/
```

利用する AI 環境は、参照ファイルを読み込める Skill / Instruction ワークフローに対応している必要があります。実際のインストール先はホスト環境によって異なります。

## Scanner サポート

付属の Scan Wrapper は、環境にインストール済みのツールを利用可能な範囲で実行します。

- Semgrep
- Trivy
- Gitleaks
- `npm audit`
- `govulncheck`
- `pip-audit`

例：

```bash
cd your-project
/path/to/secure-coding-review/scripts/security-scan.sh . security-reports
```

スキャナが存在しない場合、それを**スキャン成功とは扱いません**。重要なチェックを実行できない場合、Security Gate は `INCOMPLETE` とすべきです。

## 設計原則

### 結論より先に証拠を確認する

Skill は、各 Finding を次のように区別します。

- Confirmed（確認済み）
- Likely（可能性が高い）
- Possible（可能性あり）
- Needs verification（追加確認が必要）

CVE、スキャナ結果、Exploitability、パッケージの正当性、または根拠のない Runtime Behavior を捏造してはいけません。

### AI の自己レビューは独立した証明ではない

不具合を生成した AI は、自己レビューでも同じ前提ミスを繰り返す可能性があります。

そのため、決定論的なスキャナ、対象を絞ったセキュリティテスト、実行時の証拠、Human Review が引き続き重要です。

### Raw Evidence を保持する

Scanner Output と実際の Code Diff は、検証可能な状態で保持すべきです。

要約は原始証拠の代替にはなりません。

### 小さく安全な変更を優先する

大規模な AI 自動リファクタリングよりも、問題を解決するために必要な最小限かつ安全な変更を優先します。

## 現在の対応範囲

現在、次の Reference を含みます。

- 一般的な Application Security
- Java / Kotlin
- Python
- JavaScript / TypeScript
- AWS / IaC
- AI 生成コード固有のリスク
- 一般的な脆弱性／データフローパターン

今後の予定については [roadmap](docs/roadmap.md) を参照してください。

## Security Gate の例

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

より完全な例は [examples/security-gate-example.md](examples/security-gate-example.md) を参照してください。

## Contributing

Bug Report や技術的な提案を歓迎します。特に次の領域を対象とします。

- 言語／Framework 別の Security Reference
- 明確な Evidence 条件を持つ脆弱性パターン
- Scanner Adapter
- False Positive の削減
- Security Regression Test の例
- Cloud / IaC ルール

本プロジェクトは主に Repository Owner がメンテナンスします。Pull Request は、本プロジェクトの Security Model と Roadmap に適合する場合に受け入れることがあります。

Pull Request を作成する前に [CONTRIBUTING.md](CONTRIBUTING.md) を確認してください。

## Security

本プロジェクト自体に関するセキュリティ脆弱性の疑いを、通常の Public Issue として公開しないでください。

詳細は [SECURITY.md](SECURITY.md) を参照してください。

## License

MIT。詳細は [LICENSE](LICENSE) を参照してください。
