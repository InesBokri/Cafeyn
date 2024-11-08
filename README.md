**Topics Management App**

The app retrieves a list of topics from a remote API and allows users to mark specific topics as favorites, saving them locally for future sessions. Favorite topics are highlighted separately, enabling easy access and management. The app uses a clean and maintainable architecture, leveraging MVVM (Model-View-ViewModel) principles and a repository pattern, ensuring separation of concerns and easier testing.

**Features**
**Fetch Topics:** Retrieve topics from a remote API endpoint.
**Save Favorite Topics:** Users can mark topics as favorites, which are then saved locally using UserDefaults.
**Dynamic Sections:** Topics are displayed in separate sections — one for all available topics and another for favorites.
Persistent Favorites: Favorite topics are saved locally so they persist between sessions.

**Architecture**
The app is structured following the **MVVM (Model-View-ViewModel)** architecture pattern with a **repository** layer, which promotes separation of concerns and simplifies maintenance.

**Layers**
**Model:** Defines the Topic structure representing individual topics.

**ViewModel:** Acts as the intermediary between the View and the Model/Repository. It handles the logic for fetching and managing topics, including loading and saving favorite topics from UserDefaults.

**View:** Displays the data managed by the ViewModel. The main view controller fetches the data and populates two sections in a table view

**Unit Testing**
Unit tests are designed to verify the functionality of key components, ensuring data flows correctly and logic performs as expected. The tests cover:

**ViewModel Tests:** Validates the ViewModel’s logic for managing topics and favorite topics
**Repository Tests:** Tests the TopicRepository

**Getting Started**
**Clone the repository** and open the project in Xcode.
**Run** the app to see available topics retrieved from the remote endpoint.
**Mark topics as favorite** to move them to the favorites section.
**Run Unit Tests** using Xcode’s test navigator.
![Simulator Screen Shot - iPhone 14 Pro - 2024-11-08 at 12 00 48](https://github.com/user-attachments/assets/e4a20922-578b-410c-98fb-3cbca93c7411)
![Simulator Screen Shot - iPhone 14 Pro - 2024-11-08 at 12 00 54](https://github.com/user-attachments/assets/a3ef48b5-1526-4b8e-8661-9c75d6cbf02e)
