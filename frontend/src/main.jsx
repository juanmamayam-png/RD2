import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import { AuthProvider }   from './context/AuthContext.jsx'
import { SocketProvider } from './context/SocketContext.jsx'
import AppRouter          from './router/AppRouter.jsx'
import './utils/constants.js'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <BrowserRouter>
      <AuthProvider>
        <SocketProvider>
          <AppRouter />
        </SocketProvider>
      </AuthProvider>
    </BrowserRouter>
  </StrictMode>
)
