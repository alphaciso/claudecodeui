# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Claude Code UI is a web-based interface for the Claude Code CLI, providing a responsive desktop and mobile UI for AI-assisted coding. The project uses a React frontend with a Node.js/Express backend that interfaces with the Claude Code CLI.

## Common Development Commands

```bash
# Install dependencies (uses npm)
npm install

# Development mode (runs both frontend and backend concurrently)
npm run dev

# Production build
npm run build

# Start production server (builds and serves)
npm start

# Run frontend only (Vite dev server on port 3001)
npm run client

# Run backend only (Express server on port 3000)
npm run server
```

## Architecture Overview

### Backend (Node.js + Express)
- **Entry Point**: `server/index.js` - Main Express server with WebSocket support
- **Claude CLI Integration**: `server/claude-cli.js` - Spawns and manages Claude CLI processes
- **Project Management**: `server/projects.js` - Handles Claude project discovery and session management
- **Database**: `server/database/db.js` - SQLite database for authentication
- **Routes**:
  - `server/routes/auth.js` - Authentication endpoints
  - `server/routes/git.js` - Git operations
  - `server/routes/mcp.js` - MCP (Model Context Protocol) support
- **Middleware**: `server/middleware/auth.js` - JWT authentication

### Frontend (React + Vite)
- **Entry Point**: `src/App.jsx` - Main app component with session protection system
- **Key Components**:
  - `src/components/ChatInterface.jsx` - Main chat UI
  - `src/components/Shell.jsx` - Terminal integration using xterm.js
  - `src/components/FileTree.jsx` - File explorer
  - `src/components/GitPanel.jsx` - Git operations UI
  - `src/components/CodeEditor.jsx` - Code editor using CodeMirror
  - `src/components/TodoList.jsx` - Task management
- **Contexts**:
  - `src/contexts/AuthContext.jsx` - Authentication state
  - `src/contexts/ThemeContext.jsx` - Dark/light theme
- **Utils**:
  - `src/utils/websocket.js` - WebSocket client for real-time communication
  - `src/utils/api.js` - API client wrapper
  - `src/utils/whisper.js` - Voice recording integration

### Key Features

1. **Session Protection System**: Prevents automatic project updates during active conversations (see comments in App.jsx)
2. **WebSocket Communication**: Real-time bidirectional communication between frontend and Claude CLI
3. **Tool Permission Management**: Frontend controls which Claude tools are enabled/disabled
4. **Multi-Project Support**: Discovers and manages multiple Claude projects from `~/.claude/projects/`
5. **Authentication**: JWT-based auth with SQLite backend

### Environment Configuration

Create a `.env` file with:
```
PORT=3000          # Backend server port
VITE_PORT=3001     # Frontend dev server port
API_KEY=your_key   # Optional API key for setup
```

### Important Notes

- The backend spawns Claude CLI processes using node-pty for proper terminal emulation
- Project metadata is stored in `~/.claude/projects/` following Claude CLI conventions
- The UI supports both temporary session IDs (for new chats) and persistent session IDs
- File operations are restricted to project directories for security
- WebSocket connections handle real-time chat streaming and project updates