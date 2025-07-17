import {
  MoreHorizontal,
} from "lucide-react"

import { Search, HelpCircle, Bell } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"

export function Header() {
  return (
    <header className="flex items-start justify-between">
      <div>
        <h1 className="text-3xl font-bold text-slate-800">Hello, Jane Doe 👋</h1>
      </div>
      <div className="flex items-center gap-2">
        <Button variant="ghost" size="icon">
          <Search className="h-5 w-5 text-slate-500" />
        </Button>
        <Button variant="ghost" size="icon">
          <HelpCircle className="h-5 w-5 text-slate-500" />
        </Button>
        <Button variant="ghost" size="icon">
          <Bell className="h-5 w-5 text-slate-500" />
        </Button>
      </div>
      <div className="flex items-center gap-3 p-2">
        <Avatar>
          <AvatarImage src="/placeholder.svg?height=40&width=40" alt="Jane Doe" />
          <AvatarFallback>JD</AvatarFallback>
        </Avatar>
        <div className="flex-1">
          <p className="font-semibold text-sm text-slate-800">Jane Doe</p>
          <p className="text-xs text-slate-500">Facility_admin, Facility_operator</p>
        </div>
        <button className="text-slate-500 hover:text-slate-800">
          <MoreHorizontal className="h-5 w-5" />
        </button>
      </div>

    </header>
  )
}
