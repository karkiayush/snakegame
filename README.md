# Snake Game – Flutter App

A fun and interactive Snake Game built using Flutter, powered by Supabase for user authentication and score storage, and Provider for state management.

---

## Features

- User Authentication (Signup/Login) via Supabase
- Profile Image Upload on Signup
- Grid-based Snake Movement
- Dynamic Food Spawning
- Score Increments as snake eats food
- Game Over Conditions
    - Snake hits wall
    - Snake hits itself
- Pause/Resume Game
- Directional Controls using on-screen arrow buttons
- Game Over Dialog with Score + Play Again / Exit options
- Score Storage to Supabase
- Session Persistence (user stays logged in after app restart)
- Clean and responsive UI using Flutter best practices

---

## Tech Stack

| Layer            | Technology    |
|------------------|---------------|
| UI               | Flutter       |
| Auth & DB        | Supabase      |
| State Management | Provider      |
| Media Picker     | image_picker  |

---

## Authentication & Storage

- Auth handled using Supabase's `auth` module.
- On signup, users can upload a profile image to Supabase Storage.
- Scores are stored in a `scores` table with:
    - `user_id`: UUID of user
    - `score`: Game score
    - `played_at`: Timestamp