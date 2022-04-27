# GoGoal
## Overview

GoGoal is an innovative app that helps people track, achieve and share their goals. Featured by an interactive community, users can connect by the same subscribed topics and get motivated by each other's progress and achievements.

## App demo

[Project presentation](https://docs.google.com/presentation/d/1SRsgQ4quoIOuaUlc-RLGU8klx2Eesj9jjpp4KJIZx5U/edit?usp=sharing)

[Project poster](https://drive.google.com/file/d/1HOKqadc8QaHQm11j3liEKsnSTrIhLoSs/view?usp=sharing)

[Wireframes and prototype](https://www.figma.com/file/BJBHb090zgX1U1znavqm7e/GoGoal!?node-id=0%3A1)

## App setup

Please take the following steps to deploy and run your own app:

1. Install Xcode (recommend version 12.x)

2. Git clone this repository to your local machine

3. Create a new Firebase project on GCP

4. Add an iOS app in the Firebase project

   + Designate your own bundle ID
   + Download the config file named `GoogleService-Info.plist`
   + Replace the original config file under `/GoGoal` directory

5. Enable `Email/Password` authentication in the Firebase project

6. Enable `Firestore Database` and `Storage` in the Firebase project (update their default security rules if necessary)

7. Add composite indexes for the Firestore database as below:

   | Collection ID | Fields indexed                                               | Query scope | Status  |
   | :------------ | :----------------------------------------------------------- | :---------- | :------ |
   | posts_dev     | topicId Ascending, createDate Descending                     | Collection  | Enabled |
   | goals_dev     | isCompleted Ascending, topicId Ascending, lastUpdateDate Descending | Collection  | Enabled |
   | posts_prod    | topicId Ascending, createDate Descending                     | Collection  | Enabled |
   | goals_prod    | isCompleted Ascending, topicId Ascending, lastUpdateDate Descending | Collection  | Enabled |

8. Run `pod install` to install some CocoaPods dependencies. Use `arch -x86_64 pod install` instead if you are using a MacBook with M1 chips.

9. To run the app, choose a simulator or a device to build the entire project. We provided two environments: `DEV` (default) and `PROD`. You can change it by editing the value in `Info.plist`.

10. To run the test suite, switch to the Test navigator. It always uses the `DEV` environment.

Now you are ready to go!
