import { Sidebar } from "@/components/sidebar"
import { Header } from "@/components/header"
import { Dashboard } from "@/components/dashboard/dashboard-card"
import { TopTen } from "@/components/dashboard/topten-card"
import { Statistics } from "@/components/dashboard/statistics-card"

export default function DashboardPage() {
  return (
    <div className="min-h-screen w-full bg-slate-50 text-slate-900">
      <div className="flex">
        <Sidebar />
        <main className="flex-1 p-6 lg:p-8">
          <Header />
          <div className="mt-8 grid grid-cols-1 lg:grid-cols-3 gap-8">
            <div className="lg:col-span-2 space-y-8">
              <Dashboard />
            </div>
            <div className="space-y-8">
              <TopTen />
              <Statistics />
            </div>
          </div>
        </main>
      </div>
    </div>
  )
}
