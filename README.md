# Sportify

**Sportify** is a comprehensive iOS sports tracking application designed to explore sports, track leagues, and manage favorite teams seamlessly. Developed with a focus on elegant UI, robust architecture, and a smooth user experience.
Sports portal App Demo @ ITI 
developed by : Eng. Osama Hosam & Eng. Mina Wagdy

## ✨ Features

* **Sports Catalog:** Displays all available sports from the sportsdb. Presented in a clean CollectionView, featuring exactly two sports per row with appropriate spacing, displaying the sport's thumbnail and name.
* **Leagues Explorer:** Tapping a sport navigates to the Leagues screen. This TableViewController displays custom rows featuring a circular league badge and the league's name.
* **Dynamic League Details:** A fully custom compositional layout divided into distinct sections. 
    * Features a static menu section allowing users to toggle between **Recent** and **Upcoming** events. Clicking these options dynamically updates the event list in the section below it. 
    * Includes a horizontal CollectionView dedicated to displaying circular images of the participating teams.
* **Team Profiles:** Tapping a team image directs the user to an elegant Team Details screen displaying specific team information.
* **Offline Favorites:** Users can add leagues to their favorites, which are persisted locally using CoreData. If the user is online, tapping a favorite navigates to its details; if offline, a graceful alert is shown indicating no internet connection.
* **Premium Enhancements:** Fully implements an introductory Onboarding screen, comprehensive localization for broad accessibility (English/Arabic RTL), and full Dark Theme support.

## 🛠 Architecture & Tech Stack

The application strictly adheres to the **MVP (Model-View-Presenter)** design pattern, ensuring a clean separation of concerns between the user interface and business logic. 

* **Language/Platform:** Swift / iOS
* **Networking:** All API requests to `allsportsapi.com` are handled using **Alamofire**. Connectivity states are actively monitored using Alamofire's `NetworkReachabilityManager`.
* **Image Processing:** **Kingfisher** is integrated for high-performance downloading, caching, and processing of sport and team images.
* **UI/UX Enhancements:** **SkeletonView** is utilized to display elegant loading placeholders while data is being fetched, maintaining good UX across all screens.
* **Reactive Data Flow:** Implemented data binding and event streaming utilizing reactive subjects (BehaviorSubject/PublishSubject).
* **Local Persistence:** **Core Data** is used as the local database to save and retrieve favorite leagues.

## 🧪 Testing Strategy

* Unit testing is implemented using the **XCTest** framework.
* Testing is heavily focused on the logical core of the application. We utilized **Spies** to rigorously test the Presenters and verify their interactions with their respective View protocols, ensuring high confidence in the app's business logic without coupling the tests to the UI.
