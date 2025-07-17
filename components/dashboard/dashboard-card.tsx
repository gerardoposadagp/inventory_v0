"use client"

import { useState, useEffect, useMemo } from "react"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Bar, BarChart, CartesianGrid, XAxis, YAxis, ResponsiveContainer } from "recharts"
import { ChartTooltip, ChartTooltipContent } from "@/components/ui/chart"
import { createClient } from "@/lib/supabase/client"
import { type LucideIcon, Package, Boxes, Warehouse, AlertTriangle } from "lucide-react"
import { Skeleton } from "@/components/ui/skeleton"

interface StatCardProps {
  title: string
  value: string | number
  icon: LucideIcon
  loading: boolean
}

function StatCard({ title, value, icon: Icon, loading }: StatCardProps) {
  return (
    <div className="flex items-center p-4 bg-slate-50 rounded-lg">
      <div className="mr-4 bg-slate-200 p-3 rounded-lg">
        <Icon className="h-6 w-6 text-slate-600" />
      </div>
      <div>
        <p className="text-sm text-slate-500 font-medium">{title}</p>
        {loading ? (
          <Skeleton className="h-7 w-20 mt-1" />
        ) : (
          <p className="text-2xl font-bold text-slate-800">{value}</p>
        )}
      </div>
    </div>
  )
}

interface Country {
  id: number
  country_name: string
}
interface City {
  id: number
  city_name: string
}
interface Facility {
  id: number
  facility_name: string
}
interface DashboardStats {
  metrics: {
    total_quantity: number
    distinct_items: number
    facility_count: number
    expiring_soon_count: number
  }
  category_distribution: { category_name: string; quantity: number }[]
}

export function Dashboard() {
  const supabase = createClient()
  const [loading, setLoading] = useState(true)
  const [stats, setStats] = useState<DashboardStats | null>(null)

  const [countries, setCountries] = useState<Country[]>([])
  const [cities, setCities] = useState<City[]>([])
  const [facilities, setFacilities] = useState<Facility[]>([])

  const [selectedCountry, setSelectedCountry] = useState<string | null>(null)
  const [selectedCity, setSelectedCity] = useState<string | null>(null)
  const [selectedFacility, setSelectedFacility] = useState<string | null>(null)

  useEffect(() => {
    async function getCountries() {
      const { data } = await supabase.from("countries").select("id, country_name").order("country_name")
      setCountries(data || [])
    }
    getCountries()
  }, [supabase])

  useEffect(() => {
    async function getCities() {
      if (!selectedCountry) {
        setCities([])
        setSelectedCity(null)
        return
      }
      const { data } = await supabase
        .from("cities")
        .select("id, city_name")
        .eq("country_id", selectedCountry)
        .order("city_name")
      setCities(data || [])
    }
    getCities()
  }, [selectedCountry, supabase])

  useEffect(() => {
    async function getFacilities() {
      if (!selectedCity) {
        setFacilities([])
        setSelectedFacility(null)
        return
      }
      const { data } = await supabase
        .from("facilities")
        .select("id, facility_name")
        .eq("city_id", selectedCity)
        .order("facility_name")
      setFacilities(data || [])
    }
    getFacilities()
  }, [selectedCity, supabase])

  useEffect(() => {
    async function getStats() {
      setLoading(true)
      const { data, error } = await supabase.rpc("get_dashboard_stats", {
        p_country_id: selectedCountry,
        p_city_id: selectedCity,
        p_facility_id: selectedFacility,
      })
      if (data) {
        setStats(data)
      }
      setLoading(false)
    }
    getStats()
  }, [selectedCountry, selectedCity, selectedFacility, supabase])

  const chartData = useMemo(() => stats?.category_distribution || [], [stats])

  return (
    <Card>
      <CardHeader>
        <CardTitle>Dashboard</CardTitle>
        <div className="mt-4 grid grid-cols-1 md:grid-cols-3 gap-4">
          <Select onValueChange={setSelectedCountry} value={selectedCountry ?? undefined}>
            <SelectTrigger>
              <SelectValue placeholder="Select Country" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">All Countries</SelectItem>
              {countries.map((c) => (
                <SelectItem key={c.id} value={c.id.toString()}>
                  {c.country_name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          <Select
            onValueChange={setSelectedCity}
            value={selectedCity ?? undefined}
            disabled={!selectedCountry || cities.length === 0}
          >
            <SelectTrigger>
              <SelectValue placeholder="Select City" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">All Cities</SelectItem>
              {cities.map((c) => (
                <SelectItem key={c.id} value={c.id.toString()}>
                  {c.city_name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          <Select
            onValueChange={setSelectedFacility}
            value={selectedFacility ?? undefined}
            disabled={!selectedCity || facilities.length === 0}
          >
            <SelectTrigger>
              <SelectValue placeholder="Select Facility" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">All Facilities</SelectItem>
              {facilities.map((f) => (
                <SelectItem key={f.id} value={f.id.toString()}>
                  {f.facility_name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
          <StatCard
            title="Total Items"
            value={stats?.metrics.total_quantity.toLocaleString() ?? 0}
            icon={Package}
            loading={loading}
          />
          <StatCard
            title="Distinct Items"
            value={stats?.metrics.distinct_items.toLocaleString() ?? 0}
            icon={Boxes}
            loading={loading}
          />
          <StatCard
            title="Facilities"
            value={stats?.metrics.facility_count.toLocaleString() ?? 0}
            icon={Warehouse}
            loading={loading}
          />
          <StatCard
            title="Expiring Soon"
            value={stats?.metrics.expiring_soon_count.toLocaleString() ?? 0}
            icon={AlertTriangle}
            loading={loading}
          />
        </div>
        <div className="h-[350px] w-full">
          <h3 className="font-semibold mb-4 text-slate-800">Inventory by Category</h3>
          {loading ? (
            <Skeleton className="h-full w-full" />
          ) : (
            <ResponsiveContainer>
              <BarChart data={chartData}>
                <CartesianGrid vertical={false} />
                <XAxis dataKey="category_name" tickLine={false} axisLine={false} tickMargin={8} />
                <YAxis />
                <ChartTooltip content={<ChartTooltipContent />} />
                <Bar dataKey="quantity" fill="hsl(221 83% 53%)" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          )}
        </div>
      </CardContent>
    </Card>
  )
}
