"use client"

import Link from "next/link"
import { usePathname } from "next/navigation"
import { LayoutDashboard, Users, Flag, Goal, Building, User, Star, Sticker, ChevronRight, Library } from "lucide-react"
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
  href: string
  icon: LucideIcon
  label: string
  active?: boolean
  beta?: boolean
}

const NavLink = ({ href, icon: Icon, label, active, beta }: NavLinkProps) => (
  <Link
    href={href}
    className={`flex items-center gap-3 px-4 py-2 rounded-lg transition-colors ${
      active ? "bg-blue-100 text-blue-600 font-semibold" : "text-slate-600 hover:bg-slate-100"
    }`}
  >
    <Icon className="h-5 w-5" />
    <span>{label}</span>
    {beta && <Badge variant="secondary">BETA</Badge>}
  </Link>
)

const navLinksConfig = [
  {
    title: "Our Assets",
    links: [
      { href: "/items", label: "Items", icon: Library },
      { href: "/inventory", label: "Inventory", icon: Star },
    ],
  },
  {
    title: "Admin",
    links: [
      { href: "/categories", label: "Items categories", icon: Sticker },
      { href: "/countries", label: "Countries", icon: Flag },
      { href: "/cities", label: "Cities", icon: Goal },
      { href: "/facilities", label: "Facilities", icon: Building },
      { href: "/users", label: "User profiles", icon: User },
      { href: "/roles", label: "User roles", icon: Users },
    ],
  },
]

export function Sidebar() {
  const pathname = usePathname()

  return (
    <aside className="hidden lg:flex flex-col w-64 h-screen bg-white border-r p-4 sticky top-0">
      <div className="p-2 mb-4">
        <RemoteLogo />
      </div>
      <nav className="flex-1 space-y-1">
        <NavLink href="/" icon={LayoutDashboard} label="Dashboard" active={pathname === "/"} />
        {navLinksConfig.map((section) => (
          <div key={section.title}>
            <div className="px-4 pt-4 pb-2 text-xs font-semibold text-slate-400 uppercase tracking-wider">
              {section.title}
            </div>
            {section.links.map((link) => (
              <NavLink
                key={link.href}
                href={link.href}
                icon={link.icon}
                label={link.label}
                active={pathname === link.href}
              />
            ))}
          </div>
        ))}
      </nav>
    </aside>
  )
}
