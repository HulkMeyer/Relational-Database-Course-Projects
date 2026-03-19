# Number Guessing Game

A bash-based number guessing game with a PostgreSQL backend, completed as part of the [freeCodeCamp Relational Database Certification](https://www.freecodecamp.org/learn/relational-database/).

---

## Project Overview

This project generates a random number between 1 and 1000 for users to guess. It tracks players by username, stores their game history, and displays personal stats for returning players. All data is persisted in a PostgreSQL database.

---

## Database Schema

### `users` table
| Column | Type | Constraints |
|--------|------|-------------|
| user_id | SERIAL | PRIMARY KEY |
| username | VARCHAR(22) | UNIQUE, NOT NULL |
| games_played | INT | DEFAULT 0 |
| best_game | INT | |

### `games` table
| Column | Type | Constraints |
|--------|------|-------------|
| game_id | SERIAL | PRIMARY KEY |
| user_id | INT | FOREIGN KEY → users(user_id), NOT NULL |
| guesses | INT | NOT NULL |

---

## Files

- `number_guess.sh` — the main game script
- `number_guess.sql` — database dump for rebuilding the database

---

## How to Run

### Rebuild the database
```bash
psql -U postgres < number_guess.sql
```

### Run the game
```bash
chmod +x number_guess.sh
./number_guess.sh
```

---

## Example Gameplay

### First time user
```
Enter your username:
colt
Welcome, colt! It looks like this is your first time here.
Guess the secret number between 1 and 1000:
500
It's lower than that, guess again:
250
It's higher than that, guess again:
375
It's higher than that, guess again:
400
It's lower than that, guess again:
388
You guessed it in 5 tries. The secret number was 388. Nice job!
```

### Returning user
```
Enter your username:
colt
Welcome back, colt! You have played 3 games, and your best game took 5 guesses.
Guess the secret number between 1 and 1000:
```

### Invalid input
```
Guess the secret number between 1 and 1000:
abc
That is not an integer, guess again:
```

---

## How It Works

1. A random number between 1 and 1000 is generated when the script starts
2. The user is prompted for a username
3. If the username exists in the database, their stats are displayed
4. If the username is new, they are added to the database
5. The user guesses until they find the secret number
6. After winning, the game count and best game stats are updated in the database

---

## Git Commit Convention

Commits in this project follow the conventional commits format:
- `feat:` — new features
- `fix:` — bug fixes
- `chore:` — maintenance tasks
- `refactor:` — code restructuring
- `test:` — test additions or changes

---

## Certification

This project is part of the freeCodeCamp [Relational Database Certification](https://www.freecodecamp.org/learn/relational-database/), which covers PostgreSQL, Bash scripting, and Git.
