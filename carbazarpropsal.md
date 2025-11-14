Final Year Project Proposal  
Abstract 
CARBAZAR is a mobile and web-based platform dedicated to revolutionizing the automobile 
marketplace by integrating e-commerce with real-time vehicle auctions. The system will allow 
users to sign up as buyers or sellers, providing secure profile management features such as 
Google login, multi-factor authentication, and account settings. Sellers can showcase their 
vehicles for sale or auction by uploading descriptions, images, documents, and verified 
ownership links from government excise portals, ensuring trust and transparency. Buyers can 
browse through vehicles, use category filters, view auctions with countdown timers, bid live, 
and verify seller authenticity. The application includes wishlist functionality, seller ratings, 
map-based location visits, and direct chat options to enhance trustworthiness. An admin 
panel, developed in React, ensures full platform governance, including user verification, fraud 
prevention, and auction oversight. By providing a secure, transparent, and interactive 
marketplace, CARBAZAR aims to minimize fraud in automobile transactions and establish 
itself as a reliable digital hub for vehicle buying and selling.CARBAZAR is a hybrid 
automobile auction and sales platform designed to digitize vehicle trading while ensuring 
trust, transparency, and convenience. The system provides buyers and sellers with a secure 
marketplace where vehicles can be listed, auctioned, or sold directly. Core features include 
real-time auctions with countdown timers, detailed vehicle pages with images/documents, 
wishlist functionality, secure user roles (buyer/seller), and government excise portal 
integration for vehicle verification. Sellers can add business information and showroom 
details, while buyers benefit from profile personalization, live auction updates, and 
chat/contact with sellers. To minimize fraud, all users are verified through admin oversight 
with ID checks. The system comprises a Flutter Android App for buyers and sellers, and a 
React-based Admin Panel for system management. 
1.1 Introduction 
The automobile industry is one of the most significant markets worldwide, yet traditional 
vehicle buying and selling still faces challenges such as fraud, lack of transparency, and 
inefficiency in auctions. CARBAZAR is designed to digitize this ecosystem by offering a 
mobile application built with Flutter and an admin dashboard in React. 
The platform allows sellers to list cars for sale or auction while ensuring authenticity through 
official government excise portals. Buyers benefit from real-time auctions with live bidding, 
vehicle document verification, and seller ratings, creating trust and reducing fraud. The system 
also integrates advanced features like wishlist saving, city-based filtering, direct chat, and 
analytics for sellers to track vehicle visibility and engagement. By combining a modern e
commerce-like interface with robust administrative controls, CARBAZAR seeks to address 
the challenges of fraudulent activities and build a reliable, user-friendly digital automobile 
marketplace.

1.2. Project Title: 
The title of the project is “CARBAZAR” 
1.3. Project Overview statement: 
The CARBAZAR project aims to create a digital automobile marketplace that merges e- 
commerce functionality with vehicle-specific requirements such as auctions, government 
verification, and real-time user interaction. Sellers can provide their business information, 
including garage/showroom details, office location, and verified documents, while buyers can 
participate in transparent bidding processes, explore vehicle listings, and save preferences. 
Core innovations include: 
• Vehicle Auctions: Real-time bidding with live updates and countdown timers. 
• E-commerce UI: Category filters, price updates, and city-based searches. 
• Buyer-Seller Features: Direct chat, comments, ratings, and wishlist. 
• Admin Security: ID verification, fraud monitoring, and user management. 
• Recommendation System: AI-based vehicle suggestions from user preferences. 
• Notification System: Real-time push and email alerts for auctions and bids. 
• Seller Analytics: Graphs, engagement metrics, and market insights. 


 Project Goals & Objectives: 
Goals: 
 
1. Establish a secure and transparent digital automobile marketplace. 
2. Enable real-time vehicle auctions with interactive bidding. 
3. Build user trust through government data integration and seller verification.

Provide buyers with enhanced decision-making tools (filters, wishlist, ratings). 
5. Ensure fraud prevention and accountability via a strong admin panel. 
Objectives: 
1. Develop a Flutter-based mobile app for buyers and sellers. 
2. Build a React-based admin panel for system management. 
3. Integrate Google authentication, multi-factor login, and profile settings. 
4. Implement auction functionality with live bidding and countdown timers. 
5. AI-based vehicle suggestions from user preferences. 
6. Enable map embedding for location-based selling and visiting. 
7. Launch wishlist, seller analytics, and rating systems. 
8. Deploy fraud prevention measures with admin oversight. 
1.5. High-level system components: 
The CARBAZAR platform is composed of several high-level functional units that 
collectively provide a secure, transparent, and interactive automobile marketplace. Each 
component contributes to the overall system mission by handling specific inputs, processes, 
outputs, and stored data. The main high-level components are as follows: 
1. User Management Component 
• Inputs: User credentials, authentication tokens, profile details, verification 
documents. 
• Processes: Google sign-in, multi-factor authentication, role assignment 
(buyer/seller), profile updates, and document validation. 
• Outputs: Authenticated user sessions, verified user identities, personalized 
dashboards. 
• Stored Data: User profiles, authentication logs, verification records. 
2. Vehicle Listing & Auction Component 
• Inputs: Vehicle details (descriptions, images, documents, showroom info), 
auction setup data (start time, base price, countdown). 
• Processes: Vehicle listing creation, auction scheduling, real-time bidding, and status 
updates. 
© Department of Software Engineering 
Faculty of Computing & IT University 
of Gujrat 
8 
Version: 1.0 
SE- UOG - Project Management Office 
Final Year Project Proposal Guide 
Date: 23 September 2025 
• Outputs: Public listings of vehicles, live auction feeds, bid notifications, winner 
announcements. 
• Stored Data: Vehicle records, auction details, bidding history. 
3. Buyer Interaction Component 
• Inputs: Buyer search queries, wishlist additions, chat messages, ratings/reviews. 
• Processes: Filtering/searching vehicles by brand, price, or city; wishlist 
management; direct chat with sellers; providing ratings. 
• Outputs: Search results, wishlist updates, communication threads, rating 
feedback. 
• Stored Data: Buyer preferences, chat history, rating logs. 
4. Admin Panel Component 
• Inputs: User verification requests, fraud alerts, system monitoring logs. 
• Processes: Reviewing and approving/verifying users, monitoring auctions, 
detecting/reporting fraudulent activity, managing listings. 
• Outputs: Verified user accounts, blocked accounts in case of fraud, compliance 
reports. 
• Stored Data: Admin logs, fraud detection data, system audit records. 
5. System Infrastructure Component 
• Inputs: API requests from mobile and web clients, authentication calls, database 
queries. 
• Processes: Backend services (Node.js/Express) handling requests, Firebase storage 
and authentication, real-time updates. 
• Outputs: RESTful API responses, real-time auction updates, secure data 
transactions. 
• Stored Data: Centralized user/vehicle/auction database, authentication tokens, 
analytics data. 
1.6. Application Architecture: 
• Client Layer (Frontend): 
o Technology: Flutter (mobile), React (admin panel) 
o Components: 
o Mobile UI for browsing, auctions, and profiles 
o State management (Provider/Bloc for Flutter, Redux for React) 
• Application Layer (Backend): 
© Department of Software Engineering 
Faculty of Computing & IT University 
of Gujrat 
9 
Version: 1.0 
SE- UOG - Project Management Office 
Final Year Project Proposal Guide 
Date: 23 September 2025 
• Technology: Node.js with Express 
• Components: 
o RESTful APIs for auctions, users, and vehicles 
o Authentication (JWT, OAuth for Google sign-in) 
o Business logic for bidding, seller verification 
• Database Layer: 
• Technology: FireBase 
• Components: 
o Users, vehicles, auctions, bids, chats, ratings 
• Admin Panel: 
• Technology: React + Node.js 
• Components: 
o User verification via ID documents 
o Vehicle listing monitoring 
o Fraud detection and reporting tools 




------------------------------------


Vehicle Auctions: Real-time bidding with live updates and countdown timers.
E-commerce UI: Category filters, price updates, and city-based searches.
Buyer-Seller Features: Direct chat, comments, ratings, and wishlist.
Admin Security: ID verification, fraud monitoring, and user management.
Recommendation System: Al-based vehicle suggestions from user preferences.
Notification System: Real-time push and email alerts for auctions and bids.
Seller Analytics: Graphs, engagement metrics, and market insights.

------------------------------------------


1. Vehicle Auctions: Is module me users real-time me car auctions me participate kar sakte hain, jahan live bidding hoti hai countdown timer ke sath aur sab updates turant show hote hain.
2. E-commerce UI: Ye module website ko ek online store jaisa interface deta hai jahan users brand (Honda, Toyota), price range aur city ke hisaab se car search aur filter kar sakte hain.
3. Buyer-Seller Features: Is module me buyer aur seller directly chat kar sakte hain, comments aur ratings de sakte hain, aur pasandida vehicles ko wishlist me save kar sakte hain.
4. Admin Security: Ye module admin ko full control deta hai jahan wo user ID verify kar sakta hai, fraud activities monitor kar sakta hai aur users ya listings ko manage kar sakta hai.
5. Recommendation System: Is module me Al based system hota hai jo user ke search history, wishlist, location aur price range ke hisaab se unke liye best vehicle recommend karta hai.
6. Notification System: Ye module users ko real-time me push aur email notifications deta hai jaise auction updates, new listings, bid status changes aur upcoming auctions.
7. Seller Analytics: Is module me sellers ke liye dashboard hota hai jahan wo apni listings ke views, engagement, aur bid trends ko graphs aur reports ke zariye dekh sakte hain.