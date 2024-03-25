# @neptune-software/google-abap-sdk

## Introduction
This is an additional integration scenario for the amazing Google ABAP SDK Library.
The main purpose of this library is to allow sending Firebase Push Notifications (aka Firebase Cloud Messaging) via the new HTTP v1 API (https://fcm.googleapis.com/v1/projects/*myproject-b5ae1*/messages:send) as the legacy FCM API (https://fcm.googleapis.com/fcm/send) was deprecated on June 20, 2023, and will be removed in June 2024. You find more information about the deprecation and migration steps [here](https://firebase.google.com/docs/cloud-messaging/migrate-v1).
The biggest challenge for the new API is that the authentication takes place through short-lived OAuth access tokens that need to be obtained before sending the actual request. The main ABAP Cloud Library already has all implementation for the correct handling of tokens in place that's why we choose to have the main Google Cloud ABAP SDK as a foundation for this additional functionality.

So please make sure you **FIRST INSTALL AND SETUP THE GOOGLE CLOUD ABAP SDK IN VERSION 1.5** (see [Prerequisites](#Prerequisites)) before using this package because you would get syntax errors otherwise. 

## Background
The Neptune DXP allows you to create Mobile Clients both for Android and iOS via the Cordova framework. Our solution offers an easy way to integrate Firebase Cloud Messaging (Push Notifications via Firebase) into your Mobile Clients by configuring a few parameters in our Cockpit. Our Neptune DXP SAP Edition is an ABAP Addon that comes with the Function Module called /NEPTUNE/PUSH_FIREBASE. It allows you to send push notifications to the corresponding Mobile Clients. However, since this function module is using the legacy FCM API, this new repository leveraging the well-established Google Cloud ABAP SDK is the easy-to-use successor of the /NEPTUNE/PUSH_FIREBASE function module.

In addition to the Neptune DXP integration, you can also use this library for general-purpose Firebase Cloud Messaging scenarios outside a Neptune DXP use case.

## Prerequisites
Before using this library you need to install the [Cloud ABAP SDK version 1.5](https://cloud.google.com/solutions/sap/docs/abap-sdk/latest/all-guides). It comes with a very detailed install and setup guide so please follow that upfront. After you install the corresponding transport (at least the "Token" approach is required. The additional OAuth transport can be installed but is not required) you need to set up the general authentication settings that are mentioned in the documentation that will then later be used for this FCM library.

## Artifacts
This package comes with a class (ZCL_GOOG_FCM_V1) that implements the calling of the new HTTP v1 API via the following public methods.
| Method                       | Purpose                                                                    |
| ---------------------------- | -------------------------------------------------------------------------- |
| MESSAGES_SEND                | Send a single message via a topic or a device token                        |
| MESSAGES_SEND_EACH           | Send many different messages to many different topics or device tokens     |
| MESSAGES_SEND_EACH_FOR_MC    | Send the same message to many device tokens                                |

In addition to that, there is also a demo program (ZGOOG_R_DEMO_FIREBASE) that allows you to easily test if the Cloud Messaging works correctly.

## Tests
This library has been created and tested with the following Software Versions.
* Neptune DXP SAP Edition v23.10.0004
* cordova-ios@7.0.1
* cordova-android@11.0.0
* @havesource/cordova-plugin-push@4.0.0

The actual mobile clients have been created via the Neptune Mobile Build Service.

![DemoScreenhot](./assets/doc_images/demo_program.png)

![iOS Push](./assets/doc_images/ios_push.png)

![iOS Push App](./assets/doc_images/ios_push_app.png)

## Setup for Firebase Cloud Messaging
The general setup for the Google Cloud ABAP SDK needs to be followed to be able to use this repository.
There are many different options to perform the authentication against the Google Cloud Platform. In our test cases, we were using the approach via:
[Authenticate using JSON Web Tokens (JWT)](https://cloud.google.com/solutions/sap/docs/abap-sdk/latest/authentication#externally_hosted_use_token).
When setting up Firebase cloud messaging in the Firebase console you will already get a service account generated for you. You can navigate to the service account from the Firebase console in the settings overview:
![Firebase Console Service Accounts](./assets/doc_images/firebase-console-service-accounts.png)
The auto-generated service account will have a private key that is of type JSON as this is the recommended key type by Google. For our setup, we however required a p12 file to be able to put that into STRUST. That's why we needed to generate an additional Key for the generated Service account in the Google Cloud console (which you can navigate to from the Firebase service account settings).
![Google Cloud Console Service Account](./assets/doc_images/google-cloud-console-service-account.png)

![Google Cloud Console Service Account Key Overview](./assets/doc_images/google-cloud-console-service-account-key-overview.png)

![Google Cloud Console Service Account Key Create P12](./assets/doc_images//google-cloud-console-service-account-key-create-p12.png)

The rest of the setup mentioned in the general Authentication step for the Google Cloud ABAP SDK can then be followed with that P12 file:

https://cloud.google.com/solutions/sap/docs/abap-sdk/latest/authentication#jwt-create-p12-key

https://cloud.google.com/solutions/sap/docs/abap-sdk/latest/authentication#jwt-import-service-account-key-strust


## Sample Configuration 
Below you find the setup that we used for setting up Firebase cloud messaging from an SAP configuration perspective. The Client Key Identifier can freely be chosen (in our case we used **FIREBASE**). When instantiating the class `zcl_goog_fcm_v1` you need to provide the name of the client key so the framework can pick up all required settings for the communication against the Google Cloud services.

### STRUST PSE File
We downloaded the p12 file from the service account. Our SAP Basis administrator converted the p12 file with the `sapgenpse` command line tool to a pse file that we then were able to import into STRUST in the newly created note (part of the setup).
![STRUST PSE Setup](./assets/doc_images/strust-pse-setup.png)

### Configure Client Key
![SPRO Client Key Setup](./assets/doc_images/spro-google-client-key-setup.png)

### Configure Service Mapping
![SPRO Service Mapping Setup](./assets/doc_images/spro-google-service-mapping.png)

### Configure Parameters
![SPRO Parameter Setup](./assets/doc_images/spro-google-parameters.png)