import type React from "react"
import { Sidebar } from "@/components/sidebar"
import { Header } from "@/components/header"

export default function AppLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="min-h-screen w-full bg-slate-50 text-slate-900">
      <div className="flex">
        <Sidebar />
        <main className="flex-1 p-6 lg:p-8">
          <Header />
          {children}
        </main>
      </div>
    </div>
  )
}
