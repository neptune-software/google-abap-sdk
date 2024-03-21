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
Before using this library you need to install the [Cloud ABAP SDK version 1.5](https://cloud.google.com/solutions/sap/docs/abap-sdk/latest/all-guides). It comes with a very detailed install and setup guide so please follow that upfront. After you install the corresponding transport (at least the "Token" approach is required. The additional OAuth transport can be installed to but is not required)

## Artifacts
This package comes with a class (ZCL_GOOG_FCM_V1) that implements the calling of the new HTTP v1 API via the following public methods.
| Method                       | Purpose                                                                    |
| ---------------------------- | -------------------------------------------------------------------------- |
| MESSAGES_SEND                | Send a single message via a topic or a device token                        |
| MESSAGES_SEND_EACH           | Send many different messages to many different topics or device tokens     |
| MESSAGES_SEND_EACH_FOR_MC    | Send the same message to many device tokens                                |

In addition to that, there is also a demo program (ZGOOG_R_DEMO_FIREBASE) that allows you to easily test if the Cloud Messaging works correctly.

![DemoScreenhot](./assets/doc_images/demo_program.png)

![iOS Push](./assets/doc_images/ios_push.png)

![iOS Push App](./assets/doc_images/ios_push_app.png)