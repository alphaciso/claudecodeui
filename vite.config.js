import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig(({ command, mode }) => {
  // Load env file based on `mode` in the current working directory.
  const env = loadEnv(mode, process.cwd(), '')
  
  
  return {
    plugins: [react()],
    server: {
      port: parseInt(env.VITE_PORT) || 3001,
      host: true, // Allow external connections
      allowedHosts: [
        'localhost',
        '127.0.0.1',
        '4090d6dd0154.ngrok.app', // Add the ngrok host
        '.ngrok.app', // Allow any ngrok subdomain
        '.ngrok.io',   // Allow legacy ngrok domains
        'dev.extensionauditor.com' // Add the custom domain
      ],
      proxy: {
        '/api': `http://localhost:${env.PORT || 3000}`,
        '/ws': {
          target: `ws://localhost:${env.PORT || 3000}`,
          ws: true
        },
        '/shell': {
          target: `ws://localhost:${env.PORT || 3000}`,
          ws: true
        }
      }
    },
    build: {
      outDir: 'dist'
    }
  }
})