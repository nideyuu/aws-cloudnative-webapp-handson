# aws-cloudnative-webapp-handson

## 概要

このリポジトリは、AWS上でクラウドネイティブなWebアプリケーション基盤を構築するハンズオンです。

CloudFrontをWebアプリケーションの単一入口として利用し、静的コンテンツはS3、API通信はALB配下のEC2へ振り分けます。EC2はPrivate Subnetに配置し、APIサーバーとして動作させます。データベースにはPrivate DB Subnet上のRDS MySQLを利用します。

このハンズオンでは、AWSエンジニアとして案件に入ることを目的に、Web/AP/DB構成、Public/Private Subnet分離、Security Groupによる通信制御、CloudFrontによるパスベースの振り分け、TerraformによるIaC化を学習します。

---

## 構成概要

```text
User
  |
  v
CloudFront
  |----------------------|
  |                      |
  v                      v
S3                    ALB
Static Web             |
HTML/CSS/JS            v
                      EC2
                   API Server
                       |
                       v
                      RDS
                     MySQL
```

---

## 通信の流れ

### 静的Web配信

```text
User
  |
  v
CloudFront
  |
  v
S3
```

CloudFrontのルートパス `/` へのアクセスはS3へ転送され、HTML/CSS/JavaScriptなどの静的ファイルを配信します。

### API通信

```text
User
  |
  v
CloudFront
  |
  v
ALB
  |
  v
EC2
  |
  v
RDS
```

CloudFrontの `/api/*` へのアクセスはALBへ転送され、ALB配下のEC2上でAPIを処理します。APIサーバーは必要に応じてRDS MySQLへ接続します。

---

## 使用する主なAWSサービス

| サービス             | 用途                                    |
| ---------------- | ------------------------------------- |
| CloudFront       | Webアプリケーションの単一入口、パスベースの振り分け           |
| S3               | 静的ファイルの配置                             |
| ALB              | API通信をEC2へ転送                          |
| EC2              | APIサーバー                               |
| RDS              | MySQLデータベース                           |
| VPC              | 専用ネットワーク                              |
| Subnet           | Public / Private App / Private DB の分離 |
| Internet Gateway | Public Subnetの外部接続                    |
| NAT Gateway      | Private Subnet上のEC2から外部への通信           |
| Security Group   | 通信制御                                  |
| IAM Role         | EC2からSSMを利用するための権限                    |
| Systems Manager  | Private EC2への接続                       |

---

## ネットワーク設計

| 種別                    | CIDR         | 用途                |
| --------------------- | ------------ | ----------------- |
| VPC                   | 10.0.0.0/16  | ハンズオン用VPC         |
| Public Subnet 1a      | 10.0.1.0/24  | ALB / NAT Gateway |
| Public Subnet 1c      | 10.0.2.0/24  | ALB               |
| Private App Subnet 1a | 10.0.11.0/24 | EC2 API Server    |
| Private App Subnet 1c | 10.0.12.0/24 | 将来の拡張用            |
| Private DB Subnet 1a  | 10.0.21.0/24 | RDS Subnet Group  |
| Private DB Subnet 1c  | 10.0.22.0/24 | RDS Subnet Group  |

---

## セキュリティ設計

### ALB Security Group

```text
Inbound:
  HTTP 80 from 0.0.0.0/0

Outbound:
  EC2 Security Group
```

学習用構成では検証しやすさを優先し、ALBのHTTP 80を公開します。
本番構成ではHTTPS化、CloudFront経由のアクセス制限、WAF導入などを検討します。

### EC2 Security Group

```text
Inbound:
  HTTP 80 from ALB Security Group

Outbound:
  RDS 3306
  Internet via NAT Gateway
```

EC2はPrivate Subnetに配置し、インターネットから直接アクセスできない構成にします。

### RDS Security Group

```text
Inbound:
  MySQL 3306 from EC2 Security Group
```

RDSはPrivate DB Subnetに配置し、EC2からのMySQL接続のみ許可します。

---

## ハンズオンの進め方

```text
Phase 1: 全体構成の設計
Phase 2: 通信の流れの理解
Phase 3: AWSリソース一覧の整理
Phase 4: 手動構築
Phase 5: Terraform化
Phase 6: README / GitHub整理
Phase 7: 面接・案件説明用の説明文作成
```

---

## 初期構築方針

まずは、以下の構成を手動で構築します。

```text
CloudFront
  |----------------------|
  |                      |
  v                      v
S3                    ALB
                       |
                       v
                      EC2
                       |
                       v
                      RDS
```

初期構築では、HTTPS化、独自ドメイン、Route53、Auto Scaling、WAFなどは後回しにします。

まずは以下の3点を確認できることをゴールにします。

```text
1. CloudFront経由でS3の静的Webページを表示できる
2. CloudFrontの /api/* からALB経由でEC2へ到達できる
3. EC2からRDS MySQLへ接続できる
```

---

## 学習目的

このハンズオンでは、以下の内容を学習します。

* CloudFrontを単一入口としたWebアプリ構成
* S3による静的Web配信
* CloudFrontのパスベースルーティング
* ALBによるAPI通信の転送
* Private Subnet上のEC2運用
* RDS MySQLとの接続
* Security Groupによる通信制御
* NAT Gatewayを使ったPrivate Subnetからの外向き通信
* SSM Session ManagerによるEC2接続
* TerraformによるIaC化

---

## この構成で意識するポイント

### CloudFrontを単一入口にする理由

CloudFrontをWebアプリケーションの入口にすることで、静的コンテンツとAPI通信を同じドメイン配下で扱えるようにします。

```text
/        -> S3
/api/*   -> ALB -> EC2 -> RDS
```

これにより、利用者はS3やALBを直接意識せず、CloudFront経由でWebアプリケーションを利用できます。

### EC2をPrivate Subnetに配置する理由

EC2をPrivate Subnetに配置することで、インターネットからEC2へ直接アクセスできない構成にします。

```text
OK:
  ALB -> EC2

NG:
  Internet -> EC2
```

APIサーバーへのアクセスはALB経由に限定します。

### RDSをPrivate DB Subnetに配置する理由

RDSをPrivate DB Subnetに配置し、Security GroupでEC2からのMySQL通信のみ許可します。

```text
OK:
  EC2 -> RDS

NG:
  Internet -> RDS
NG:
  ALB -> RDS
```

これにより、データベースを外部公開しない安全な構成にします。

### NAT Gatewayを利用する理由

EC2はPrivate Subnetに配置するため、インターネットから直接アクセスされません。

ただし、EC2から外部へ通信する場面があります。

```text
dnf update
パッケージインストール
Dockerイメージ取得
外部リポジトリへのアクセス
```

そのため、Private Subnet上のEC2から外向き通信を行うためにNAT Gatewayを利用します。

```text
```

---

## 今後の拡張予定

* Terraform化
* CloudWatch Logs追加
* EC2 2台構成
* HTTPS化
* Route53による独自ドメイン対応
* S3 BackendによるTerraform state管理
＊WAF追加
＊Auto Scaling追加
---
## 注意事項
このリポジトリは学習用のハンズオンです。
初期構築では理解しやすさを優先し、一部の構成を簡略化しています。
本番環境では、以下のような追加設計を検討します。

* HTTPS化
* 独自ドメインの利用
* WAFによる保護
* Multi-AZ構成
* Auto Scaling
* CloudWatch Logs / Metrics による監視
* Secrets ManagerやSSM Parameter Storeによる認証情報管理
* CloudFrontからALBへのアクセス制限


