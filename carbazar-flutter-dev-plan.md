<!-- CARBAZAR Flutter Development Plan -->

# CARBAZAR Flutter Android MVP — Development Phase Plan

This plan translates the PRD (`carbazar-flutter-mvp-prd.md`) into an executable roadmap for the Android-only Flutter build, detailing scope slices, sequencing, staffing, tooling, quality gates, and delivery milestones.

## 1. Objectives
1. Deliver the MVP scope (auth, discovery, auctions, wishlist, chat, notifications, settings) within 12 weeks.
2. Uphold the sleek, professional card-based UI with polished transitions described in the PRD.
3. Ensure production readiness: verified security rules, observability, and Google Play deployable bundle.

## 2. Architecture Snapshot
- **Client:** Flutter 3.x, Dart 3, Modular architecture (feature-first packages: `auth`, `listings`, `auctions`, `chat`, `profile`, `core_ui`).
- **State Management:** Riverpod or Bloc (decision in Sprint 0); animations via Implicit/Explicit Animations + `go_router` for transitions.
- **Networking:** REST via `dio`, WebSockets/Firestore listeners for live auctions, Firebase Cloud Messaging for push.
- **Storage:** Firestore for listings, auctions, users; Firebase Storage for media; Secure Storage for tokens.
- **CI/CD:** GitHub Actions (analyze, test, build), Fastlane for Play Store tracks.

## 3. Workstreams
| Workstream | Description | Leads |
| --- | --- | --- |
| **Foundation** | Project setup, design system tokens, routing, analytics hooks | Lead Flutter Dev |
| **Auth & Profiles** | Google/OTP login, role selection, verification status, settings | Mobile Dev A |
| **Discovery** | Home feed, filters, listing detail, wishlist | Mobile Dev B |
| **Auctions & Notifications** | Live room, bidding, push alerts | Mobile Dev C |
| **Chat & Support** | Buyer-seller chat, report fraud, FAQ | Mobile Dev D |
| **QA & Release** | Testing, performance tuning, Play listing | QA Engineer |

## 4. Milestones & Sprints (12 Weeks)
- **Sprint 0 (Week 1):** Finalize architecture decisions, DevOps pipeline, wireframe handoff, sample data seeds, choose state management.
- **Sprint 1 (Week 2):** Auth baseline (Google + OTP), role selection, skeleton screens, navigation shell.
- **Sprint 2 (Week 3):** Profile setup, verification status badges, basic settings.
- **Sprint 3 (Week 4):** Home feed scaffolding, filter chips, search endpoint wiring.
- **Sprint 4 (Week 5):** Listing detail, image gallery, wishlist persistence.
- **Sprint 5 (Week 6):** Auction lobby UI, countdown, bid placement validation.
- **Sprint 6 (Week 7):** Realtime sync integration (Firestore listeners), notification inbox.
- **Sprint 7 (Week 8):** Push notifications (FCM), background handling, deep links.
- **Sprint 8 (Week 9):** Chat MVP, moderation hooks, call/map deep links.
- **Sprint 9 (Week 10):** Settings enhancements, document upload, report fraud.
- **Sprint 10 (Week 11):** Polishing animations, accessibility, offline caching.
- **Sprint 11 (Week 12):** Stabilization, regression QA, beta build, Play Console submission.

## 5. Deliverables per Sprint
- Definition of Done includes unit/widget tests (>70% critical features), design QA sign-off, localization hooks, analytics events instrumented.
- Sprint demos to stakeholders; retro to capture risks (especially auction latency and verification flow).

## 6. Tooling & Environments
- IDE: Android Studio / VS Code with Flutter extensions.
- Feature flags using Firebase Remote Config for risky modules (chat attachments, dark mode).
- Staging Firebase project mirrors production security rules; emulator farm via Firebase Test Lab.

## 7. Quality Strategy
- **Testing Pyramid:** Unit (Riverpod providers, repositories), Widget (screen states), Integration (happy path flows), Manual exploratory (auction stress).
- **Performance Benchmarks:** Home feed <1.5s TTI on Pixel 5, auction event latency <2s, memory <256MB per session.
- **Security:** Pen test checklist for auth, Firestore rules peer review, secure storage for sensitive tokens.

## 8. Release Management
- Weekly beta builds to internal testers (Firebase App Distribution).
- Release candidate after Sprint 11 with signed AAB, Play Console listing assets, privacy policy.
- Rollout strategy: staged rollout (10% → 50% → 100%) after monitoring crash analytics.

## 9. Dependencies & Integration Points
1. Backend APIs for listings, auctions, chat endpoints—need contract finalized by Sprint 2.
2. Government excise verification link workflow confirmed by Sprint 3.
3. Notification topics & payload schema from backend by Sprint 6.
4. Admin panel status updates (verification, listing approval) exposed via Firestore triggers.

## 10. Risks & Mitigations
- **Realtime auction complexity:** Build simulator tool in Sprint 5 to test bidding concurrency.
- **Design-system drift:** Maintain `core_ui` component library with figma-tokens sync; weekly design reviews.
- **Data costs:** Optimize image compression, leverage Cloud Storage lifecycle rules.
- **Team bandwidth:** Cross-train devs on auctions & chat to avoid single points of failure.

## 11. Communication Cadence
- Daily stand-ups, bi-weekly stakeholder sync, sprint reviews/retros, shared status doc referencing both PRD and this plan.

## 12. Acceptance Criteria for Development Phase Completion
1. All PRD features implemented behind feature flags as needed.
2. Test coverage targets met; zero P0/P1 defects outstanding.
3. Performance/UX benchmarks verified on target hardware.
4. Release checklist (security review, analytics validation, documentation) signed off.

---
This plan keeps the team aligned while executing the CARBAZAR Flutter MVP, ensuring we deliver the sleek, high-trust experience defined in the PRD on time and with quality.

