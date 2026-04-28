import { useEffect, useState } from 'react'
import { useAuth } from '../hooks/useAuth.js'
import { useSocket } from '../hooks/useSocket.js'
import { useGeolocation } from '../hooks/useGeolocation.js'
import { solicitudesService } from '../services/solicitudes.service.js'
import { conductoresService } from '../services/conductores.service.js'

export default function ConductorPage() {
  const { user, logout } = useAuth()
  const { socket } = useSocket()
  const { coords }  = useGeolocation()
  const [disponible, setDisponible] = useState(false)
  const [solicitudes, setSolicitudes] = useState([])

  useEffect(() => {
    solicitudesService.listar().then(setSolicitudes).catch(console.error)
  }, [])

  // Escuchar nuevas solicitudes por WebSocket
  useEffect(() => {
    if (!socket) return
    socket.on('solicitud:nueva', (s) => setSolicitudes(prev => [s, ...prev]))
    return () => socket.off('solicitud:nueva')
  }, [socket])

  // Enviar ubicación GPS cada 5 segundos cuando disponible
  useEffect(() => {
    if (!disponible || !coords || !socket) return
    const id = setInterval(() => {
      conductoresService.ubicacion(coords.lat, coords.lng)
    }, 5000)
    return () => clearInterval(id)
  }, [disponible, coords, socket])

  async function toggleDisponible() {
    const nuevo = !disponible
    await conductoresService.disponible(nuevo)
    setDisponible(nuevo)
  }

  async function aceptar(solicitudId) {
    await solicitudesService.aceptar(solicitudId)
    setSolicitudes(prev => prev.filter(s => s.id !== solicitudId))
  }

  return (
    <div className="app-shell">
      <header className="topbar">
        <span className="logo-sm">Rappicampo</span>
        <span>{user?.nombre}</span>
        <button onClick={logout}>Salir</button>
      </header>
      <main className="screen">
        <div className="available-toggle">
          <div>
            <b>{disponible ? '✅ Disponible' : 'No disponible'}</b>
            <small>{disponible ? 'Recibes solicitudes' : 'Activa para trabajar'}</small>
          </div>
          <div className={`switch ${disponible?'on':''}`} onClick={toggleDisponible} />
        </div>
        <h3>Solicitudes cercanas ({solicitudes.length})</h3>
        {solicitudes.map(s => (
          <div key={s.id} className="solicitud-item">
            <div><b>{s.descripcion}</b></div>
            <small>{s.origen_dir} → {s.destino_dir}</small>
            <div style={{ display:'flex', gap:8, marginTop:8 }}>
              <button className="btn-accept" onClick={() => aceptar(s.id)}>✓ Aceptar</button>
              <button className="btn-reject" onClick={() => setSolicitudes(p=>p.filter(x=>x.id!==s.id))}>✕ Pasar</button>
            </div>
          </div>
        ))}
      </main>
    </div>
  )
}
