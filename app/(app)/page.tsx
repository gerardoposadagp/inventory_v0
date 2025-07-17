import { Dashboard } from "@/components/dashboard/dashboard-card"
import { TopTen } from "@/components/dashboard/topten-card"
import { Statistics } from "@/components/dashboard/statistics-card"
import Link from "next/link"
import { Button } from "@/components/ui/button"

export default function DashboardPage() {
  return (
    <div className="space-y-8 mt-8">
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div className="lg:col-span-2 space-y-8">
          <Dashboard />
          <div className="flex items-center justify-between gap-4 rounded-lg bg-white p-6 shadow-sm">
            <div>
              <h3 className="text-lg font-semibold text-slate-800">Ready to get started?</h3>
              <p className="text-sm text-slate-500">Explore our features or create an account for free.</p>
            </div>
            <div className="flex items-center gap-2">
              <Button asChild>
                <Link href="/signup">Join for free</Link>
              </Button>
              <Button asChild variant="outline">
                <Link href="/pricing">See our plans</Link>
              </Button>
            </div>
          </div>
          <div className="rounded-lg bg-white p-8 shadow-sm">
            <h3 className="text-center text-sm font-semibold text-slate-500 uppercase tracking-wider mb-8">
              Our current Customers
            </h3>
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-x-8 gap-y-6 text-slate-500">
              <img
                src="/placeholder.svg?height=40&width=120"
                alt="Company Logo 1"
                className="h-8 object-contain mx-auto"
              />
              <img
                src="/placeholder.svg?height=40&width=120"
                alt="Company Logo 2"
                className="h-8 object-contain mx-auto"
              />
              <img
                src="/placeholder.svg?height=40&width=120"
                alt="Company Logo 3"
                className="h-8 object-contain mx-auto"
              />
              <img
                src="/placeholder.svg?height=40&width=120"
                alt="Company Logo 4"
                className="h-8 object-contain mx-auto"
              />
              <img
                src="/placeholder.svg?height=40&width=120"
                alt="Company Logo 5"
                className="h-8 object-contain mx-auto"
              />
              <img
                src="/placeholder.svg?height=40&width=120"
                alt="Company Logo 6"
                className="h-8 object-contain mx-auto"
              />
              <img
                src="/placeholder.svg?height=40&width=120"
                alt="Company Logo 7"
                className="h-8 object-contain mx-auto"
              />
              <img
                src="/placeholder.svg?height=40&width=120"
                alt="Company Logo 8"
                className="h-8 object-contain mx-auto"
              />
              <img
                src="/placeholder.svg?height=40&width=120"
                alt="Company Logo 9"
                className="h-8 object-contain mx-auto"
              />
              <img
                src="/placeholder.svg?height=40&width=120"
                alt="Company Logo 10"
                className="h-8 object-contain mx-auto"
              />
            </div>
          </div>
          <div className="rounded-lg bg-white p-8 shadow-sm">
            <h3 className="text-center text-lg font-semibold text-slate-800 mb-8">A Glimpse of Our Facilities</h3>
            <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
              <img
                src="/placeholder.svg?height=200&width=200"
                alt="Modern warehouse interior"
                className="rounded-lg object-cover aspect-square"
              />
              <img
                src="/placeholder.svg?height=200&width=200"
                alt="Logistics center exterior"
                className="rounded-lg object-cover aspect-square"
              />
              <img
                src="/placeholder.svg?height=200&width=200"
                alt="Automated sorting machinery"
                className="rounded-lg object-cover aspect-square"
              />
              <img
                src="/placeholder.svg?height=200&width=200"
                alt="Corporate office lobby"
                className="rounded-lg object-cover aspect-square"
              />
              <img
                src="/placeholder.svg?height=200&width=200"
                alt="Shipping docks at dusk"
                className="rounded-lg object-cover aspect-square"
              />
              <img
                src="/placeholder.svg?height=200&width=200"
                alt="Clean room laboratory"
                className="rounded-lg object-cover aspect-square"
              />
              <img
                src="/placeholder.svg?height=200&width=200"
                alt="Large storage racks"
                className="rounded-lg object-cover aspect-square"
              />
              <img
                src="/placeholder.svg?height=200&width=200"
                alt="Solar panels on a facility roof"
                className="rounded-lg object-cover aspect-square"
              />
              <img
                src="/placeholder.svg?height=200&width=200"
                alt="Employee break room"
                className="rounded-lg object-cover aspect-square"
              />
              <img
                src="/placeholder.svg?height=200&width=200"
                alt="Fleet of delivery trucks"
                className="rounded-lg object-cover aspect-square"
              />
            </div>
          </div>
        </div>
        <div className="space-y-8">
          <TopTen />
          <Statistics />
        </div>
      </div>
    </div>
  )
}
