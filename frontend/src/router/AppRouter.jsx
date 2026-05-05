import { Routes, Route, Navigate } from 'react-router-dom'
import DashboardPage from '../pages/DashboardPage.jsx'
import SolicitudPage from '../pages/SolicitudPage.jsx'
import TrackingPage from '../pages/TrackingPage.jsx'
import ConductorPage from '../pages/ConductorPage.jsx'
import PerfilPage from '../pages/PerfilPage.jsx'

export default function AppRouter() {
  return (
    <Routes>
      <Route path="/" element={<DashboardPage />} />
      <Route path="/solicitud" element={<SolicitudPage />} />
      <Route path="/tracking/:id" element={<TrackingPage />} />
      <Route path="/conductor" element={<ConductorPage />} />
      <Route path="/perfil" element={<PerfilPage />} />
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}