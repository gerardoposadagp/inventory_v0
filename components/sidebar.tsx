import {
  LayoutDashboard,
  Users,
  Flag,
  Goal,
  Building,
  User,
  FileText,
  Calculator,
  Star,
  MessageCircle,
  Sticker,
  FileSignature,
  Receipt,
  Building,
  MoreHorizontal,
  ChevronRight,
  Library
} from "lucide-react"
// import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Badge } from "@/components/ui/badge"
import type { LucideIcon } from "lucide-react"

const RemoteLogo = () => (
  <div className="flex items-center gap-2">
    <div className="p-2 bg-blue-600 rounded-full">
      <ChevronRight className="text-white h-4 w-4" strokeWidth={4} />
    </div>
    <span className="font-bold text-xl text-slate-800">Inventory</span>
  </div>
)

interface NavLinkProps {
  icon: LucideIcon
  label: string
  active?: boolean
  beta?: boolean
}

const NavLink = ({ icon: Icon, label, active, beta }: NavLinkProps) => (
  <a
    href="#"
    className={`flex items-center gap-3 px-4 py-2 rounded-lg transition-colors ${
      active ? "bg-blue-100 text-blue-600 font-semibold" : "text-slate-600 hover:bg-slate-100"
    }`}
  >
    <Icon className="h-5 w-5" />
    <span>{label}</span>
    {beta && <Badge variant="secondary">BETA</Badge>}
  </a>
)

export function Sidebar() {
  return (
    <aside className="hidden lg:flex flex-col w-64 h-screen bg-white border-r p-4">
      <div className="p-2 mb-4">
        <RemoteLogo />
      </div>
      <nav className="flex-1 space-y-1">
        <NavLink icon={LayoutDashboard} label="Dashboard" />
        <div className="px-4 pt-4 pb-2 text-xs font-semibold text-slate-400 uppercase tracking-wider">Our Assets</div>
        <NavLink icon={Library} label="Items" />
        <NavLink icon={Star} label="Inventory" />
        <div className="px-4 pt-4 pb-2 text-xs font-semibold text-slate-400 uppercase tracking-wider">Admin</div>
        <NavLink icon={Sticker} label="Items categories" />
        <NavLink icon={Flag} label="Countries" />
        <NavLink icon={Goal} label="Cities" />
        <NavLink icon={Building} label="Facilities" />
        <NavLink icon={User} label="User profiles" />
        <NavLink icon={Users} label="User roles" />
      </nav>
    </aside>
  )
}
