import { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import { useSocket } from '../hooks/useSocket.js'
import MapaTracking from '../components/MapaTracking.jsx'
import EstadoBadge  from '../components/EstadoBadge.jsx'

export default function TrackingPage() {
  const { id } = useParams()
  const { socket } = useSocket()
  const [conductorPos, setConductorPos] = useState(null)
  const [eta, setEta] = useState(null)
  const [estado, setEstado] = useState('aceptada')

  useEffect(() => {
    if (!socket) return
    socket.emit('tracking:join', { solicitudId: id })
    socket.on('tracking:update', ({ lat, lng, eta: e }) => {
      setConductorPos({ lat, lng })
      if (e) setEta(e)
    })
    socket.on('solicitud:actualizada', (s) => setEstado(s.estado))
    return () => { socket.off('tracking:update'); socket.off('solicitud:actualizada') }
  }, [socket, id])

  return (
    <div className="app-shell">
      <header className="topbar"><span className="logo-sm">📍 Seguimiento</span></header>
      <main className="screen">
        <div style={{ display:'flex', justifyContent:'space-between', marginBottom:12 }}>
          <EstadoBadge estado={estado} />
          {eta && <span className="eta-badge">⏱ {eta} min</span>}
        </div>
        <MapaTracking conductorPos={conductorPos} />
        <p style={{ textAlign:'center', color:'#a0a0c0', marginTop:12 }}>
          {conductorPos
            ? `Conductor en ${conductorPos.lat.toFixed(4)}, ${conductorPos.lng.toFixed(4)}`
            : 'Esperando ubicación del conductor...'}
        </p>
      </main>
    </div>
  )
}
