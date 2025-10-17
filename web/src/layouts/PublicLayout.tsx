import { useState } from 'react'
import { Link, Outlet, useNavigate } from 'react-router-dom'
import RegisterModal from '../components/RegisterModal'
import LoginModal from '../components/LoginModal'

export default function PublicLayout() {
  const [openRegModal, setOpenRegModal] = useState(false)
  const [openLogModal, setOpenLogModal] = useState(false)
  const navigate = useNavigate()
  
  return (
    <div className="min-h-dvh flex flex-col bg-zinc-50 text-zinc-900">
      <header className="sticky top-0 z-10 border-b bg-white/70 backdrop-blur">
        <nav className="mx-auto max-w-6xl px-4 h-14 flex items-center gap-3">
          
          <Link to="/" className="inline-flex items-center gap-1 font-bold tracking-tight">
            <img src="/eventify-icon.svg" alt="" className="h-5 w-5" />
            <span className="text-[20px]">Eventify</span>
          </Link>

          <div className="ms-auto flex items-center gap-2">
            <button
              onClick={() => setOpenRegModal(true)}
              className="inline-flex items-center rounded-xl border border-zinc-300 px-4 h-9 text-sm font-medium hover:bg-zinc-100"
            >
              Register
            </button>
            
            <button
              onClick={() => setOpenLogModal(true)}
              className="inline-flex items-center rounded-xl bg-primary text-white px-4 h-9 text-sm font-medium hover:opacity-90"
            >
              Login
            </button>
          </div>
        </nav>
      </header>

      <main className="flex-1 mx-auto max-w-6xl px-4 py-8">
        <Outlet />
      </main>
      
      <RegisterModal
        open={openRegModal}
        onClose={() => setOpenRegModal(false)}
        onSuccess={() => {
          setOpenRegModal(false)
          navigate('/app') // redirect to your workspace
        }}
      />
      <LoginModal
        open={openLogModal}
        onClose={() => setOpenLogModal(false)}
        onSuccess={() => {
          setOpenLogModal(false)
          navigate('/app') // redirect to your workspace
        }}
      />
    </div>
  )
}
