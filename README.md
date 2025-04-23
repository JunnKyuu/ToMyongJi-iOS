# 💡 투명지 (To MyongJi)

<div align="center">
  <img src="UI/Resources/Assets.xcassets/logo.imageset/logo.png" alt="투명지 로고" width="200"/>
  
  [![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white)](https://apps.apple.com/kr/app/투명지/id6743519294)
  [![Web](https://img.shields.io/badge/Web-000000?style=for-the-badge&logo=react&logoColor=61DAFB)](https://www.tomyongji.com)
</div>

## 📌 프로젝트 소개

투명지(To MyongJi)는 "To MyongJi(명지대학교 학생들을 위해)"라는 의미와 동시에 학생회비 내역을 투명하게 공개한다는 목적을 담은 학생회비 통합 관리 플랫폼입니다.

최근 발생한 명지대학교 학생회비 횡령 사건을 계기로, 기존 학생회비 관리 방식의 불투명성과 비효율성을 해결하고자 개발되었습니다.

## 👥 팀원 소개

### Product Manager / Ops

| [<img src="https://github.com/eeeseohyun.png" width="150" height="150"/>](https://github.com/eeeseohyun) |
| :------------------------------------------------------------------------------------------------------: |
|                                                **이서현**                                                |

### iOS / Frontend

| [<img src="https://github.com/JunnKyuu.png" width="150" height="150"/>](https://github.com/JunnKyuu) |
| :--------------------------------------------------------------------------------------------------: |
|                                              **이준규**                                              |

### Backend

| [<img src="https://github.com/eeeseohyun.png" width="150" height="150"/>](https://github.com/eeeseohyun) | [<img src="https://github.com/jinhyeongpark.png" width="150" height="150"/>](https://github.com/jinhyeongpark) |
| :------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------: |
|                                                **이서현**                                                |                                                   **박진형**                                                   |

## ✨ 주요 기능

<!-- 스플래시 화면 이미지 -->
<div align="center">
  <img src="UI/Resources/Assets.xcassets/splash-view.imageset/splash-view.png" alt="스플래시 화면" width="200"/>
  <p align="center">투명지 시작 화면</p>
</div>

### 📊 영수증 조회

- **일반 조회**: 모든 사용자가 접근 가능한 기본 조회 기능 (잔액 미표시)
- **학생회 소속원 조회**: 학생회 소속원만 접근 가능한 상세 조회 기능 (잔액 표시)

<!-- 영수증 조회 관련 이미지 -->
<div align="center">
  <img src="UI/Resources/Assets.xcassets/select-department.imageset/select-department.png" alt="학과 선택" width="200"/>
  <img src="UI/Resources/Assets.xcassets/receipt-list-screenshot.imageset/receipt-list-screenshot.png" alt="영수증 조회" width="200"/>
  <p align="center">학과 선택 및 영수증 조회 화면</p>
</div>

### ✍️ 영수증 작성 (로그인 필요)

- 날짜, 내용, 입금, 출금 내역을 저장
- 로그인한 사용자만 접근 가능

<!-- 영수증 작성 화면 이미지 -->
<div align="center">
  <img src="UI/Resources/Assets.xcassets/create-receipt-screenshot.imageset/create-receipt-screenshot.png" alt="영수증 작성" width="200"/>
  <p align="center">영수증 작성 화면</p>
</div>

### 👤 프로필 관리 (로그인 필요)

- **내 정보 조회**: 학생회 소속원 및 회장 정보 확인
- **학생회 소속원 관리**
  - 소속원 조회
  - 소속원 추가/삭제 (학생회 회장 전용)

<!-- 프로필 화면 이미지 -->
<div align="center">
  <img src="UI/Resources/Assets.xcassets/profile-screenshot.imageset/profile-screenshot.png" alt="마이페이지" width="200"/>
  <p align="center">마이페이지 화면</p>
</div>

## 🛠 기술 스택

### 🍎 App(iOS)

<img src="https://img.shields.io/badge/Xcode-2379F4?style=for-the-badge&logo=Xcode&logoColor=white"><img src="https://img.shields.io/badge/XCTest-2379F4?style=for-the-badge&logo=Xcode&logoColor=white"><img src="https://img.shields.io/badge/SPM-2379F4?style=for-the-badge&logo=Xcode&logoColor=white"><img src="https://img.shields.io/badge/Swift-E60012?style=for-the-badge&logo=Swift&logoColor=white"><img src="https://img.shields.io/badge/SwiftUI-F05138?style=for-the-badge&logo=Swift&logoColor=white"><img src="https://img.shields.io/badge/combine-FF61F6?style=for-the-badge&logo=Swift&logoColor=white"><img src="https://img.shields.io/badge/Alamofire-EF2D5E?style=for-the-badge&logo=Swift&logoColor=white"><img src="https://img.shields.io/badge/Tuist-5A2EF4?style=for-the-badge&logo=Swift&logoColor=white">

<br>

### 🖥️ Web

<img src="https://img.shields.io/badge/Javascript-F7DF1E?style=for-the-badge&logo=Javascript&logoColor=white"><img src="https://img.shields.io/badge/react-61DAFB?style=for-the-badge&logo=react&logoColor=white"><img src="https://img.shields.io/badge/zustand-FF3366?style=for-the-badge&logo=react&logoColor=white"><img src="https://img.shields.io/badge/tailwindcss-06B6D4?style=for-the-badge&logo=tailwindcss&logoColor=white"><img src="https://img.shields.io/badge/vercel-000000?style=for-the-badge&logo=vercel&logoColor=white">

### 🔧 Backend

<img src="https://img.shields.io/badge/Java-007396?style=for-the-badge&logo=java&logoColor=white"><img src="https://img.shields.io/badge/Spring-6DB33F?style=for-the-badge&logo=spring&logoColor=white"><img src="https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white"><img src="https://img.shields.io/badge/JUnit5-25A162?style=for-the-badge&logo=junit5&logoColor=white">

### ⚙️ Ops

<img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white"><img src="https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white"><img src="https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white"><img src="https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white"><img src="https://img.shields.io/badge/GitHub_Secrets-181717?style=for-the-badge&logo=github&logoColor=white"><img src="https://img.shields.io/badge/Amazon_RDS-527FFF?style=for-the-badge&logo=amazon-rds&logoColor=white"><img src="https://img.shields.io/badge/Promtail-374EE6?style=for-the-badge&logo=grafana&logoColor=white"><img src="https://img.shields.io/badge/Loki-F46800?style=for-the-badge&logo=grafana&logoColor=white"><img src="https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white">

### 🛠 Collaboration

<img src="https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white"><img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white"><img src="https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=white"><img src="https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white">
