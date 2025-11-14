<!-- CARBAZAR Flutter MVP PRD -->

# CARBAZAR Flutter Android MVP — Product Requirements Document

## 1. Summary & Scope
- **Background:** CARBAZAR digitizes Pakistan’s automobile trading via a Flutter client for buyers/sellers and a React admin console. The MVP targets Android phones only and focuses on fraud-aware discovery, direct purchase intent, and live auctions.
- **Vision:** Deliver a secure, modern marketplace that mixes fixed-price listings and timed auctions with verified sellers, ensuring transparency and trust through government excise verification links and admin oversight.
- **Goals (MVP):**
  1. Allow verified buyers and sellers to authenticate (Google + OTP) and manage basic profiles.
  2. Provide a high-quality catalog with filters, wishlist, and card-based browsing experience.
  3. Enable participation in real-time auctions with live countdowns, bid placement, and notifications.
  4. Offer direct buyer-seller communication (chat/call) anchored by trust indicators.
  5. Push critical alerts (auction state changes, bid outbid, verification updates) reliably.
- **Non-Goals (MVP):**
  - No in-app payments/escrow.
  - No web/iOS clients.
  - No advanced AI recommender or seller analytics dashboards yet.
  - No self-serve KYC—admin still verifies documents offline.

## 2. Personas
| Persona | Description | Key Needs |
| --- | --- | --- |
| **Buyer Bilal** | 25-40, tech-savvy, looking for used cars with confidence | Transparent pricing, verified sellers, easy bidding, mobile-first access |
| **Seller Sana** | Small showroom owner, posts multiple listings | Fast listing creation, managing inquiries, showcasing credibility |
| **Auction Enthusiast Amir** | Enthusiast chasing deals via auctions | Live status, instant notifications, rapid bid interactions |

## 3. Primary User Journeys
1. **Buyer Onboarding → Browse → Wishlist → Contact Seller**  
2. **Seller Authentication → Submit listing for approval → Track listing status**  
3. **Buyer enters Auction → Places bid → Receives state changes → Wins/Loses**  
4. **User receives admin verification prompt → Uploads documents → Waits for approval**  

## 4. Functional Requirements
### 4.1 Authentication & Profiles
- Google sign-in plus phone OTP (Firebase Auth).
- Role selection (buyer/seller) and lightweight profile (name, city, CNIC snapshot, optional dealership info).
- Admin verification status visible (Unverified, Pending, Verified, Blocked).

### 4.2 Home Feed & Discovery
- Hero card carousel for featured auctions/listings with smooth parallax transitions.
- Filter chips (Brand, Price Range, City, Body Type) with persistent state.
- Search with typeahead (local cache + backend suggestion).
- Vehicle cards: cover photo, title, price/base bid, location, verification badge, countdown pill if auction.
- Pull-to-refresh + infinite scroll pattern.

### 4.3 Listing Detail
- Image gallery with pinch zoom; document thumbnails (registration, inspection).
- Card sections: Vehicle spec sheet, seller info, verification proof link, auction timeline (if relevant), similar listings.
- Action buttons: `Bid Now` (if auction), `Contact Seller`, `Chat`, `Wishlist`.

### 4.4 Auctions
- Real-time auction room showing current bid, bid history snapshot, participants count.
- Interactive countdown (sync via server time; show <5 min warning state).
- Bid placement bottom sheet with min increment validation, error states (insufficient verification, network).
- Auto-refresh from Firebase RTDB/WebSockets fallback.

### 4.5 Wishlist & Notifications
- Persist wishlist per user; offline-first cache.
- Push notifications: new bid, outbid, auction starting soon, seller responses.
- Notification inbox screen with grouped cards; tap navigates to relevant listing/auction.

### 4.6 Chat & Contact
- In-app chat (basic text + attachment placeholders) between verified buyer & seller; moderation hooks for admin.
- Quick actions for `Call Seller` (deep link into dialer) and `Visit Map` (launch Google Maps with pin).

### 4.7 Settings & Support
- Profile edit, document upload, passwordless re-auth.
- FAQ, report fraud flow (form with auto-attach listing ID).
- Dark mode support (align with Android 12 material you when time allows, not blocking release).

## 5. Experience Requirements
- **Visual Language:** Sleek, modern, professional; rely on card-based layout, elevated surfaces, tinted backgrounds, and brand accent (deep blue + amber). Maintain consistent 8pt spacing grid.
- **Motion:** Smooth, physics-based transitions between sections (shared element transitions for cards → detail, cross-fade for tab changes). All interactions <200ms response, <500ms transition.
- **Navigation:** Bottom navigation (Home, Auctions, Wishlist, Inbox, Profile). Floating action button for `Add Listing` when seller role active.
- **Accessibility:** Minimum 4.5:1 contrast, scalable fonts up to 200%, voice-over labels for timer, verification badges, and key CTAs.
- **Microcopy:** Emphasize trust (“Verified by Excise Portal”), urgency (“Auction ending in 02:15”), transparency (“Inspection report required for approval”).

## 6. Technical & Data Constraints
- **Platform:** Flutter 3.x, Android SDK 24+, target Pixel 5 baseline performance.
- **Backend:** Node.js/Express APIs + Firebase (Auth, Firestore, Storage, Cloud Messaging, optional Realtime DB). Admin panel already React-based; mobile consumes exposed REST/RTDB endpoints.
- **Data:** Vehicle entity (specs, docs, verification link), Auction entity (start/end, base price, current bid, participant IDs), User entity (role, verification status, KYC docs).
- **Performance:** Home feed renders <1.5s on 4G; auction updates within 2s latency; image upload limit 10MB per file with aggressive compression.
- **Security:** JWT tokens, Firestore rules per role, read-only for unverified users on sensitive data, chat moderation hooks.
- **Analytics:** Log key funnels (signup completion, filter usage, bids per auction, wishlist adds). Use Firebase Analytics segments for buyers vs sellers.

## 7. Success Metrics & Release Criteria
- **Activation:** 70% of new users complete verification-ready profile in 7 days.
- **Engagement:** ≥40% of weekly active buyers place at least 1 bid or contact seller.
- **Auction Health:** Avg. 5 bids per live auction; push delivery rate ≥95%.
- **Quality:** Crash-free sessions ≥99%; ANR <0.3%.
- **Release Gate:** All P0/P1 defects closed, Firebase rules security reviewed, basic load test (500 concurrent bid events).

## 8. Risks & Mitigations
- **Real-time sync drift** – implement server-time sync headers + fallback poll.
- **Fraudulent listings** – strict admin approval workflow, document checks, user report button prominent.
- **Network variability** – offline caching for feed/wishlist, exponential retry for bids with clear UX.
- **Scope creep (AI, payments)** – documented as post-MVP roadmap; blocked behind feature flags.

## 9. Open Questions
1. Confirm exact government excise API or manual link upload process for verification cards.
2. Determine whether chat requires end-to-end encryption at MVP.
3. Clarify if sellers can run both fixed-price and auction simultaneously for same vehicle.
4. Decide on initial push notification provider beyond Firebase Cloud Messaging for redundancy.

---
Prepared for the CARBAZAR Flutter Android MVP build; aligns with sleek, card-first design expectations and ensures a tightly scoped, launch-ready experience.

