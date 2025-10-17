import { useEffect, useRef, useState } from 'react'
import { setCookie } from '../lib/cookies'

type LoginResponse = {
  access_token: string
  refresh_token: string
}

type Props = {
  open: boolean
  onClose: () => void
  onSuccess: (payload: LoginResponse) => void
}

const API_BASE = import.meta.env.VITE_API_URL ?? ''

export default function LoginModal({ open, onClose, onSuccess }: Props) {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const firstFieldRef = useRef<HTMLInputElement>(null)
  const panelRef = useRef<HTMLDivElement>(null)

  // Lock scroll when open
  useEffect(() => {
    if (!open) return
    const prev = document.documentElement.style.overflow
    document.documentElement.style.overflow = 'hidden'
    return () => { document.documentElement.style.overflow = prev }
  }, [open])

  // Autofocus first field
  useEffect(() => {
    if (open) firstFieldRef.current?.focus()
  }, [open])

  // Close on ESC
  useEffect(() => {
    if (!open) return
    const onKey = (e: KeyboardEvent) => { if (e.key === 'Escape' && !loading) onClose() }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [open, loading, onClose])

  if (!open) return null

  const submit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError(null)
    setLoading(true)
    try {
      const res = await fetch(`${API_BASE}/api/v1/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password }),
      })
      const json = (await res.json()) as LoginResponse | { message?: string }
      if (!res.ok) {
        const msg = (json as any)?.message || `Login failed (${res.status})`
        throw new Error(msg)
      }
      const payload = json as LoginResponse      
      setCookie('access_token', payload.access_token, { days: 1, sameSite: 'Lax' })
      setCookie('refresh_token', payload.refresh_token, { days: 7, sameSite: 'Lax' })
      // localStorage.setItem('access_token', payload.access_token)
      // localStorage.setItem('refresh_token', payload.refresh_token)
      onSuccess(payload)
    } catch (err: any) {
      setError(err?.message ?? 'Something went wrong')
    } finally {
      setLoading(false)
    }
  }

  const overlayClick = (e: React.MouseEvent<HTMLDivElement>) => {
    if (loading) return
    // close if clicking outside the panel
    if (panelRef.current && !panelRef.current.contains(e.target as Node)) onClose()
  }

  return (
    <div
      role="dialog"
      aria-modal="true"
      aria-labelledby="register-title"
      className="fixed inset-0 z-50 grid place-items-center bg-black/50 backdrop-blur"
      onMouseDown={overlayClick}
    >
      <div
        ref={panelRef}
        className="w-[min(92vw,520px)] rounded-2xl bg-white shadow-lg p-6"
        onMouseDown={(e) => e.stopPropagation()}
      >
        <div className="flex items-start justify-between mb-4">
          <h2 id="register-title" className="text-xl font-semibold">Login into your account</h2>
          <button
            type="button"
            className="rounded-lg p-2 hover:bg-zinc-100"
            onClick={onClose}
            disabled={loading}
            aria-label="Close"
          >
            <svg viewBox="0 0 24 24" className="size-5" aria-hidden="true">
              <path d="M6 6l12 12M18 6L6 18" stroke="currentColor" strokeWidth="2" strokeLinecap="round"/>
            </svg>
          </button>
        </div>

        <form onSubmit={submit} className="grid gap-4" noValidate>
          <label className="grid gap-1">
            <span className="text-sm text-zinc-600">Email</span>
            <input
              type="email"
              className="h-10 rounded-xl border border-zinc-300 px-3 focus:outline-none focus:ring-2 focus:ring-zinc-950/10"
              placeholder="jane@example.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </label>

          <label className="grid gap-1">
            <span className="text-sm text-zinc-600">Password</span>
            <input
              type="password"
              className="h-10 rounded-xl border border-zinc-300 px-3 focus:outline-none focus:ring-2 focus:ring-zinc-950/10"
              placeholder="••••••••"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              minLength={6}
              required
            />
          </label>

          {error && (
            <div className="rounded-xl border border-red-200 bg-red-50 text-red-700 text-sm px-3 py-2">
              {error}
            </div>
          )}

          <button
            type="submit"
            disabled={loading}
            className="h-10 rounded-xl bg-black text-white font-medium hover:opacity-90 disabled:opacity-50"
            aria-busy={loading}
          >
            {loading ? 'Logging …' : 'Login'}
          </button>
        </form>
      </div>
    </div>
  )
}
