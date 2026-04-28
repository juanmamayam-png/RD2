import { Routes, Route, Navigate } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth.js'
import LoginPage      from '../pages/LoginPage.jsx'
import RegisterPage   from '../pages/RegisterPage.jsx'
import DashboardPage  from '../pages/DashboardPage.jsx'
import SolicitudPage  from '../pages/SolicitudPage.jsx'
import TrackingPage   from '../pages/TrackingPage.jsx'
import ConductorPage  from '../pages/ConductorPage.jsx'
import PerfilPage     from '../pages/PerfilPage.jsx'

function PrivateRoute({ children, role }) {
  const { user } = useAuth()
  if (!user) return <Navigate to="/login" replace />
  if (role && user.rol !== role) return <Navigate to="/" replace />
  return children
}

export default function AppRouter() {
  return (
    <Routes>
      <Route path="/login"    element={<LoginPage />} />
      <Route path="/register" element={<RegisterPage />} />
      <Route path="/" element={
        <PrivateRoute><DashboardPage /></PrivateRoute>
      }/>
      <Route path="/solicitud" element={
        <PrivateRoute role="ciudadano"><SolicitudPage /></PrivateRoute>
      }/>
      <Route path="/tracking/:id" element={
        <PrivateRoute><TrackingPage /></PrivateRoute>
      }/>
      <Route path="/conductor" element={
        <PrivateRoute role="conductor"><ConductorPage /></PrivateRoute>
      }/>
      <Route path="/perfil" element={
        <PrivateRoute><PerfilPage /></PrivateRoute>
      }/>
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}
