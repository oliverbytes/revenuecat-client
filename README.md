<!--
*** Thanks for checking out this README Template. If you have a suggestion that would
*** make this better, please fork the repo and create a pull request or simply open
*** an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
-->





<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/nemoryoliver/revenuecat-client">
    <img src="assets/images/app_icon.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">RevenueCat Client</h3>

  <p align="center">
    A 3rd Party RevenueCat Cross Platform Client made with Flutter! This app is not endorsed nor affiliated by RevenueCat. Logo & Trademarks belongs to RevenueCat.
    <br />
    <br />
    <a href="https://revenuecat.surge.sh">Web Client: https://revenuecat.surge.sh</a>
    ·
    <a href="https://github.com/nemoryoliver/revenuecat-client/releases">Download & Install for Android & MacOS</a>
    ·
    <a href="https://github.com/nemoryoliver/revenuecat-client/issues">Report Bug</a>
    ·
    <a href="https://github.com/nemoryoliver/revenuecat-client/issues">Request Feature</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
  * [Built With](#built-with)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Usage](#usage)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)
* [Acknowledgements](#acknowledgements)



<!-- ABOUT THE PROJECT -->
## About The Project

### MOCKED SCREENSHOT

[![RevenueCat Mobile App][screenshots-mobile]](https://github.com/nemoryoliver/revenuecat-client)
[![RevenueCat Desktop App][screenshots-desktop]](https://github.com/nemoryoliver/revenuecat-client)

We are very grateful that RevenueCat exists! It's now easier to integrate In-App Purchase features in our apps with minimal code and less complexity. Yes, you can use RevenueCat's Web Dashboard to see everything, but come on, an app is better on mobile. 

### Supported Platforms
- iOS
- Android
- Mac OS
- [Web](https://revenuecat.surge.sh)
- Windows (soon)

### Features
#### View Overview
- filter by Date (previous day & next day buttons + date picker)
- shows data per platform (iOS & Android)
- shows last purchase, renewal, and trial conversion dates
- RC Overview: Active Trials, Active Subscriptions, MRR, Revenue, Installs and Active Users in the last 28 days
#### View Transactions
- filter by Date (date picker)
- search by Transaction ID

### Built With
Google Flutter SDK
* [Flutter](https://flutter.dev)



<!-- GETTING STARTED -->
## Getting Started


### Prerequisites

* [Flutter SDK](https://flutter.dev)
* [Android SDK & Android Studio](https://developer.android.com/studio) for deployment to Android
* [XCode IDE](https://developer.apple.com/xcode/) for deployment to iOS/iPad/MacOS
* [VS Code IDE](https://code.visualstudio.com/) optional

### Installation

1. Obtain your RevenueCat Authorization Token
* fire up your development machine and open your favorite browser
* Go to RevenueCat's website and make sure you're logged in already
* Open the browser's Developer Console
* Go to Network Tab
* apply filter: api.revenuecat.com
* open any logged traffic (some may not include the token, so take your time hunting)
* Go to Headers Tab
* then find the token in the Request Headers section
* Copy and send it to your Test Device.
2. Clone the repo
```sh
git clone https://github.com/nemoryoliver/revenuecat-client.git
```
3. Switch Flutter Channel to dev or master
```
flutter channel dev
```
4. Enable desktop support
```
flutter config --enable-macos-desktop
```
5. Install packages dependencies
```
flutter pub get
```
6. Run
```
flutter run
```



<!-- USAGE EXAMPLES -->
## Usage


<!-- ROADMAP -->
## Roadmap

* Notifications
* Search Transactions with User ID & Email
* Charts for RC Premium Users
* Windows Support (if requested)
* Light Mode (if requested)

See the [open issues](https://github.com/nemoryoliver/revenuecat-client/issues) for a list of proposed features (and known issues).



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License
 
Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Oliver Martinez - [@nemoryoliver](https://twitter.com/nemoryoliver) - nemoryoliver@gmail.com

Project Link: [https://github.com/nemoryoliver/revenuecat-client](https://github.com/nemoryoliver/revenuecat-client)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* [RevenueCat](https://revenuecat.com)





<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/nemoryoliver/revenuecat-client.svg?style=flat-square
[contributors-url]: https://github.com/nemoryoliver/revenuecat-client/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/nemoryoliver/revenuecat-client.svg?style=flat-square
[forks-url]: https://github.com/nemoryoliver/revenuecat-client/network/members
[stars-shield]: https://img.shields.io/github/stars/nemoryoliver/revenuecat-client.svg?style=flat-square
[stars-url]: https://github.com/nemoryoliver/revenuecat-client/stargazers
[issues-shield]: https://img.shields.io/github/issues/nemoryoliver/revenuecat-client.svg?style=flat-square
[issues-url]: https://github.com/nemoryoliver/revenuecat-client/issues
[license-shield]: https://img.shields.io/github/license/nemoryoliver/revenuecat-client.svg?style=flat-square
[license-url]: https://github.com/nemoryoliver/revenuecat-client/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=flat-square&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/nemoryoliver
[screenshots-mobile]: images/screenshots_mobile.jpg
[screenshots-desktop]: images/screenshots_desktop.jpg
