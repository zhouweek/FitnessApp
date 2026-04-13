# Fitness App

A fitness tracking application with Flutter frontend and FastAPI backend.

## Features

- User authentication and profile management
- Workout tracking and scheduling
- Fitness goals setting and monitoring
- Daily activity targets
- Progress visualization
- API integration with backend services

## Project Structure

```
FitnessApp/
├── lib/             # Flutter frontend code
├── android/         # Android build configuration
├── assets/          # Images, icons, and fonts
├── backend/         # FastAPI backend code
└── dev_lib/         # Development libraries
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Python 3.11+
- Android Studio (for Android development)

### Frontend Setup

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Backend Setup

```bash
# Navigate to backend directory
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows: venv\Scripts\activate
# Linux/Mac: source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the backend server
uvicorn app.main:app --reload
```

## API Documentation

Once the backend server is running, you can access the API documentation at:
- `http://localhost:8000/api/v1/docs`

## Deployment

For deployment instructions, please refer to the `backend/DEPLOYMENT.md` file.

## License

This project is licensed under the MIT License.