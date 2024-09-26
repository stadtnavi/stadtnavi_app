
# In-App Messaging Configuration Guide for Clients

This guide will walk you through the process of setting up and configuring In-App Messaging from the Firebase Console to your app using the stadtnavi-core package. In-App Messaging allows you to engage with users while they are actively using your app by displaying targeted messages or promotions.

---

## 1. Introduction
Firebase In-App Messaging helps you communicate with your app users while they are interacting with your app. You can display messages in various formats, such as banners, modals, or popups, depending on your campaign needs.

This guide explains how to create, configure, and manage in-app messages using the Firebase Console.

---

## 2. Getting Started with Firebase
To get started with Firebase In-App Messaging, ensure you have access to the **Firebase Console** for your project. Here are the basic steps:

1. **Open Firebase Console:**
   - Visit [Firebase Console](https://console.firebase.google.com/).
   - Log in with your credentials.

2. **Select Your Project:**
   - Choose the project related to your app from the list of projects.
   - If you don't have a project, please contact your technical team to assist with creating one.

---

## 3. Creating an In-App Messaging Campaign

### Step 1: Open the In-App Messaging Section
1. From the left-hand menu, click on **Engage** and then select **In-App Messaging**.
2. Click the **Create Campaign** button to start setting up a new in-app message.

### Step 2: Choose a Message Format
   ![Choose Message Format](./images/in-app-messaging/message-format.png)
   Firebase In-App Messaging offers several formats to choose from:
   - **Banner**: A small banner that appears at the top or bottom of the screen.
   - **Modal**: A larger, centered message that interrupts the user’s activity.
   - **Image**: A full-screen image with optional text.
   - **Card**: A small message that appears as a card.

Select the format that best suits your campaign's needs.

### Step 3: Configure the Message Content
   ![Configure Message Content](./images/in-app-messaging/configure-message.png)
   In the **Message Content** section, provide the following details:
   
   - **Title (Optional):** The main heading of your message.
   - **Body (Required):** The message you want to communicate. Keep it clear and concise.
   - **Button Text (Optional):** Label for the action button, such as *Learn More* or *Get Started*.
   - **Image (Optional):** You can include an image to make the message more engaging.

You can preview the message to see how it will appear to users.

---

## 4. Define Targeting and Triggers

### Step 1: Target Your Audience
   ![Target Audience](./images/in-app-messaging/target-audience.png)
   Define the audience for your message. You can target users based on:
   - **App Version**: Show the message only to users of a specific version of your app.
   - **User Properties**: Target users based on demographics, app usage, or other custom criteria.

### Step 2: Set Triggers
   ![Set Triggers](./images/in-app-messaging/set-triggers.png)
   In-App Messaging allows you to display messages based on specific triggers. These include:
   - **App Open**: Display the message when users open the app.
   - **Custom Events**: Show the message after a user completes a specific action, such as making a purchase or viewing a product.
   - **User Engagement**: Trigger messages when users reach a certain level of engagement within the app.

---

## 5. Scheduling and Frequency Settings

### Step 1: Schedule Your Campaign
   ![Schedule Campaign](./images/in-app-messaging/schedule-campaign.png)
   You can control when your message will appear by setting a start and end date. This allows you to run time-sensitive campaigns, such as promotions or announcements.

### Step 2: Frequency Capping
   ![Frequency Capping](./images/in-app-messaging/frequency-capping.png)
   Use **Frequency Capping** to control how often a user sees the message. You can choose to display the message:
   - **Once per session**
   - **Once per day**
   - **Multiple times**

---

## 6. Reviewing and Publishing the Campaign

### Step 1: Review Your Campaign
   ![Review Campaign](./images/in-app-messaging/review-campaign.png)
   Before publishing, you can review the details of your campaign, including message content, targeting, triggers, and scheduling.

### Step 2: Publish Your Campaign
   Once you’ve confirmed the settings:
   - Click **Publish** to start the campaign.
   - If you scheduled the campaign for a future date, it will automatically start at the scheduled time.

---

## 7. Monitoring Campaign Performance
   ![Monitor Performance](./images/in-app-messaging/monitor-performance.png)
   After your campaign is live, you can monitor its performance in the **In-App Messaging** section. Firebase provides metrics such as:
   - **Impressions**: How many users have seen your message.
   - **Click-through Rate**: How many users interacted with the message.

Use these insights to adjust your campaigns as needed.

---

## 8. Understanding In-App Message Behavior

In-App Messages behave differently depending on the app's state:

1. **When the app is open:** 
   - The in-app message will appear based on the triggers you’ve set (e.g., app open, custom event).

2. **When the app is closed or in the background:** 
   - In-App Messaging will not trigger messages when the app is not in use. The message will appear when the user next opens the app or triggers a defined event.

---

This guide covers the essential steps to set up and manage In-App Messaging campaigns in Firebase. Be sure to replace the image placeholders with actual screenshots for better understanding!
