import { Link, Outlet } from 'react-router-dom'
import { useState } from 'react'
import { apiGet } from '../lib/api'
import AccountModal from '../components/AccountModal'

export default function AppLayout() {
  const [modalOpen, setModalOpen] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [user, setUser] = useState<User | null>(null)
  
  async function loadUser() {
    try {
      setError(null)
      setLoading(true)
      const me = await apiGet<User>('/api/v1/account/me')
      setUser(me)
    } catch (e: any) {
      setUser(null)
      setError(e?.message ?? 'Unable to load account')
    } finally {
      setLoading(false)
    }
  }
  
  function onAccountClick() {
    setModalOpen(true)
    loadUser()
  }
  
  return (
    <div className="min-h-dvh grid grid-rows-[auto,1fr] bg-zinc-50">
      <header className="h-14 border-b bg-white/70 backdrop-blur">
        <nav className="mx-auto max-w-6xl px-4 h-full flex items-center gap-3">         
          <Link to="/app" className="inline-flex items-center gap-1 font-bold tracking-tight">
            <img src="/eventify-icon.svg" alt="" className="h-5 w-5" />
            <span className="text-[20px]">Eventify</span>
          </Link>

          <div className="ms-auto flex items-center gap-2">
            <button
              onClick={onAccountClick}
              className="inline-flex h-9 items-center rounded-xl border px-3 text-sm hover:bg-zinc-100"
            >
              Account
            </button>
          </div>
        </nav>
      </header>

      <main className="overflow-auto">
        <div className="mx-auto max-w-6xl p-4">
          <Outlet />
        </div>
      </main>
      
      <AccountModal
        open={modalOpen}
        onClose={() => setModalOpen(false)}
        user={user}
        loading={loading}
        error={error}
        onRetry={loadUser}
      />
    </div>
  )
}
