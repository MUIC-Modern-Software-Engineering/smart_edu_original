# Smart Edu

This README documents the steps necessary to get the Smart Edu application up and running.

## Ruby Version

- Ruby 3.4.1

## System Dependencies

- Rails 8.0.1
- PostgreSQL
- Node.js
- Bun

## Configuration

1. Clone the repository:
    ```sh
    git clone https://github.com/C0NS03L/smart_edu_original
    cd smart_edu_original
    ```

2. Run the setup scripts:
    ```sh
    bun setup
    ```

## Database Creation

1. Create and set up the database:
    ```sh
    bin/rails db:create
    bin/rails db:migrate
    ```

## Database Initialization

1. Seed the database with initial data:
    ```sh
    bin/rails db:seed
    ```

## How to Run the Test Suite

1. Run the tests:
    ```sh
    bin/rails test
    ```

## Deployment Instructions
