# Study Buddy - AI Assistant Creation App

Study Buddy is an AI assistant creation app that allows you to design and customize your personal assistant's personality to cater to your specific needs. While it's particularly useful as a study companion, it can serve a wide range of applications.

## Features

### In-Built Notes and Calendar

Study Buddy comes equipped with an integrated notes feature and a calendar function. Users can add content to their notes and calendar, with the added convenience of having their assistant access all the resources created.

### Automated Study Plans

Utilize your AI assistant to generate personalized study plans and seamlessly integrate them into your calendar. This automation streamlines your study routine.

### Note Summarization and Quizzes

Your assistant can access your notes, assist you in summarizing key points, and even quiz you in preparation for tests. It's a valuable tool for reinforcing your understanding of the material.

## Technology

Study Buddy harnesses the power of OpenAI's GPT models to provide intelligent and interactive AI assistance.

## Project Setup

### Server Setup

Repository: [Study Buddy Server](https://github.com/Abu-muhab/gpt-study-buddy/tree/main/gpt_study_buddy_server)

**Requirements:** Docker, Docker Compose

1. Set up the server environment by copying the contents of `.env.example`:

   ```
   OPENAI_API_KEY=your_api_key
   DB_URL="mongodb://<MONGO_INITDB_ROOT_USERNAME>:<MONGO_INITDB_ROOT_PASSWORD>@mongo:27017/?authMechanism=DEFAULT"
   MONGO_INITDB_ROOT_USERNAME=username
   MONGO_INITDB_ROOT_PASSWORD=password
   ME_CONFIG_MONGODB_PORT=27017
   ME_CONFIG_MONGODB_ADMINUSERNAME=<MONGO_INITDB_ROOT_USERNAME>
   ME_CONFIG_MONGODB_ADMINPASSWORD=<MONGO_INITDB_ROOT_PASSWORD>
   ```

   Replace the placeholders with your actual values.

2. Run the project by executing the command:

   ```
   make dev
   ```

### App Setup

Repository: [Study Buddy App](https://github.com/Abu-muhab/gpt-study-buddy/tree/main/gpt_study_buddy_app)

**Requirements:** Flutter SDK

1. Configure the app environment by copying the contents of `.env.example`:

   ```
   SERVER_URL=http://localhost:8000
   ```

   Replace the placeholder with your specific server URL.

2. To run the app, use the following command:

   ```
   flutter run
   ```
