# DocuMind

**AI-powered document chat with RAG (Retrieval-Augmented Generation)**

Upload PDFs, ask questions, and get intelligent answers grounded in your documents.

## Features

- 📄 **PDF Upload** — Ingest documents for AI-powered analysis
- 💬 **Smart Chat** — Ask questions and get answers with source citations
- 📚 **Document Management** — View, manage, and delete ingested documents
- 🌐 **Cross-Platform** — Works on Web, Android, iOS, macOS, Linux, Windows
- 🎨 **Modern UI** — Material 3 with dark mode, animations, and glassmorphism

## Tech Stack

- **Framework:** Flutter 3.x
- **State Management:** Riverpod
- **Navigation:** go_router
- **Networking:** Dio
- **Architecture:** Clean Architecture (Feature-first, Domain/Data/Presentation layers)

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run on your preferred platform
flutter run -d chrome    # Web
flutter run -d windows   # Windows
flutter run -d macos     # macOS
```

## Project Structure

```
lib/
├── core/           # Shared infrastructure (theme, network, router, errors)
├── features/       # Feature modules (chat, documents, ingest, home)
├── injection.dart  # (removed — using Riverpod providers)
└── main.dart       # Entry point with ProviderScope
```

## API

DocuMind connects to a RAG Chatbot API with these endpoints:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| POST | `/ingest` | Upload PDF for processing |
| GET | `/documents` | List ingested documents |
| DELETE | `/documents/{filename}` | Delete a document |
| POST | `/chat` | Send query, get AI response |
