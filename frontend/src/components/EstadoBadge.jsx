const CONFIG = {
  pendiente: { color: '#fbbf24', bg: 'rgba(251,191,36,.15)', label: '⏳ Pendiente' },
  aceptada:  { color: '#4f8ef7', bg: 'rgba(79,142,247,.15)', label: '✓ Aceptada' },
  en_camino: { color: '#ff6b35', bg: 'rgba(255,107,53,.15)', label: '🏍️ En camino' },
  recogido:  { color: '#a78bfa', bg: 'rgba(167,139,250,.15)', label: '📦 Recogido' },
  entregado: { color: '#2dd4a0', bg: 'rgba(45,212,160,.15)', label: '✅ Entregado' },
  cancelado: { color: '#f06060', bg: 'rgba(240,96,96,.15)', label: '✕ Cancelado' },
}

export default function EstadoBadge({ estado }) {
  const c = CONFIG[estado] || CONFIG.pendiente
  return (
    <span style={{ background: c.bg, color: c.color, padding: '3px 10px',
                   borderRadius: '99px', fontSize: '11px', fontWeight: 700 }}>
      {c.label}
    </span>
  )
}
