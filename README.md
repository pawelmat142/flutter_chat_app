# Flutter chat app

Just another simple chat application made to learn next technology. </br>

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Packages](#packages)
* [Setup](#setup)
* [Commits](#commits)

## General info

This project is meant to be an example of building my first Flutter application step by step. </br>
Each commit will be a documentation of expanding the application with next feature. </br>

## Technologies
Project is created with:
* Flutter 3
* Dart 2
* Firebase (Firestore, FireAuth, storage)

## Packages
Flutter/Dart packages used to build this project:
* reactive_forms
* get_it
* firebase_core
* firebase_auth
* cloud_firestore
* hive
* hive_flutter
* navigation_history_observer
* provider
* intl
* auto_size_text
* firebase_storage
* cross_file
* file_picker
* image_picker
* path_provider
* rsa_encrypt
* pointycastle
* flutter_timezone
* flutter_fgbg
* device_info_plus
* awesome_notifications

## Setup

Ready .apk file may be installed on any Android device. You can download it [here](https://drive.google.com/drive/folders/1OpUzcEuO5Mr3DBd4977ORzwrv-EduInr?hl=pl)
<br />
or
<br />
To run this project locally:
* You need to have Android Studio with Android Virtual Device and Flutter
* You also need to have your Firebase account - add new project
* Configure Firebase: open Project Overview website > add app > Flutter > follow the steps
* Add Firestore Database, get into Rules and paste content of firestore_security_rules.js there
* Add Storage, get into Rules and paste content of firebase_storage_security_rules.js there
* open Android Studio
* File > New > Project from Version Control
* paste url:
  ```https://github.com/pawelmat142/flutter_chat_app.git```
* press get dependencies
* start emulator and run app

## Commits

### [000] initial commit - blank Flutter app
As blank app as possible Flutter application.
</br></br>

### [001] routing and navigation
Added screens directory, two Scaffold screens as stateless widgets and routing in main file.
</br></br>

### [002] custom button widget - styles constants
Added styles files with constant values and custom button widget with configurable styles but default set by constants.
</br></br>

### [003] login form screen - reactive form
Added reactive form package, custom text field widget, login form screen.
</br>`flutter pub add reactive_forms`
</br></br>

### [004] basic reactive form validators
Added basic reactive form validators and error messages to text fields.
</br></br>

### [005] animation, stream, stateful controllable button widget
Added animation what changes color, used in controllable stateful widget with stream usage example.
</br></br>

### [006] reactive form submit made with controllable button widget
Submit button added to reactive form what automatically activates / deactivates when form is valid / invalid.
</br></br>

### [007] register page
Register page, navigate button with new color and form submit methods added.
</br></br>

### [008] custom form validation - must match
Added must match custom validation to register form and error messages also.
</br></br>

### [009] getIt - dependency injection package
Authentication service template as dependency injection example made with getIt package.
</br>`flutter pub add get_it`
</br></br>

### [010] alert / popup, navigation service
Implementation reusable and configurable UI popup component and navigation service what provides current BuildContext at any place in the application.</br>
Popup used in registration / login methods, injected as lazy singleton by getIt.
</br></br>

### [011] firebase authentication - configuration and implementation
Firebase core initialization:
</br>`flutter pub add firebase_core`
</br>Firebase authentication initialization:
</br>`flutter pub add firebase_auth`
</br></br>

### [012] authentication error handling and spinner
Spinner UI component implemented what shows that something is loading. </br>
Logout option, log / logout navigation and error handling with popups.
</br></br>

### [013] user data model
basic user data model is prepared
</br> + little fix with form_styles and validators files moving
</br></br>

### [014] -||- fix
little fix with form_styles and validators files moving
</br></br>

### [015] -||- still fix moving files fix

### [016] firestore implementation - user service
cloud firestore example implementation
</br>`flutter pub add cloud_firestore`
</br> user service prepared, test screen to test first firestore requests
</br></br>

### [017] firestore - security rules
basic firebase security rules written
</br> little refactor what makes nickname equals user document id so nickname is unique
</br>

### [018] firestore - security rules - continued
private sub collection created inside user what makes user modifiable only for owner
</br> additional rules added
</br> that makes user document modifiable only for owner
</br>

### [019] user service develop
findByNickname and delete methods

### [020] user and auth services integration
authentication system completed

### [021] contacts screen view prepared
contacts screen view, basic contact tile component

### [022] contact search option
contact finding UI process

### [023] notification data model
basic notification data model is prepared
</br> send invitation option
</br> basic notification security rules

### [024] Stream builder - notifications screen
notifications screen,
</br> notifications service,
</br> stream builder with notification tile implemented

### [025] State services refactor
services what keeps some user state refactored with login/logout triggering
notifications screen refactor - no more stream builder
little screens refactors

### [026] Notification tile
Made with stream listener notification tile shows notifications number

### [027] Notification flushbar
`flutter pub add another_flushbar`
</br> flushbar notifications implementation

### [028] Invitation view
notification view - mark as read when open

### [029] Stream broadcast - notifications screen
multiple stream usage example with widget building and storage listening
</br> Refactor notifications service and screen to make screen reactive

### [030] Notification flushbar tap
navigate to notification view if tap flushbar

### [031] Notifications screen sort
unread notifications are on the top of notifications screen

### [032] Self notification
sending invitation triggers invitation self notification what is read by default

### [033] Widget class extension example
refactor notification view and create invitation view as extension

### [034] Factory project pattern
Invitation self notification view with factory pattern implemented

### [035] UX improvements and invitation reject feature
reject / cancel invitation
</br> flushbar for invitation sent / deleted
</br> navigation to notifications from flushbar

### [036] Delete all notifications feature
notifications ale deleted also for senders

### [037] Delete account feature
delete account includes delete user and PRIVATE docs
</br> includes also delete all notifications also for senders
</br> adds record to DELETED_ACCOUNTS collection to show info about deleted account
</br> fireAuth account needs to be deleted manually

### [038] Contacts service
contacts service prepared and registered

### [039] Notifications refactor
notifications has sender and receiver properties now
new notification type - invitation acceptance

### [040] Invitation acceptance - receiver
Contacts as one document subcollection of User - list of nicknames
</br> security rules for CONTACTS subcollection - only owner
</br>receiver accept invitation = add to contacts sender nickname
</br>invitation acceptance view added

### [041] Invitation acceptance - sender
sender get invitationAcceptance = add to contacts receiver nickname - only if not read
</br> invitation acceptance flushbar

### [042] Contacts screen and service develop
reactive contacts screen
</br> service stores each user subscription
</br> any change sets state to contacts screen

### [043] Contact tile develop
contact tile shows if user is logged or not
</br> contact view added as data view extension
</br> contact tiles sorting - logged first

### [044] Delete contact feature
new notification type - contactDeletedNotification - has no view
</br> is sent to receiver when sender deletes contact
</br> and automatically deletes contact for receiver if logged or when login

### [045] Sww popup, delete all contacts

### [046] Navigator improvements and delete single notification feature

### [047] small todos cleanup

### [048] Invitation first message

## feature/conversation

### [049] conversation view
prepared as view navigated from contacts screen by tap on contact tile

### [050] Message data model
conversation service register
</br>conversation view with listener
</br>basic security rules

### [051] Hive - local storage - setup
`flutter pub add hive`
</br>`flutter remove add hive_flutter`
</br>`flutter pub add hive_generator --dev`
</br>`dart pub add build_runner --dev`

### [052] Hive - local storage - type register
message data model refactor to make it hive DAO
</br>`flutter packages pub run build_runner build`
</br> this command generates adapter file .g.dart

### [053] Hive - local storage - usage
when login for each contact conversation box is opened/created
</br> example adding to box = send message
</br> conversation view build with valueListenableBuilder

### [054] Message receiving
listen for coming messages - Messages collection
</br>received message is deleted straight away and add to Hive

### [055] contactsEventListener + refactor
open hive conversation when add new contact
</br> login / logout services debug + refactor

### [056] todo bug fixed

### [057] todos

### [058] Popup menu and clear conversation feature

### [059] delete contact = delete conversation = contactsEvent

### [060] todos
notification remove bug
</br> delete account event should delete all hive data

### [061] Sending conversationClearNotification

### [062] Receiving conversationClearNotification

### [063] conversationClearNotification = event shown on conversation view

### [064] first message shown in conversation

## feature/error_handling

### [065] First step
LogProcess class prepared
</br> DeleteAccount as extension of LogProcess
</br> new collection `log` with security rule

### [066] Prepared firestore batch for delete account

### [067] Count batch writes

### [068] Batch overload solved

### [069] Delete Hive data when delete account

### [070] DeleteAccountProcess - reset services

### [071] LogService
Global LogProcess
example on login process

### [072] Finish branch

## feature/data_state_object

### [073] DataStageObject preparations

## feature/security_rules_refactor

### [074] PpUser - change collection name

### [075] PpUser - signature field
PpUser model - add signature field what is PpUser docId now

### [076] PpUser - PpUser document id change to

### [077] Update security rules
access to CONTACTS, NOTIFICATIONS, Messages

### [078] ContactNicknames refactor 1
invitation send, delete, reject, remove notification updated

### [079] ContactNicknames refactor 2
conversation, contact view, accept invitation

### [080] ContactNicknames refactor 3
delete contact, send message update

### [081] ContactNicknames refactored to ContactUids

### [082] BUGs
messages not saving after relogin
</br> logout bug

### [083] Allow send messages if invitation is accepted

### [084] PpMessage refactor
sending and resolving by uid - not nickname

### [085] First message in conversation

### [086] BUGs
clear conversation
</br> logout, delete account process
</br> avoid multiple contact uids

## feature/chat_features

### [087] Conversation clear feature
by ConversationMock feature
</br> little files refactor

### [088] Conversation lock feature

## feature/provider_refactor

### [089] Initialize provider, Me refactor

### [090] ContactUids refactor

### [091] Contacts refactor

### [092] Refactoring states
Contacts, ContactUids, Me states refactored

### [093] Notifications refactored

### [094] Conversations refactored
directories paths refactored

### [095] Directories refactor

### [096] Make screen widgets const

## chat_features

### [097] DateFormatter - AnimatedContainer
`flutter pub add intl`
</br> show time on tap message bubble

### [098] Sort and show time of messages

### [099] Conversation settings view navigation

### [100] Conversation settings data model - hive

### [101] Conversation settings view - form

### [102] Conversation settings service

### [103] Set read timestamp to PpMessage on ConversationView

### [104] timeToLive set to sent messages

### [105] login/logout, deleteContact fix

### [106] login/logout, deleteContact fix..

### [107] login/logout, deleteContact fix..

### [108] SnackBar instead of most notifications

### [109] MessageCleaner implemented

### [110] ContactTile shows number of unread messages
`flutter pub add auto_size_text`

### [111] Little fixes

### [112] MessageCleaner works with unread messages number on contactTile

## feature/avatars

### [113] Random avatars preparations

### [114] Random avatars preparations

### [115] Little fix

### [116] Data model connected to PpUser model

### [117] UserView refactor

### [118] EditAvatarView

### [118] Edit avatar ready

### [119] Firebase storage initialization
`flutter pub add firebase_storage`
</br>`flutter pub add cross_file`
</br>`flutter pub add file_picker`

### [120] Uploading image feature

### [121] Directories refactor

### [122] FilePicker changed to ImagePicker
`flutter pub add image_picker`

### [123] Avatar images stored in device and it's path in Hive
`flutter pub add image_picker`
</br> AvatarHiveImage model
</br> `flutter pub run build_runner build --delete-conflicting-outputs`
</br> AvatarWidget refactored - auto detect if image in device(Hive)
</br> if not download one and store in Hive/device

### [124] Delete avatar feature

### [125] little fixes

### [126] more little fixes

### [127] ContactScreen refactored to be 'HomeScreen'

### [128] Avatars as Hero animations

### [129] EditAvatarView
color selection refactored to horizontal ListView

### [130] Little fixes

### [131] Prevent double instantiate of Conversation
MessageCleaner instance moved to Conversation object
</br> MessageCleaner disposed when contact deleted

### [132] Prevent flushbar if not needed

### [133] little fix - first test release ready flutterVersionCode=1

## feature/encrypt

### [134] service and hive data model object prepared
`flutter pub add pointycastle`
`flutter pub add rsa_encrypt`

### [135] Encrypt/decrypt messages
PpUser data model refactor - stores public key
</br> send messages refactor
</br> receive messages refactor

### [136] Generates new key pair
if not exists or doesn't match (new device)

### [137] Filter empty string in conversation
and spinner bug fixed

### [138] Bugfixing
delete image in storage on delete account
</br> lock mock fixed to be removable only for sender
</br> UserView as constant

### [139] Turn on logs on non debug mode
i want to receive online logs to firebase for testing

## feature/notifications

### [140] Notifications installation
`flutter pub add flutter_local_notifications`
</br> `flutter pub add device_info_plus`
</br> `flutter pub add flutter_timezone`

### [141] BUG multiple ContactsScreen on stack - fixed

### [143] BUG navigation with arguments gives route name = null - fixed

### [144] Notifications on coming messages / invitations

### [145] Navigation by notification payload
`flutter pub add flutter_fgbg`

### [146] PpNotification data model refactored to pass AvatarModel object

### [147] ConversationSettingsView refactored

### [148] Icon, app name changed
`appicon.co` - generate folder from one square png
</br> android/app/src/main/res - replace all mipmap folders
</br> iod/Runner - replace whole Assets.xcassets folder

### [149] AwesomeNotification instead of flutter_local_notifications
`flutter pub add awesome_notifications`
</br>refactored

### [150] payload navigation and preventing refactored

### [151] Dismiss notification on open conversation

### [152] Badges

## last_fixes

### [153] On tap MessageBubble show duration to expire

### [154] Delete account data from device feature
