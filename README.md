# GlobeExam
GlobeExam  is a sample iOS application built for a technical assessment. It demonstrates the ability to consume and display a remote JSON feed using modern iOS development best practices. The app is designed to be clear, maintainable, and scalable, with attention to architecture, offline support, and user experience.

📝 Project Overview
- Architecture: MVVM (Model-View-ViewModel)
- Networking: Alamofire for API requests
- Reactive Programming: Combine for data binding and event handling
- Layout: SnapKit for programmatic Auto Layout
- Features:
 	- Fetches posts from a JSON API
	- Offline caching of posts
	- Pull-to-refresh functionality
	- Search functionality with debounce
	- Detailed view for individual posts
	- Unit tests for caching mechanism

🛠 Setup Instructions
1. Clone the Repository:
   git clone https://github.com/johncelis/GlobeExam.git
	 cd GlobeExam

3. Open the Project:
	Open `PostApp.xcodeproj` in Xcode.

4. Install Dependencies:
The project uses Swift Package Manager (SPM) for dependency management. Upon opening the project, Xcode should automatically resolve and fetch the required packages:
- Alamofire
- SnapKit
If not, you can manually add them via File > Add Packages... in Xcode.

5. Build and Run:
Select a simulator or your device and press `Cmd + R` to build and run the application.
