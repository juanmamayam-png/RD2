export default function RolBadge({ rol }) {
  const estilos = {
    conductor: { background: 'rgba(255,107,53,.15)', color: '#ff6b35', label: '🏍️ Conductor' },
    ciudadano: { background: 'rgba(79,142,247,.15)', color: '#4f8ef7',  label: '🧑‍🌾 Ciudadano' },
  }
  const s = estilos[rol] || estilos.ciudadano
  return (
    <span style={{ background: s.background, color: s.color, padding: '3px 10px',
                   borderRadius: '99px', fontSize: '12px', fontWeight: 700 }}>
      {s.label}
    </span>
  )
}
